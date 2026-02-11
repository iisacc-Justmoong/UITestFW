#include <QCoreApplication>
#include <QGuiApplication>
#include <QQuickStyle>
#include <QQmlApplicationEngine>
#include <QtPlugin>

#include "backend/ExampleBootstrap.h"

Q_IMPORT_PLUGIN(LVRSPlugin)

int main(int argc, char *argv[])
{
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
