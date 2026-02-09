#include <QtTest>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QCoreApplication>
#include <QDir>
#include <QtPlugin>

Q_IMPORT_PLUGIN(UIFrameworkPlugin)

class ImportApiTests : public QObject
{
    Q_OBJECT

private slots:
    void versionless_import_application_window_loads();
    void appshell_compat_loads();
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

void ImportApiTests::versionless_import_application_window_loads()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import UIFramework as UIF

UIF.ApplicationWindow {
    width: 1200
    height: 800
    visible: false
    title: "API"
    subtitle: "Merged"
    navItems: ["Overview", "Runs"]
    navigationEnabled: true

    property bool importReady: UIF.Theme.dark
    property bool shellApiReady: navItems.length === 2 && navWidth > 0 && navDrawerWidth > 0
    property bool qualityReady: UIF.RenderQuality.enabled && UIF.RenderQuality.supersampleScale >= 3.0

    UIF.Label {
        text: "Content Slot"
    }
}
)";

    QScopedPointer<QObject> root(createFromQml(engine, qml));
    QVERIFY(root);
    QVERIFY(root->property("importReady").toBool());
    QVERIFY(root->property("shellApiReady").toBool());
    QVERIFY(root->property("qualityReady").toBool());
    QCOMPARE(root->property("subtitle").toString(), QStringLiteral("Merged"));
}

void ImportApiTests::appshell_compat_loads()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import UIFramework as UIF

UIF.AppShell {
    width: 1000
    height: 700
    visible: false
    title: "Compat"
    subtitle: "Wrapper"
    navItems: ["A"]
    navigationEnabled: true
}
)";

    QScopedPointer<QObject> root(createFromQml(engine, qml));
    QVERIFY(root);
    QCOMPARE(root->property("title").toString(), QStringLiteral("Compat"));
    QCOMPARE(root->property("subtitle").toString(), QStringLiteral("Wrapper"));
    QVERIFY(root->property("navItems").isValid());
}

QTEST_MAIN(ImportApiTests)
#include "tst_import_api.moc"
