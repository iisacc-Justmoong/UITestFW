#pragma once

#include <QObject>
#include <QtQml/qqml.h>

class PlatformInfo : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(Platform)
    QML_SINGLETON

    Q_PROPERTY(QString os READ os CONSTANT)
    Q_PROPERTY(QString arch READ arch CONSTANT)

    Q_PROPERTY(bool mobile READ mobile CONSTANT)
    Q_PROPERTY(bool desktop READ desktop CONSTANT)

    Q_PROPERTY(bool android READ android CONSTANT)
    Q_PROPERTY(bool ios READ ios CONSTANT)
    Q_PROPERTY(bool macos READ macos CONSTANT)
    Q_PROPERTY(bool windows READ windows CONSTANT)
    Q_PROPERTY(bool linux READ linux CONSTANT)

public:
    explicit PlatformInfo(QObject *parent = nullptr);

    QString os() const;
    QString arch() const;

    bool mobile() const;
    bool desktop() const;

    bool android() const;
    bool ios() const;
    bool macos() const;
    bool windows() const;
    bool linux() const;
};
