#include <QtTest>

#include <QCoreApplication>
#include <QContextMenuEvent>
#include <QEvent>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QPointer>
#include <QQuickItem>
#include <QQuickWindow>
#include <QSignalSpy>
#include <QtPlugin>

#include <utility>

#include "backend/runtime/debuglogger.h"
#include "backend/runtime/renderingmonitor.h"
#include "backend/runtime/runtimeevents.h"

Q_IMPORT_PLUGIN(LVRSPlugin)

class RuntimeServicesTests : public QObject
{
    Q_OBJECT

private slots:
    void runtime_events_measurement_boundaries();
    void runtime_events_idle_and_reset_signal_contract();
    void runtime_events_context_menu_signal_contract();
    void runtime_events_single_input_event_is_counted_once();
    void render_monitor_counts_frames_when_swapped();
    void render_monitor_active_signal_and_destroy_path();
    void debug_logger_enabled_signal_and_message_format();
};

namespace {
QStringList *g_capturedLogs = nullptr;

void messageCaptureHandler(QtMsgType type, const QMessageLogContext &, const QString &msg)
{
    if (type == QtInfoMsg && g_capturedLogs)
        g_capturedLogs->append(msg);
}
}

void RuntimeServicesTests::runtime_events_measurement_boundaries()
{
    RuntimeEvents events;
    QQuickWindow window;
    window.setWidth(800);
    window.setHeight(500);
    events.attachWindow(&window);
    QTRY_VERIFY(events.running());
    QVERIFY(events.uiCreatedCount() > 0);

    events.setIdleTimeoutMs(-10);
    QCOMPARE(events.idleTimeoutMs(), 250);
    events.setIdleTimeoutMs(24 * 60 * 60 * 1000 + 999);
    QCOMPARE(events.idleTimeoutMs(), 24 * 60 * 60 * 1000);

    events.setOsSampleIntervalMs(-10);
    QCOMPARE(events.osSampleIntervalMs(), 250);
    events.setOsSampleIntervalMs(70 * 1000);
    QCOMPARE(events.osSampleIntervalMs(), 60 * 1000);

    const qint64 previousActivityEpoch = events.lastActivityEpochMs();
    QTest::qWait(2);
    events.markActivity();
    QVERIFY(events.lastActivityEpochMs() >= previousActivityEpoch);

    QKeyEvent keyPress(QEvent::KeyPress, Qt::Key_K, Qt::ControlModifier, QStringLiteral("k"));
    QCoreApplication::sendEvent(&window, &keyPress);
    QVERIFY(events.isKeyPressed(Qt::Key_K));
    QKeyEvent keyRelease(QEvent::KeyRelease, Qt::Key_K, Qt::ControlModifier, QStringLiteral("k"));
    QCoreApplication::sendEvent(&window, &keyRelease);
    QVERIFY(!events.isKeyPressed(Qt::Key_K));
    QVERIFY(events.keyPressCount() >= 1);
    QVERIFY(events.keyReleaseCount() >= 1);

    const QPointF p(24.0, 18.0);
    QMouseEvent mouseMove(QEvent::MouseMove, p, p, p, Qt::NoButton, Qt::NoButton, Qt::NoModifier);
    QMouseEvent mousePress(QEvent::MouseButtonPress, p, p, p, Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
    QMouseEvent mouseRelease(QEvent::MouseButtonRelease, p, p, p, Qt::LeftButton, Qt::NoButton, Qt::NoModifier);
    QCoreApplication::sendEvent(&window, &mouseMove);
    QCoreApplication::sendEvent(&window, &mousePress);
    QCoreApplication::sendEvent(&window, &mouseRelease);
    QVERIFY(events.mouseMoveCount() >= 1);
    QVERIFY(events.mousePressCount() >= 1);
    QVERIFY(events.mouseReleaseCount() >= 1);

    const quint64 createdBefore = events.uiCreatedCount();
    auto *dynamicItem = new QQuickItem(window.contentItem());
    dynamicItem->setVisible(true);
    QCoreApplication::processEvents();
    QVERIFY(events.uiCreatedCount() > createdBefore);
    delete dynamicItem;
    QCoreApplication::processEvents();
    QVERIFY(events.uiDestroyedCount() >= 1);

    const QVariantMap snapshot = events.snapshot();
    QVERIFY(snapshot.contains(QStringLiteral("running")));
    QVERIFY(snapshot.contains(QStringLiteral("keyPressCount")));
    QVERIFY(snapshot.contains(QStringLiteral("mouseMoveCount")));
    QVERIFY(snapshot.contains(QStringLiteral("uiCreatedCount")));
    QVERIFY(snapshot.contains(QStringLiteral("idle")));
    QVERIFY(snapshot.contains(QStringLiteral("pid")));
    QVERIFY(snapshot.contains(QStringLiteral("rssBytes")));
    QVERIFY(snapshot.contains(QStringLiteral("uptimeMs")));
    QVERIFY(snapshot.value(QStringLiteral("pid")).toLongLong() > 0);

    events.stop();
    QVERIFY(!events.running());
}

void RuntimeServicesTests::runtime_events_idle_and_reset_signal_contract()
{
    RuntimeEvents events;
    QQuickWindow window;
    events.attachWindow(&window);
    QTRY_VERIFY(events.running());

    QSignalSpy idleChangedSpy(&events, &RuntimeEvents::idleChanged);
    QSignalSpy idleEnteredSpy(&events, &RuntimeEvents::idleEntered);
    QSignalSpy idleExitedSpy(&events, &RuntimeEvents::idleExited);
    QSignalSpy runningSpy(&events, &RuntimeEvents::runningChanged);
    QVERIFY(idleChangedSpy.isValid());
    QVERIFY(idleEnteredSpy.isValid());
    QVERIFY(idleExitedSpy.isValid());
    QVERIFY(runningSpy.isValid());

    events.setIdleTimeoutMs(250);
    events.markActivity();
    QTRY_VERIFY_WITH_TIMEOUT(events.idle(), 1200);
    QVERIFY(idleChangedSpy.count() >= 1);
    QVERIFY(idleEnteredSpy.count() >= 1);

    events.markActivity();
    QTRY_VERIFY(!events.idle());
    QVERIFY(idleExitedSpy.count() >= 1);

    QKeyEvent keyPress(QEvent::KeyPress, Qt::Key_T, Qt::NoModifier, QStringLiteral("t"));
    QKeyEvent keyRelease(QEvent::KeyRelease, Qt::Key_T, Qt::NoModifier, QStringLiteral("t"));
    QCoreApplication::sendEvent(&window, &keyPress);
    QVERIFY(events.anyKeyPressed());
    QCoreApplication::sendEvent(&window, &keyRelease);
    QVERIFY(!events.anyKeyPressed());

    const QPointF p(12.0, 14.0);
    QMouseEvent mousePress(QEvent::MouseButtonPress, p, p, p, Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
    QMouseEvent mouseRelease(QEvent::MouseButtonRelease, p, p, p, Qt::LeftButton, Qt::NoButton, Qt::NoModifier);
    QCoreApplication::sendEvent(&window, &mousePress);
    QVERIFY(events.mouseButtonPressed());
    QCoreApplication::sendEvent(&window, &mouseRelease);
    QVERIFY(!events.mouseButtonPressed());

    events.stop();
    QVERIFY(!events.running());

    events.resetCounters();
    QCOMPARE(events.keyPressCount(), 0u);
    QCOMPARE(events.keyReleaseCount(), 0u);
    QCOMPARE(events.mouseMoveCount(), 0u);
    QCOMPARE(events.mousePressCount(), 0u);
    QCOMPARE(events.mouseReleaseCount(), 0u);
    QCOMPARE(events.uiCreatedCount(), 0u);
    QCOMPARE(events.uiShownCount(), 0u);
    QCOMPARE(events.uiHiddenCount(), 0u);
    QCOMPARE(events.uiDestroyedCount(), 0u);
    QVERIFY(!events.anyKeyPressed());
    QVERIFY(!events.mouseButtonPressed());
    QCOMPARE(runningSpy.count(), 1);
}

void RuntimeServicesTests::runtime_events_context_menu_signal_contract()
{
    RuntimeEvents events;
    QQuickWindow window;
    events.attachWindow(&window);
    QTRY_VERIFY(events.running());

    QSignalSpy contextSpy(&events, &RuntimeEvents::contextRequested);
    QVERIFY(contextSpy.isValid());

    const QPoint local(22, 16);
    const QPoint global(320, 240);
    QContextMenuEvent contextEvent(QContextMenuEvent::Mouse,
                                   local,
                                   global,
                                   Qt::NoModifier);
    QCoreApplication::sendEvent(&window, &contextEvent);

    QTRY_VERIFY(contextSpy.count() >= 1);
    const QList<QVariant> args = contextSpy.takeLast();
    QVERIFY(args.size() >= 4);
    QCOMPARE(args.at(2).toInt(), static_cast<int>(Qt::NoModifier));
    QCOMPARE(args.at(3).toInt(), static_cast<int>(QContextMenuEvent::Mouse));
    QCOMPARE(events.lastMouseButtons(), static_cast<int>(Qt::RightButton));
    QCOMPARE(events.lastMouseX(), static_cast<qreal>(global.x()));
    QCOMPARE(events.lastMouseY(), static_cast<qreal>(global.y()));
}

void RuntimeServicesTests::runtime_events_single_input_event_is_counted_once()
{
    RuntimeEvents events;
    QQuickWindow window;
    events.attachWindow(&window);
    QTRY_VERIFY(events.running());

    events.resetCounters();

    QKeyEvent keyPress(QEvent::KeyPress, Qt::Key_G, Qt::NoModifier, QStringLiteral("g"));
    QKeyEvent keyRelease(QEvent::KeyRelease, Qt::Key_G, Qt::NoModifier, QStringLiteral("g"));
    QCoreApplication::sendEvent(&window, &keyPress);
    QCoreApplication::sendEvent(&window, &keyRelease);

    const QPointF p(30.0, 22.0);
    QMouseEvent mouseMove(QEvent::MouseMove, p, p, p, Qt::NoButton, Qt::NoButton, Qt::NoModifier);
    QMouseEvent mousePress(QEvent::MouseButtonPress, p, p, p, Qt::LeftButton, Qt::LeftButton, Qt::NoModifier);
    QMouseEvent mouseRelease(QEvent::MouseButtonRelease, p, p, p, Qt::LeftButton, Qt::NoButton, Qt::NoModifier);
    QCoreApplication::sendEvent(&window, &mouseMove);
    QCoreApplication::sendEvent(&window, &mousePress);
    QCoreApplication::sendEvent(&window, &mouseRelease);

    QCOMPARE(events.keyPressCount(), 1u);
    QCOMPARE(events.keyReleaseCount(), 1u);
    QCOMPARE(events.mouseMoveCount(), 1u);
    QCOMPARE(events.mousePressCount(), 1u);
    QCOMPARE(events.mouseReleaseCount(), 1u);
    QCOMPARE(events.lastMouseX(), 30.0);
    QCOMPARE(events.lastMouseY(), 22.0);
}

void RuntimeServicesTests::render_monitor_counts_frames_when_swapped()
{
    RenderingMonitor monitor;
    QQuickWindow window;
    monitor.attachWindow(&window);
    QVERIFY(monitor.active());
    QCOMPARE(monitor.frameCount(), 0u);

    QVERIFY(QMetaObject::invokeMethod(&monitor, "handleFrameSwapped", Qt::DirectConnection));
    QTest::qWait(5);
    QVERIFY(QMetaObject::invokeMethod(&monitor, "handleFrameSwapped", Qt::DirectConnection));
    QVERIFY(monitor.frameCount() >= 2);
    QVERIFY(monitor.lastFrameMs() >= 0.0);
    QVERIFY(monitor.fps() >= 0.0);

    monitor.reset();
    QCOMPARE(monitor.frameCount(), 0u);
    QCOMPARE(monitor.lastFrameMs(), 0.0);

    monitor.stop();
    QVERIFY(!monitor.active());
    monitor.start();
    QVERIFY(monitor.active());
    monitor.attachWindow(static_cast<QObject *>(nullptr));
    QVERIFY(!monitor.active());
}

void RuntimeServicesTests::render_monitor_active_signal_and_destroy_path()
{
    RenderingMonitor monitor;
    QSignalSpy activeSpy(&monitor, &RenderingMonitor::activeChanged);
    QSignalSpy statsSpy(&monitor, &RenderingMonitor::statsChanged);
    QVERIFY(activeSpy.isValid());
    QVERIFY(statsSpy.isValid());

    auto *window = new QQuickWindow;
    monitor.attachWindow(window);
    QVERIFY(monitor.active());
    QCOMPARE(activeSpy.count(), 1);
    QVERIFY(statsSpy.count() >= 1);

    QVERIFY(QMetaObject::invokeMethod(&monitor, "handleFrameSwapped", Qt::DirectConnection));
    const quint64 frameCountBeforeStop = monitor.frameCount();
    QVERIFY(frameCountBeforeStop >= 1);

    monitor.stop();
    QCOMPARE(activeSpy.count(), 2);
    QVERIFY(!monitor.active());
    QVERIFY(QMetaObject::invokeMethod(&monitor, "handleFrameSwapped", Qt::DirectConnection));
    QCOMPARE(monitor.frameCount(), frameCountBeforeStop);

    monitor.start();
    QCOMPARE(activeSpy.count(), 3);
    QVERIFY(monitor.active());

    delete window;
    QCoreApplication::processEvents();
    QTRY_VERIFY(!monitor.active());
    QCOMPARE(activeSpy.count(), 4);
}

void RuntimeServicesTests::debug_logger_enabled_signal_and_message_format()
{
    DebugLogger logger;
    QSignalSpy enabledSpy(&logger, &DebugLogger::enabledChanged);
    QVERIFY(enabledSpy.isValid());

    logger.setEnabled(false);
    QCOMPARE(enabledSpy.count(), 0);
    logger.setEnabled(true);
    QCOMPARE(enabledSpy.count(), 1);
    logger.setEnabled(true);
    QCOMPARE(enabledSpy.count(), 1);

    QStringList captured;
    g_capturedLogs = &captured;
    const auto previousHandler = qInstallMessageHandler(messageCaptureHandler);

    logger.log(QString(), QString(), 42);
    logger.warn(QStringLiteral("Runtime"), QStringLiteral("warning"));
    logger.error(QString(), QStringLiteral("failure"));

    qInstallMessageHandler(previousHandler);
    g_capturedLogs = nullptr;
    logger.setEnabled(false);
    QCOMPARE(enabledSpy.count(), 2);

    bool sawLog = false;
    bool sawWarn = false;
    bool sawError = false;
    for (const QString &line : std::as_const(captured)) {
        sawLog = sawLog || (line.contains(QStringLiteral("[LOG]")) && line.contains(QStringLiteral("Unknown.event")));
        sawWarn = sawWarn || (line.contains(QStringLiteral("[WARN]")) && line.contains(QStringLiteral("Runtime.warning")));
        sawError = sawError || (line.contains(QStringLiteral("[ERROR]")) && line.contains(QStringLiteral("Unknown.failure")));
    }
    QVERIFY(sawLog);
    QVERIFY(sawWarn);
    QVERIFY(sawError);
}

QTEST_MAIN(RuntimeServicesTests)
#include "tst_runtime_services.moc"
