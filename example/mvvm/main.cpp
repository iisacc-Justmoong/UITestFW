#include <QCoreApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtPlugin>

#include "example/mvvm/backend/ExampleBootstrap.h"

Q_IMPORT_PLUGIN(UIFrameworkPlugin)

int main(int argc, char *argv[])
{
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
