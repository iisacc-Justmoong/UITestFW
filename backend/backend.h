#pragma once

#include <QObject>
#include <QtQml/qqml.h>

class Backend : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(Backend)
    QML_SINGLETON

    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)

public:
    explicit Backend(QObject *parent = nullptr);

    Q_INVOKABLE bool saveTextFile(const QString &path, const QString &text);
    Q_INVOKABLE QString readTextFile(const QString &path);
    Q_INVOKABLE bool ensureDir(const QString &path);
    Q_INVOKABLE QString writableLocation(int location) const;

    QString lastError() const;

signals:
    void lastErrorChanged();

private:
    void setLastError(const QString &message);

    QString m_lastError;
};
