#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("UITestFW"));

    QQmlApplicationEngine engine;
    const QUrl moduleUrl(QStringLiteral("qrc:/qt/qml/UITestFW/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [&app, moduleUrl](QObject *obj, const QUrl &objUrl) {
            if (!obj && objUrl == moduleUrl) {
                app.exit(-1);
            }
        },
        Qt::QueuedConnection);

    engine.load(moduleUrl);

    return app.exec();
}
