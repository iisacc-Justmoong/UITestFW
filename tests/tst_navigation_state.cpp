#include <QtTest>

#include <QCoreApplication>
#include <QEvent>
#include <QPointer>
#include <QSignalSpy>
#include <QtPlugin>

#include "backend/navigation/pagemonitor.h"
#include "backend/state/viewmodelregistry.h"

Q_IMPORT_PLUGIN(LVRSPlugin)

class NavigationStateTests : public QObject
{
    Q_OBJECT

private slots:
    void page_monitor_history_metrics();
    void page_monitor_signal_contract_and_normalization();
    void viewmodels_registry_tracks_keys_and_ownership();
    void viewmodels_registry_signal_and_prune_contract();
};

void NavigationStateTests::page_monitor_history_metrics()
{
    PageMonitor monitor;
    QCOMPARE(monitor.count(), 0);
    QCOMPARE(monitor.current(), QString());
    QVERIFY(!monitor.canUndo());

    monitor.record(QStringLiteral("/overview"));
    monitor.record(QStringLiteral("/overview"));
    QCOMPARE(monitor.count(), 1);
    QCOMPARE(monitor.current(), QStringLiteral("/overview"));

    monitor.record(QStringLiteral("/reports"));
    QCOMPARE(monitor.count(), 2);
    QVERIFY(monitor.canUndo());
    QCOMPARE(monitor.undo(), QStringLiteral("/overview"));
    QCOMPARE(monitor.count(), 1);
    QVERIFY(!monitor.canUndo());

    monitor.clear();
    QCOMPARE(monitor.count(), 0);
    QCOMPARE(monitor.current(), QString());
}

void NavigationStateTests::page_monitor_signal_contract_and_normalization()
{
    PageMonitor monitor;
    QSignalSpy historySpy(&monitor, &PageMonitor::historyChanged);
    QVERIFY(historySpy.isValid());

    monitor.record(QStringLiteral("  /overview  "));
    QCOMPARE(monitor.current(), QStringLiteral("/overview"));
    QCOMPARE(historySpy.count(), 1);

    monitor.record(QStringLiteral("/overview"));
    monitor.record(QStringLiteral("   "));
    QCOMPARE(historySpy.count(), 1);

    QCOMPARE(monitor.undo(), QStringLiteral("/overview"));
    QCOMPARE(historySpy.count(), 1);

    monitor.record(QStringLiteral("/details"));
    QCOMPARE(historySpy.count(), 2);
    QCOMPARE(monitor.undo(), QStringLiteral("/overview"));
    QCOMPARE(historySpy.count(), 3);

    monitor.clear();
    QCOMPARE(historySpy.count(), 4);
    monitor.clear();
    QCOMPARE(historySpy.count(), 4);
}

void NavigationStateTests::viewmodels_registry_tracks_keys_and_ownership()
{
    ViewModelRegistry registry;
    QCOMPARE(registry.keys().size(), 0);
    QVERIFY(registry.get(QStringLiteral("missing")) == nullptr);

    auto *shared = new QObject;
    QPointer<QObject> sharedGuard(shared);
    registry.set(QStringLiteral("alpha"), shared);
    registry.set(QStringLiteral("beta"), shared);
    QVERIFY(registry.keys().contains(QStringLiteral("alpha")));
    QVERIFY(registry.keys().contains(QStringLiteral("beta")));
    QVERIFY(registry.get(QStringLiteral("alpha")) == shared);
    QVERIFY(shared->parent() == &registry);

    registry.remove(QStringLiteral("alpha"));
    QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);
    QCoreApplication::processEvents();
    QVERIFY(!sharedGuard.isNull());

    registry.remove(QStringLiteral("beta"));
    QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);
    QCoreApplication::processEvents();
    QTRY_VERIFY(sharedGuard.isNull());

    auto *single = new QObject;
    QPointer<QObject> singleGuard(single);
    registry.set(QStringLiteral("single"), single);
    QCOMPARE(registry.keys().size(), 1);
    registry.clear();
    QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);
    QCoreApplication::processEvents();
    QTRY_VERIFY(singleGuard.isNull());
    QCOMPARE(registry.keys().size(), 0);
}

void NavigationStateTests::viewmodels_registry_signal_and_prune_contract()
{
    ViewModelRegistry registry;
    QSignalSpy keysSpy(&registry, &ViewModelRegistry::keysChanged);
    QVERIFY(keysSpy.isValid());

    auto *ignored = new QObject;
    QPointer<QObject> ignoredGuard(ignored);
    registry.set(QStringLiteral("   "), ignored);
    QCOMPARE(keysSpy.count(), 0);
    QVERIFY(!ignoredGuard.isNull());
    delete ignored;
    QTRY_VERIFY(ignoredGuard.isNull());

    QObject externalParent;
    auto *externalOwned = new QObject(&externalParent);
    registry.set(QStringLiteral("primary"), externalOwned);
    QCOMPARE(keysSpy.count(), 1);
    QCOMPARE(externalOwned->parent(), &externalParent);
    registry.set(QStringLiteral("primary"), externalOwned);
    QCOMPARE(keysSpy.count(), 1);
    registry.set(QStringLiteral("secondary"), externalOwned);
    QCOMPARE(keysSpy.count(), 2);

    registry.remove(QStringLiteral("missing"));
    QCOMPARE(keysSpy.count(), 2);
    registry.remove(QStringLiteral("primary"));
    QCOMPARE(keysSpy.count(), 3);
    QVERIFY(!externalOwned->parent()->inherits("ViewModelRegistry"));

    QPointer<QObject> externalGuard(externalOwned);
    delete externalOwned;
    QTRY_VERIFY(externalGuard.isNull());

    auto *owned = new QObject;
    QPointer<QObject> ownedGuard(owned);
    registry.set(QStringLiteral("owned"), owned);
    QCOMPARE(keysSpy.count(), 5);
    QVERIFY(owned->parent() == &registry);

    auto *trigger = new QObject;
    registry.set(QStringLiteral("trigger"), trigger);
    QCOMPARE(keysSpy.count(), 6);
    QVERIFY(!registry.keys().contains(QStringLiteral("secondary")));

    registry.remove(QStringLiteral("owned"));
    QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);
    QCoreApplication::processEvents();
    QTRY_VERIFY(ownedGuard.isNull());

    const int beforeClear = keysSpy.count();
    registry.clear();
    QCOMPARE(keysSpy.count(), beforeClear + 1);
    registry.clear();
    QCOMPARE(registry.keys().size(), 0);
}

QTEST_MAIN(NavigationStateTests)
#include "tst_navigation_state.moc"
