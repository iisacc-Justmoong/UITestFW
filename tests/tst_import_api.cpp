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
    property bool labelStyleApiReady: contentLabel.style === contentLabel.body
        && contentLabel.font.pixelSize === UIF.Theme.textBody
        && contentLabel.font.weight === UIF.Theme.textBodyWeight
        && contentLabel.color === UIF.Theme.bodyColor
    property bool figmaTextDesignReady:
        titleLabel.font.pixelSize === UIF.Theme.textTitle
        && titleLabel.font.weight === UIF.Theme.textTitleWeight
        && titleLabel.color === UIF.Theme.titleHeaderColor
        && title2Label.font.pixelSize === UIF.Theme.textTitle2
        && title2Label.font.weight === UIF.Theme.textTitle2Weight
        && title2Label.color === UIF.Theme.titleHeaderColor
        && headerLabel.font.pixelSize === UIF.Theme.textHeader
        && headerLabel.font.weight === UIF.Theme.textHeaderWeight
        && headerLabel.color === UIF.Theme.titleHeaderColor
        && header2Label.font.pixelSize === UIF.Theme.textHeader2
        && header2Label.font.weight === UIF.Theme.textHeader2Weight
        && header2Label.color === UIF.Theme.titleHeaderColor
        && bodyLabel.font.pixelSize === UIF.Theme.textBody
        && bodyLabel.font.weight === UIF.Theme.textBodyWeight
        && bodyLabel.color === UIF.Theme.bodyColor
        && descriptionLabel.font.pixelSize === UIF.Theme.textDescription
        && descriptionLabel.font.weight === UIF.Theme.textDescriptionWeight
        && descriptionLabel.color === UIF.Theme.descriptionColor
        && captionLabel.font.pixelSize === UIF.Theme.textCaption
        && captionLabel.font.weight === UIF.Theme.textCaptionWeight
        && captionLabel.color === UIF.Theme.captionColor
        && disabledLabel.font.pixelSize === UIF.Theme.textDisabled
        && disabledLabel.font.weight === UIF.Theme.textDisabledWeight
        && disabledLabel.color === UIF.Theme.disabledColor

    UIF.Label {
        id: contentLabel
        text: "Content Slot"
        style: body
    }
    UIF.Label { id: titleLabel; text: "Title"; style: title; visible: false }
    UIF.Label { id: title2Label; text: "Title2"; style: title2; visible: false }
    UIF.Label { id: headerLabel; text: "Header"; style: header; visible: false }
    UIF.Label { id: header2Label; text: "Header2"; style: header2; visible: false }
    UIF.Label { id: bodyLabel; text: "Body"; style: body; visible: false }
    UIF.Label { id: descriptionLabel; text: "Description"; style: description; visible: false }
    UIF.Label { id: captionLabel; text: "Caption"; style: caption; visible: false }
    UIF.Label { id: disabledLabel; text: "Disabled"; style: disabled; visible: false }
}
)";

    QScopedPointer<QObject> root(createFromQml(engine, qml));
    QVERIFY(root);
    QVERIFY(root->property("importReady").toBool());
    QVERIFY(root->property("shellApiReady").toBool());
    QVERIFY(root->property("qualityReady").toBool());
    QVERIFY(root->property("labelStyleApiReady").toBool());
    QVERIFY(root->property("figmaTextDesignReady").toBool());
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
