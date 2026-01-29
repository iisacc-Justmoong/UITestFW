#include "backend/renderingmonitor.h"

#include <QQuickWindow>

RenderingMonitor::RenderingMonitor(QObject *parent)
    : QObject(parent)
{
}

void RenderingMonitor::attachWindow(QObject *window)
{
    if (m_window)
        detachWindow();

    auto *quickWindow = qobject_cast<QQuickWindow *>(window);
    if (!quickWindow) {
        resetMetrics();
        setActive(false);
        return;
    }

    m_window = quickWindow;
    connect(m_window, &QObject::destroyed, this, &RenderingMonitor::handleWindowDestroyed);
    connect(m_window, &QQuickWindow::frameSwapped, this, &RenderingMonitor::handleFrameSwapped);

    resetMetrics();
    setActive(true);
}

void RenderingMonitor::start()
{
    if (m_active)
        return;
    setActive(true);
}

void RenderingMonitor::stop()
{
    if (!m_active)
        return;
    setActive(false);
}

void RenderingMonitor::reset()
{
    resetMetrics();
}

bool RenderingMonitor::active() const
{
    return m_active;
}

double RenderingMonitor::fps() const
{
    return m_fps;
}

double RenderingMonitor::lastFrameMs() const
{
    return m_lastFrameMs;
}

quint64 RenderingMonitor::frameCount() const
{
    return m_frameCount;
}

void RenderingMonitor::handleFrameSwapped()
{
    if (!m_active)
        return;

    if (!m_frameTimer.isValid()) {
        m_frameTimer.start();
        m_frameCount = 0;
    }

    const qint64 elapsed = m_frameTimer.restart();
    if (elapsed > 0) {
        m_lastFrameMs = static_cast<double>(elapsed);
        m_fps = 1000.0 / m_lastFrameMs;
    }
    m_frameCount += 1;

    emit statsChanged();
}

void RenderingMonitor::handleWindowDestroyed()
{
    detachWindow();
    setActive(false);
}

void RenderingMonitor::setActive(bool next)
{
    if (m_active == next)
        return;
    m_active = next;
    emit activeChanged();
}

void RenderingMonitor::resetMetrics()
{
    m_frameTimer.invalidate();
    m_fps = 0.0;
    m_lastFrameMs = 0.0;
    m_frameCount = 0;
    emit statsChanged();
}

void RenderingMonitor::detachWindow()
{
    if (!m_window)
        return;
    m_window->disconnect(this);
    m_window.clear();
}
