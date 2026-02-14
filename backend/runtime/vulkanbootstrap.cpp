#include "backend/runtime/vulkanbootstrap.h"

#include <QDir>
#include <QFileInfo>
#include <QLibrary>
#include <QQuickWindow>
#include <QSGRendererInterface>
#include <QSet>
#include <QStringList>
#include <QtGlobal>
#include <QtGui/qtgui-config.h>

namespace {
void appendIfExists(QStringList &candidates, const QString &path)
{
    if (path.isEmpty())
        return;
    if (QFileInfo::exists(path))
        candidates.append(path);
}

void appendCellarCandidates(QStringList &candidates, const QString &cellarRoot)
{
    QDir cellarDir(cellarRoot);
    if (!cellarDir.exists())
        return;

    const QStringList versions = cellarDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
    for (auto it = versions.crbegin(); it != versions.crend(); ++it)
        appendIfExists(candidates, cellarDir.filePath(*it + "/lib/libMoltenVK.dylib"));
}

QStringList buildVulkanLoaderCandidates()
{
    QStringList candidates;

    const QString envVulkanLib = qEnvironmentVariable("QT_VULKAN_LIB");
    if (!envVulkanLib.isEmpty())
        candidates.append(envVulkanLib);

#if defined(Q_OS_MACOS)
    const QString brewPrefix = qEnvironmentVariable("HOMEBREW_PREFIX");
    if (!brewPrefix.isEmpty()) {
        appendIfExists(candidates, brewPrefix + "/lib/libMoltenVK.dylib");
        appendIfExists(candidates, brewPrefix + "/opt/molten-vk/lib/libMoltenVK.dylib");
        appendCellarCandidates(candidates, brewPrefix + "/Cellar/molten-vk");
    }

    appendIfExists(candidates, "/opt/homebrew/lib/libMoltenVK.dylib");
    appendIfExists(candidates, "/opt/homebrew/opt/molten-vk/lib/libMoltenVK.dylib");
    appendCellarCandidates(candidates, "/opt/homebrew/Cellar/molten-vk");

    appendIfExists(candidates, "/usr/local/lib/libMoltenVK.dylib");
    appendIfExists(candidates, "/usr/local/opt/molten-vk/lib/libMoltenVK.dylib");
    appendCellarCandidates(candidates, "/usr/local/Cellar/molten-vk");

    candidates.append("libMoltenVK.dylib");
    candidates.append("MoltenVK");
    candidates.append("vulkan");
    candidates.append("libvulkan.1");
    candidates.append("libMoltenVK");
#elif defined(Q_OS_WIN)
    candidates.append("vulkan-1");
#else
    candidates.append("vulkan");
    candidates.append("libvulkan.so.1");
#endif

    QStringList unique;
    QSet<QString> seen;
    for (const QString &candidate : candidates) {
        if (candidate.isEmpty())
            continue;
        if (seen.contains(candidate))
            continue;
        seen.insert(candidate);
        unique.append(candidate);
    }
    return unique;
}

bool tryLoadVulkanRuntime(QString *resolvedLoaderName, QString *lastErrorMessage)
{
    const QStringList candidates = buildVulkanLoaderCandidates();
    QString lastError;
    for (const QString &candidate : candidates) {
        QLibrary loader(candidate);
        if (loader.load()) {
            loader.unload();
            qputenv("QT_VULKAN_LIB", candidate.toUtf8());
            if (resolvedLoaderName)
                *resolvedLoaderName = candidate;
            return true;
        }
        if (!loader.errorString().isEmpty())
            lastError = loader.errorString();
    }

    if (lastErrorMessage)
        *lastErrorMessage = lastError;
    return false;
}
}

namespace lvrs {
GraphicsBackendBootstrapResult bootstrapPreferredGraphicsBackend()
{
    GraphicsBackendBootstrapResult result;

    qputenv("QSG_RHI_PREFER_SOFTWARE_RENDERER", QByteArrayLiteral("0"));

#if defined(Q_OS_MACOS)
#if defined(QT_FEATURE_metal) && QT_FEATURE_metal > 0
    qputenv("QSG_RHI_BACKEND", QByteArrayLiteral("metal"));
    QQuickWindow::setGraphicsApi(QSGRendererInterface::Metal);
    result.available = true;
    result.backendName = QStringLiteral("metal");
    return result;
#endif

#if defined(QT_FEATURE_vulkan) && QT_FEATURE_vulkan > 0
    qputenv("QSG_RHI_BACKEND", QByteArrayLiteral("vulkan"));
    QQuickWindow::setGraphicsApi(QSGRendererInterface::Vulkan);

    if (qEnvironmentVariableIsEmpty("VK_ICD_FILENAMES")) {
        if (QFileInfo::exists("/opt/homebrew/etc/vulkan/icd.d/MoltenVK_icd.json"))
            qputenv("VK_ICD_FILENAMES", QByteArrayLiteral("/opt/homebrew/etc/vulkan/icd.d/MoltenVK_icd.json"));
        else if (QFileInfo::exists("/usr/local/etc/vulkan/icd.d/MoltenVK_icd.json"))
            qputenv("VK_ICD_FILENAMES", QByteArrayLiteral("/usr/local/etc/vulkan/icd.d/MoltenVK_icd.json"));
    }

    QString lastError;
    QString loaderName;
    if (tryLoadVulkanRuntime(&loaderName, &lastError)) {
        result.available = true;
        result.backendName = QStringLiteral("vulkan");
        result.loaderName = loaderName;
        return result;
    }

    result.errorMessage =
        QStringLiteral("Metal is unavailable and Vulkan fallback initialization failed. Install MoltenVK and set QT_VULKAN_LIB to libMoltenVK.dylib.");
    if (!lastError.isEmpty())
        result.errorMessage += QStringLiteral(" Last loader error: %1").arg(lastError);
    return result;
#else
    result.errorMessage =
        QStringLiteral("This Qt build does not include Metal or Vulkan support on macOS.");
    return result;
#endif
#else
#if defined(QT_FEATURE_vulkan) && QT_FEATURE_vulkan > 0
    qputenv("QSG_RHI_BACKEND", QByteArrayLiteral("vulkan"));
    QQuickWindow::setGraphicsApi(QSGRendererInterface::Vulkan);

    QString lastError;
    QString loaderName;
    if (tryLoadVulkanRuntime(&loaderName, &lastError)) {
        result.available = true;
        result.backendName = QStringLiteral("vulkan");
        result.loaderName = loaderName;
        return result;
    }

    result.errorMessage =
        QStringLiteral("No Vulkan loader found. Install Vulkan runtime and set QT_VULKAN_LIB appropriately.");
    if (!lastError.isEmpty())
        result.errorMessage += QStringLiteral(" Last loader error: %1").arg(lastError);
    return result;
#else
    result.errorMessage =
        QStringLiteral("This Qt build does not include Vulkan support.");
    return result;
#endif
#endif
}
}
