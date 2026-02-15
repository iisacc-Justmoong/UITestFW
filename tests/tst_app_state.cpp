#include <QtTest>

#include <QtPlugin>

#include "backend/state/appstate.h"

#if defined(LVRS_USE_STATIC_QML_PLUGIN)
Q_IMPORT_PLUGIN(LVRSPlugin)
#endif

class AppStateTests : public QObject
{
    Q_OBJECT

private slots:
    void defaults_and_progress_clamping();
    void route_tracking_updates_models();
    void snapshot_sync_bridges_backend_state();
    void resilient_normalization_and_index_clamping();
    void definitions_drive_route_matching();
};

void AppStateTests::defaults_and_progress_clamping()
{
    AppState state;

    QCOMPARE(state.currentRoute(), QStringLiteral("/overview"));
    QCOMPARE(state.progressStart(), 0.0);
    QCOMPARE(state.progressEnd(), 100.0);
    QCOMPARE(state.progressCurrent(), 46.0);

    state.setProgressCurrent(140.0);
    QCOMPARE(state.progressCurrent(), 100.0);

    state.setProgressStart(40.0);
    QCOMPARE(state.progressCurrent(), 100.0);

    state.setProgressEnd(80.0);
    QCOMPARE(state.progressCurrent(), 80.0);

    state.nudgeProgress(-1000.0);
    QCOMPARE(state.progressCurrent(), 40.0);
}

void AppStateTests::route_tracking_updates_models()
{
    AppState state;
    state.bootstrap();

    QVERIFY(!state.navItems().isEmpty());
    QVERIFY(!state.scaffoldNavModel().isEmpty());
    QVERIFY(!state.demoListItems().isEmpty());

    state.recordNavigation(QStringLiteral("/reports"));
    QCOMPARE(state.currentRoute(), QStringLiteral("/reports"));
    QCOMPARE(state.scaffoldNavIndex(), -1);
    QCOMPARE(state.pageHistory().size(), 1);
    QCOMPARE(state.pageHistory().last(), QStringLiteral("/reports"));

    const QVariantList listItems = state.demoListItems();
    QVERIFY(listItems.size() >= 2);
    QCOMPARE(listItems.at(0).toMap().value(QStringLiteral("selected")).toBool(), false);
    QCOMPARE(listItems.at(1).toMap().value(QStringLiteral("selected")).toBool(), true);

    state.recordNavigation(QStringLiteral("/reports"));
    QCOMPARE(state.pageHistory().size(), 2);
    QCOMPARE(state.pageHistory().last(), QStringLiteral("/reports"));

    QString reportsBadge;
    const QVariantList navItems = state.navItems();
    for (const QVariant &entry : navItems) {
        const QVariantMap map = entry.toMap();
        if (map.value(QStringLiteral("path")).toString() == QStringLiteral("/reports")) {
            reportsBadge = map.value(QStringLiteral("badge")).toString();
            break;
        }
    }
    QCOMPARE(reportsBadge, QStringLiteral("2"));
}

void AppStateTests::snapshot_sync_bridges_backend_state()
{
    AppState state;

    const QVariantMap runtime {
        {QStringLiteral("pid"), 77},
        {QStringLiteral("uptimeMs"), 64000}
    };
    state.syncRuntimeSnapshot(runtime);
    QCOMPARE(state.runtimeSnapshot(), runtime);

    const QVariantMap viewState {
        {QStringLiteral("currentActiveView"), QStringLiteral("/runs")},
        {QStringLiteral("loadedViews"), QStringList {QStringLiteral("/overview"), QStringLiteral("/runs")}}
    };
    state.syncViewStateSnapshot(viewState);
    QCOMPARE(state.viewStateSnapshot(), viewState);

    state.syncPageHistory(QStringList {
        QStringLiteral("/overview"),
        QStringLiteral("/runs"),
        QStringLiteral("/runs")
    });

    QCOMPARE(state.currentRoute(), QStringLiteral("/runs"));
    QCOMPARE(state.scaffoldNavIndex(), 1);
    QCOMPARE(state.pageHistory().size(), 3);

    const QVariantList scaffold = state.scaffoldNavModel();
    QVERIFY(scaffold.size() >= 2);
    QCOMPARE(scaffold.at(1).toMap().value(QStringLiteral("badge")).toString(), QStringLiteral("2"));
}

void AppStateTests::resilient_normalization_and_index_clamping()
{
    AppState state;

    state.recordNavigation(QStringLiteral(" reports?tab=summary "));
    QCOMPARE(state.currentRoute(), QStringLiteral("/reports"));

    state.recordNavigation(QStringLiteral("https://example.com/runs/42?tab=logs#tail"));
    QCOMPARE(state.currentRoute(), QStringLiteral("/runs/42"));

    state.setCurrentRoute(QStringLiteral("not-found: settings?x=1"));
    QCOMPARE(state.currentRoute(), QStringLiteral("not-found: /settings"));

    state.setScaffoldNavIndex(99);
    QCOMPARE(state.scaffoldNavIndex(), 3);
    state.setScaffoldNavIndex(-9);
    QCOMPARE(state.scaffoldNavIndex(), -1);

    state.syncPageHistory(QStringList {
        QStringLiteral("/overview"),
        QStringLiteral("/runs/42"),
        QStringLiteral("/runs/9")
    });
    const QVariantList scaffold = state.scaffoldNavModel();
    QVERIFY(scaffold.size() >= 2);
    QCOMPARE(scaffold.at(1).toMap().value(QStringLiteral("badge")).toString(), QStringLiteral("2"));
}

void AppStateTests::definitions_drive_route_matching()
{
    AppState state;

    state.setScaffoldDefinitions(QVariantList {
        QVariantMap {
            {QStringLiteral("label"), QStringLiteral("Overview")},
            {QStringLiteral("path"), QStringLiteral("/overview")}
        },
        QVariantMap {
            {QStringLiteral("label"), QStringLiteral("Reports")},
            {QStringLiteral("path"), QStringLiteral("/reports")}
        }
    });

    const QVariantList scaffoldModel = state.scaffoldNavModel();
    QCOMPARE(scaffoldModel.size(), 2);
    QCOMPARE(scaffoldModel.at(1).toMap().value(QStringLiteral("path")).toString(), QStringLiteral("/reports"));

    state.recordNavigation(QStringLiteral("/reports"));
    QCOMPARE(state.scaffoldNavIndex(), 1);

    state.recordNavigation(QStringLiteral("not-found: reports"));
    QCOMPARE(state.currentRoute(), QStringLiteral("not-found: /reports"));
    QCOMPARE(state.scaffoldNavIndex(), -1);

    const QVariantList refreshedScaffold = state.scaffoldNavModel();
    QCOMPARE(refreshedScaffold.at(1).toMap().value(QStringLiteral("badge")).toString(), QStringLiteral("1"));
}

QTEST_MAIN(AppStateTests)
#include "tst_app_state.moc"
