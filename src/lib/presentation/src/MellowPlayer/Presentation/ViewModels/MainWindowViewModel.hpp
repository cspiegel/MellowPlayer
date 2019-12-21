#pragma once

#include <MellowPlayer/Presentation/IMainWindow.hpp>
#include <MellowPlayer/Presentation/Qml/ContextProperty.hpp>
#include <QObject>

namespace MellowPlayer::Presentation
{
    class IQmlApplicationEngine;

    class MainWindowViewModel : public IMainWindow, public ContextProperty
    {
        Q_OBJECT
        Q_PROPERTY(bool visible READ isVisible WRITE setVisible NOTIFY visibleChanged)
    public:
        MainWindowViewModel(std::shared_ptr<IContextProperties> contextProperties, IQmlApplicationEngine& qmlApplicationEngine);

        // IMainWindow implementation
        void load() override;
        void show() override;
        void hide() override;
        void raise() override;

        // Properties for QML
        bool isVisible() const;

        Q_INVOKABLE void requestQuit() override;

    signals:
        void quitRequest();

    public slots:
        void setVisible(bool visible);

    signals:
        void visibleChanged();
        void raiseRequested();

    private:
        IQmlApplicationEngine& qmlApplicationEngine_;
        bool visible_;
    };
}
