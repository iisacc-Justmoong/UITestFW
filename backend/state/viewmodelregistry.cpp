#include "backend/state/viewmodelregistry.h"

#include <QSet>

ViewModelRegistry::ViewModelRegistry(QObject *parent)
    : QObject(parent)
{
}

QObject *ViewModelRegistry::get(const QString &key) const
{
    auto it = m_entries.constFind(key);
    if (it == m_entries.constEnd())
        return nullptr;
    return it.value();
}

void ViewModelRegistry::set(const QString &key, QObject *object)
{
    if (key.trimmed().isEmpty())
        return;

    QObject *previous = nullptr;
    auto existing = m_entries.constFind(key);
    if (existing != m_entries.constEnd())
        previous = existing.value();

    if (object && !object->parent())
        object->setParent(const_cast<ViewModelRegistry *>(this));

    bool changed = false;
    auto it = m_entries.find(key);
    if (it == m_entries.end()) {
        m_entries.insert(key, object);
        changed = true;
    } else if (it.value() != object) {
        it.value() = object;
        changed = true;
    }

    if (changed)
        emit keysChanged();

    maybeDisposeOwned(previous, key);
    prune();
}

void ViewModelRegistry::remove(const QString &key)
{
    auto it = m_entries.find(key);
    if (it == m_entries.end())
        return;

    QObject *object = it.value();
    m_entries.erase(it);
    emit keysChanged();
    maybeDisposeOwned(object);
}

void ViewModelRegistry::clear()
{
    if (m_entries.isEmpty())
        return;

    const auto entries = m_entries;
    m_entries.clear();
    emit keysChanged();

    QSet<QObject *> processed;
    for (auto it = entries.begin(); it != entries.end(); ++it) {
        QObject *object = it.value();
        if (!object || processed.contains(object))
            continue;
        processed.insert(object);
        maybeDisposeOwned(object);
    }
}

QStringList ViewModelRegistry::keys() const
{
    return m_entries.keys();
}

void ViewModelRegistry::prune()
{
    bool changed = false;
    for (auto it = m_entries.begin(); it != m_entries.end(); ) {
        if (!it.value()) {
            it = m_entries.erase(it);
            changed = true;
        } else {
            ++it;
        }
    }
    if (changed)
        emit keysChanged();
}

bool ViewModelRegistry::hasReference(QObject *object, const QString &exceptKey) const
{
    if (!object)
        return false;
    for (auto it = m_entries.constBegin(); it != m_entries.constEnd(); ++it) {
        if (!exceptKey.isEmpty() && it.key() == exceptKey)
            continue;
        if (it.value() == object)
            return true;
    }
    return false;
}

void ViewModelRegistry::maybeDisposeOwned(QObject *object, const QString &exceptKey)
{
    if (!object)
        return;
    if (hasReference(object, exceptKey))
        return;
    if (object->parent() == this)
        object->deleteLater();
}
