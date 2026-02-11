#pragma once

#include <QElapsedTimer>
#include <QHash>
#include <QObject>
#include <QPointer>
#include <QSet>
#include <QTimer>
#include <QVariantMap>
#include <QtQml/qqml.h>

class QQuickWindow;

class RuntimeEvents : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(RuntimeEvents)
    QML_SINGLETON

    Q_PROPERTY(bool running READ running NOTIFY runningChanged)

    Q_PROPERTY(quint64 keyPressCount READ keyPressCount NOTIFY keyboardChanged)
    Q_PROPERTY(quint64 keyReleaseCount READ keyReleaseCount NOTIFY keyboardChanged)
    Q_PROPERTY(int lastKey READ lastKey NOTIFY keyboardChanged)
    Q_PROPERTY(QString lastKeyText READ lastKeyText NOTIFY keyboardChanged)
    Q_PROPERTY(int lastKeyModifiers READ lastKeyModifiers NOTIFY keyboardChanged)
    Q_PROPERTY(bool anyKeyPressed READ anyKeyPressed NOTIFY keyboardChanged)

    Q_PROPERTY(quint64 mouseMoveCount READ mouseMoveCount NOTIFY mouseChanged)
    Q_PROPERTY(quint64 mousePressCount READ mousePressCount NOTIFY mouseChanged)
    Q_PROPERTY(quint64 mouseReleaseCount READ mouseReleaseCount NOTIFY mouseChanged)
    Q_PROPERTY(qreal lastMouseX READ lastMouseX NOTIFY mouseChanged)
    Q_PROPERTY(qreal lastMouseY READ lastMouseY NOTIFY mouseChanged)
    Q_PROPERTY(int lastMouseButtons READ lastMouseButtons NOTIFY mouseChanged)
    Q_PROPERTY(int lastMouseModifiers READ lastMouseModifiers NOTIFY mouseChanged)
    Q_PROPERTY(bool mouseButtonPressed READ mouseButtonPressed NOTIFY mouseChanged)

    Q_PROPERTY(quint64 uiCreatedCount READ uiCreatedCount NOTIFY uiChanged)
    Q_PROPERTY(quint64 uiShownCount READ uiShownCount NOTIFY uiChanged)
    Q_PROPERTY(quint64 uiHiddenCount READ uiHiddenCount NOTIFY uiChanged)
    Q_PROPERTY(quint64 uiDestroyedCount READ uiDestroyedCount NOTIFY uiChanged)
    Q_PROPERTY(QString lastUiEvent READ lastUiEvent NOTIFY uiChanged)
    Q_PROPERTY(QString lastUiObjectName READ lastUiObjectName NOTIFY uiChanged)
    Q_PROPERTY(QString lastUiClassName READ lastUiClassName NOTIFY uiChanged)

    Q_PROPERTY(bool idle READ idle NOTIFY idleChanged)
    Q_PROPERTY(int idleTimeoutMs READ idleTimeoutMs WRITE setIdleTimeoutMs NOTIFY idleTimeoutMsChanged)
    Q_PROPERTY(qint64 idleForMs READ idleForMs NOTIFY idleForMsChanged)
    Q_PROPERTY(qint64 lastActivityEpochMs READ lastActivityEpochMs NOTIFY lastActivityChanged)

    Q_PROPERTY(qint64 pid READ pid CONSTANT)
    Q_PROPERTY(QString processName READ processName CONSTANT)
    Q_PROPERTY(QString osName READ osName CONSTANT)
    Q_PROPERTY(bool applicationActive READ applicationActive NOTIFY osChanged)
    Q_PROPERTY(int osSampleIntervalMs READ osSampleIntervalMs WRITE setOsSampleIntervalMs NOTIFY osSampleIntervalMsChanged)
    Q_PROPERTY(qint64 uptimeMs READ uptimeMs NOTIFY osStatsChanged)
    Q_PROPERTY(qint64 rssBytes READ rssBytes NOTIFY osStatsChanged)

public:
    explicit RuntimeEvents(QObject *parent = nullptr);
    ~RuntimeEvents() override;

    bool running() const;

    quint64 keyPressCount() const;
    quint64 keyReleaseCount() const;
    int lastKey() const;
    QString lastKeyText() const;
    int lastKeyModifiers() const;
    bool anyKeyPressed() const;
    Q_INVOKABLE bool isKeyPressed(int key) const;

    quint64 mouseMoveCount() const;
    quint64 mousePressCount() const;
    quint64 mouseReleaseCount() const;
    qreal lastMouseX() const;
    qreal lastMouseY() const;
    int lastMouseButtons() const;
    int lastMouseModifiers() const;
    bool mouseButtonPressed() const;

    quint64 uiCreatedCount() const;
    quint64 uiShownCount() const;
    quint64 uiHiddenCount() const;
    quint64 uiDestroyedCount() const;
    QString lastUiEvent() const;
    QString lastUiObjectName() const;
    QString lastUiClassName() const;

    bool idle() const;
    int idleTimeoutMs() const;
    void setIdleTimeoutMs(int value);
    qint64 idleForMs() const;
    qint64 lastActivityEpochMs() const;

    qint64 pid() const;
    QString processName() const;
    QString osName() const;
    bool applicationActive() const;
    int osSampleIntervalMs() const;
    void setOsSampleIntervalMs(int value);
    qint64 uptimeMs() const;
    qint64 rssBytes() const;

    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void attachWindow(QObject *window);
    Q_INVOKABLE void markActivity();
    Q_INVOKABLE void resetCounters();
    Q_INVOKABLE QVariantMap snapshot() const;

signals:
    void runningChanged();
    void keyboardChanged();
    void keyPressed(int key, int modifiers, bool autoRepeat, const QString &text);
    void keyReleased(int key, int modifiers, bool autoRepeat, const QString &text);
    void mouseChanged();
    void mouseMoved(qreal x, qreal y, int buttons, int modifiers);
    void mousePressed(qreal x, qreal y, int buttons, int modifiers);
    void mouseReleased(qreal x, qreal y, int buttons, int modifiers);
    void contextRequested(qreal x, qreal y, int modifiers, int reason);
    void uiChanged();
    void uiEvent(const QString &eventType, const QString &objectName, const QString &className, bool visible);
    void idleChanged();
    void idleTimeoutMsChanged();
    void idleForMsChanged();
    void lastActivityChanged();
    void idleEntered();
    void idleExited();
    void osChanged();
    void osSampleIntervalMsChanged();
    void osStatsChanged();
    void osApplicationStateChanged(int state);

protected:
    bool eventFilter(QObject *watched, QEvent *event) override;

private:
    struct UiObjectInfo {
        QString objectName;
        QString className;
        bool visible = false;
    };

    void trackUiObjectRecursive(QObject *object);
    void detachTrackedObjects();
    void handleTrackedDestroyed(const QObject *object);
    void recordUiEvent(const QString &eventType, const QObject *object, bool visible);
    void updateMouseFromEvent(qreal x, qreal y, int buttons, int modifiers);
    void handleIdleTick();
    void handleOsTick();
    void updateIdleState(bool nextIdle);
    qint64 nowEpochMs() const;
    qint64 sampleResidentSetBytes() const;

    QPointer<QQuickWindow> m_window;
    QSet<QObject *> m_trackedObjects;
    QHash<const QObject *, UiObjectInfo> m_trackedInfo;
    QSet<int> m_pressedKeys;

    QTimer m_idleTimer;
    QTimer m_osTimer;
    QElapsedTimer m_uptimeTimer;
    qint64 m_lastActivityMonotonicMs = 0;

    bool m_running = false;

    quint64 m_keyPressCount = 0;
    quint64 m_keyReleaseCount = 0;
    int m_lastKey = 0;
    QString m_lastKeyText;
    int m_lastKeyModifiers = 0;

    quint64 m_mouseMoveCount = 0;
    quint64 m_mousePressCount = 0;
    quint64 m_mouseReleaseCount = 0;
    qreal m_lastMouseX = 0.0;
    qreal m_lastMouseY = 0.0;
    int m_lastMouseButtons = 0;
    int m_lastMouseModifiers = 0;
    bool m_mouseButtonPressed = false;

    quint64 m_uiCreatedCount = 0;
    quint64 m_uiShownCount = 0;
    quint64 m_uiHiddenCount = 0;
    quint64 m_uiDestroyedCount = 0;
    QString m_lastUiEvent;
    QString m_lastUiObjectName;
    QString m_lastUiClassName;

    bool m_idle = false;
    int m_idleTimeoutMs = 60000;
    qint64 m_idleForMs = 0;
    qint64 m_lastActivityEpochMs = 0;

    bool m_applicationActive = true;
    int m_osSampleIntervalMs = 1000;
    qint64 m_uptimeMs = 0;
    qint64 m_rssBytes = -1;
};
