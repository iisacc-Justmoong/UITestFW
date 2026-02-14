#pragma once

#include "backend/runtime/appbootstrap.h"

#include <functional>

class QQmlApplicationEngine;

namespace lvrs {

struct QmlAppLaunchSpec {
    AppBootstrapOptions bootstrap;
    QString moduleUri;
    QString rootObject = QStringLiteral("Main");
    std::function<void(QQmlApplicationEngine &engine)> configureEngine;
};

int runBootstrappedQmlApp(int argc, char *argv[], const QmlAppLaunchSpec &spec);

} // namespace lvrs

