#include <MellowPlayer/UseCases/Interfaces/IQtApplication.hpp>
#include <MellowPlayer/UseCases/Interfaces/IMainWindow.hpp>
#include <MellowPlayer/UseCases/Plugin/PluginManager.hpp>
#include <MellowPlayer/UseCases/Services/IHotkeysService.hpp>
#include <MellowPlayer/UseCases/Services/IMprisService.hpp>
#include <MellowPlayer/UseCases/Interfaces/ISystemTrayIcon.hpp>
#include <MellowPlayer/UseCases/Logging/LoggingManager.hpp>
#include "LinuxApplication.hpp"

#ifdef Q_OS_LINUX

USE_MELLOWPLAYER_NAMESPACE(UseCases)
USE_MELLOWPLAYER_NAMESPACE(Infrastructure)

LinuxApplication::LinuxApplication(IQtApplication& qtApp,
                                   IMainWindow& mainWindow,
                                   PluginManager& pluginManager,
                                   IHotkeysService& kotkeys,
                                   ISystemTrayIcon& systemTrayIcon,
                                   INotificationService& playerNotificationService,
                                   IMprisService& mprisService) :
        Application(qtApp, mainWindow, pluginManager, kotkeys, systemTrayIcon, playerNotificationService),
        logger(LoggingManager::instance().getLogger("LinuxApplication")),
        mprisService(mprisService) {

}

void LinuxApplication::initialize() {
    LOG_TRACE(logger, "initialize");
    Application::initialize();
    mprisService.start();
}

#endif