#include "backend/fonts/fontpolicy.h"
#include "backend/runtime/renderquality.h"

#include <QCoreApplication>
#include <QDebug>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QLibrary>
#include <QQuickWindow>
#include <QQmlApplicationEngine>
#include <QSGRendererInterface>
#include <QtPlugin>

Q_IMPORT_PLUGIN(LVRSPlugin)

namespace {
void loadBundledFonts()
{
    static const char *kFontResources[] = {
        ":/qt/qml/LVRS/resources/font/Pretendard-Regular.ttf",
        ":/qt/qml/LVRS/resources/font/Pretendard-Medium.ttf",
        ":/qt/qml/LVRS/resources/font/Pretendard-SemiBold.ttf",
        ":/qt/qml/LVRS/resources/font/Pretendard-Bold.ttf",
        ":/qt/qml/LVRS/resources/font/Pretendard-Light.ttf",
        ":/qt/qml/LVRS/resources/font/Pretendard-ExtraLight.ttf",
        ":/qt/qml/LVRS/resources/font/Pretendard-Thin.ttf",
        ":/qt/qml/LVRS/resources/font/Pretendard-ExtraBold.ttf",
        ":/qt/qml/LVRS/resources/font/Pretendard-Black.ttf"
    };

    for (const char *fontResource : kFontResources) {
        if (QFontDatabase::addApplicationFont(QString::fromLatin1(fontResource)) < 0)
            qWarning() << "Failed to load bundled font:" << fontResource;
    }
}

bool enforceVulkanBackend()
{
    qputenv("QSG_RHI_BACKEND", QByteArrayLiteral("vulkan"));
    qputenv("QSG_RHI_PREFER_SOFTWARE_RENDERER", QByteArrayLiteral("0"));
    QQuickWindow::setGraphicsApi(QSGRendererInterface::Vulkan);

    const char *kVulkanLoaders[] = {
#if defined(Q_OS_WIN)
        "vulkan-1"
#elif defined(Q_OS_MACOS)
        "vulkan",
        "MoltenVK",
        "libvulkan.1",
        "libMoltenVK"
#else
        "vulkan",
        "libvulkan.so.1"
#endif
    };

    for (const char *loaderName : kVulkanLoaders) {
        QLibrary vulkanLoader(QString::fromLatin1(loaderName));
        if (vulkanLoader.load()) {
            vulkanLoader.unload();
            qInfo() << "LVRS graphics backend: Vulkan (forced), loader =" << loaderName;
            return true;
        }
    }

    qCritical() << "No Vulkan loader found. LVRS requires Vulkan rendering.";
    return false;
}
}

int main(int argc, char *argv[])
{
    RenderQuality::configureGlobalDefaults();
    if (!enforceVulkanBackend())
        return -1;

    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("LVRS"));
    loadBundledFonts();
    FontPolicy::installPretendardFallbacks();
    if (!FontPolicy::enforcePretendardFallback())
        qWarning() << "Pretendard fallback could not be enforced.";

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule(QStringLiteral("LVRSDemo"), QStringLiteral("Main"));

    return app.exec();
}
