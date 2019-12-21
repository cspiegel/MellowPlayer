#include <MellowPlayer/Domain/Settings/Setting.hpp>
#include <MellowPlayer/Presentation/ViewModels/Settings/Types/IconSettingViewModel.hpp>

using namespace MellowPlayer::Domain;
using namespace MellowPlayer::Presentation;

IconSettingViewModel::IconSettingViewModel(Setting &setting, QObject *parent) : SettingViewModel(setting, parent)
{
}

QString IconSettingViewModel::getValue() const
{
    return setting_.value().toString();
}

QString IconSettingViewModel::qmlComponent()
{
    return "Delegates/IconSettingDelegate.qml";
}

void IconSettingViewModel::setValue(QString value)
{
    setting_.setValue(value);
}

void IconSettingViewModel::onValueChanged()
{
    emit valueChanged();
}
