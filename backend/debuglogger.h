#pragma once

#include <QObject>
#include <QtQml/qqml.h>

class DebugLogger : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(Debug)
    QML_SINGLETON

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

public:
    explicit DebugLogger(QObject *parent = nullptr);

    bool enabled() const;
    void setEnabled(bool value);

    Q_INVOKABLE void log(const QString &component, const QString &event, const QVariant &data = QVariant());
    Q_INVOKABLE void warn(const QString &component, const QString &event, const QVariant &data = QVariant());
    Q_INVOKABLE void error(const QString &component, const QString &event, const QVariant &data = QVariant());

signals:
    void enabledChanged();

private:
    void output(const QString &level, const QString &component, const QString &event, const QVariant &data);

    bool m_enabled = false;
};
