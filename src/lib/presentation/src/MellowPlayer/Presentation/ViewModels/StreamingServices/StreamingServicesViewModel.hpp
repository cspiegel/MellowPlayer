#pragma once

#include <MellowPlayer/Presentation/Models/StreamingServiceListModel.hpp>
#include <MellowPlayer/Presentation/Models/StreamingServiceProxyListModel.hpp>
#include <MellowPlayer/Presentation/Qml/ContextProperty.hpp>
#include <QObject>

class QQmlApplicationEngine;

namespace MellowPlayer::Domain
{
    class Settings;
    class Setting;
    class Players;
    class StreamingServices;
    class StreamingService;
    class IWorkDispatcher;
    class IStreamingServiceCreator;
    class IUserScriptFactory;
}

namespace MellowPlayer::Infrastructure
{
    class ICommandLineArguments;
    class INetworkProxies;
    class IHttpClientFactory;
}

namespace MellowPlayer::Presentation
{
    class StreamingServicesViewModel : public QObject, public ContextProperty
    {
        Q_OBJECT
        Q_PROPERTY(QAbstractItemModel* filteredServices READ filteredServices CONSTANT)
        Q_PROPERTY(QObject* currentService READ currentService WRITE setCurrentService NOTIFY currentServiceChanged)
    public:
        StreamingServicesViewModel(Domain::StreamingServices& streamingServices,
                                   Domain::Players& players,
                                   Domain::Settings& settings,
                                   Domain::IWorkDispatcher& workDispatcher,
                                   Domain::IStreamingServiceCreator& streamingServiceCreator,
                                   Infrastructure::ICommandLineArguments& commandLineArguments,
                                   Domain::IUserScriptFactory& userScriptFactory,
                                   IContextProperties& contextProperties,
                                   Infrastructure::INetworkProxies& networkProxies,
                                   ThemeViewModel& themeViewModel,
                                   Infrastructure::IHttpClientFactory& httpClientFactory);

        using ContextProperty::registerTo;
        void initialize();

        void activate(QObject* service);

        Q_INVOKABLE void reload();

        QList<StreamingServiceViewModel*> services() const;
        StreamingServiceProxyListModel* filteredServices();
        StreamingServiceViewModel* currentService() const;

        Q_INVOKABLE void next();
        Q_INVOKABLE void previous();
        Q_INVOKABLE void createService(const QString& serviceName,
                                       const QString& serviceUrl,
                                       const QString& authorName,
                                       const QString& authorWebsite,
                                       bool allPlatforms,
                                       bool linuxPlatform,
                                       bool appImagePlatform,
                                       bool osxPlatform,
                                       bool windowsPlatform);

        void registerTo(IQmlApplicationEngine& qmlApplicationEngine) override;

    public slots:
        void setCurrentService(QObject* value);

    signals:
        void currentServiceChanged(QObject* currentService);
        void currentIndexChanged(int currentIndex);
        void serviceCreated(const QString& directory);
        void activationRequested(QObject* service);

    private slots:
        void onServiceAdded(Domain::StreamingService* streamingService);

    private:
        int nextIndex(int index) const;
        int previousIndex(int index) const;

        Domain::StreamingServices& _streamingServices;
        Domain::Players& _players;
        Domain::Settings& _settings;
        Domain::Setting& _currentServiceSetting;
        Domain::IWorkDispatcher& _workDispatcher;
        Domain::IStreamingServiceCreator& _streamingServiceCreator;
        Infrastructure::ICommandLineArguments& _commandLineArguments;
        Domain::IUserScriptFactory& _userScriptFactory;
        Infrastructure::INetworkProxies& _networkProxies;
        StreamingServiceListModel* _services;
        StreamingServiceProxyListModel _filteredServices;
        StreamingServiceViewModel* _currentService = nullptr;
        ThemeViewModel& _themeViewModel;
        Infrastructure::IHttpClientFactory& _httpClientFactory;
        void initializeCurrent();
        void load();
    };
}
