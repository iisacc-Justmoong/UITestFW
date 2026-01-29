#pragma once

#include <QObject>

class ExampleModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString status READ status WRITE setStatus NOTIFY statusChanged)

public:
    explicit ExampleModel(QObject *parent = nullptr);

    QString status() const;
    void setStatus(const QString &value);

signals:
    void statusChanged();

private:
    QString m_status;
};
