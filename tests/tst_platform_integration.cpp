#include <QtTest>

#include <QScopedPointer>
#include <QQmlEngine>
#include <QtPlugin>

#include "backend/platform/platforminfo.h"
#include "test_utils.h"

Q_IMPORT_PLUGIN(LVRSPlugin)

class PlatformIntegrationTests : public QObject
{
    Q_OBJECT

private slots:
    void platform_flags_consistency();
    void application_window_and_main_metrics_are_exposed();
};

void PlatformIntegrationTests::platform_flags_consistency()
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

void PlatformIntegrationTests::application_window_and_main_metrics_are_exposed()
{
    {
        QQmlEngine engine;
        engine.addImportPath(TestUtils::qmlImportBase());

        const QByteArray qml = R"(
import QtQuick
import LVRS as LV

LV.ApplicationWindow {
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
    property bool runtimeRunning: LV.RuntimeEvents.running
    property bool tokenCompliant:
        LV.Theme.isThemeTextStyleCompliant(LV.Theme.textTitle, LV.Theme.textTitleWeight, LV.Theme.textTitleStyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textTitle2, LV.Theme.textTitle2Weight, LV.Theme.textTitle2StyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textHeader, LV.Theme.textHeaderWeight, LV.Theme.textHeaderStyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textHeader2, LV.Theme.textHeader2Weight, LV.Theme.textHeader2StyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textBody, LV.Theme.textBodyWeight, LV.Theme.textBodyStyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textDescription, LV.Theme.textDescriptionWeight, LV.Theme.textDescriptionStyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textCaption, LV.Theme.textCaptionWeight, LV.Theme.textCaptionStyleName)
        && LV.Theme.isThemeTextStyleCompliant(LV.Theme.textDisabled, LV.Theme.textDisabledWeight, LV.Theme.textDisabledStyleName)
}
)";

        QScopedPointer<QObject> root(TestUtils::createFromQml(engine, qml));
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
        engine.addImportPath(TestUtils::qmlImportBase());
        const QString mainPath = QFINDTESTDATA("../qml/Main.qml");
        QVERIFY2(!mainPath.isEmpty(), "Failed to locate ../qml/Main.qml");

        QScopedPointer<QObject> root(TestUtils::loadQmlFile(engine, mainPath));
        QVERIFY(root);
        QTRY_VERIFY(root->property("metricsPass").toBool());
        QCOMPARE(root->property("metricsTotalChecks").toInt(), 6);
        QCOMPARE(root->property("metricsPassedChecks").toInt(), 6);
        QVERIFY(root->property("metricsRenderScaleCompliant").toBool());
        QVERIFY(root->property("metricsFontFallbackCompliant").toBool());
        QVERIFY(root->property("metricsThemeTextCompliant").toBool());
        QVERIFY(root->property("metricsRuntimeCompliant").toBool());
        QVERIFY(root->property("metricsSvgCompliant").toBool());
        QVERIFY(root->property("metricsPageCompliant").toBool());
        QVERIFY(root->property("metricsSummary").toString().contains('/'));
        QVERIFY(root->property("runtimeSnapshot").isValid());
        const QVariantMap snapshot = root->property("runtimeSnapshot").toMap();
        QVERIFY(snapshot.contains(QStringLiteral("pid")));
        QVERIFY(snapshot.contains(QStringLiteral("uptimeMs")));
        QVERIFY(snapshot.contains(QStringLiteral("rssBytes")));
    }
}

QTEST_MAIN(PlatformIntegrationTests)
#include "tst_platform_integration.moc"
