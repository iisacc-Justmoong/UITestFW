#include <QtTest>

#include <QScopedPointer>
#include <QQmlEngine>
#include <QtPlugin>

#include "test_utils.h"

Q_IMPORT_PLUGIN(LVRSPlugin)

class PageRouterTests : public QObject
{
    Q_OBJECT

private slots:
    void route_params_are_passed_to_target_component();
    void component_navigation_keeps_path_stack_in_sync();
    void page_router_updates_view_state_tracker_from_stack();
};

void PageRouterTests::route_params_are_passed_to_target_component()
{
    QQmlEngine engine;
    engine.addImportPath(TestUtils::qmlImportBase());

    const QByteArray qml = R"(
import QtQuick
import LVRS as UIF

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
import LVRS as UIF

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

void PageRouterTests::page_router_updates_view_state_tracker_from_stack()
{
    QQmlEngine engine;
    engine.addImportPath(TestUtils::qmlImportBase());

    const QByteArray qml = R"(
import QtQuick
import LVRS as UIF

Item {
    id: root
    width: 320
    height: 240

    property string activeView: UIF.ViewStateTracker.currentActiveView
    property string rootState: {
        UIF.ViewStateTracker.stack
        return UIF.ViewStateTracker.stateOf("/")
    }
    property string runState: {
        UIF.ViewStateTracker.stack
        return UIF.ViewStateTracker.stateOf("/runs/42")
    }
    property int loadedCount: UIF.ViewStateTracker.loadedCount

    Component {
        id: homePage
        Item { }
    }

    Component {
        id: runPage
        Item { property string runId: "" }
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

    function resetTracker() {
        UIF.ViewStateTracker.clear()
        router.setRoot("/")
    }

    function openRun() {
        router.go("/runs/42")
    }

    function goBack() {
        router.back()
    }
}
)";

    QScopedPointer<QObject> root(TestUtils::createFromQml(engine, qml));
    QVERIFY(root);
    QVERIFY(QMetaObject::invokeMethod(root.data(), "resetTracker"));

    QTRY_COMPARE(root->property("activeView").toString(), QStringLiteral("/"));
    QTRY_COMPARE(root->property("rootState").toString(), QStringLiteral("Active"));
    QTRY_COMPARE(root->property("loadedCount").toInt(), 1);

    QVERIFY(QMetaObject::invokeMethod(root.data(), "openRun"));
    QTRY_COMPARE(root->property("activeView").toString(), QStringLiteral("/runs/42"));
    QTRY_COMPARE(root->property("rootState").toString(), QStringLiteral("Inactive"));
    QTRY_COMPARE(root->property("runState").toString(), QStringLiteral("Active"));
    QTRY_COMPARE(root->property("loadedCount").toInt(), 2);

    QVERIFY(QMetaObject::invokeMethod(root.data(), "goBack"));
    QTRY_COMPARE(root->property("activeView").toString(), QStringLiteral("/"));
    QTRY_COMPARE(root->property("rootState").toString(), QStringLiteral("Active"));
    QTRY_COMPARE(root->property("runState").toString(), QString());
    QTRY_COMPARE(root->property("loadedCount").toInt(), 1);
}

QTEST_MAIN(PageRouterTests)
#include "tst_page_router.moc"
