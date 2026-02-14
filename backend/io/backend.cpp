#include "backend/io/backend.h"

#include "backend/runtime/runtimeevents.h"

#include <QCoreApplication>
#include <QDateTime>
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

bool Backend::hookUserEvents()
{
    setLastError(QString());

    RuntimeEvents *runtime = resolveRuntimeEvents();
    if (!runtime) {
        setLastError(QStringLiteral("RuntimeEvents singleton unavailable"));
        return false;
    }

    runtime->start();

    if (m_userEventHooked && m_runtimeEvents == runtime)
        return true;

    unhookUserEvents();

    m_runtimeEvents = runtime;
    m_runtimeEventConnection = connect(runtime,
                                       &RuntimeEvents::eventRecorded,
                                       this,
                                       [this](const QVariantMap &eventData) {
                                           appendHookedEvent(eventData);
                                       });
    m_runtimeDestroyedConnection = connect(runtime,
                                           &QObject::destroyed,
                                           this,
                                           [this]() {
                                               m_runtimeEvents.clear();
                                               if (m_userEventHooked) {
                                                   m_userEventHooked = false;
                                                   emit userEventHookedChanged();
                                               }
                                           });

    const QVariantList cachedEvents = runtime->recentEvents();
    for (const QVariant &entry : cachedEvents)
        appendHookedEvent(entry.toMap());

    m_userEventHooked = true;
    emit userEventHookedChanged();
    return true;
}

void Backend::unhookUserEvents()
{
    if (m_runtimeEventConnection)
        QObject::disconnect(m_runtimeEventConnection);
    if (m_runtimeDestroyedConnection)
        QObject::disconnect(m_runtimeDestroyedConnection);

    m_runtimeEventConnection = QMetaObject::Connection();
    m_runtimeDestroyedConnection = QMetaObject::Connection();
    m_runtimeEvents.clear();

    if (m_userEventHooked) {
        m_userEventHooked = false;
        emit userEventHookedChanged();
    }
}

void Backend::clearHookedUserEvents()
{
    if (m_hookedEvents.isEmpty() && m_lastHookedEvent.isEmpty() && m_lastHookedInputState.isEmpty())
        return;

    m_hookedEvents.clear();
    m_lastHookedEvent.clear();
    m_lastHookedInputState.clear();
    m_hookedTypeCounts.clear();
    emit hookedEventsChanged();
}

QVariantList Backend::hookedUserEvents(int limit) const
{
    if (limit <= 0 || limit >= m_hookedEvents.size())
        return m_hookedEvents;

    QVariantList subset;
    const int start = m_hookedEvents.size() - limit;
    subset.reserve(limit);
    for (int i = start; i < m_hookedEvents.size(); ++i)
        subset.append(m_hookedEvents.at(i));
    return subset;
}

QVariantMap Backend::hookedUserEventSummary() const
{
    QVariantMap summary;
    summary.insert(QStringLiteral("hooked"), m_userEventHooked);
    summary.insert(QStringLiteral("eventCount"), m_hookedEvents.size());
    summary.insert(QStringLiteral("capacity"), m_hookedEventCapacity);
    summary.insert(QStringLiteral("lastEvent"), m_lastHookedEvent);
    summary.insert(QStringLiteral("input"), currentUserInputState());

    QVariantMap typeCounts;
    for (auto it = m_hookedTypeCounts.constBegin(); it != m_hookedTypeCounts.constEnd(); ++it)
        typeCounts.insert(it.key(), it.value());
    summary.insert(QStringLiteral("typeCounts"), typeCounts);

    if (m_runtimeEvents)
        summary.insert(QStringLiteral("runtimeEventSequence"), QVariant::fromValue(m_runtimeEvents->eventSequence()));

    return summary;
}

QVariantMap Backend::currentUserInputState() const
{
    if (m_runtimeEvents)
        return m_runtimeEvents->inputState();
    return m_lastHookedInputState;
}

QString Backend::lastError() const
{
    return m_lastError;
}

bool Backend::userEventHooked() const
{
    return m_userEventHooked;
}

int Backend::hookedEventCount() const
{
    return m_hookedEvents.size();
}

int Backend::hookedEventCapacity() const
{
    return m_hookedEventCapacity;
}

void Backend::setHookedEventCapacity(int value)
{
    const int next = qBound(64, value, 32768);
    if (m_hookedEventCapacity == next)
        return;

    m_hookedEventCapacity = next;
    emit hookedEventCapacityChanged();

    bool dropped = false;
    while (m_hookedEvents.size() > m_hookedEventCapacity) {
        const QVariantMap droppedEvent = m_hookedEvents.takeFirst().toMap();
        const QString droppedType = droppedEvent.value(QStringLiteral("type")).toString();
        if (!droppedType.isEmpty()) {
            const int current = m_hookedTypeCounts.value(droppedType, 0);
            if (current <= 1)
                m_hookedTypeCounts.remove(droppedType);
            else
                m_hookedTypeCounts.insert(droppedType, current - 1);
        }
        dropped = true;
    }

    if (dropped)
        emit hookedEventsChanged();
}

QVariantMap Backend::lastHookedEvent() const
{
    return m_lastHookedEvent;
}

QVariantMap Backend::lastHookedInputState() const
{
    return m_lastHookedInputState;
}

RuntimeEvents *Backend::resolveRuntimeEvents() const
{
    if (m_runtimeEvents)
        return m_runtimeEvents.data();

    if (RuntimeEvents::instance())
        return RuntimeEvents::instance();

    if (!qApp)
        return nullptr;

    const QList<RuntimeEvents *> runtimes = qApp->findChildren<RuntimeEvents *>();
    if (runtimes.isEmpty())
        return nullptr;
    return runtimes.constLast();
}

void Backend::appendHookedEvent(const QVariantMap &eventData)
{
    if (eventData.isEmpty())
        return;

    QVariantMap hookedEvent = eventData;
    hookedEvent.insert(QStringLiteral("hookEpochMs"), QVariant::fromValue(QDateTime::currentMSecsSinceEpoch()));

    const QString eventType = hookedEvent.value(QStringLiteral("type")).toString();
    if (!eventType.isEmpty())
        m_hookedTypeCounts.insert(eventType, m_hookedTypeCounts.value(eventType, 0) + 1);

    const QVariantMap payload = hookedEvent.value(QStringLiteral("payload")).toMap();
    const QVariantMap payloadInput = payload.value(QStringLiteral("input")).toMap();
    if (!payloadInput.isEmpty())
        m_lastHookedInputState = payloadInput;
    else if (m_runtimeEvents)
        m_lastHookedInputState = m_runtimeEvents->inputState();

    m_lastHookedEvent = hookedEvent;
    m_hookedEvents.append(hookedEvent);

    while (m_hookedEvents.size() > m_hookedEventCapacity) {
        const QVariantMap droppedEvent = m_hookedEvents.takeFirst().toMap();
        const QString droppedType = droppedEvent.value(QStringLiteral("type")).toString();
        if (!droppedType.isEmpty()) {
            const int current = m_hookedTypeCounts.value(droppedType, 0);
            if (current <= 1)
                m_hookedTypeCounts.remove(droppedType);
            else
                m_hookedTypeCounts.insert(droppedType, current - 1);
        }
    }

    emit hookedEventsChanged();
}

void Backend::setLastError(const QString &message)
{
    if (m_lastError == message)
        return;
    m_lastError = message;
    emit lastErrorChanged();
}
