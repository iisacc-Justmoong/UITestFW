#include <QtTest>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQmlProperty>
#include <QQuickItem>
#include <QCoreApplication>
#include <QDir>
#include <QtPlugin>

Q_IMPORT_PLUGIN(LVRSPlugin)

class LayoutTests : public QObject
{
    Q_OBJECT

private slots:
    void vstack_default_spacing();
    void hstack_default_spacing();
    void vstack_alignment_name();
    void hstack_alignment_name();
    void spacer_min_length_vertical();
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

void LayoutTests::vstack_default_spacing()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import QtQuick.Layouts
import LVRS 1.0 as UIF

Item {
    UIF.VStack {
        id: stack
        spacing: -1
    }
}
)";

    QScopedPointer<QObject> root(createFromQml(engine, qml));
    QVERIFY(root);

    const auto children = root->children().first()->children();
    QObject *layout = nullptr;
    for (QObject *child : children) {
        const QString cls = QString::fromLatin1(child->metaObject()->className());
        if (cls.contains("ColumnLayout")) {
            layout = child;
            break;
        }
    }
    QVERIFY(layout);
    QCOMPARE(layout->property("spacing").toInt(), 8);
}

void LayoutTests::hstack_default_spacing()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import QtQuick.Layouts
import LVRS 1.0 as UIF

Item {
    UIF.HStack {
        id: stack
        spacing: -1
    }
}
)";

    QScopedPointer<QObject> root(createFromQml(engine, qml));
    QVERIFY(root);

    const auto children = root->children().first()->children();
    QObject *layout = nullptr;
    for (QObject *child : children) {
        const QString cls = QString::fromLatin1(child->metaObject()->className());
        if (cls.contains("RowLayout")) {
            layout = child;
            break;
        }
    }
    QVERIFY(layout);
    QCOMPARE(layout->property("spacing").toInt(), 8);
}

void LayoutTests::vstack_alignment_name()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import QtQuick.Layouts
import LVRS 1.0 as UIF

Item {
    property int childAlign: child.Layout.alignment

    UIF.VStack {
        alignmentName: "leading"
        Rectangle {
            id: child
            width: 10; height: 10
        }
    }
}
)";

    QScopedPointer<QObject> root(createFromQml(engine, qml));
    QVERIFY(root);
    const int align = root->property("childAlign").toInt();
    QCOMPARE(align, int(Qt::AlignLeft));
}

void LayoutTests::hstack_alignment_name()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import QtQuick.Layouts
import LVRS 1.0 as UIF

Item {
    property int childAlign: child.Layout.alignment

    UIF.HStack {
        alignmentName: "bottom"
        Rectangle {
            id: child
            width: 10; height: 10
        }
    }
}
)";

    QScopedPointer<QObject> root(createFromQml(engine, qml));
    QVERIFY(root);
    const int align = root->property("childAlign").toInt();
    QCOMPARE(align, int(Qt::AlignBottom));
}

void LayoutTests::spacer_min_length_vertical()
{
    QQmlEngine engine;
    const QString importBase = QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
    engine.addImportPath(importBase);
    const QByteArray qml = R"(
import QtQuick
import QtQuick.Layouts
import LVRS 1.0 as UIF

Item {
    property bool fillHeight: spacer.Layout.fillHeight
    property int minHeight: spacer.Layout.minimumHeight

    UIF.VStack {
        UIF.Spacer {
            id: spacer
            minLength: 12
        }
    }
}
)";

    QScopedPointer<QObject> root(createFromQml(engine, qml));
    QVERIFY(root);
    QTRY_VERIFY(root->property("fillHeight").toBool());
    QTRY_COMPARE(root->property("minHeight").toInt(), 12);
}

QTEST_MAIN(LayoutTests)
#include "tst_layout.moc"
