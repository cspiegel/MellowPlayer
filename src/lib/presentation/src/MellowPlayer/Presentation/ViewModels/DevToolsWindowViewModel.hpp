#pragma once

#include <MellowPlayer/Presentation/Qml/ContextProperty.hpp>
#include <QObject>

namespace MellowPlayer::Presentation
{
    class DevToolsWindowViewModel : public QObject, public ContextProperty
    {
        Q_OBJECT
    public:
        DevToolsWindowViewModel(std::shared_ptr<IContextProperties> contextProperties);
    signals:
        void showDevTools();
    };
}