#include "backend/renderquality.h"

#include <QGuiApplication>
#include <QQuickWindow>
#include <QSurfaceFormat>

RenderQuality::RenderQuality(QObject *parent)
    : QObject(parent)
{
}

bool RenderQuality::enabled() const
{
    return m_enabled;
}

void RenderQuality::setEnabled(bool value)
{
    if (m_enabled == value)
        return;
    m_enabled = value;
    emit enabledChanged();
}

qreal RenderQuality::supersampleScale() const
{
    return m_supersampleScale;
}

void RenderQuality::setSupersampleScale(qreal value)
{
    const qreal next = qBound(m_minimumSupersampleScale, value, m_maximumSupersampleScale);
    if (qFuzzyCompare(m_supersampleScale, next))
        return;
    m_supersampleScale = next;
    emit supersampleScaleChanged();
}

qreal RenderQuality::minimumSupersampleScale() const
{
    return m_minimumSupersampleScale;
}

qreal RenderQuality::maximumSupersampleScale() const
{
    return m_maximumSupersampleScale;
}

int RenderQuality::msaaSamples() const
{
    return m_msaaSamples;
}

void RenderQuality::setMsaaSamples(int value)
{
    const int next = qBound(0, value, 16);
    if (m_msaaSamples == next)
        return;
    m_msaaSamples = next;
    emit msaaSamplesChanged();
}

bool RenderQuality::nativeTextRendering() const
{
    return m_nativeTextRendering;
}

void RenderQuality::setNativeTextRendering(bool value)
{
    if (m_nativeTextRendering == value)
        return;
    m_nativeTextRendering = value;
    emit nativeTextRenderingChanged();
}

qreal RenderQuality::effectiveSupersampleScale() const
{
    if (!m_enabled)
        return 1.0;
    return qBound(m_minimumSupersampleScale, m_supersampleScale, m_maximumSupersampleScale);
}

void RenderQuality::applyWindow(QObject *window)
{
    auto *quickWindow = qobject_cast<QQuickWindow *>(window);
    if (!quickWindow)
        return;

    const int samples = qBound(0, m_msaaSamples, 16);
    QSurfaceFormat format = quickWindow->format();
    if (format.samples() < samples) {
        format.setSamples(samples);
        quickWindow->setFormat(format);
    }

    quickWindow->setPersistentGraphics(m_enabled);
    quickWindow->setPersistentSceneGraph(m_enabled);
    QQuickWindow::setTextRenderType(
        m_nativeTextRendering ? QQuickWindow::NativeTextRendering : QQuickWindow::QtTextRendering);
}

void RenderQuality::applyGlobalDefaults()
{
    configureGlobalDefaults(m_msaaSamples, m_nativeTextRendering);
}

void RenderQuality::configureGlobalDefaults(int msaaSamples, bool nativeTextRendering)
{
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(
        Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);

    QSurfaceFormat format = QSurfaceFormat::defaultFormat();
    const int samples = qBound(0, msaaSamples, 16);
    if (format.samples() < samples)
        format.setSamples(samples);
    if (format.depthBufferSize() < 24)
        format.setDepthBufferSize(24);
    if (format.stencilBufferSize() < 8)
        format.setStencilBufferSize(8);
    QSurfaceFormat::setDefaultFormat(format);

    QQuickWindow::setTextRenderType(
        nativeTextRendering ? QQuickWindow::NativeTextRendering : QQuickWindow::QtTextRendering);
}
