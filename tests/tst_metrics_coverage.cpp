#include <QtTest>

#include <QCoreApplication>
#include <QDir>
#include <QEvent>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QPointer>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickItem>
#include <QQuickWindow>
#include <QStandardPaths>
#include <QTemporaryDir>
#include <QUrl>
#include <QtPlugin>

#include "backend/io/backend.h"
#include "backend/fonts/fontpolicy.h"
#include "backend/navigation/pagemonitor.h"
#include "backend/platform/platforminfo.h"
#include "backend/runtime/renderquality.h"
#include "backend/runtime/renderingmonitor.h"
#include "backend/runtime/runtimeevents.h"
#include "backend/graphics/svgmanager.h"
#include "backend/state/viewmodelregistry.h"

Q_IMPORT_PLUGIN(UIFrameworkPlugin)

class MetricsCoverageTests : public QObject
{
    Q_OBJECT

private slots:
    void backend_file_roundtrip_and_errors();
    void render_quality_bounds_and_window_apply();
    void font_policy_token_mapping_is_strict();
    void page_monitor_history_metrics();
    void platform_flags_consistency();
    void runtime_events_measurement_boundaries();
    void render_monitor_counts_frames_when_swapped();
    void svg_manager_generates_png_and_clamps();
    void viewmodels_registry_tracks_keys_and_ownership();
    void application_window_and_main_metrics_are_exposed();
};

static QString qmlImportBase()
{
    return QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
}

static QObject *createFromQml(QQmlEngine &engine, const QByteArray &qml)
{
    QQmlComponent component(&engine);
    component.setData(qml, QUrl());
    QObject *obj = component.create();
    if (component.isError()) {
        const auto errors = component.errors();
        for (const auto &err : errors)
            qWarning() << err;
    }
    return obj;
}

static QObject *loadQmlFile(QQmlEngine &engine, const QString &path)
{
    QQmlComponent component(&engine, QUrl::fromLocalFile(path));
    QObject *obj = component.create();
    if (component.isError()) {
        const auto errors = component.errors();
        for (const auto &err : errors)
            qWarning() << err;
    }
    return obj;
}

void MetricsCoverageTests::backend_file_roundtrip_and_errors()
{
    Backend backend;
    QTemporaryDir tempDir;
    QVERIFY(tempDir.isValid());

    const QString nestedDir = tempDir.path() + "/io/a/b";
    QVERIFY(backend.ensureDir(nestedDir));

    const QString filePath = nestedDir + "/sample.txt";
    QVERIFY(backend.saveTextFile(filePath, QStringLiteral("metrics-check")));
    QCOMPARE(backend.readTextFile(filePath), QStringLiteral("metrics-check"));

    QVERIFY(!backend.saveTextFile(QString(), QStringLiteral("x")));
    QVERIFY(!backend.lastError().isEmpty());

    const QString missingPath = nestedDir + "/missing.txt";
    QCOMPARE(backend.readTextFile(missingPath), QString());
    QVERIFY(!backend.lastError().isEmpty());

    const QString tempLocation = backend.writableLocation(static_cast<int>(QStandardPaths::TempLocation));
    QVERIFY(!tempLocation.isEmpty());
}

void MetricsCoverageTests::render_quality_bounds_and_window_apply()
{
    RenderQuality quality;

    quality.setSupersampleScale(999.0);
    QCOMPARE(quality.supersampleScale(), quality.maximumSupersampleScale());
    quality.setSupersampleScale(0.01);
    QCOMPARE(quality.supersampleScale(), quality.minimumSupersampleScale());

    quality.setEnabled(false);
    QCOMPARE(quality.effectiveSupersampleScale(), 1.0);
    quality.setEnabled(true);
    quality.setSupersampleScale(3.0);
    QCOMPARE(quality.effectiveSupersampleScale(), 3.0);

    quality.setMsaaSamples(-4);
    QCOMPARE(quality.msaaSamples(), 0);
    quality.setMsaaSamples(48);
    QCOMPARE(quality.msaaSamples(), 16);

    quality.setMsaaSamples(8);
    quality.setNativeTextRendering(true);
    QQuickWindow window;
    quality.applyWindow(&window);
    QVERIFY(window.format().samples() >= 8);
    QCOMPARE(QQuickWindow::textRenderType(), QQuickWindow::NativeTextRendering);
}

void MetricsCoverageTests::font_policy_token_mapping_is_strict()
{
    FontPolicy policy;
    QVERIFY(!policy.preferredFamily().isEmpty());
    QVERIFY(!policy.effectiveFamily().isEmpty());
    QCOMPARE(policy.resolveFamily(QString()), policy.effectiveFamily());

    struct Token {
        int pixelSize;
        int weight;
        const char *style;
    };
    const QList<Token> expected = {
        {26, QFont::Bold, "Bold"},
        {22, QFont::Bold, "Bold"},
        {17, QFont::DemiBold, "SemiBold"},
        {15, QFont::DemiBold, "SemiBold"},
        {13, QFont::Medium, "Medium"},
        {12, QFont::DemiBold, "SemiBold"},
        {11, QFont::Normal, "Regular"}
    };

    for (const Token &token : expected) {
        QCOMPARE(policy.weightForTextSize(token.pixelSize, QFont::Normal), token.weight);
        QCOMPARE(policy.styleNameForTextSize(token.pixelSize, QStringLiteral("Regular")), QString::fromLatin1(token.style));
        QVERIFY(policy.isThemeTextStyleCompliant(token.pixelSize, token.weight, QString::fromLatin1(token.style)));
    }

    QCOMPARE(policy.weightForTextSize(99, QFont::Light), QFont::Light);
    QCOMPARE(policy.styleNameForTextSize(99, QStringLiteral("Fallback")), QStringLiteral("Fallback"));
    QVERIFY(!policy.isThemeTextStyleCompliant(99, QFont::Bold, QStringLiteral("Bold")));
    QVERIFY(!policy.isThemeTextStyleCompliant(13, QFont::Bold, QStringLiteral("Bold")));
}

void MetricsCoverageTests::page_monitor_history_metrics()
{
    PageMonitor monitor;
    QCOMPARE(monitor.count(), 0);
    QCOMPARE(monitor.current(), QString());
    QVERIFY(!monitor.canUndo());

    monitor.record(QStringLiteral("/overview"));
    monitor.record(QStringLiteral("/overview"));
    QCOMPARE(monitor.count(), 1);
    QCOMPARE(monitor.current(), QStringLiteral("/overview"));

    monitor.record(QStringLiteral("/reports"));
    QCOMPARE(monitor.count(), 2);
    QVERIFY(monitor.canUndo());
    QCOMPARE(monitor.undo(), QStringLiteral("/overview"));
    QCOMPARE(monitor.count(), 1);
    QVERIFY(!monitor.canUndo());

    monitor.clear();
    QCOMPARE(monitor.count(), 0);
    QCOMPARE(monitor.current(), QString());
}

void MetricsCoverageTests::platform_flags_consistency()
{
    PlatformInfo platform;
    QVERIFY(!platform.os().isEmpty());
    QVERIFY(!platform.arch().isEmpty());
    QVERIFY(platform.desktop() || platform.mobile());

    const int explicitPlatformCount = (platform.android() ? 1 : 0)
        + (platform.ios() ? 1 : 0)
        + (platform.macos() ? 1 : 0)
        + (platform.windows() ? 1 : 0)
        + (platform.linux() ? 1 : 0);
    QCOMPARE(explicitPlatformCount, 1);

    if (platform.macos())
        QCOMPARE(platform.os(), QStringLiteral("osx"));
    if (platform.windows())
        QCOMPARE(platform.os(), QStringLiteral("windows"));
    if (platform.linux())
        QCOMPARE(platform.os(), QStringLiteral("linux"));
}

void MetricsCoverageTests::runtime_events_measurement_boundaries()
{
    RuntimeEvents events;
    QQuickWindow window;
    window.setWidth(800);
    window.setHeight(500);
    events.attachWindow(&window);
    QTRY_VERIFY(events.running());
    QVERIFY(events.uiCreatedCount() > 0);

    events.setIdleTimeoutMs(-10);
    QCOMPARE(events.idleTimeoutMs(), 250);
    events.setIdleTimeoutMs(24 * 60 * 60 * 1000 + 999);
    QCOMPARE(events.idleTimeoutMs(), 24 * 60 * 60 * 1000);

    events.setOsSampleIntervalMs(-10);
    QCOMPARE(events.osSampleIntervalMs(), 250);
    events.setOsSampleIntervalMs(70 * 1000);
    QCOMPARE(events.osSampleIntervalMs(), 60 * 1000);

    const qint64 previousActivityEpoch = events.lastActivityEpochMs();
    QTest::qWait(2);
    events.markActivity();
    QVERIFY(events.lastActivityEpochMs() >= previousActivityEpoch);

    QKeyEvent keyPress(QEvent::KeyPress, Qt::Key_K, Qt::ControlModifier, QStringLiteral("k"));
    QCoreApplication::sendEvent(&window, &keyPress);
    QVERIFY(events.isKeyPressed(Qt::Key_K));
    QKeyEvent keyRelease(QEvent::KeyRelease, Qt::Key_K, Qt::ControlModifier, QStringLiteral("k"));
    QCoreApplication::sendEvent(&window, &keyRelease);
    QVERIFY(!events.isKeyPressed(Qt::Key_K));
    QVERIFY(events.keyPressCount() >= 1);
    QVERIFY(events.keyReleaseCount() >= 1);

    const QPointF p(24.0, 18.0);
    QMouseEvent mouseMove(QEvent::MouseMove, p, p, p, Qt::NoButton, Qt::NoButton, Qt::NoModifier);
    QMouseEvent mousePress(QEvent::MouseButtonPress, p, p, p, Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
    QMouseEvent mouseRelease(QEvent::MouseButtonRelease, p, p, p, Qt::LeftButton, Qt::NoButton, Qt::NoModifier);
    QCoreApplication::sendEvent(&window, &mouseMove);
    QCoreApplication::sendEvent(&window, &mousePress);
    QCoreApplication::sendEvent(&window, &mouseRelease);
    QVERIFY(events.mouseMoveCount() >= 1);
    QVERIFY(events.mousePressCount() >= 1);
    QVERIFY(events.mouseReleaseCount() >= 1);

    const quint64 createdBefore = events.uiCreatedCount();
    auto *dynamicItem = new QQuickItem(window.contentItem());
    dynamicItem->setVisible(true);
    QCoreApplication::processEvents();
    QVERIFY(events.uiCreatedCount() > createdBefore);
    delete dynamicItem;
    QCoreApplication::processEvents();
    QVERIFY(events.uiDestroyedCount() >= 1);

    const QVariantMap snapshot = events.snapshot();
    QVERIFY(snapshot.contains(QStringLiteral("running")));
    QVERIFY(snapshot.contains(QStringLiteral("keyPressCount")));
    QVERIFY(snapshot.contains(QStringLiteral("mouseMoveCount")));
    QVERIFY(snapshot.contains(QStringLiteral("uiCreatedCount")));
    QVERIFY(snapshot.contains(QStringLiteral("idle")));
    QVERIFY(snapshot.contains(QStringLiteral("pid")));
    QVERIFY(snapshot.contains(QStringLiteral("rssBytes")));
    QVERIFY(snapshot.contains(QStringLiteral("uptimeMs")));
    QVERIFY(snapshot.value(QStringLiteral("pid")).toLongLong() > 0);

    events.stop();
    QVERIFY(!events.running());
}

void MetricsCoverageTests::render_monitor_counts_frames_when_swapped()
{
    RenderingMonitor monitor;
    QQuickWindow window;
    monitor.attachWindow(&window);
    QVERIFY(monitor.active());
    QCOMPARE(monitor.frameCount(), 0u);

    QVERIFY(QMetaObject::invokeMethod(&monitor, "handleFrameSwapped", Qt::DirectConnection));
    QTest::qWait(5);
    QVERIFY(QMetaObject::invokeMethod(&monitor, "handleFrameSwapped", Qt::DirectConnection));
    QVERIFY(monitor.frameCount() >= 2);
    QVERIFY(monitor.lastFrameMs() >= 0.0);
    QVERIFY(monitor.fps() >= 0.0);

    monitor.reset();
    QCOMPARE(monitor.frameCount(), 0u);
    QCOMPARE(monitor.lastFrameMs(), 0.0);

    monitor.stop();
    QVERIFY(!monitor.active());
    monitor.start();
    QVERIFY(monitor.active());
    monitor.attachWindow(static_cast<QObject *>(nullptr));
    QVERIFY(!monitor.active());
}

void MetricsCoverageTests::svg_manager_generates_png_and_clamps()
{
    SvgManager manager;

    manager.setMaximumScale(0.5);
    QCOMPARE(manager.maximumScale(), 1.0);
    manager.setMinimumScale(0.2);
    QCOMPARE(manager.minimumScale(), 1.0);
    manager.setMaximumScale(4.0);
    manager.setMinimumScale(3.0);
    QCOMPARE(manager.minimumScale(), 3.0);
    QCOMPARE(manager.maximumScale(), 4.0);

    manager.setCacheSize(10000);
    QCOMPARE(manager.cacheSize(), 4096);
    manager.setCacheSize(-1);
    QCOMPARE(manager.cacheSize(), 0);
    manager.setCacheSize(32);
    QCOMPARE(manager.cacheSize(), 32);

    QCOMPARE(manager.icon(QString(), 16, 3.0), QString());
    QVERIFY(!manager.lastError().isEmpty());

    const QByteArray svg = QByteArrayLiteral(
        "<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16'>"
        "<rect x='0' y='0' width='16' height='16' fill='#ff453a'/></svg>");
    const QString svgUrl = QStringLiteral("data:image/svg+xml;base64,") + QString::fromLatin1(svg.toBase64());
    const QString pngA = manager.icon(svgUrl, 16, 3.0);
    QVERIFY(pngA.startsWith(QStringLiteral("data:image/png;base64,")));
    QVERIFY(manager.lastError().isEmpty());

    const QString pngB = manager.icon(svgUrl, 16, 3.0);
    QCOMPARE(pngB, pngA);

    const quint64 revisionBeforeClear = manager.revision();
    manager.clearCache();
    QVERIFY(manager.revision() > revisionBeforeClear);
    QVERIFY(manager.deviceScale() >= 1.0);
}

void MetricsCoverageTests::viewmodels_registry_tracks_keys_and_ownership()
{
    ViewModelRegistry registry;
    QCOMPARE(registry.keys().size(), 0);
    QVERIFY(registry.get(QStringLiteral("missing")) == nullptr);

    auto *shared = new QObject;
    QPointer<QObject> sharedGuard(shared);
    registry.set(QStringLiteral("alpha"), shared);
    registry.set(QStringLiteral("beta"), shared);
    QVERIFY(registry.keys().contains(QStringLiteral("alpha")));
    QVERIFY(registry.keys().contains(QStringLiteral("beta")));
    QVERIFY(registry.get(QStringLiteral("alpha")) == shared);
    QVERIFY(shared->parent() == &registry);

    registry.remove(QStringLiteral("alpha"));
    QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);
    QCoreApplication::processEvents();
    QVERIFY(!sharedGuard.isNull());

    registry.remove(QStringLiteral("beta"));
    QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);
    QCoreApplication::processEvents();
    QTRY_VERIFY(sharedGuard.isNull());

    auto *single = new QObject;
    QPointer<QObject> singleGuard(single);
    registry.set(QStringLiteral("single"), single);
    QCOMPARE(registry.keys().size(), 1);
    registry.clear();
    QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);
    QCoreApplication::processEvents();
    QTRY_VERIFY(singleGuard.isNull());
    QCOMPARE(registry.keys().size(), 0);
}

void MetricsCoverageTests::application_window_and_main_metrics_are_exposed()
{
    {
        QQmlEngine engine;
        engine.addImportPath(qmlImportBase());

        const QByteArray qml = R"(
import QtQuick
import UIFramework as UIF

UIF.ApplicationWindow {
    id: root
    width: 520
    height: 560
    desktopMinWidth: 0
    desktopMinHeight: 0
    mobileMinWidth: 0
    mobileMinHeight: 0
    visible: false
    title: "MetricsWindow"

    property bool compactRule: matchesMedia("compact")
    property bool expandedRule: matchesMedia("expanded")
    property bool unknownRule: matchesMedia("unknown")
    property bool runtimeRunning: UIF.RuntimeEvents.running
    property bool tokenCompliant:
        UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textTitle, UIF.Theme.textTitleWeight, UIF.Theme.textTitleStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textTitle2, UIF.Theme.textTitle2Weight, UIF.Theme.textTitle2StyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textHeader, UIF.Theme.textHeaderWeight, UIF.Theme.textHeaderStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textHeader2, UIF.Theme.textHeader2Weight, UIF.Theme.textHeader2StyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textBody, UIF.Theme.textBodyWeight, UIF.Theme.textBodyStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textDescription, UIF.Theme.textDescriptionWeight, UIF.Theme.textDescriptionStyleName)
        && UIF.Theme.isThemeTextStyleCompliant(UIF.Theme.textCaption, UIF.Theme.textCaptionWeight, UIF.Theme.textCaptionStyleName)
}
)";

        QScopedPointer<QObject> root(createFromQml(engine, qml));
        QVERIFY(root);
        QVERIFY(root->property("compactRule").toBool());
        QVERIFY(!root->property("expandedRule").toBool());
        QVERIFY(!root->property("unknownRule").toBool());
        QTRY_VERIFY(root->property("runtimeRunning").toBool());
        QVERIFY(root->property("tokenCompliant").toBool());

        const double effectiveScale = root->property("effectiveSupersampleScale").toDouble();
        QVERIFY(effectiveScale >= 1.0);
        QVERIFY(effectiveScale <= 4.0);

        root->setProperty("width", 1400);
        root->setProperty("height", 1020);
        QTRY_VERIFY(root->property("expandedRule").toBool());
    }

    {
        QQmlEngine engine;
        engine.addImportPath(qmlImportBase());
        const QString mainPath = QFINDTESTDATA("../qml/Main.qml");
        QVERIFY2(!mainPath.isEmpty(), "Failed to locate ../qml/Main.qml");

        QScopedPointer<QObject> root(loadQmlFile(engine, mainPath));
        QVERIFY(root);
        QTRY_VERIFY(root->property("metricsPass").toBool());
        QVERIFY(root->property("metricsSummary").toString().contains('/'));
        QVERIFY(root->property("runtimeSnapshot").isValid());
    }
}

QTEST_MAIN(MetricsCoverageTests)
#include "tst_metrics_coverage.moc"
