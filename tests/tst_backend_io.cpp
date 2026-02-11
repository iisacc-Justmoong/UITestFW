#include <QtTest>

#include <QSignalSpy>
#include <QStandardPaths>
#include <QTemporaryDir>
#include <QtPlugin>

#include "backend/io/backend.h"

Q_IMPORT_PLUGIN(LVRSPlugin)

class BackendIoTests : public QObject
{
    Q_OBJECT

private slots:
    void backend_file_roundtrip_and_errors();
    void backend_error_signal_and_directory_idempotence();
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

QTEST_MAIN(BackendIoTests)
#include "tst_backend_io.moc"
