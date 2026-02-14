#include <QCoreApplication>
#include <QGuiApplication>
#include <QLibrary>
#include <QQuickWindow>
#include <QQuickStyle>
#include <QQmlApplicationEngine>
#include <QSGRendererInterface>
#include <QtPlugin>

#include "backend/ExampleBootstrap.h"

Q_IMPORT_PLUGIN(LVRSPlugin)

namespace {
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
            return true;
        }
    }
    return false;
}
}

int main(int argc, char *argv[])
{
    if (!enforceVulkanBackend())
        return -1;

    QQuickStyle::setStyle(QStringLiteral("Basic"));
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    setupExampleViewModel(&engine);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule(QStringLiteral("ExampleMVVM"), QStringLiteral("Main"));

    return app.exec();
}
