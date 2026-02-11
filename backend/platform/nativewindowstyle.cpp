#include "backend/platform/nativewindowstyle.h"

NativeWindowStyle::NativeWindowStyle(QObject *parent)
    : QObject(parent)
{
}

bool NativeWindowStyle::titleBarColorSupported() const
{
    return false;
}

bool NativeWindowStyle::applyTitleBarColor(QObject *window, const QColor &color, bool darkAppearance)
{
    Q_UNUSED(window);
    Q_UNUSED(color);
    Q_UNUSED(darkAppearance);
    return false;
}
