#pragma once

#include <QColor>
#include <QObject>
#include <QtQml/qqml.h>

class NativeWindowStyle : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(NativeWindowStyle)
    QML_SINGLETON

    Q_PROPERTY(bool titleBarColorSupported READ titleBarColorSupported CONSTANT)

public:
    explicit NativeWindowStyle(QObject *parent = nullptr);

    bool titleBarColorSupported() const;

    Q_INVOKABLE bool applyTitleBarColor(QObject *window, const QColor &color, bool darkAppearance = true);
};
