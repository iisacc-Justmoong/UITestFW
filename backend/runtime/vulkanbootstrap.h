#pragma once

#include <QString>

namespace lvrs {
struct GraphicsBackendBootstrapResult {
    bool available = false;
    QString backendName;
    QString loaderName;
    QString errorMessage;
};

GraphicsBackendBootstrapResult bootstrapPreferredGraphicsBackend();
}
