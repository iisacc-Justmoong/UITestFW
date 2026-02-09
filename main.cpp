#include "backend/fonts/fontpolicy.h"
#include "backend/runtime/renderquality.h"

#include <QCoreApplication>
#include <QDebug>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtPlugin>

Q_IMPORT_PLUGIN(UIFrameworkPlugin)

namespace {
void loadBundledFonts()
{
    static const char *kFontResources[] = {
        ":/qt/qml/UIFramework/resources/font/Pretendard-Regular.ttf",
        ":/qt/qml/UIFramework/resources/font/Pretendard-Medium.ttf",
        ":/qt/qml/UIFramework/resources/font/Pretendard-SemiBold.ttf",
        ":/qt/qml/UIFramework/resources/font/Pretendard-Bold.ttf",
        ":/qt/qml/UIFramework/resources/font/Pretendard-Light.ttf",
        ":/qt/qml/UIFramework/resources/font/Pretendard-ExtraLight.ttf",
        ":/qt/qml/UIFramework/resources/font/Pretendard-Thin.ttf",
        ":/qt/qml/UIFramework/resources/font/Pretendard-ExtraBold.ttf",
        ":/qt/qml/UIFramework/resources/font/Pretendard-Black.ttf"
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
    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("UITestFW"));
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

    engine.loadFromModule(QStringLiteral("UITestFW"), QStringLiteral("Main"));

    return app.exec();
}
