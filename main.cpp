#include "backend/fonts/fontpolicy.h"
#include "backend/runtime/renderquality.h"
#include "backend/runtime/vulkanbootstrap.h"

#include <QCoreApplication>
#include <QDebug>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
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

}

int main(int argc, char *argv[])
{
    RenderQuality::configureGlobalDefaults();

    const lvrs::GraphicsBackendBootstrapResult backendBootstrap = lvrs::bootstrapPreferredGraphicsBackend();
    if (!backendBootstrap.available) {
        qCritical().noquote() << backendBootstrap.errorMessage;
        return -1;
    }
    if (backendBootstrap.loaderName.isEmpty())
        qInfo() << "LVRS graphics backend:" << backendBootstrap.backendName;
    else
        qInfo() << "LVRS graphics backend:" << backendBootstrap.backendName
                << ", loader =" << backendBootstrap.loaderName;

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
