#include "backend/runtime/debuglogger.h"

#include <QDateTime>
#include <QDebug>

DebugLogger::DebugLogger(QObject *parent)
    : QObject(parent)
{
}

bool DebugLogger::enabled() const
{
    return m_enabled;
}

void DebugLogger::setEnabled(bool value)
{
    if (m_enabled == value)
        return;
    m_enabled = value;
    emit enabledChanged();
}

void DebugLogger::log(const QString &component, const QString &event, const QVariant &data)
{
    output(QStringLiteral("LOG"), component, event, data);
}

void DebugLogger::warn(const QString &component, const QString &event, const QVariant &data)
{
    output(QStringLiteral("WARN"), component, event, data);
}

void DebugLogger::error(const QString &component, const QString &event, const QVariant &data)
{
    output(QStringLiteral("ERROR"), component, event, data);
}

void DebugLogger::output(const QString &level, const QString &component, const QString &event, const QVariant &data)
{
    if (!m_enabled)
        return;

    const QString timestamp = QDateTime::currentDateTime().toString(QStringLiteral("HH:mm:ss.zzz"));
    const QString componentName = component.isEmpty() ? QStringLiteral("Unknown") : component;
    const QString eventName = event.isEmpty() ? QStringLiteral("event") : event;
    const QString message = QStringLiteral("[%1] [%2] %3.%4")
        .arg(timestamp, level, componentName, eventName);

    if (data.isValid()) {
        qInfo().noquote() << message << data;
    } else {
        qInfo().noquote() << message;
    }
}
