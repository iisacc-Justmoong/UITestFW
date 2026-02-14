#include "backend/runtime/appentry.h"

#include <QtPlugin>

#if defined(LVRS_USE_STATIC_QML_PLUGIN)
Q_IMPORT_PLUGIN(LVRSPlugin)
#endif

int main(int argc, char *argv[])
{
    lvrs::QmlAppLaunchSpec launchSpec;
    launchSpec.bootstrap.applicationName = QStringLiteral("LVRSExampleEventListener");
    launchSpec.bootstrap.quickStyleName = QStringLiteral("Basic");
    launchSpec.moduleUri = QStringLiteral("ExampleEventListener");
    launchSpec.rootObject = QStringLiteral("Main");

    return lvrs::runBootstrappedQmlApp(argc, argv, launchSpec);
}
