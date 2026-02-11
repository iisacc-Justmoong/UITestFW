#include "backend/runtime/runtimeevents.h"

#include <QChildEvent>
#include <QCoreApplication>
#include <QContextMenuEvent>
#include <QDateTime>
#include <QEvent>
#include <QFile>
#include <QGuiApplication>
#include <QHoverEvent>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QQuickWindow>
#include <QSysInfo>

#ifdef Q_OS_MAC
#include <mach/mach.h>
#endif

#ifdef Q_OS_LINUX
#include <unistd.h>
#endif

RuntimeEvents::RuntimeEvents(QObject *parent)
    : QObject(parent)
{
    m_idleTimer.setInterval(250);
    m_idleTimer.setTimerType(Qt::CoarseTimer);
    connect(&m_idleTimer, &QTimer::timeout, this, &RuntimeEvents::handleIdleTick);

    m_osTimer.setInterval(m_osSampleIntervalMs);
    m_osTimer.setTimerType(Qt::CoarseTimer);
    connect(&m_osTimer, &QTimer::timeout, this, &RuntimeEvents::handleOsTick);

    m_uptimeTimer.start();
    m_lastActivityMonotonicMs = 0;
    m_lastActivityEpochMs = nowEpochMs();

    if (qGuiApp) {
        m_applicationActive = qGuiApp->applicationState() == Qt::ApplicationActive;
        connect(qGuiApp,
                &QGuiApplication::applicationStateChanged,
                this,
                [this](Qt::ApplicationState state) {
                    const bool nextActive = state == Qt::ApplicationActive;
                    if (m_applicationActive != nextActive) {
                        m_applicationActive = nextActive;
                        emit osChanged();
                    }
                    emit osApplicationStateChanged(static_cast<int>(state));
                });
    }
}

RuntimeEvents::~RuntimeEvents()
{
    stop();
}

bool RuntimeEvents::running() const
{
    return m_running;
}

quint64 RuntimeEvents::keyPressCount() const
{
    return m_keyPressCount;
}

quint64 RuntimeEvents::keyReleaseCount() const
{
    return m_keyReleaseCount;
}

int RuntimeEvents::lastKey() const
{
    return m_lastKey;
}

QString RuntimeEvents::lastKeyText() const
{
    return m_lastKeyText;
}

int RuntimeEvents::lastKeyModifiers() const
{
    return m_lastKeyModifiers;
}

bool RuntimeEvents::anyKeyPressed() const
{
    return !m_pressedKeys.isEmpty();
}

bool RuntimeEvents::isKeyPressed(int key) const
{
    return m_pressedKeys.contains(key);
}

quint64 RuntimeEvents::mouseMoveCount() const
{
    return m_mouseMoveCount;
}

quint64 RuntimeEvents::mousePressCount() const
{
    return m_mousePressCount;
}

quint64 RuntimeEvents::mouseReleaseCount() const
{
    return m_mouseReleaseCount;
}

qreal RuntimeEvents::lastMouseX() const
{
    return m_lastMouseX;
}

qreal RuntimeEvents::lastMouseY() const
{
    return m_lastMouseY;
}

int RuntimeEvents::lastMouseButtons() const
{
    return m_lastMouseButtons;
}

int RuntimeEvents::lastMouseModifiers() const
{
    return m_lastMouseModifiers;
}

bool RuntimeEvents::mouseButtonPressed() const
{
    return m_mouseButtonPressed;
}

quint64 RuntimeEvents::uiCreatedCount() const
{
    return m_uiCreatedCount;
}

quint64 RuntimeEvents::uiShownCount() const
{
    return m_uiShownCount;
}

quint64 RuntimeEvents::uiHiddenCount() const
{
    return m_uiHiddenCount;
}

quint64 RuntimeEvents::uiDestroyedCount() const
{
    return m_uiDestroyedCount;
}

QString RuntimeEvents::lastUiEvent() const
{
    return m_lastUiEvent;
}

QString RuntimeEvents::lastUiObjectName() const
{
    return m_lastUiObjectName;
}

QString RuntimeEvents::lastUiClassName() const
{
    return m_lastUiClassName;
}

bool RuntimeEvents::idle() const
{
    return m_idle;
}

int RuntimeEvents::idleTimeoutMs() const
{
    return m_idleTimeoutMs;
}

void RuntimeEvents::setIdleTimeoutMs(int value)
{
    const int next = qBound(250, value, 24 * 60 * 60 * 1000);
    if (m_idleTimeoutMs == next)
        return;
    m_idleTimeoutMs = next;
    emit idleTimeoutMsChanged();
}

qint64 RuntimeEvents::idleForMs() const
{
    return m_idleForMs;
}

qint64 RuntimeEvents::lastActivityEpochMs() const
{
    return m_lastActivityEpochMs;
}

qint64 RuntimeEvents::pid() const
{
    return static_cast<qint64>(QCoreApplication::applicationPid());
}

QString RuntimeEvents::processName() const
{
    const QString name = QCoreApplication::applicationName();
    if (!name.isEmpty())
        return name;
    return QStringLiteral("LVRSApp");
}

QString RuntimeEvents::osName() const
{
    return QSysInfo::prettyProductName();
}

bool RuntimeEvents::applicationActive() const
{
    return m_applicationActive;
}

int RuntimeEvents::osSampleIntervalMs() const
{
    return m_osSampleIntervalMs;
}

void RuntimeEvents::setOsSampleIntervalMs(int value)
{
    const int next = qBound(250, value, 60 * 1000);
    if (m_osSampleIntervalMs == next)
        return;
    m_osSampleIntervalMs = next;
    if (m_osTimer.interval() != next)
        m_osTimer.setInterval(next);
    emit osSampleIntervalMsChanged();
}

qint64 RuntimeEvents::uptimeMs() const
{
    return m_uptimeMs;
}

qint64 RuntimeEvents::rssBytes() const
{
    return m_rssBytes;
}

void RuntimeEvents::start()
{
    if (m_running)
        return;
    if (!qApp)
        return;

    qApp->installEventFilter(this);
    m_idleTimer.start();
    m_osTimer.start();
    m_running = true;
    handleOsTick();
    emit runningChanged();
}

void RuntimeEvents::stop()
{
    if (!m_running)
        return;

    if (qApp)
        qApp->removeEventFilter(this);

    m_window.clear();

    detachTrackedObjects();

    m_idleTimer.stop();
    m_osTimer.stop();
    m_running = false;
    emit runningChanged();
}

void RuntimeEvents::attachWindow(QObject *window)
{
    auto *quickWindow = qobject_cast<QQuickWindow *>(window);
    if (!quickWindow)
        return;

    start();

    if (m_window == quickWindow)
        return;

    detachTrackedObjects();

    m_window = quickWindow;
    connect(m_window,
            &QObject::destroyed,
            this,
            [this]() {
                m_window.clear();
                detachTrackedObjects();
            });

    trackUiObjectRecursive(m_window);
}

void RuntimeEvents::markActivity()
{
    const qint64 nowMonotonic = m_uptimeTimer.isValid() ? m_uptimeTimer.elapsed() : 0;
    m_lastActivityMonotonicMs = nowMonotonic;
    m_lastActivityEpochMs = nowEpochMs();
    emit lastActivityChanged();

    if (m_idle)
        updateIdleState(false);
}

void RuntimeEvents::resetCounters()
{
    m_keyPressCount = 0;
    m_keyReleaseCount = 0;
    m_lastKey = 0;
    m_lastKeyText.clear();
    m_lastKeyModifiers = 0;
    m_pressedKeys.clear();
    emit keyboardChanged();

    m_mouseMoveCount = 0;
    m_mousePressCount = 0;
    m_mouseReleaseCount = 0;
    m_lastMouseX = 0.0;
    m_lastMouseY = 0.0;
    m_lastMouseButtons = 0;
    m_lastMouseModifiers = 0;
    m_mouseButtonPressed = false;
    emit mouseChanged();

    m_uiCreatedCount = 0;
    m_uiShownCount = 0;
    m_uiHiddenCount = 0;
    m_uiDestroyedCount = 0;
    m_lastUiEvent.clear();
    m_lastUiObjectName.clear();
    m_lastUiClassName.clear();
    emit uiChanged();

    m_idleForMs = 0;
    emit idleForMsChanged();
    markActivity();
}

QVariantMap RuntimeEvents::snapshot() const
{
    QVariantMap map;
    map.insert(QStringLiteral("running"), m_running);
    map.insert(QStringLiteral("keyPressCount"), QVariant::fromValue(m_keyPressCount));
    map.insert(QStringLiteral("keyReleaseCount"), QVariant::fromValue(m_keyReleaseCount));
    map.insert(QStringLiteral("mouseMoveCount"), QVariant::fromValue(m_mouseMoveCount));
    map.insert(QStringLiteral("mousePressCount"), QVariant::fromValue(m_mousePressCount));
    map.insert(QStringLiteral("mouseReleaseCount"), QVariant::fromValue(m_mouseReleaseCount));
    map.insert(QStringLiteral("uiCreatedCount"), QVariant::fromValue(m_uiCreatedCount));
    map.insert(QStringLiteral("uiShownCount"), QVariant::fromValue(m_uiShownCount));
    map.insert(QStringLiteral("uiHiddenCount"), QVariant::fromValue(m_uiHiddenCount));
    map.insert(QStringLiteral("uiDestroyedCount"), QVariant::fromValue(m_uiDestroyedCount));
    map.insert(QStringLiteral("idle"), m_idle);
    map.insert(QStringLiteral("idleForMs"), QVariant::fromValue(m_idleForMs));
    map.insert(QStringLiteral("pid"), pid());
    map.insert(QStringLiteral("rssBytes"), QVariant::fromValue(m_rssBytes));
    map.insert(QStringLiteral("uptimeMs"), QVariant::fromValue(m_uptimeMs));
    return map;
}

bool RuntimeEvents::eventFilter(QObject *watched, QEvent *event)
{
    if (!event)
        return QObject::eventFilter(watched, event);

    switch (event->type()) {
    case QEvent::KeyPress: {
        auto *keyEvent = static_cast<QKeyEvent *>(event);
        m_keyPressCount += 1;
        m_lastKey = keyEvent->key();
        m_lastKeyText = keyEvent->text();
        m_lastKeyModifiers = static_cast<int>(keyEvent->modifiers());
        m_pressedKeys.insert(keyEvent->key());
        emit keyboardChanged();
        emit keyPressed(keyEvent->key(),
                        static_cast<int>(keyEvent->modifiers()),
                        keyEvent->isAutoRepeat(),
                        keyEvent->text());
        markActivity();
        break;
    }
    case QEvent::KeyRelease: {
        auto *keyEvent = static_cast<QKeyEvent *>(event);
        m_keyReleaseCount += 1;
        m_lastKey = keyEvent->key();
        m_lastKeyText = keyEvent->text();
        m_lastKeyModifiers = static_cast<int>(keyEvent->modifiers());
        m_pressedKeys.remove(keyEvent->key());
        emit keyboardChanged();
        emit keyReleased(keyEvent->key(),
                         static_cast<int>(keyEvent->modifiers()),
                         keyEvent->isAutoRepeat(),
                         keyEvent->text());
        markActivity();
        break;
    }
    case QEvent::MouseMove: {
        auto *mouseEvent = static_cast<QMouseEvent *>(event);
        m_mouseMoveCount += 1;
        updateMouseFromEvent(mouseEvent->globalPosition().x(),
                             mouseEvent->globalPosition().y(),
                             static_cast<int>(mouseEvent->buttons()),
                             static_cast<int>(mouseEvent->modifiers()));
        emit mouseChanged();
        emit mouseMoved(m_lastMouseX, m_lastMouseY, m_lastMouseButtons, m_lastMouseModifiers);
        markActivity();
        break;
    }
    case QEvent::MouseButtonPress: {
        auto *mouseEvent = static_cast<QMouseEvent *>(event);
        m_mousePressCount += 1;
        m_mouseButtonPressed = true;
        updateMouseFromEvent(mouseEvent->globalPosition().x(),
                             mouseEvent->globalPosition().y(),
                             static_cast<int>(mouseEvent->buttons()),
                             static_cast<int>(mouseEvent->modifiers()));
        emit mouseChanged();
        emit mousePressed(m_lastMouseX, m_lastMouseY, m_lastMouseButtons, m_lastMouseModifiers);
        markActivity();
        break;
    }
    case QEvent::MouseButtonRelease: {
        auto *mouseEvent = static_cast<QMouseEvent *>(event);
        m_mouseReleaseCount += 1;
        m_mouseButtonPressed = false;
        updateMouseFromEvent(mouseEvent->globalPosition().x(),
                             mouseEvent->globalPosition().y(),
                             static_cast<int>(mouseEvent->buttons()),
                             static_cast<int>(mouseEvent->modifiers()));
        emit mouseChanged();
        emit mouseReleased(m_lastMouseX, m_lastMouseY, m_lastMouseButtons, m_lastMouseModifiers);
        markActivity();
        break;
    }
    case QEvent::ContextMenu: {
        auto *contextEvent = static_cast<QContextMenuEvent *>(event);
        const int modifiers = static_cast<int>(contextEvent->modifiers());
        const int buttons = contextEvent->reason() == QContextMenuEvent::Mouse
            ? static_cast<int>(Qt::RightButton)
            : 0;
        updateMouseFromEvent(static_cast<qreal>(contextEvent->globalPos().x()),
                             static_cast<qreal>(contextEvent->globalPos().y()),
                             buttons,
                             modifiers);
        emit mouseChanged();
        emit contextRequested(m_lastMouseX,
                              m_lastMouseY,
                              m_lastMouseModifiers,
                              static_cast<int>(contextEvent->reason()));
        markActivity();
        break;
    }
    case QEvent::HoverMove: {
        auto *hoverEvent = static_cast<QHoverEvent *>(event);
        m_mouseMoveCount += 1;
        updateMouseFromEvent(hoverEvent->globalPosition().x(),
                             hoverEvent->globalPosition().y(),
                             m_lastMouseButtons,
                             m_lastMouseModifiers);
        emit mouseChanged();
        emit mouseMoved(m_lastMouseX, m_lastMouseY, m_lastMouseButtons, m_lastMouseModifiers);
        markActivity();
        break;
    }
    case QEvent::ChildAdded: {
        auto *childEvent = static_cast<QChildEvent *>(event);
        const bool withinTrackedTree = watched == m_window || m_trackedObjects.contains(watched);
        if (withinTrackedTree && childEvent->added() && childEvent->child())
            trackUiObjectRecursive(childEvent->child());
        break;
    }
    case QEvent::Show:
    case QEvent::ShowToParent:
        recordUiEvent(QStringLiteral("shown"), watched, true);
        break;
    case QEvent::Hide:
    case QEvent::HideToParent:
        recordUiEvent(QStringLiteral("hidden"), watched, false);
        break;
    default:
        break;
    }

    return QObject::eventFilter(watched, event);
}

void RuntimeEvents::trackUiObjectRecursive(QObject *object)
{
    if (!object || m_trackedObjects.contains(object))
        return;

    m_trackedObjects.insert(object);

    UiObjectInfo info;
    info.objectName = object->objectName();
    if (info.objectName.isEmpty())
        info.objectName = QStringLiteral("unnamed");
    info.className = QString::fromLatin1(object->metaObject()->className());
    const QVariant visibleProp = object->property("visible");
    info.visible = visibleProp.isValid() ? visibleProp.toBool() : true;
    m_trackedInfo.insert(object, info);

    connect(object,
            &QObject::destroyed,
            this,
            [this, object]() {
                handleTrackedDestroyed(object);
            });

    recordUiEvent(QStringLiteral("created"), object, info.visible);

    const auto children = object->children();
    for (QObject *child : children)
        trackUiObjectRecursive(child);
}

void RuntimeEvents::detachTrackedObjects()
{
    m_trackedObjects.clear();
    m_trackedInfo.clear();
}

void RuntimeEvents::handleTrackedDestroyed(const QObject *object)
{
    if (!m_trackedInfo.contains(object))
        return;

    const UiObjectInfo info = m_trackedInfo.take(object);
    m_trackedObjects.remove(const_cast<QObject *>(object));
    m_uiDestroyedCount += 1;
    m_lastUiEvent = QStringLiteral("destroyed");
    m_lastUiObjectName = info.objectName;
    m_lastUiClassName = info.className;
    emit uiChanged();
    emit uiEvent(m_lastUiEvent, m_lastUiObjectName, m_lastUiClassName, false);
}

void RuntimeEvents::recordUiEvent(const QString &eventType, const QObject *object, bool visible)
{
    if (!object || !m_trackedInfo.contains(object))
        return;

    UiObjectInfo &info = m_trackedInfo[object];
    info.visible = visible;

    if (eventType == QLatin1String("created"))
        m_uiCreatedCount += 1;
    else if (eventType == QLatin1String("shown"))
        m_uiShownCount += 1;
    else if (eventType == QLatin1String("hidden"))
        m_uiHiddenCount += 1;

    m_lastUiEvent = eventType;
    m_lastUiObjectName = info.objectName;
    m_lastUiClassName = info.className;
    emit uiChanged();
    emit uiEvent(eventType, info.objectName, info.className, visible);
}

void RuntimeEvents::updateMouseFromEvent(qreal x, qreal y, int buttons, int modifiers)
{
    m_lastMouseX = x;
    m_lastMouseY = y;
    m_lastMouseButtons = buttons;
    m_lastMouseModifiers = modifiers;
}

void RuntimeEvents::handleIdleTick()
{
    const qint64 nowMs = m_uptimeTimer.elapsed();
    const qint64 idleFor = qMax<qint64>(0, nowMs - m_lastActivityMonotonicMs);
    if (m_idleForMs != idleFor) {
        m_idleForMs = idleFor;
        emit idleForMsChanged();
    }

    if (!m_idle && m_idleForMs >= m_idleTimeoutMs)
        updateIdleState(true);
}

void RuntimeEvents::handleOsTick()
{
    const qint64 nextUptime = m_uptimeTimer.elapsed();
    const qint64 nextRss = sampleResidentSetBytes();

    bool changed = false;
    if (m_uptimeMs != nextUptime) {
        m_uptimeMs = nextUptime;
        changed = true;
    }
    if (m_rssBytes != nextRss) {
        m_rssBytes = nextRss;
        changed = true;
    }

    if (qGuiApp) {
        const bool nextActive = qGuiApp->applicationState() == Qt::ApplicationActive;
        if (m_applicationActive != nextActive) {
            m_applicationActive = nextActive;
            emit osChanged();
        }
    }

    if (changed)
        emit osStatsChanged();
}

void RuntimeEvents::updateIdleState(bool nextIdle)
{
    if (m_idle == nextIdle)
        return;
    m_idle = nextIdle;
    emit idleChanged();
    if (m_idle)
        emit idleEntered();
    else
        emit idleExited();
}

qint64 RuntimeEvents::nowEpochMs() const
{
    return QDateTime::currentMSecsSinceEpoch();
}

qint64 RuntimeEvents::sampleResidentSetBytes() const
{
#ifdef Q_OS_MAC
    mach_task_basic_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    if (task_info(mach_task_self(), MACH_TASK_BASIC_INFO, reinterpret_cast<task_info_t>(&info), &count) == KERN_SUCCESS)
        return static_cast<qint64>(info.resident_size);
    return -1;
#elif defined(Q_OS_LINUX)
    QFile file(QStringLiteral("/proc/self/statm"));
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return -1;
    const QByteArray line = file.readLine().trimmed();
    const QList<QByteArray> parts = line.split(' ');
    if (parts.size() < 2)
        return -1;
    bool ok = false;
    const qint64 residentPages = parts.at(1).toLongLong(&ok);
    if (!ok)
        return -1;
    const long pageSize = sysconf(_SC_PAGESIZE);
    if (pageSize <= 0)
        return -1;
    return residentPages * static_cast<qint64>(pageSize);
#else
    return -1;
#endif
}
