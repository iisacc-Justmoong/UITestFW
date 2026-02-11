#include "backend/state/appstate.h"

#include "backend/state/appstate_macros.h"

#include <QRegularExpression>
#include <QUrl>
#include <QtMath>

namespace {
constexpr qreal kEpsilon = 0.000001;
constexpr int kScaffoldNavCount = 4;

bool qrealEquals(qreal left, qreal right)
{
    return qAbs(left - right) <= kEpsilon;
}

#define LVRS_UPDATE_IF_CHANGED(member, nextValue, changedSignal) \
    do { \
        if ((member) != (nextValue)) { \
            (member) = (nextValue); \
            emit changedSignal(); \
        } \
    } while (false)

QVariantMap createNavEntry(const QString &label,
                           const QString &icon,
                           const QString &badge,
                           const QString &path,
                           bool selected)
{
    QVariantMap item;
    item.insert(QStringLiteral("label"), label);
    item.insert(QStringLiteral("icon"), icon);
    item.insert(QStringLiteral("badge"), badge);
    item.insert(QStringLiteral("path"), path);
    item.insert(QStringLiteral("selected"), selected);
    return item;
}

QVariantMap createListEntry(const QString &label,
                            const QString &detail,
                            bool selected,
                            bool showChevron)
{
    QVariantMap item;
    item.insert(QStringLiteral("label"), label);
    item.insert(QStringLiteral("detail"), detail);
    item.insert(QStringLiteral("selected"), selected);
    item.insert(QStringLiteral("showChevron"), showChevron);
    return item;
}
}

AppState::AppState(QObject *parent)
    : QObject(parent)
    , m_currentRoute(QStringLiteral(LVRS_ROUTE_OVERVIEW))
{
    m_demoContextMenuItems = {
        QVariantMap {
            {QStringLiteral("id"), QStringLiteral("new")},
            {QStringLiteral("label"), QStringLiteral("New Run")},
            {QStringLiteral("key"), QStringLiteral("Cmd+N")},
            {QStringLiteral("showChevron"), false}
        },
        QVariantMap {
            {QStringLiteral("id"), QStringLiteral("open")},
            {QStringLiteral("label"), QStringLiteral("Open Recent")},
            {QStringLiteral("key"), QStringLiteral("Cmd+O")},
            {QStringLiteral("showChevron"), true}
        },
        QVariantMap {{QStringLiteral("type"), QStringLiteral("divider")}},
        QVariantMap {
            {QStringLiteral("id"), QStringLiteral("archive")},
            {QStringLiteral("label"), QStringLiteral("Archive")},
            {QStringLiteral("key"), QStringLiteral("Cmd+E")},
            {QStringLiteral("showChevron"), false}
        }
    };

    rebuildAllModels();
}

QVariantList AppState::navItems() const
{
    return m_navItems;
}

QVariantList AppState::scaffoldNavModel() const
{
    return m_scaffoldNavModel;
}

QVariantList AppState::demoListItems() const
{
    return m_demoListItems;
}

QVariantList AppState::demoContextMenuItems() const
{
    return m_demoContextMenuItems;
}

bool AppState::alertOpen() const
{
    return m_alertOpen;
}

void AppState::setAlertOpen(bool value)
{
    LVRS_UPDATE_IF_CHANGED(m_alertOpen, value, alertOpenChanged);
}

qreal AppState::progressStart() const
{
    return m_progressStart;
}

void AppState::setProgressStart(qreal value)
{
    const qreal next = qIsFinite(value) ? value : m_progressStart;
    if (qrealEquals(next, m_progressStart))
        return;
    m_progressStart = next;
    const qreal clamped = clampedProgress(m_progressCurrent);
    if (!qrealEquals(clamped, m_progressCurrent))
        m_progressCurrent = clamped;
    emit progressChanged();
}

qreal AppState::progressEnd() const
{
    return m_progressEnd;
}

void AppState::setProgressEnd(qreal value)
{
    const qreal next = qIsFinite(value) ? value : m_progressEnd;
    if (qrealEquals(next, m_progressEnd))
        return;
    m_progressEnd = next;
    const qreal clamped = clampedProgress(m_progressCurrent);
    if (!qrealEquals(clamped, m_progressCurrent))
        m_progressCurrent = clamped;
    emit progressChanged();
}

qreal AppState::progressCurrent() const
{
    return m_progressCurrent;
}

void AppState::setProgressCurrent(qreal value)
{
    const qreal next = clampedProgress(value);
    if (qrealEquals(next, m_progressCurrent))
        return;
    m_progressCurrent = next;
    emit progressChanged();
}

QString AppState::currentRoute() const
{
    return m_currentRoute;
}

void AppState::setCurrentRoute(const QString &value)
{
    const QString normalized = normalizeRoutePath(value);
    if (normalized.isEmpty() || m_currentRoute == normalized)
        return;
    m_currentRoute = normalized;
    updateScaffoldIndexFromRoute();
    rebuildAllModels();
    emit currentRouteChanged();
}

int AppState::scaffoldNavIndex() const
{
    return m_scaffoldNavIndex;
}

void AppState::setScaffoldNavIndex(int value)
{
    const int next = qBound(0, value, kScaffoldNavCount - 1);
    if (m_scaffoldNavIndex == next)
        return;
    m_scaffoldNavIndex = next;
    rebuildScaffoldNavModel();
    emit scaffoldNavIndexChanged();
}

int AppState::hierarchyActiveButtonId() const
{
    return m_hierarchyActiveButtonId;
}

void AppState::setHierarchyActiveButtonId(int value)
{
    const int next = value > 0 ? value : 1;
    LVRS_UPDATE_IF_CHANGED(m_hierarchyActiveButtonId, next, hierarchyActiveButtonIdChanged);
}

QVariantMap AppState::runtimeSnapshot() const
{
    return m_runtimeSnapshot;
}

QVariantMap AppState::viewStateSnapshot() const
{
    return m_viewStateSnapshot;
}

QStringList AppState::pageHistory() const
{
    return m_pageHistory;
}

void AppState::bootstrap()
{
    if (m_currentRoute.isEmpty())
        m_currentRoute = QStringLiteral(LVRS_ROUTE_OVERVIEW);
    setProgressCurrent(m_progressCurrent);
    rebuildAllModels();
}

void AppState::nudgeProgress(qreal delta)
{
    setProgressCurrent(m_progressCurrent + delta);
}

void AppState::recordNavigation(const QString &path)
{
    const QString normalized = normalizeRoutePath(path);
    if (normalized.isEmpty())
        return;

    m_pageHistory.append(normalized);
    emit pageHistoryChanged();

    const int count = m_routeVisitCounts.value(normalized).toInt() + 1;
    m_routeVisitCounts.insert(normalized, count);
    setCurrentRoute(normalized);
}

void AppState::selectScaffoldNavIndex(int index)
{
    setScaffoldNavIndex(index);
    const QString route = routeForScaffoldIndex(m_scaffoldNavIndex);
    if (!route.isEmpty())
        recordNavigation(route);
}

void AppState::syncRuntimeSnapshot(const QVariantMap &snapshot)
{
    LVRS_UPDATE_IF_CHANGED(m_runtimeSnapshot, snapshot, runtimeSnapshotChanged);
}

void AppState::syncViewStateSnapshot(const QVariantMap &snapshot)
{
    LVRS_UPDATE_IF_CHANGED(m_viewStateSnapshot, snapshot, viewStateSnapshotChanged);
}

void AppState::syncPageHistory(const QStringList &history)
{
    QStringList normalized;
    normalized.reserve(history.size());
    for (const QString &item : history) {
        const QString token = normalizeRoutePath(item);
        if (!token.isEmpty())
            normalized.append(token);
    }

    if (normalized == m_pageHistory)
        return;

    m_pageHistory = normalized;
    emit pageHistoryChanged();

    recalculateRouteCountsFromHistory();
    if (!m_pageHistory.isEmpty()) {
        const QString latest = m_pageHistory.last();
        if (!latest.isEmpty() && latest != m_currentRoute) {
            m_currentRoute = latest;
            updateScaffoldIndexFromRoute();
            emit currentRouteChanged();
        }
    }
    rebuildAllModels();
}

QString AppState::normalizeRoutePath(const QString &rawPath)
{
    QString value = rawPath.trimmed();
    if (value.isEmpty())
        return QString();

    bool notFound = false;
    if (value.startsWith(QStringLiteral("not-found:"), Qt::CaseInsensitive)) {
        notFound = true;
        value = value.mid(QStringLiteral("not-found:").size()).trimmed();
    }

    if (value.isEmpty())
        value = QStringLiteral("/");

    if (value.contains(QStringLiteral("://"))) {
        const QUrl url(value);
        if (url.isValid()) {
            QString urlPath = url.path();
            if (urlPath.isEmpty() && !url.host().isEmpty())
                urlPath = QStringLiteral("/") + url.host();
            if (!urlPath.isEmpty())
                value = urlPath;
        }
    }

    const int hashIndex = value.indexOf(QLatin1Char('#'));
    if (hashIndex >= 0)
        value = value.left(hashIndex);
    const int queryIndex = value.indexOf(QLatin1Char('?'));
    if (queryIndex >= 0)
        value = value.left(queryIndex);

    if (!value.startsWith(QLatin1Char('/')))
        value.prepend(QLatin1Char('/'));
    value.replace(QRegularExpression(QStringLiteral("/+")), QStringLiteral("/"));
    if (value.size() > 1 && value.endsWith(QLatin1Char('/')))
        value.chop(1);

    const QString lower = value.toLower();
    if (lower == QStringLiteral("/") || lower == QStringLiteral("/home"))
        value = QStringLiteral(LVRS_ROUTE_OVERVIEW);
    else if (lower == QStringLiteral("/report"))
        value = QStringLiteral(LVRS_ROUTE_REPORTS);
    else if (lower == QStringLiteral("/run"))
        value = QStringLiteral(LVRS_ROUTE_RUNS);
    else if (lower == QStringLiteral("/device"))
        value = QStringLiteral(LVRS_ROUTE_DEVICES);
    else if (lower == QStringLiteral("/setting"))
        value = QStringLiteral(LVRS_ROUTE_SETTINGS);

    if (notFound)
        return QStringLiteral("not-found: ") + value;
    return value;
}

bool AppState::routeMatches(const QString &candidatePath, const QString &currentPath)
{
    const QString candidate = stripNotFoundPrefix(normalizeRoutePath(candidatePath));
    const QString current = stripNotFoundPrefix(normalizeRoutePath(currentPath));

    if (candidate.isEmpty() || current.isEmpty())
        return false;
    if (candidate == current)
        return true;
    if (candidate == QStringLiteral("/"))
        return current == QStringLiteral("/");
    return current.startsWith(candidate + QLatin1Char('/'));
}

bool AppState::isNotFoundRoute(const QString &path)
{
    return path.startsWith(QStringLiteral("not-found:"), Qt::CaseInsensitive);
}

QString AppState::stripNotFoundPrefix(const QString &path)
{
    if (!isNotFoundRoute(path))
        return path;
    QString payload = path.mid(QStringLiteral("not-found:").size()).trimmed();
    if (payload.isEmpty())
        payload = QStringLiteral("/");
    return payload;
}

qreal AppState::clampedProgress(qreal value) const
{
    if (!qIsFinite(value))
        return m_progressCurrent;
    const qreal minValue = qMin(m_progressStart, m_progressEnd);
    const qreal maxValue = qMax(m_progressStart, m_progressEnd);
    return qBound(minValue, value, maxValue);
}

QString AppState::routeForScaffoldIndex(int index) const
{
    switch (qBound(0, index, kScaffoldNavCount - 1)) {
    case 0:
        return QStringLiteral(LVRS_ROUTE_OVERVIEW);
    case 1:
        return QStringLiteral(LVRS_ROUTE_RUNS);
    case 2:
        return QStringLiteral(LVRS_ROUTE_DEVICES);
    case 3:
        return QStringLiteral(LVRS_ROUTE_SETTINGS);
    default:
        return QString();
    }
}

int AppState::routeVisitCount(const QString &path) const
{
    int total = 0;
    const QString normalizedTarget = stripNotFoundPrefix(normalizeRoutePath(path));
    if (normalizedTarget.isEmpty())
        return 0;

    for (auto it = m_routeVisitCounts.constBegin(); it != m_routeVisitCounts.constEnd(); ++it) {
        const QString candidate = stripNotFoundPrefix(normalizeRoutePath(it.key()));
        if (routeMatches(normalizedTarget, candidate))
            total += it.value().toInt();
    }
    return total;
}

QString AppState::badgeForRoute(const QString &path, const QString &fallbackBadge) const
{
    const int count = routeVisitCount(path);
    if (count > 0)
        return QString::number(count);
    return fallbackBadge;
}

void AppState::rebuildNavItems()
{
    const QVariantList next = {
        createNavEntry(QStringLiteral("Overview"),
                       QStringLiteral("◉"),
                       badgeForRoute(QStringLiteral(LVRS_ROUTE_OVERVIEW), QStringLiteral(LVRS_BADGE_OVERVIEW)),
                       QStringLiteral(LVRS_ROUTE_OVERVIEW),
                       routeMatches(QStringLiteral(LVRS_ROUTE_OVERVIEW), m_currentRoute)),
        createNavEntry(QStringLiteral("Controls"),
                       QStringLiteral("▣"),
                       QStringLiteral(LVRS_BADGE_CONTROLS),
                       QStringLiteral(LVRS_ROUTE_RUNS),
                       routeMatches(QStringLiteral(LVRS_ROUTE_RUNS), m_currentRoute)),
        createNavEntry(QStringLiteral("Navigation"),
                       QStringLiteral("⇄"),
                       QStringLiteral(LVRS_BADGE_NAVIGATION),
                       QStringLiteral(LVRS_ROUTE_REPORTS),
                       routeMatches(QStringLiteral(LVRS_ROUTE_REPORTS), m_currentRoute)),
        createNavEntry(QStringLiteral("Layout"),
                       QStringLiteral("◫"),
                       QStringLiteral(LVRS_BADGE_LAYOUT),
                       QStringLiteral(LVRS_ROUTE_SETTINGS),
                       routeMatches(QStringLiteral(LVRS_ROUTE_SETTINGS), m_currentRoute))
    };
    LVRS_UPDATE_IF_CHANGED(m_navItems, next, navItemsChanged);
}

void AppState::rebuildScaffoldNavModel()
{
    const QVariantList next = {
        createNavEntry(QStringLiteral("Overview"),
                       QStringLiteral("◉"),
                       badgeForRoute(QStringLiteral(LVRS_ROUTE_OVERVIEW), QStringLiteral("4")),
                       QStringLiteral(LVRS_ROUTE_OVERVIEW),
                       m_scaffoldNavIndex == 0),
        createNavEntry(QStringLiteral("Runs"),
                       QStringLiteral("▣"),
                       badgeForRoute(QStringLiteral(LVRS_ROUTE_RUNS), QStringLiteral(LVRS_BADGE_RUNS)),
                       QStringLiteral(LVRS_ROUTE_RUNS),
                       m_scaffoldNavIndex == 1),
        createNavEntry(QStringLiteral("Devices"),
                       QStringLiteral("⌘"),
                       badgeForRoute(QStringLiteral(LVRS_ROUTE_DEVICES), QStringLiteral(LVRS_BADGE_DEVICES)),
                       QStringLiteral(LVRS_ROUTE_DEVICES),
                       m_scaffoldNavIndex == 2),
        createNavEntry(QStringLiteral("Settings"),
                       QStringLiteral("⚙"),
                       badgeForRoute(QStringLiteral(LVRS_ROUTE_SETTINGS), QStringLiteral(LVRS_BADGE_SETTINGS)),
                       QStringLiteral(LVRS_ROUTE_SETTINGS),
                       m_scaffoldNavIndex == 3)
    };
    LVRS_UPDATE_IF_CHANGED(m_scaffoldNavModel, next, scaffoldNavModelChanged);
}

void AppState::rebuildDemoListItems()
{
    const QVariantList next = {
        createListEntry(QStringLiteral("Overview"),
                        QStringLiteral("Cmd+1"),
                        routeMatches(QStringLiteral(LVRS_ROUTE_OVERVIEW), m_currentRoute),
                        true),
        createListEntry(QStringLiteral("Reports"),
                        QStringLiteral("Cmd+2"),
                        routeMatches(QStringLiteral(LVRS_ROUTE_REPORTS), m_currentRoute),
                        true),
        createListEntry(QStringLiteral("Settings"),
                        QStringLiteral("Cmd+,"),
                        routeMatches(QStringLiteral(LVRS_ROUTE_SETTINGS), m_currentRoute),
                        false)
    };
    LVRS_UPDATE_IF_CHANGED(m_demoListItems, next, demoListItemsChanged);
}

void AppState::rebuildAllModels()
{
    rebuildNavItems();
    rebuildScaffoldNavModel();
    rebuildDemoListItems();
}

void AppState::recalculateRouteCountsFromHistory()
{
    QVariantMap counts;
    for (const QString &path : m_pageHistory) {
        const QString normalized = stripNotFoundPrefix(normalizeRoutePath(path));
        if (normalized.isEmpty())
            continue;
        counts.insert(normalized, counts.value(normalized).toInt() + 1);
    }
    m_routeVisitCounts = counts;
}

void AppState::updateScaffoldIndexFromRoute()
{
    if (isNotFoundRoute(m_currentRoute))
        return;

    const QString route = stripNotFoundPrefix(m_currentRoute);
    int next = 0;
    if (routeMatches(QStringLiteral(LVRS_ROUTE_SETTINGS), route))
        next = 3;
    else if (routeMatches(QStringLiteral(LVRS_ROUTE_DEVICES), route))
        next = 2;
    else if (routeMatches(QStringLiteral(LVRS_ROUTE_RUNS), route)
             || routeMatches(QStringLiteral(LVRS_ROUTE_REPORTS), route))
        next = 1;
    if (m_scaffoldNavIndex != next) {
        m_scaffoldNavIndex = next;
        emit scaffoldNavIndexChanged();
    }
}
