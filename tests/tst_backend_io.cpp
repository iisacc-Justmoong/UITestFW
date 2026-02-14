#include <QtTest>

#include <QCoreApplication>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QQuickWindow>
#include <QSignalSpy>
#include <QStandardPaths>
#include <QTemporaryDir>
#include <QtPlugin>

#include "backend/io/backend.h"
#include "backend/runtime/runtimeevents.h"

#if defined(LVRS_USE_STATIC_QML_PLUGIN)
Q_IMPORT_PLUGIN(LVRSPlugin)
#endif

class BackendIoTests : public QObject
{
    Q_OBJECT

private slots:
    void backend_file_roundtrip_and_errors();
    void backend_error_signal_and_directory_idempotence();
    void backend_event_hook_receives_runtime_events();
};

void BackendIoTests::backend_file_roundtrip_and_errors()
{
    Backend backend;
    QTemporaryDir tempDir;
    QVERIFY(tempDir.isValid());

    const QString nestedDir = tempDir.path() + "/io/a/b";
    QVERIFY(backend.ensureDir(nestedDir));

    const QString filePath = nestedDir + "/sample.txt";
    QVERIFY(backend.saveTextFile(filePath, QStringLiteral("metrics-check")));
    QCOMPARE(backend.readTextFile(filePath), QStringLiteral("metrics-check"));

    QVERIFY(!backend.saveTextFile(QString(), QStringLiteral("x")));
    QVERIFY(!backend.lastError().isEmpty());

    const QString missingPath = nestedDir + "/missing.txt";
    QCOMPARE(backend.readTextFile(missingPath), QString());
    QVERIFY(!backend.lastError().isEmpty());

    const QString tempLocation = backend.writableLocation(static_cast<int>(QStandardPaths::TempLocation));
    QVERIFY(!tempLocation.isEmpty());
}

void BackendIoTests::backend_error_signal_and_directory_idempotence()
{
    Backend backend;
    QSignalSpy errorSpy(&backend, &Backend::lastErrorChanged);
    QVERIFY(errorSpy.isValid());

    QVERIFY(!backend.ensureDir(QStringLiteral("   ")));
    QCOMPARE(backend.lastError(), QStringLiteral("Empty path"));

    QTemporaryDir tempDir;
    QVERIFY(tempDir.isValid());
    const QString targetDir = tempDir.path() + "/x/y/z";
    QVERIFY(backend.ensureDir(targetDir));
    QCOMPARE(backend.lastError(), QString());
    QVERIFY(backend.ensureDir(targetDir));
    QCOMPARE(backend.lastError(), QString());

    QVERIFY(!backend.readTextFile(QStringLiteral(" ")).size());
    QCOMPARE(backend.lastError(), QStringLiteral("Empty path"));

    const QString filePath = targetDir + "/coverage.txt";
    QVERIFY(backend.saveTextFile(filePath, QStringLiteral("ok")));
    QCOMPARE(backend.lastError(), QString());
    QCOMPARE(backend.readTextFile(filePath), QStringLiteral("ok"));
    QCOMPARE(backend.lastError(), QString());

    QVERIFY(errorSpy.count() >= 4);
}

void BackendIoTests::backend_event_hook_receives_runtime_events()
{
    RuntimeEvents runtime;
    runtime.start();

    QQuickWindow window;
    window.setWidth(320);
    window.setHeight(180);
    runtime.attachWindow(&window);

    Backend backend;
    QVERIFY(backend.hookUserEvents());
    QVERIFY(backend.userEventHooked());

    backend.clearHookedUserEvents();
    QCOMPARE(backend.hookedEventCount(), 0);

    QSignalSpy hookedSpy(&backend, &Backend::hookedEventsChanged);
    QVERIFY(hookedSpy.isValid());

    const QPointF point(28.0, 20.0);
    QKeyEvent keyPress(QEvent::KeyPress, Qt::Key_A, Qt::NoModifier, QStringLiteral("a"));
    QKeyEvent keyRelease(QEvent::KeyRelease, Qt::Key_A, Qt::NoModifier, QStringLiteral("a"));
    QMouseEvent mousePress(QEvent::MouseButtonPress,
                           point,
                           point,
                           point,
                           Qt::LeftButton,
                           Qt::LeftButton,
                           Qt::NoModifier);
    QMouseEvent mouseRelease(QEvent::MouseButtonRelease,
                             point,
                             point,
                             point,
                             Qt::LeftButton,
                             Qt::NoButton,
                             Qt::NoModifier);

    QCoreApplication::sendEvent(&window, &keyPress);
    QCoreApplication::sendEvent(&window, &mousePress);
    QCoreApplication::sendEvent(&window, &mouseRelease);
    QCoreApplication::sendEvent(&window, &keyRelease);

    QTRY_VERIFY(backend.hookedEventCount() >= 4);
    QVERIFY(hookedSpy.count() >= 1);

    const QVariantMap last = backend.lastHookedEvent();
    QVERIFY(!last.isEmpty());
    QVERIFY(!last.value(QStringLiteral("type")).toString().isEmpty());
    QVERIFY(last.contains(QStringLiteral("payload")));

    const QVariantMap summary = backend.hookedUserEventSummary();
    QVERIFY(summary.value(QStringLiteral("hooked")).toBool());
    QVERIFY(summary.value(QStringLiteral("eventCount")).toInt() >= 4);
    const QVariantMap typeCounts = summary.value(QStringLiteral("typeCounts")).toMap();
    QVERIFY(!typeCounts.isEmpty());

    const QVariantMap input = backend.currentUserInputState();
    QVERIFY(input.contains(QStringLiteral("anyKeyPressed")));
    QVERIFY(input.contains(QStringLiteral("pointerUi")));
    const QVariantMap pointerUi = input.value(QStringLiteral("pointerUi")).toMap();
    QVERIFY(pointerUi.contains(QStringLiteral("objectName")));

    backend.unhookUserEvents();
    QVERIFY(!backend.userEventHooked());
}

QTEST_MAIN(BackendIoTests)
#include "tst_backend_io.moc"
