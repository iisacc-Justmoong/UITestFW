#pragma once

#include <QObject>
#include <QPointer>
#include <QStringList>
#include <QHash>
#include <QtQml/qqml.h>

class ViewModelRegistry : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(ViewModels)
    QML_SINGLETON

    Q_PROPERTY(QStringList keys READ keys NOTIFY keysChanged)

public:
    explicit ViewModelRegistry(QObject *parent = nullptr);

    Q_INVOKABLE QObject *get(const QString &key) const;
    Q_INVOKABLE void set(const QString &key, QObject *object);
    Q_INVOKABLE void remove(const QString &key);
    Q_INVOKABLE void clear();

    QStringList keys() const;

signals:
    void keysChanged();

private:
    void prune();
    bool hasReference(QObject *object, const QString &exceptKey = QString()) const;
    void maybeDisposeOwned(QObject *object, const QString &exceptKey = QString());

    QHash<QString, QPointer<QObject>> m_entries;
};
