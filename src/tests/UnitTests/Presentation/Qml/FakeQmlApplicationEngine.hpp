#pragma once

#include <MellowPlayer/Presentation/Qml/IQmlApplicationEngine.hpp>
#include <QObject>
#include <QString>
#include <QUrl>
#include <QtCore/QMap>

namespace MellowPlayer::Presentation::Tests
{
    class FakeQmlApplicationEngine : public IQmlApplicationEngine
    {
    public:
        void setContextProperty(const QString& name, QObject* object) override
        {
            _contextProperties[name] = object;
        }

        bool hasContextProperty(const QString& name)
        {
            return _contextProperties.contains(name);
        }

        QObject* contextProperty(const QString& name) const
        {
            return _contextProperties[name];
        }

        void addImportPath(const QString& path) override
        {
            _importPaths.append(path);
        }

        int importPathsCount()
        {
            return _importPaths.count();
        }

        void load(const QUrl& url) override
        {
            _loadedUrl = url;
        }

        bool isLoaded() const
        {
            return !_loadedUrl.isEmpty();
        }

    private:
        QMap<QString, QObject*> _contextProperties;
        QStringList _importPaths;
        QUrl _loadedUrl;
    };
}
