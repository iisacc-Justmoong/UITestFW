#include <QtTest>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QCoreApplication>
#include <QDir>
#include <QtPlugin>

Q_IMPORT_PLUGIN(UIFrameworkPlugin)

class EventListenerTests : public QObject
{
    Q_OBJECT

private slots:
    void click_trigger();
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

QTEST_MAIN(EventListenerTests)
#include "tst_eventlistener.moc"
