#include <QtTest>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QCoreApplication>
#include <QContextMenuEvent>
#include <QDir>
#include <QMouseEvent>
#include <QQuickWindow>
#include <QtPlugin>

Q_IMPORT_PLUGIN(UIFrameworkPlugin)

class EventListenerTests : public QObject
{
    Q_OBJECT

private slots:
    void click_trigger();
    void global_context_requested_trigger();
};

void EventListenerTests::click_trigger()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import UIFramework 1.0 as UIF

Item {
    id: root
    width: 100
    height: 40
    property int count: 0

    Rectangle {
        anchors.fill: parent
        UIF.EventListener {
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
import UIFramework 1.0 as UIF

UIF.ApplicationWindow {
    id: root
    width: 240
    height: 140
    visible: false
    title: "EventListenerGlobalContextTest"

    property int contextCount: 0
    property bool runtimeRunning: UIF.RuntimeEvents.running
    property string lastSource: ""
    property int lastReason: -2

    function resetMonitor() {
        contextCount = 0
        lastSource = ""
        lastReason = -2
        UIF.RuntimeEvents.resetCounters()
    }

    UIF.EventListener {
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

QTEST_MAIN(EventListenerTests)
#include "tst_eventlistener.moc"
