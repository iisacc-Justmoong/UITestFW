#include "platforminfo.h"

#include <QSysInfo>

PlatformInfo::PlatformInfo(QObject *parent)
    : QObject(parent)
{
}

QString PlatformInfo::os() const
{
#if defined(Q_OS_ANDROID)
    return QStringLiteral("android");
#elif defined(Q_OS_IOS)
    return QStringLiteral("ios");
#elif defined(Q_OS_MACOS)
    return QStringLiteral("osx");
#elif defined(Q_OS_WIN)
    return QStringLiteral("windows");
#elif defined(Q_OS_LINUX)
    return QStringLiteral("linux");
#else
    return QStringLiteral("unknown");
#endif
}

QString PlatformInfo::arch() const
{
    return QSysInfo::currentCpuArchitecture();
}

bool PlatformInfo::mobile() const
{
    return android() || ios();
}

bool PlatformInfo::desktop() const
{
    return macos() || windows() || linux();
}

bool PlatformInfo::android() const
{
#if defined(Q_OS_ANDROID)
    return true;
#else
    return false;
#endif
}

bool PlatformInfo::ios() const
{
#if defined(Q_OS_IOS)
    return true;
#else
    return false;
#endif
}

bool PlatformInfo::macos() const
{
#if defined(Q_OS_MACOS)
    return true;
#else
    return false;
#endif
}

bool PlatformInfo::windows() const
{
#if defined(Q_OS_WIN)
    return true;
#else
    return false;
#endif
}

bool PlatformInfo::linux() const
{
#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    return true;
#else
    return false;
#endif
}
