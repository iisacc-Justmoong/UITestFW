#include "backend/platform/nativewindowstyle.h"

#include <QWindow>

#import <AppKit/AppKit.h>

namespace {
NSColor *toNativeColor(const QColor &color)
{
    return [NSColor colorWithSRGBRed:color.redF()
                               green:color.greenF()
                                blue:color.blueF()
                               alpha:color.alphaF()];
}
}

NativeWindowStyle::NativeWindowStyle(QObject *parent)
    : QObject(parent)
{
}

bool NativeWindowStyle::titleBarColorSupported() const
{
    return true;
}

bool NativeWindowStyle::applyTitleBarColor(QObject *windowObject, const QColor &color, bool darkAppearance)
{
    auto *window = qobject_cast<QWindow *>(windowObject);
    if (!window)
        return false;

    if (!window->handle())
        window->create();

    NSView *view = reinterpret_cast<NSView *>(window->winId());
    if (!view)
        return false;

    NSWindow *nativeWindow = view.window;
    if (!nativeWindow)
        return false;

    const bool isDark = darkAppearance;
    [nativeWindow setBackgroundColor:toNativeColor(color)];
    [nativeWindow setTitlebarAppearsTransparent:YES];

    if (@available(macOS 11.0, *)) {
        [nativeWindow setToolbarStyle:isDark ? NSWindowToolbarStyleUnifiedCompact : NSWindowToolbarStyleUnified];
        [nativeWindow setTitlebarSeparatorStyle:NSTitlebarSeparatorStyleNone];
    }

    if (@available(macOS 10.14, *)) {
        [nativeWindow setAppearance:[NSAppearance appearanceNamed:isDark ? NSAppearanceNameDarkAqua : NSAppearanceNameAqua]];
    }

    return true;
}
