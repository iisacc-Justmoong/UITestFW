#include "backend/runtime/appbootstrap.h"

#include "backend/fonts/fontpolicy.h"
#include "backend/runtime/renderquality.h"

#include <QDebug>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QQuickStyle>

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

void logGraphicsBackend(const lvrs::GraphicsBackendBootstrapResult &backend)
{
    if (backend.loaderName.isEmpty()) {
        qInfo() << "LVRS graphics backend:" << backend.backendName;
        return;
    }
    qInfo() << "LVRS graphics backend:" << backend.backendName
            << ", loader =" << backend.loaderName;
}

} // namespace

namespace lvrs {

AppBootstrapState preApplicationBootstrap(const AppBootstrapOptions &options)
{
    AppBootstrapState state;

    if (options.configureRenderQualityDefaults)
        RenderQuality::configureGlobalDefaults();

    const QString quickStyleName = options.quickStyleName.trimmed();
    if (!quickStyleName.isEmpty())
        QQuickStyle::setStyle(quickStyleName);

    if (options.bootstrapGraphicsBackend) {
        state.graphicsBackend = bootstrapPreferredGraphicsBackend();
        if (!state.graphicsBackend.available) {
            state.ok = false;
            state.errorMessage = state.graphicsBackend.errorMessage;
            return state;
        }
        if (options.logGraphicsBackend)
            logGraphicsBackend(state.graphicsBackend);
    }

    return state;
}

void postApplicationBootstrap(QGuiApplication &app, const AppBootstrapOptions &options)
{
    const QString appName = options.applicationName.trimmed();
    if (!appName.isEmpty())
        app.setApplicationName(appName);

    if (options.installBundledFonts)
        loadBundledFonts();

    if (options.installPretendardFallbacks)
        FontPolicy::installPretendardFallbacks();

    if (options.enforcePretendardFallback && !FontPolicy::enforcePretendardFallback())
        qWarning() << "Pretendard fallback could not be enforced.";
}

} // namespace lvrs

