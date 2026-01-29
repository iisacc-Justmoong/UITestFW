#include "ExampleModel.h"

ExampleModel::ExampleModel(QObject *parent)
    : QObject(parent)
    , m_status(QStringLiteral("Idle"))
{
}

QString ExampleModel::status() const
{
    return m_status;
}

void ExampleModel::setStatus(const QString &value)
{
    if (m_status == value)
        return;
    m_status = value;
    emit statusChanged();
}
