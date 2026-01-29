#include <QtTest>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QCoreApplication>
#include <QDir>
#include <QtPlugin>

Q_IMPORT_PLUGIN(UIFrameworkPlugin)

class DebugTests : public QObject
{
    Q_OBJECT

private slots:
    void debug_enabled_toggle();
};

void DebugTests::debug_enabled_toggle()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import UIFramework 1.0 as UIF

Item {
    Component.onCompleted: {
        UIF.Debug.enabled = true
        UIF.Debug.log("Test", "enabled")
        UIF.Debug.enabled = false
    }
}
)";

    QQmlComponent component(&engine);
    component.setData(qml, QUrl());
    QScopedPointer<QObject> obj(component.create());
    QVERIFY(obj);
}

QTEST_MAIN(DebugTests)
#include "tst_debug.moc"
