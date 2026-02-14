#pragma once

#include <QObject>
#include <QHash>
#include <QMetaObject>
#include <QPointer>
#include <QVariantList>
#include <QVariantMap>
#include <QtQml/qqml.h>

class RuntimeEvents;

class Backend : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(Backend)
    QML_SINGLETON

    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)
    Q_PROPERTY(bool userEventHooked READ userEventHooked NOTIFY userEventHookedChanged)
    Q_PROPERTY(int hookedEventCount READ hookedEventCount NOTIFY hookedEventsChanged)
    Q_PROPERTY(int hookedEventCapacity READ hookedEventCapacity WRITE setHookedEventCapacity NOTIFY hookedEventCapacityChanged)
    Q_PROPERTY(QVariantMap lastHookedEvent READ lastHookedEvent NOTIFY hookedEventsChanged)
    Q_PROPERTY(QVariantMap lastHookedInputState READ lastHookedInputState NOTIFY hookedEventsChanged)

public:
    explicit Backend(QObject *parent = nullptr);

    Q_INVOKABLE bool saveTextFile(const QString &path, const QString &text);
    Q_INVOKABLE QString readTextFile(const QString &path);
    Q_INVOKABLE bool ensureDir(const QString &path);
    Q_INVOKABLE QString writableLocation(int location) const;
    Q_INVOKABLE bool hookUserEvents();
    Q_INVOKABLE void unhookUserEvents();
    Q_INVOKABLE void clearHookedUserEvents();
    Q_INVOKABLE QVariantList hookedUserEvents(int limit = -1) const;
    Q_INVOKABLE QVariantMap hookedUserEventSummary() const;
    Q_INVOKABLE QVariantMap currentUserInputState() const;

    QString lastError() const;
    bool userEventHooked() const;
    int hookedEventCount() const;
    int hookedEventCapacity() const;
    void setHookedEventCapacity(int value);
    QVariantMap lastHookedEvent() const;
    QVariantMap lastHookedInputState() const;

signals:
    void lastErrorChanged();
    void userEventHookedChanged();
    void hookedEventsChanged();
    void hookedEventCapacityChanged();

private:
    RuntimeEvents *resolveRuntimeEvents() const;
    void appendHookedEvent(const QVariantMap &eventData);
    void setLastError(const QString &message);

    QString m_lastError;
    bool m_userEventHooked = false;
    int m_hookedEventCapacity = 2048;
    QVariantList m_hookedEvents;
    QVariantMap m_lastHookedEvent;
    QVariantMap m_lastHookedInputState;
    QHash<QString, int> m_hookedTypeCounts;
    QPointer<RuntimeEvents> m_runtimeEvents;
    QMetaObject::Connection m_runtimeEventConnection;
    QMetaObject::Connection m_runtimeDestroyedConnection;
};
