#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl moduleUrl(QStringLiteral("qrc:/qt/qml/ExampleEventListener/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [moduleUrl](QObject *obj, const QUrl &objUrl) {
            if (!obj && objUrl == moduleUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.load(moduleUrl);

    return app.exec();
}
