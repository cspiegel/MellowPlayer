#include <MellowPlayer/Infrastructure/Network/LocalSocket.hpp>

using namespace MellowPlayer::Infrastructure;

LocalSocket::LocalSocket() : _qLocalSocket(new QLocalSocket(this))
{
    initSignals();
}

void LocalSocket::connectToServer(const QString& name, QIODevice::OpenMode openMode)
{
    _qLocalSocket->connectToServer(name, openMode);
}

void LocalSocket::disconnectFromServer()
{
    _qLocalSocket->disconnectFromServer();
}

void LocalSocket::write(const QString& data)
{
    if (_qLocalSocket->state() == QLocalSocket::ConnectedState)
    {
        _qLocalSocket->write(data.toLocal8Bit());
        _qLocalSocket->waitForBytesWritten();
    }
    else
        throw std::logic_error("cannot write data on a socket that is not connected");
}

void LocalSocket::setQLocalSocket(QLocalSocket* localSocket)
{
    delete _qLocalSocket;
    _qLocalSocket = localSocket;
    initSignals();
}

QString LocalSocket::readAll()
{
    return _qLocalSocket->readAll();
}

void LocalSocket::initSignals()
{
    connect(_qLocalSocket, &QLocalSocket::connected, this, &LocalSocket::connected);
    connect(_qLocalSocket, &QLocalSocket::disconnected, this, &LocalSocket::disconnected);
    connect(_qLocalSocket, &QLocalSocket::readyRead, this, &LocalSocket::readyRead);
    connect(_qLocalSocket, QNonConstOverload<QLocalSocket::LocalSocketError>::of(&QLocalSocket::error), [=](QLocalSocket::LocalSocketError) { emit error(); });
}