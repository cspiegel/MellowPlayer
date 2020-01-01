#include "SingleInstanceCheck.hpp"
#include <MellowPlayer/Domain/Logging/ILogger.hpp>
#include <MellowPlayer/Domain/Logging/Loggers.hpp>
#include <MellowPlayer/Domain/Logging/LoggingMacros.hpp>
#include <MellowPlayer/Domain/Player/IPlayer.hpp>
#include <MellowPlayer/Infrastructure/Application/IApplication.hpp>
#include <MellowPlayer/Infrastructure/Application/QtApplication.hpp>
#include <MellowPlayer/Infrastructure/CommandLineArguments/ICommandLineArguments.hpp>
#include <MellowPlayer/Infrastructure/Network/LocalServer.hpp>
#include <MellowPlayer/Infrastructure/Network/LocalSocket.hpp>
#include <QtCore/QDir>
#include <QtCore/QStandardPaths>
#include <QtCore/QTimer>

using namespace std;
using namespace MellowPlayer::Application;
using namespace MellowPlayer::Infrastructure;
using namespace MellowPlayer::Domain;

const QString SingleInstanceCheck::_playPauseAction = "play-pause";
const QString SingleInstanceCheck::_nextAction = "next";
const QString SingleInstanceCheck::_previousAction = "previous";
const QString SingleInstanceCheck::_restoreWindowAction = "restore-window";
const QString SingleInstanceCheck::_toggleFavoriteAction = "toggle-favorite";

SingleInstanceCheck::SingleInstanceCheck(IApplication& application,
                                         IPlayer& currentPlayer,
                                         ICommandLineArguments& commandLineArguments,
                                         IFactory<ILocalServer, QString>& localServerFactory,
                                         IFactory<ILocalSocket>& localSocketFactory)
        : _logger(Loggers::logger("SingleInstanceCheck")),
          _application(application),
          _currentPlayer(currentPlayer),
          _commandLineArguments(commandLineArguments),
          _localServerFactory(localServerFactory),
          _localSocketFactory(localSocketFactory),
          _lockFilePath(GetLockFilePath()),
          _lockFile(_lockFilePath),
          _isPrimary(false)
{
    auto lockFileDirectory = QFileInfo(_lockFilePath).dir().path();
    QDir().mkpath(lockFileDirectory);
    _lockFile.setStaleLockTime(0);
}

void SingleInstanceCheck::initialize(const ResultCallback& resultCallback)
{
    _resultCallback = resultCallback;

    LOG_INFO(_logger, "Lock file: " << _lockFilePath)
    if (_lockFile.tryLock(100))
        initializePrimaryApplication();
    else
        initializeSecondaryApplication();
}

QString SingleInstanceCheck::toString() const
{
    return "SingleInstanceCheck";
}

QString SingleInstanceCheck::errorMessage() const
{
    return "Another instance is already running";
}

void SingleInstanceCheck::initializePrimaryApplication()
{
    _isPrimary = true;
    LOG_DEBUG(_logger, "Initializing primary application");

    _localServer = _localServerFactory.create(qApp->applicationName());
    connect(_localServer.get(), &ILocalServer::newConnection, this, &SingleInstanceCheck::onSecondaryApplicationConnected);
    _localServer->listen();

    connect(&_pollStateTimer, &QTimer::timeout, this, &SingleInstanceCheck::pollState);
    _pollStateTimer.setInterval(1000);
    _pollStateTimer.start();

    _resultCallback(true);
}

void SingleInstanceCheck::onSecondaryApplicationConnected()
{
    auto nextConnection = _localServer->nextPendingConnection();
    if (nextConnection)
    {
        if (_localSocket)
            _localSocket->disconnectFromServer();

        LOG_INFO(_logger, "Another application was started, showing this one instead");
        _localSocket = move(nextConnection);
        connect(_localSocket.get(), &ILocalSocket::readyRead, this, &SingleInstanceCheck::onSecondaryApplicationActionRequest);
    }
}

void SingleInstanceCheck::onSecondaryApplicationActionRequest()
{
    QString action = QString(_localSocket->readAll()).split("\n")[0];
    LOG_INFO(_logger, "Secondary application request: " << action);

    if (action == _playPauseAction)
        _currentPlayer.togglePlayPause();
    else if (action == _nextAction)
        _currentPlayer.next();
    else if (action == _previousAction)
        _currentPlayer.previous();
    else if (action == _toggleFavoriteAction)
        _currentPlayer.toggleFavoriteSong();
    else
        _application.restoreWindow();
}

void SingleInstanceCheck::initializeSecondaryApplication()
{
    _isPrimary = false;
    LOG_DEBUG(_logger, "Another instance is already running, transmitting command line arguments...");

    _localSocket = _localSocketFactory.create();
    connect(_localSocket.get(), &ILocalSocket::connected, this, &SingleInstanceCheck::onConnectedToPrimaryApplication);
    connect(_localSocket.get(), &ILocalSocket::error, this, &SingleInstanceCheck::onConnectionErrorWithPrimaryApplication);
    _localSocket->connectToServer(qApp->applicationName(), QIODevice::WriteOnly);
}

void SingleInstanceCheck::onConnectedToPrimaryApplication()
{
    LOG_INFO(_logger, "connection with the primary application succeeded");
    QString action = requestedAcion();
    LOG_DEBUG(_logger, "sending action: " << action);
    _localSocket->write(action + "\n");
    _resultCallback(false);
}

void SingleInstanceCheck::onConnectionErrorWithPrimaryApplication()
{
    LOG_WARN(_logger, "could not connect to the primary application, quitting...");
    _resultCallback(false);
}

QString SingleInstanceCheck::requestedAcion() const
{
    if (_commandLineArguments.playPauseRequested())
        return _playPauseAction;
    else if (_commandLineArguments.nextRequested())
        return _nextAction;
    else if (_commandLineArguments.previousRequested())
        return _previousAction;
    else if (_commandLineArguments.toggleFavoriteRequested())
        return _toggleFavoriteAction;
    return _restoreWindowAction;
}

void SingleInstanceCheck::cleanUp()
{
    if (_isPrimary)
    {
        _localServer->close();
        _lockFile.unlock();
    }
    else
    {
        _localSocket->disconnectFromServer();
    }
}

void SingleInstanceCheck::pollState()
{
    QFileInfo lockFile(_lockFilePath);
    if (!lockFile.exists())
    {
        LOG_WARN(_logger, "lock file disappeared, trying to restore lock");
        if (_lockFile.tryLock(100))
            LOG_INFO(_logger, "lock restored");
    }

    QFileInfo serverFile(_localServer->serverSocketFilePath());
    if (!serverFile.exists())
    {
        LOG_WARN(_logger, "server file disappeared trying to restore local server");
        _localServer->close();
        if (_localServer->listen())
            LOG_INFO(_logger, "local server restored");
        ;
    }
}

bool SingleInstanceCheck::IsAnotherInstanceRunning()
{
    QLockFile lock(GetLockFilePath());
    lock.setStaleLockTime(0);
    if (lock.tryLock(100)) {
        lock.unlock();
        return false;
    }
    return true;
}

QString SingleInstanceCheck::GetLockFilePath()
{
    return QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).first() + QDir::separator() + "single-instance.lock";
}
