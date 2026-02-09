#include "backend/fonts/fontpolicy.h"

#include <QFont>
#include <QFontDatabase>
#include <QFontInfo>
#include <QGuiApplication>
#include <QStringList>

#include <array>

namespace {
struct TextStyleToken {
    int pixelSize;
    int weight;
    const char *styleName;
};

constexpr std::array<TextStyleToken, 7> kThemeTextTokens = {{
    {26, QFont::Bold, "Bold"},
    {22, QFont::Bold, "Bold"},
    {17, QFont::DemiBold, "SemiBold"},
    {15, QFont::DemiBold, "SemiBold"},
    {13, QFont::Medium, "Medium"},
    {12, QFont::DemiBold, "SemiBold"},
    {11, QFont::Normal, "Regular"}
}};

const QStringList kSubstitutionTargets = {
    QStringLiteral("Arial"),
    QStringLiteral("Helvetica"),
    QStringLiteral("Sans Serif"),
    QStringLiteral("Noto Sans"),
    QStringLiteral("SF Pro Text"),
    QStringLiteral("SF Pro Display"),
    QStringLiteral("system-ui"),
    QStringLiteral("sans-serif")
};
}

FontPolicy::FontPolicy(QObject *parent)
    : QObject(parent)
{
    installPretendardFallbacks();
    enforcePretendardFallback();
    refresh();
}

QString FontPolicy::preferredFamily() const
{
    return m_preferredFamily;
}

QString FontPolicy::effectiveFamily() const
{
    return m_effectiveFamily;
}

bool FontPolicy::pretendardAvailable() const
{
    return m_pretendardAvailable;
}

QString FontPolicy::lastWarning() const
{
    return m_lastWarning;
}

bool FontPolicy::enforceApplicationFallback()
{
    const bool applied = enforcePretendardFallback();
    refresh();
    if (!applied && !m_pretendardAvailable) {
        setLastWarning(QStringLiteral("Pretendard is unavailable. Falling back to application font."));
    }
    return applied;
}

void FontPolicy::refresh()
{
    const QString nextPretendard = detectPretendardFamily();
    const bool nextPretendardAvailable = !nextPretendard.isEmpty();
    const QString nextEffective = detectEffectiveFamily();

    bool changed = false;
    if (m_pretendardAvailable != nextPretendardAvailable) {
        m_pretendardAvailable = nextPretendardAvailable;
        changed = true;
    }
    if (m_effectiveFamily != nextEffective) {
        m_effectiveFamily = nextEffective;
        changed = true;
    }
    if (changed)
        emit effectiveFamilyChanged();
}

QString FontPolicy::resolveFamily(const QString &requestedFamily) const
{
    const QString requested = requestedFamily.trimmed();
    if (requested.isEmpty())
        return m_effectiveFamily;
    if (familyAvailable(requested))
        return requested;
    return m_effectiveFamily;
}

int FontPolicy::weightForTextSize(int pixelSize, int fallbackWeight) const
{
    int mappedWeight = fallbackWeight;
    if (!tokenForPixelSize(pixelSize, &mappedWeight, nullptr))
        return fallbackWeight;
    return mappedWeight;
}

QString FontPolicy::styleNameForTextSize(int pixelSize, const QString &fallbackStyleName) const
{
    QString mappedStyleName = fallbackStyleName;
    if (!tokenForPixelSize(pixelSize, nullptr, &mappedStyleName))
        return fallbackStyleName;
    return mappedStyleName;
}

bool FontPolicy::isThemeTextStyleCompliant(int pixelSize, int weight, const QString &styleName) const
{
    int expectedWeight = QFont::Normal;
    QString expectedStyleName;
    if (!tokenForPixelSize(pixelSize, &expectedWeight, &expectedStyleName))
        return false;
    return weight == expectedWeight
           && QString::compare(styleName.trimmed(), expectedStyleName, Qt::CaseInsensitive) == 0;
}

void FontPolicy::installPretendardFallbacks()
{
    for (const QString &target : kSubstitutionTargets)
        QFont::insertSubstitution(target, QStringLiteral("Pretendard"));
}

bool FontPolicy::enforcePretendardFallback()
{
    if (!qGuiApp)
        return false;

    QString pretendardFamily;
    const QStringList families = QFontDatabase::families();
    for (const QString &family : families) {
        if (QString::compare(family, QStringLiteral("Pretendard"), Qt::CaseInsensitive) == 0) {
            pretendardFamily = family;
            break;
        }
        if (family.contains(QStringLiteral("Pretendard"), Qt::CaseInsensitive) && pretendardFamily.isEmpty())
            pretendardFamily = family;
    }

    if (pretendardFamily.isEmpty())
        return false;

    QFont current = qGuiApp->font();
    if (QString::compare(current.family(), pretendardFamily, Qt::CaseInsensitive) == 0)
        return true;

    current.setFamily(pretendardFamily);
    current.setStyleName(styleNameForWeight(current.weight()));
    qGuiApp->setFont(current);
    const QFontInfo info(qGuiApp->font());
    return QString::compare(info.family(), pretendardFamily, Qt::CaseInsensitive) == 0;
}

bool FontPolicy::tokenForPixelSize(int pixelSize, int *weight, QString *styleName)
{
    for (const TextStyleToken &token : kThemeTextTokens) {
        if (token.pixelSize != pixelSize)
            continue;
        if (weight)
            *weight = token.weight;
        if (styleName)
            *styleName = QString::fromLatin1(token.styleName);
        return true;
    }
    return false;
}

QString FontPolicy::styleNameForWeight(int weight)
{
    if (weight >= QFont::Bold)
        return QStringLiteral("Bold");
    if (weight >= QFont::DemiBold)
        return QStringLiteral("SemiBold");
    if (weight >= QFont::Medium)
        return QStringLiteral("Medium");
    return QStringLiteral("Regular");
}

bool FontPolicy::familyAvailable(const QString &family) const
{
    const QStringList families = QFontDatabase::families();
    for (const QString &candidate : families) {
        if (QString::compare(candidate, family, Qt::CaseInsensitive) == 0)
            return true;
    }
    return false;
}

QString FontPolicy::detectPretendardFamily() const
{
    const QStringList families = QFontDatabase::families();
    for (const QString &family : families) {
        if (QString::compare(family, m_preferredFamily, Qt::CaseInsensitive) == 0)
            return family;
    }
    for (const QString &family : families) {
        if (family.contains(m_preferredFamily, Qt::CaseInsensitive))
            return family;
    }
    return QString();
}

QString FontPolicy::detectEffectiveFamily() const
{
    const QString pretendard = detectPretendardFamily();
    if (!pretendard.isEmpty())
        return pretendard;
    if (qGuiApp)
        return qGuiApp->font().family();
    return QFont().family();
}

void FontPolicy::setLastWarning(const QString &message)
{
    if (m_lastWarning == message)
        return;
    m_lastWarning = message;
    emit lastWarningChanged();
}
