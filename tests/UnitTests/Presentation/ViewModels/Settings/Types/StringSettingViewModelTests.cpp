#include "catch.hpp"
#include "DI.hpp"
#include <MellowPlayer/Application/Settings/Setting.hpp>
#include <MellowPlayer/Presentation/ViewModels/Settings/Types/StringSettingViewModel.hpp>
#include <QtTest/QSignalSpy>

USING_MELLOWPLAYER_NAMESPACE(Application)
USING_MELLOWPLAYER_NAMESPACE(Presentation)

TEST_CASE("StringSettingViewModelTests") {
    ScopedScope scope;
    auto injector = getTestInjector(scope);
    Settings& settings = injector.create<Settings&>();
    Setting& setting = settings.get(SettingKey::SHORTCUTS_PLAY);
    StringSettingViewModel model(setting, nullptr);
    QSignalSpy spy(&model, SIGNAL(valueChanged()));

    SECTION("setValue") {
        REQUIRE(model.getValue() == "Ctrl+Alt+P");
        REQUIRE(spy.count() == 0);
        model.setValue("Ctrl+P");
        REQUIRE(model.getValue() == "Ctrl+P");
        REQUIRE(spy.count() == 1);
    }

    SECTION("QML Component looks valid") {
        REQUIRE(model.getQmlComponent().toLower().contains("string"));
    }
}
