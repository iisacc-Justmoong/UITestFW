#pragma once

#include <QObject>
#include <QPointer>
#include <QElapsedTimer>
#include <QtQml/qqml.h>

class QQuickWindow;

class RenderingMonitor : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(RenderMonitor)
    QML_SINGLETON

    Q_PROPERTY(bool active READ active NOTIFY activeChanged)
    Q_PROPERTY(double fps READ fps NOTIFY statsChanged)
    Q_PROPERTY(double lastFrameMs READ lastFrameMs NOTIFY statsChanged)
    Q_PROPERTY(quint64 frameCount READ frameCount NOTIFY statsChanged)

public:
    explicit RenderingMonitor(QObject *parent = nullptr);

    Q_INVOKABLE void attachWindow(QObject *window);
    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void reset();

    bool active() const;
    double fps() const;
    double lastFrameMs() const;
    quint64 frameCount() const;

signals:
    void activeChanged();
    void statsChanged();

private slots:
    void handleFrameSwapped();
    void handleWindowDestroyed();

private:
    void setActive(bool next);
    void resetMetrics();
    void detachWindow();

    QPointer<QQuickWindow> m_window;
    QElapsedTimer m_frameTimer;
    bool m_active = false;
    double m_fps = 0.0;
    double m_lastFrameMs = 0.0;
    quint64 m_frameCount = 0;
};
