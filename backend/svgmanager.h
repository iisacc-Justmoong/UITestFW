#pragma once

#include <QObject>
#include <QtQml/qqml.h>

#include <QHash>
#include <QStringList>

class QNetworkAccessManager;
class QUrl;

class SvgManager : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(SvgManager)
    QML_SINGLETON

    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)
    Q_PROPERTY(qreal minimumScale READ minimumScale WRITE setMinimumScale NOTIFY minimumScaleChanged)
    Q_PROPERTY(qreal maximumScale READ maximumScale WRITE setMaximumScale NOTIFY maximumScaleChanged)
    Q_PROPERTY(int cacheSize READ cacheSize WRITE setCacheSize NOTIFY cacheSizeChanged)

public:
    explicit SvgManager(QObject *parent = nullptr);

    Q_INVOKABLE QString icon(const QString &svgUrl, int logicalSize = 16, qreal scale = 0.0);
    Q_INVOKABLE qreal deviceScale() const;
    Q_INVOKABLE void clearCache();

    QString lastError() const;

    qreal minimumScale() const;
    void setMinimumScale(qreal value);

    qreal maximumScale() const;
    void setMaximumScale(qreal value);

    int cacheSize() const;
    void setCacheSize(int value);

signals:
    void lastErrorChanged();
    void minimumScaleChanged();
    void maximumScaleChanged();
    void cacheSizeChanged();

private:
    qreal resolveScale(qreal requestedScale) const;
    QByteArray loadSvgPayload(const QString &sourceUrl);
    QByteArray loadSvgFromUrl(const QUrl &url);
    void insertCache(const QString &key, const QString &value);
    void touchCacheKey(const QString &key);
    QString makeCacheKey(const QString &sourceUrl, int logicalSize, qreal scale) const;
    void setLastError(const QString &message);

    QNetworkAccessManager *m_network = nullptr;
    QHash<QString, QString> m_cache;
    QStringList m_cacheOrder;
    QString m_lastError;
    qreal m_minimumScale = 3.0;
    qreal m_maximumScale = 4.0;
    int m_cacheSize = 256;
};
