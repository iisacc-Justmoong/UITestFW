#include <QtTest>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QCoreApplication>
#include <QDir>
#include <QtPlugin>

#if defined(LVRS_USE_STATIC_QML_PLUGIN)
Q_IMPORT_PLUGIN(LVRSPlugin)
#endif

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
import LVRS 1.0 as LV

Item {
    Component.onCompleted: {
        LV.Debug.enabled = true
        LV.Debug.log("Test", "enabled")
        LV.Debug.enabled = false
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
