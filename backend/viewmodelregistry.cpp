#include "backend/viewmodelregistry.h"

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

    prune();
}

void ViewModelRegistry::remove(const QString &key)
{
    if (m_entries.remove(key) > 0)
        emit keysChanged();
}

void ViewModelRegistry::clear()
{
    if (m_entries.isEmpty())
        return;
    m_entries.clear();
    emit keysChanged();
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
