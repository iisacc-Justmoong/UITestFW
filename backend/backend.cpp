#include "backend/backend.h"

#include <QDir>
#include <QFile>
#include <QSaveFile>
#include <QStandardPaths>

Backend::Backend(QObject *parent)
    : QObject(parent)
{
}

bool Backend::saveTextFile(const QString &path, const QString &text)
{
    setLastError(QString());

    if (path.trimmed().isEmpty()) {
        setLastError(QStringLiteral("Empty path"));
        return false;
    }

    QSaveFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        setLastError(file.errorString());
        return false;
    }

    const QByteArray data = text.toUtf8();
    if (file.write(data) != data.size()) {
        setLastError(file.errorString());
        file.cancelWriting();
        return false;
    }

    if (!file.commit()) {
        setLastError(file.errorString());
        return false;
    }

    return true;
}

QString Backend::readTextFile(const QString &path)
{
    setLastError(QString());

    if (path.trimmed().isEmpty()) {
        setLastError(QStringLiteral("Empty path"));
        return QString();
    }

    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        setLastError(file.errorString());
        return QString();
    }

    return QString::fromUtf8(file.readAll());
}

bool Backend::ensureDir(const QString &path)
{
    setLastError(QString());

    if (path.trimmed().isEmpty()) {
        setLastError(QStringLiteral("Empty path"));
        return false;
    }

    QDir dir(path);
    if (dir.exists())
        return true;

    if (!dir.mkpath(QStringLiteral("."))) {
        setLastError(QStringLiteral("Failed to create directory"));
        return false;
    }

    return true;
}

QString Backend::writableLocation(int location) const
{
    return QStandardPaths::writableLocation(
        static_cast<QStandardPaths::StandardLocation>(location));
}

QString Backend::lastError() const
{
    return m_lastError;
}

void Backend::setLastError(const QString &message)
{
    if (m_lastError == message)
        return;
    m_lastError = message;
    emit lastErrorChanged();
}
