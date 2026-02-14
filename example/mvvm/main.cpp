#include "backend/runtime/appentry.h"

#include <QQmlApplicationEngine>
#include <QtPlugin>

#include "backend/ExampleBootstrap.h"

#if defined(LVRS_USE_STATIC_QML_PLUGIN)
Q_IMPORT_PLUGIN(LVRSPlugin)
#endif

int main(int argc, char *argv[])
{
    lvrs::QmlAppLaunchSpec launchSpec;
    launchSpec.bootstrap.applicationName = QStringLiteral("LVRSExampleMVVM");
    launchSpec.bootstrap.quickStyleName = QStringLiteral("Basic");
    launchSpec.moduleUri = QStringLiteral("ExampleMVVM");
    launchSpec.rootObject = QStringLiteral("Main");
    launchSpec.configureEngine = [](QQmlApplicationEngine &engine) {
        setupExampleViewModel(&engine);
    };

    return lvrs::runBootstrappedQmlApp(argc, argv, launchSpec);
}
