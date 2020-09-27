#include <MellowPlayer/Domain/Player/IPlayer.hpp>
#include <MellowPlayer/Domain/Player/Player.hpp>
#include <MellowPlayer/Presentation/Qml/IQmlApplicationEngine.hpp>
#include <MellowPlayer/Presentation/Qml/IQmlSingleton.hpp>
#include <MellowPlayer/Presentation/Qml/QmlSingletons.hpp>
#include <QtQml>

using namespace MellowPlayer::Domain;
using namespace MellowPlayer::Presentation;

QmlSingletons::QmlSingletons(IQmlApplicationEngine& qmlApplicationEngine, IPlayer& player, const std::vector<std::shared_ptr<IQmlSingleton>>& items)
        : _qmlApplicationEngine(qmlApplicationEngine), _player(player), _items(items)
{
}

void QmlSingletons::registerToQml()
{
    _qmlApplicationEngine.registerSingletonInstance("Player", &_player);

    for (auto& qmlSingleton : _items)
        qmlSingleton->registerTo(_qmlApplicationEngine);
}
