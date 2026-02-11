#include <QtTest>

#include <QCoreApplication>
#include <QDir>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QQuickWindow>
#include <QMouseEvent>
#include <QKeyEvent>
#include <QtPlugin>

Q_IMPORT_PLUGIN(LVRSPlugin)

class RuntimeEventsTests : public QObject
{
    Q_OBJECT

private slots:
    void runtime_events_are_exposed_and_idle_transitions();
    void keyboard_and_mouse_events_are_captured();
};

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

static QScopedPointer<QObject> createRuntimeWindow(QQmlEngine &engine)
{
    const QByteArray qml = R"(
import QtQuick
import LVRS as UIF

UIF.ApplicationWindow {
    id: root
    width: 640
    height: 420
    visible: false
    title: "RuntimeEventsTest"

    property bool running: UIF.RuntimeEvents.running
    property int pid: UIF.RuntimeEvents.pid
    property string osLabel: UIF.RuntimeEvents.osName
    property bool idleState: UIF.RuntimeEvents.idle
    property int keyPressCount: UIF.RuntimeEvents.keyPressCount
    property int keyReleaseCount: UIF.RuntimeEvents.keyReleaseCount
    property int mouseMoveCount: UIF.RuntimeEvents.mouseMoveCount
    property int mousePressCount: UIF.RuntimeEvents.mousePressCount
    property int mouseReleaseCount: UIF.RuntimeEvents.mouseReleaseCount
    property int uiCreatedCount: UIF.RuntimeEvents.uiCreatedCount
    property int uiShownCount: UIF.RuntimeEvents.uiShownCount
    property int uiHiddenCount: UIF.RuntimeEvents.uiHiddenCount
    property double uptimeMs: UIF.RuntimeEvents.uptimeMs
    property double rssBytes: UIF.RuntimeEvents.rssBytes

    function resetMonitor() {
        UIF.RuntimeEvents.resetCounters()
        UIF.RuntimeEvents.idleTimeoutMs = 150
        UIF.RuntimeEvents.markActivity()
    }

    function pokeActivity() {
        UIF.RuntimeEvents.markActivity()
    }
}
)";
    return QScopedPointer<QObject>(createFromQml(engine, qml));
}

void RuntimeEventsTests::runtime_events_are_exposed_and_idle_transitions()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);

    QScopedPointer<QObject> root = createRuntimeWindow(engine);
    QVERIFY(root);

    QTRY_VERIFY(root->property("running").toBool());
    QVERIFY(root->property("pid").toInt() > 0);
    QVERIFY(!root->property("osLabel").toString().isEmpty());
    QVERIFY(root->property("uiCreatedCount").toInt() > 0);

    QVERIFY(QMetaObject::invokeMethod(root.data(), "resetMonitor"));
    QTRY_VERIFY(root->property("uptimeMs").toDouble() >= 0.0);
    QTRY_VERIFY(root->property("idleState").toBool());

    QVERIFY(QMetaObject::invokeMethod(root.data(), "pokeActivity"));
    QTRY_VERIFY(!root->property("idleState").toBool());
}

void RuntimeEventsTests::keyboard_and_mouse_events_are_captured()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);

    QScopedPointer<QObject> root = createRuntimeWindow(engine);
    QVERIFY(root);
    QVERIFY(QMetaObject::invokeMethod(root.data(), "resetMonitor"));
    QTRY_VERIFY(root->property("running").toBool());

    auto *window = qobject_cast<QQuickWindow *>(root.data());
    QVERIFY(window);

    const int keyPressBefore = root->property("keyPressCount").toInt();
    const int keyReleaseBefore = root->property("keyReleaseCount").toInt();
    const int mouseMoveBefore = root->property("mouseMoveCount").toInt();
    const int mousePressBefore = root->property("mousePressCount").toInt();
    const int mouseReleaseBefore = root->property("mouseReleaseCount").toInt();

    QKeyEvent keyPress(QEvent::KeyPress, Qt::Key_A, Qt::NoModifier, QStringLiteral("a"));
    QKeyEvent keyRelease(QEvent::KeyRelease, Qt::Key_A, Qt::NoModifier, QStringLiteral("a"));
    QCoreApplication::sendEvent(window, &keyPress);
    QCoreApplication::sendEvent(window, &keyRelease);

    QMouseEvent mouseMove(QEvent::MouseMove,
                          QPointF(24.0, 20.0),
                          QPointF(24.0, 20.0),
                          QPointF(24.0, 20.0),
                          Qt::NoButton,
                          Qt::NoButton,
                          Qt::NoModifier);
    QMouseEvent mousePress(QEvent::MouseButtonPress,
                           QPointF(24.0, 20.0),
                           QPointF(24.0, 20.0),
                           QPointF(24.0, 20.0),
                           Qt::LeftButton,
                           Qt::LeftButton,
                           Qt::NoModifier);
    QMouseEvent mouseRelease(QEvent::MouseButtonRelease,
                             QPointF(24.0, 20.0),
                             QPointF(24.0, 20.0),
                             QPointF(24.0, 20.0),
                             Qt::LeftButton,
                             Qt::NoButton,
                             Qt::NoModifier);
    QCoreApplication::sendEvent(window, &mouseMove);
    QCoreApplication::sendEvent(window, &mousePress);
    QCoreApplication::sendEvent(window, &mouseRelease);

    QTRY_VERIFY(root->property("keyPressCount").toInt() > keyPressBefore);
    QTRY_VERIFY(root->property("keyReleaseCount").toInt() > keyReleaseBefore);
    QTRY_VERIFY(root->property("mouseMoveCount").toInt() > mouseMoveBefore);
    QTRY_VERIFY(root->property("mousePressCount").toInt() > mousePressBefore);
    QTRY_VERIFY(root->property("mouseReleaseCount").toInt() > mouseReleaseBefore);
}

QTEST_MAIN(RuntimeEventsTests)
#include "tst_runtimeevents.moc"
