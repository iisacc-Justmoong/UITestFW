#include "backend/runtime/appentry.h"

#include <QCoreApplication>
#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

namespace lvrs {

int runBootstrappedQmlApp(int argc, char *argv[], const QmlAppLaunchSpec &spec)
{
    if (spec.moduleUri.trimmed().isEmpty() || spec.rootObject.trimmed().isEmpty()) {
        qCritical().noquote() << "LVRS app entry requires non-empty module URI and root object.";
        return -1;
    }

    const AppBootstrapState bootstrapState = preApplicationBootstrap(spec.bootstrap);
    if (!bootstrapState.ok) {
        qCritical().noquote() << bootstrapState.errorMessage;
        return -1;
    }

    QGuiApplication app(argc, argv);
    postApplicationBootstrap(app, spec.bootstrap);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    if (spec.configureEngine)
        spec.configureEngine(engine);

    engine.loadFromModule(spec.moduleUri, spec.rootObject);

    return app.exec();
}

} // namespace lvrs

