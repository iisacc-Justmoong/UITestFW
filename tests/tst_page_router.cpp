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
    void global_navigator_allows_one_line_navigation();
    void route_mvvm_binding_and_write_ownership_are_applied();
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

void PageRouterTests::global_navigator_allows_one_line_navigation()
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

    property string currentPath: router.currentPath
    property int depth: router.depth

    Component { id: homePage; Item { } }
    Component { id: reportsPage; Item { } }
    Component { id: settingsPage; Item { } }

    UIF.PageRouter {
        id: router
        anchors.fill: parent
        initialPath: "/"
        routes: [
            { path: "/", component: homePage },
            { path: "/reports", component: reportsPage },
            { path: "/settings", component: settingsPage }
        ]
    }

    UIF.Link {
        id: globalLink
        visible: false
        href: "/settings"
    }

    function goReportsInOneLine() {
        UIF.Navigator.go("/reports")
    }

    function goSettingsByLink() {
        globalLink.clicked()
    }

    function goBackInOneLine() {
        UIF.Navigator.back()
    }
}
)";

    QScopedPointer<QObject> root(TestUtils::createFromQml(engine, qml));
    QVERIFY(root);
    QTRY_COMPARE(root->property("currentPath").toString(), QStringLiteral("/"));
    QCOMPARE(root->property("depth").toInt(), 1);

    QVERIFY(QMetaObject::invokeMethod(root.data(), "goReportsInOneLine"));
    QTRY_COMPARE(root->property("currentPath").toString(), QStringLiteral("/reports"));
    QCOMPARE(root->property("depth").toInt(), 2);

    QVERIFY(QMetaObject::invokeMethod(root.data(), "goSettingsByLink"));
    QTRY_COMPARE(root->property("currentPath").toString(), QStringLiteral("/settings"));
    QCOMPARE(root->property("depth").toInt(), 3);

    QVERIFY(QMetaObject::invokeMethod(root.data(), "goBackInOneLine"));
    QTRY_COMPARE(root->property("currentPath").toString(), QStringLiteral("/reports"));
    QCOMPARE(root->property("depth").toInt(), 2);
}

void PageRouterTests::route_mvvm_binding_and_write_ownership_are_applied()
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

    property string ownerOverview: {
        UIF.ViewModels.owners
        return UIF.ViewModels.ownerOf("OverviewVM")
    }
    property string ownerReports: {
        UIF.ViewModels.owners
        return UIF.ViewModels.ownerOf("ReportsVM")
    }
    property bool canWriteOverview: {
        UIF.ViewModels.bindings
        UIF.ViewModels.owners
        return UIF.ViewModels.canWrite("/overview")
    }
    property bool canWriteReports: {
        UIF.ViewModels.bindings
        UIF.ViewModels.owners
        return UIF.ViewModels.canWrite("/reports")
    }
    property string overviewStatus: overviewVm.status

    QtObject {
        id: overviewVm
        property string status: "Idle"
    }

    QtObject {
        id: reportsVm
        property string status: "Ready"
    }

    Component {
        id: overviewPage
        Item { }
    }

    Component {
        id: reportsPage
        Item { }
    }

    UIF.PageRouter {
        id: router
        anchors.fill: parent
        initialPath: "/overview"
        routes: [
            { path: "/overview", component: overviewPage, viewModelKey: "OverviewVM", writable: true },
            { path: "/reports", component: reportsPage, viewModelKey: "ReportsVM" }
        ]
    }

    function prepare() {
        UIF.ViewModels.clear()
        UIF.ViewModels.set("OverviewVM", overviewVm)
        UIF.ViewModels.set("ReportsVM", reportsVm)
        router.setRoot("/overview")
    }

    function goReports() {
        router.go("/reports")
    }

    function writeOverviewStatus(nextStatus) {
        UIF.ViewModels.updateProperty("/overview", "status", nextStatus)
    }
}
)";

    QScopedPointer<QObject> root(TestUtils::createFromQml(engine, qml));
    QVERIFY(root);
    QVERIFY(QMetaObject::invokeMethod(root.data(), "prepare"));

    QTRY_COMPARE(root->property("ownerOverview").toString(), QStringLiteral("/overview"));
    QCOMPARE(root->property("ownerReports").toString(), QString());
    QCOMPARE(root->property("canWriteOverview").toBool(), true);
    QCOMPARE(root->property("canWriteReports").toBool(), false);

    QVERIFY(QMetaObject::invokeMethod(root.data(),
                                      "writeOverviewStatus",
                                      Q_ARG(QVariant, QVariant(QStringLiteral("Working")))));
    QTRY_COMPARE(root->property("overviewStatus").toString(), QStringLiteral("Working"));

    QVERIFY(QMetaObject::invokeMethod(root.data(), "goReports"));
    QTRY_COMPARE(root->property("canWriteReports").toBool(), false);
}

QTEST_MAIN(PageRouterTests)
#include "tst_page_router.moc"
