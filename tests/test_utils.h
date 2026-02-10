#pragma once

#include <QCoreApplication>
#include <QDir>
#include <QDebug>
#include <QQmlComponent>
#include <QQmlEngine>
#include <QUrl>

namespace TestUtils {

inline QString qmlImportBase()
{
    return QDir::cleanPath(QCoreApplication::applicationDirPath() + "/..");
}

inline QObject *createFromQml(QQmlEngine &engine, const QByteArray &qml)
{
    QQmlComponent component(&engine);
    component.setData(qml, QUrl());
    QObject *obj = component.create();
    if (component.isError()) {
        const auto errors = component.errors();
        for (const auto &err : errors)
            qWarning() << err;
    }
    return obj;
}

inline QObject *loadQmlFile(QQmlEngine &engine, const QString &path)
{
    QQmlComponent component(&engine, QUrl::fromLocalFile(path));
    QObject *obj = component.create();
    if (component.isError()) {
        const auto errors = component.errors();
        for (const auto &err : errors)
            qWarning() << err;
    }
    return obj;
}

}  // namespace TestUtils
