#include <QtTest>

#include <QScopedPointer>
#include <QQmlEngine>
#include <QtPlugin>

#include "test_utils.h"

Q_IMPORT_PLUGIN(UIFrameworkPlugin)

class PageRouterTests : public QObject
{
    Q_OBJECT

private slots:
    void route_params_are_passed_to_target_component();
    void component_navigation_keeps_path_stack_in_sync();
};

void PageRouterTests::route_params_are_passed_to_target_component()
{
    QQmlEngine engine;
    engine.addImportPath(TestUtils::qmlImportBase());

    const QByteArray qml = R"(
import QtQuick
import UIFramework as UIF

Item {
    id: root
    width: 320
    height: 240

    property string capturedRunId: ""
    property string capturedMode: ""
    property int depth: router.depth
    property int pathLength: router.path.length
    property string currentPath: router.currentPath
    property var currentParams: router.currentParams

    Component {
        id: homePage
        Item { }
    }

    Component {
        id: runPage
        Item {
            property string runId: ""
            property string mode: ""
            Component.onCompleted: {
                root.capturedRunId = runId
                root.capturedMode = mode
            }
        }
    }

    UIF.PageRouter {
        id: router
        anchors.fill: parent
        initialPath: "/"
        routes: [
            { path: "/", component: homePage },
            { path: "/runs/[runId]", component: runPage }
        ]
    }

    function openRun() {
        router.go("/runs/42", { mode: "push" })
    }
}
)";

    QScopedPointer<QObject> root(TestUtils::createFromQml(engine, qml));
    QVERIFY(root);
    QTRY_COMPARE(root->property("depth").toInt(), 1);
    QCOMPARE(root->property("pathLength").toInt(), 1);
    QCOMPARE(root->property("currentPath").toString(), QStringLiteral("/"));

    QVERIFY(QMetaObject::invokeMethod(root.data(), "openRun"));
    QTRY_COMPARE(root->property("capturedRunId").toString(), QStringLiteral("42"));
    QTRY_COMPARE(root->property("capturedMode").toString(), QStringLiteral("push"));
    QCOMPARE(root->property("depth").toInt(), 2);
    QCOMPARE(root->property("pathLength").toInt(), 2);
    QCOMPARE(root->property("currentPath").toString(), QStringLiteral("/runs/42"));

    const QVariantMap currentParams = root->property("currentParams").toMap();
    QCOMPARE(currentParams.value(QStringLiteral("runId")).toString(), QStringLiteral("42"));
    QCOMPARE(currentParams.value(QStringLiteral("mode")).toString(), QStringLiteral("push"));
}

void PageRouterTests::component_navigation_keeps_path_stack_in_sync()
{
    QQmlEngine engine;
    engine.addImportPath(TestUtils::qmlImportBase());

    const QByteArray qml = R"(
import QtQuick
import UIFramework as UIF

Item {
    id: root
    width: 320
    height: 240

    property string componentTag: ""
    property int depth: router.depth
    property int pathLength: router.path.length
    property string currentPath: router.currentPath

    Component {
        id: homePage
        Item { }
    }

    Component {
        id: componentPage
        Item {
            property string tag: ""
            Component.onCompleted: root.componentTag = tag
        }
    }

    UIF.PageRouter {
        id: router
        anchors.fill: parent
        initialPath: "/"
        routes: [{ path: "/", component: homePage }]
    }

    function pushComponent() {
        router.goTo(componentPage, { tag: "push" })
    }

    function replaceComponent() {
        router.replaceWith(componentPage, { tag: "replace" })
    }

    function setComponentRoot() {
        router.setRootComponent(componentPage, { tag: "root" })
    }

    function clearExternalPath() {
        router.path = []
    }
}
)";

    QScopedPointer<QObject> root(TestUtils::createFromQml(engine, qml));
    QVERIFY(root);
    QTRY_COMPARE(root->property("depth").toInt(), 1);
    QCOMPARE(root->property("pathLength").toInt(), 1);
    QCOMPARE(root->property("currentPath").toString(), QStringLiteral("/"));

    QVERIFY(QMetaObject::invokeMethod(root.data(), "pushComponent"));
    QTRY_COMPARE(root->property("componentTag").toString(), QStringLiteral("push"));
    QCOMPARE(root->property("depth").toInt(), 2);
    QCOMPARE(root->property("pathLength").toInt(), 2);
    QCOMPARE(root->property("currentPath").toString(), QString());

    QVERIFY(QMetaObject::invokeMethod(root.data(), "replaceComponent"));
    QTRY_COMPARE(root->property("componentTag").toString(), QStringLiteral("replace"));
    QCOMPARE(root->property("depth").toInt(), 2);
    QCOMPARE(root->property("pathLength").toInt(), 2);
    QCOMPARE(root->property("currentPath").toString(), QString());

    QVERIFY(QMetaObject::invokeMethod(root.data(), "setComponentRoot"));
    QTRY_COMPARE(root->property("componentTag").toString(), QStringLiteral("root"));
    QCOMPARE(root->property("depth").toInt(), 1);
    QCOMPARE(root->property("pathLength").toInt(), 1);
    QCOMPARE(root->property("currentPath").toString(), QString());

    QVERIFY(QMetaObject::invokeMethod(root.data(), "clearExternalPath"));
    QTRY_COMPARE(root->property("depth").toInt(), 0);
    QCOMPARE(root->property("pathLength").toInt(), 0);
    QCOMPARE(root->property("currentPath").toString(), QString());
}

QTEST_MAIN(PageRouterTests)
#include "tst_page_router.moc"
