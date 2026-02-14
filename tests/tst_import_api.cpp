#include <QtTest>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QCoreApplication>
#include <QDir>
#include <QtPlugin>

Q_IMPORT_PLUGIN(LVRSPlugin)

class ImportApiTests : public QObject
{
    Q_OBJECT

private slots:
    void versionless_import_application_window_loads();
    void versionless_import_window_loads();
    void appshell_compat_loads();
    void icon_name_mapping_loads();
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
import LVRS as UIF

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

void ImportApiTests::versionless_import_window_loads()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import LVRS as LV

LV.Window {
    width: 520
    height: 360
    visible: false
    title: "Settings"
    usePlatformSafeMargin: true

    property bool windowApiReady: platform.length > 0
        && (widthClass >= compact && widthClass <= expanded)
        && (heightClass >= compact && heightClass <= expanded)
        && typeof matchesMedia === "function"
    property bool contentApiReady: contentLabel.text === "Window Content"

    LV.Label {
        id: contentLabel
        text: "Window Content"
        style: body
    }
}
)";

    QScopedPointer<QObject> root(createFromQml(engine, qml));
    QVERIFY(root);
    QCOMPARE(root->property("title").toString(), QStringLiteral("Settings"));
    QVERIFY(root->property("solidChrome").toBool());
    QVERIFY(root->property("windowApiReady").toBool());
    QVERIFY(root->property("contentApiReady").toBool());
}

void ImportApiTests::appshell_compat_loads()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import LVRS as UIF

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

void ImportApiTests::icon_name_mapping_loads()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import LVRS as UIF

Item {
    id: root

    property string iconRoot: "qrc:/qt/qml/LVRS/resources/iconset/"
    property string expectedByName: iconRoot + "viewMoreSymbolicDefault.svg"
    property string expectedByExt: iconRoot + "viewMoreSymbolicBorderless.svg"
    property string expectedByGroup: iconRoot + "panDownSymbolicDefault.svg"
    property string expectedByUrl: iconRoot + "panDownSymbolicAccent.svg"
    property string expectedMenuByName: iconRoot + "panDownSymbolicBorderless.svg"
    property bool themeAddsSvg: UIF.Theme.iconPath("panDownSymbolicDisabled") === iconRoot + "panDownSymbolicDisabled.svg"
    property bool themeKeepsSvg: UIF.Theme.iconPath("panDownSymbolicDisabled.svg") === iconRoot + "panDownSymbolicDisabled.svg"

    UIF.IconButton {
        id: byName
        iconName: "viewMoreSymbolicDefault"
        visible: false
    }

    UIF.IconButton {
        id: byExt
        iconName: "viewMoreSymbolicBorderless.svg"
        visible: false
    }

    UIF.IconButton {
        id: byGroupName
        icon.name: "panDownSymbolicDefault"
        visible: false
    }

    UIF.IconButton {
        id: byUrl
        iconSource: root.expectedByUrl
        iconName: "viewMoreSymbolicDefault"
        visible: false
    }

    UIF.IconMenuButton {
        id: menuByName
        iconName: "panDownSymbolicBorderless"
        visible: false
    }

    property bool byNameOk: byName.resolvedIconSource.toString() === expectedByName
    property bool byExtOk: byExt.resolvedIconSource.toString() === expectedByExt
    property bool byGroupOk: byGroupName.resolvedIconSource.toString() === expectedByGroup
    property bool byUrlOk: byUrl.resolvedIconSource.toString() === expectedByUrl
    property bool menuByNameOk: menuByName.resolvedIconSource.toString() === expectedMenuByName
}
)";

    QScopedPointer<QObject> root(createFromQml(engine, qml));
    QVERIFY(root);
    QVERIFY(root->property("themeAddsSvg").toBool());
    QVERIFY(root->property("themeKeepsSvg").toBool());
    QVERIFY(root->property("byNameOk").toBool());
    QVERIFY(root->property("byExtOk").toBool());
    QVERIFY(root->property("byGroupOk").toBool());
    QVERIFY(root->property("byUrlOk").toBool());
    QVERIFY(root->property("menuByNameOk").toBool());
}

QTEST_MAIN(ImportApiTests)
#include "tst_import_api.moc"
