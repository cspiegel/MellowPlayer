#pragma once

#include <MellowPlayer/Macros.hpp>
#include <MellowPlayer/UseCases.hpp>

BEGIN_MELLOWPLAYER_NAMESPACE(Infrastructure)

class PluginLoader: public UseCases::IPluginLoader {
public:
    PluginLoader();
    UseCases::PluginList load() const override;

private:
    std::unique_ptr<UseCases::Plugin> loadPlugin(const QString &directory) const;
    QString findFileByExtension(const QString &directory, const QString &suffix) const;
    QString readFileContent(const QString &filePath) const;
    UseCases::PluginMetadata readMetadata(const QString &filePath) const;
    UseCases::PluginStyle readStyle(const QString &filePath) const;
    bool checkPluginDirectory(const QString &directory) const;
    QString getUserPluginsDirectory() const;
    QStringList getSearchPaths() const;
    bool containsPlugin(const UseCases::PluginList &plugins, std::shared_ptr<UseCases::Plugin>& toCheck) const;

    UseCases::ILogger& logger;
};

END_MELLOWPLAYER_NAMESPACE
