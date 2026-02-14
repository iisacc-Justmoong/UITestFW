#include <QtTest>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QCoreApplication>
#include <QContextMenuEvent>
#include <QDir>
#include <QMouseEvent>
#include <QQuickWindow>
#include <QtPlugin>

Q_IMPORT_PLUGIN(LVRSPlugin)

class EventListenerTests : public QObject
{
    Q_OBJECT

private slots:
    void click_trigger();
    void global_context_requested_trigger();
    void application_window_global_context_signal();
};

void EventListenerTests::click_trigger()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import LVRS 1.0 as LV

Item {
    id: root
    width: 100
    height: 40
    property int count: 0

    Rectangle {
        anchors.fill: parent
        LV.EventListener {
            objectName: "listener"
            trigger: "clicked"
            action: () => root.count++
        }
    }
}
)";

    QQmlComponent component(&engine);
    component.setData(qml, QUrl());
    QScopedPointer<QObject> object(component.create());
    QVERIFY(object);

    QObject *listener = object->findChild<QObject *>("listener");
    QVERIFY(listener);
    QVariant payload;
    QVERIFY(QMetaObject::invokeMethod(listener, "fire", Q_ARG(QVariant, payload)));
    QCOMPARE(object->property("count").toInt(), 1);
}

void EventListenerTests::global_context_requested_trigger()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import LVRS 1.0 as LV

LV.ApplicationWindow {
    id: root
    width: 240
    height: 140
    visible: false
    title: "EventListenerGlobalContextTest"

    property int contextCount: 0
    property bool runtimeRunning: LV.RuntimeEvents.running
    property string lastSource: ""
    property int lastReason: -2

    function resetMonitor() {
        contextCount = 0
        lastSource = ""
        lastReason = -2
        LV.RuntimeEvents.resetCounters()
    }

    LV.EventListener {
        trigger: "globalContextRequested"
        enabled: true
        action: function(mouse) {
            root.contextCount += 1
            root.lastSource = mouse.source || ""
            root.lastReason = mouse.reason === undefined ? -2 : mouse.reason
        }
    }
}
)";

    QQmlComponent component(&engine);
    component.setData(qml, QUrl());
    QScopedPointer<QObject> object(component.create());
    QVERIFY(object);

    QTRY_VERIFY(object->property("runtimeRunning").toBool());
    QVERIFY(QMetaObject::invokeMethod(object.data(), "resetMonitor"));

    auto *window = qobject_cast<QQuickWindow *>(object.data());
    QVERIFY(window);

    const QPointF p(24.0, 18.0);
    QMouseEvent mousePress(QEvent::MouseButtonPress,
                           p,
                           p,
                           p,
                           Qt::RightButton,
                           Qt::RightButton,
                           Qt::NoModifier);
    QCoreApplication::sendEvent(window, &mousePress);
    QTRY_VERIFY(object->property("contextCount").toInt() >= 1);
    QCOMPARE(object->property("lastSource").toString(), QStringLiteral("mouse"));

    const QPoint local(34, 22);
    const QPoint global(460, 360);
    QContextMenuEvent contextEvent(QContextMenuEvent::Keyboard, local, global, Qt::NoModifier);
    QCoreApplication::sendEvent(window, &contextEvent);
    QTRY_VERIFY(object->property("contextCount").toInt() >= 2);
    QCOMPARE(object->property("lastSource").toString(), QStringLiteral("context"));
    QCOMPARE(object->property("lastReason").toInt(), static_cast<int>(QContextMenuEvent::Keyboard));
}

void EventListenerTests::application_window_global_context_signal()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import LVRS 1.0 as LV

LV.ApplicationWindow {
    id: root
    width: 240
    height: 140
    visible: false
    title: "ApplicationWindowGlobalSignalTest"

    property int contextCount: 0
    property bool hasUiPayload: false
    property real lastGlobalX: -1
    property real lastGlobalY: -1

    onGlobalContextEvent: function(eventData) {
        contextCount += 1
        hasUiPayload = !!(eventData && eventData.ui && eventData.ui.objectName !== undefined)
        lastGlobalX = eventData && eventData.globalX !== undefined ? eventData.globalX : -1
        lastGlobalY = eventData && eventData.globalY !== undefined ? eventData.globalY : -1
    }
}
)";

    QQmlComponent component(&engine);
    component.setData(qml, QUrl());
    QScopedPointer<QObject> object(component.create());
    QVERIFY(object);

    auto *window = qobject_cast<QQuickWindow *>(object.data());
    QVERIFY(window);

    const QPointF p(26.0, 19.0);
    QMouseEvent mousePress(QEvent::MouseButtonPress,
                           p,
                           p,
                           p,
                           Qt::RightButton,
                           Qt::RightButton,
                           Qt::NoModifier);
    QCoreApplication::sendEvent(window, &mousePress);

    QTRY_VERIFY(object->property("contextCount").toInt() >= 1);
    QVERIFY(object->property("hasUiPayload").toBool());
    QVERIFY(object->property("lastGlobalX").toReal() >= 0.0);
    QVERIFY(object->property("lastGlobalY").toReal() >= 0.0);
}

QTEST_MAIN(EventListenerTests)
#include "tst_eventlistener.moc"
