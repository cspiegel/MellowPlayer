import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import MellowPlayer 3.0


ApplicationWindow {
    id: mainWindow

    property var runningServices: null
    property bool hasRunningServices: runningServices !== null && runningServices.currentIndex !== -1

//    minimumWidth: 800; minimumHeight: 480
    width: App.settings.get(SettingKey.PRIVATE_WINDOW_WIDTH).value;
    height: App.settings.get(SettingKey.PRIVATE_WINDOW_HEIGHT).value;
    title: StreamingServices.currentService !== null ? StreamingServices.currentServiceName : ""
    font.pixelSize: width < 960 ? 12 : 14

    onClosing: d.handleCloseEvent(close);

    Component.onCompleted: { Dialogs.mainWindow = mainWindow }
    Material.accent: ActiveTheme.accent
    Material.background: ActiveTheme.background
    Material.foreground: ActiveTheme.foreground
    Material.primary: ActiveTheme.primaryI
    Material.theme: ActiveTheme.dark ? Material.Dark : Material.Light

    header: MainToolBar {
        id: mainToolBar

        visible: App.settings.get(SettingKey.APPEARANCE_TOOLBAR_VISIBLE).value && mainWindow.visibility !== ApplicationWindow.FullScreen
    }

    footer: UpdateToolBar { }

    StackView {
        id: stack

        anchors.fill: parent

        Component { id: selectServicePageComponent; SelectServicePage {} }
        Component { id: runningServicesPageComponent;  RunningServicesPage {} }
    }

    SettingsDrawer {
        id: settingsDrawer;

        width: mainWindow.width; height: mainWindow.height
    }

    ListeningHistoryDrawer {
        id: listeningHistoryDrawer;

        height: mainWindow.height; width: 450
    }

    AboutDialog {
        id: aboutDialog
    }

    MessageBoxDialog {
        id: confirmQuitMsgBox

        standardButtons: Dialog.Ok | Dialog.Cancel
        message: qsTr("Are you sure you want to quit MellowPlayer?")
        title: qsTr("Confirm quit")

        onAccepted: {
            console.log("quit")
            Qt.quit()
        }
    }

    MessageBoxDialog {
        id: errorDialog

        standardButtons: MessageBoxDialog.Close

        onAccepted: close()
    }

    MessageBoxDialog {
        id: exitToTrayMsgBox

        title: qsTr("Closing to system tray")
        message: qsTr("<p>MellowPlayer will continue to run in background.<br>" +
                      "You can quit the application or restore the main window via the system tray icon menu.</p>")
        standardButtons: Dialog.Ok

        onAccepted: {
            MainWindow.visible = false;
            mainWindow.visible = false;
        }
    }

    NewPluginWizard {
        id: newPluginWizard

        property real scaleFactor: 0.9

        modal: true
        width: 600; height: 440
        x: mainWindow.width / 2 - width / 2;
        y: mainWindow.height / 2 - height / 2 - 48;
    }

    FullScreenNotification {
        id: fullScreenNotification

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 12
        visible: false
    }

    StreamingServiceSettingsDialog {
        id: settingsDialog

        height: 540; width: 960
        x: parent.width / 2 - width / 2; y: parent.height / 2 - height / 2
    }

    Connections {
        target: MainWindow

        function onVisibleChanged() {
            MainWindow.visible ? d.restoreWindow() : d.hideWindow()
        }
        function onQuitRequest() { d.quit() }
        function onForceQuitRequest() { d.forceQuit = true; App.quit() }
        function onRaiseRequested() {
            d.restoreWindow()
        }
    }

    Action {
        id: toggleCurrentPageAction
        shortcut: App.settings.get(SettingKey.SHORTCUTS_SELECT_SERVICE).value
        onTriggered: MainWindow.toggleActivePage()
        Component.onCompleted: Actions.toggleCurrentPage = toggleCurrentPageAction
    }

    Action {
        id: openListeningHistoryAction
        shortcut: App.settings.get(SettingKey.SHORTCUTS_LISTENING_HISTORY).value
        onTriggered:  listeningHistoryDrawer.open()
        Component.onCompleted: Actions.openListeningHistory = openListeningHistoryAction
    }

    Action {
        id: openSettingsAction
        shortcut: App.settings.get(SettingKey.SHORTCUTS_SETTINGS).value
        text: qsTr("Settings")
        onTriggered: settingsDrawer.open()
        Component.onCompleted: Actions.openSettings = openSettingsAction
    }

    Action {
        id: createNewPluginAction
        shortcut: App.settings.get(SettingKey.SHORTCUTS_CREATE_PLUGIN).value
        text: qsTr("Create plugin")
        onTriggered: newPluginWizard.open()
        Component.onCompleted: Actions.createNewPlugin = createNewPluginAction
    }

    Action {
        id: reportIssueAction
        shortcut: App.settings.get(SettingKey.SHORTCUTS_REPORT_ISSUE).value
        text: qsTr("Report issue")
        onTriggered: Dialogs.reportIssue()
        Component.onCompleted: Actions.reportIssue = reportIssueAction
    }

    Action {
        id: toggleToolBarAction
        shortcut: App.settings.get(SettingKey.SHORTCUTS_SHOW_TOOLBAR).value
        text: qsTr("Toggle main toolbar")
        onTriggered: App.settings.get(SettingKey.APPEARANCE_TOOLBAR_VISIBLE).value = !App.settings.get(SettingKey.APPEARANCE_TOOLBAR_VISIBLE).value
        Component.onCompleted: Actions.toggleToolBar = toggleToolBarAction
    }

    Action {
        id: checkForUpdatesAction
        enabled: !Updater.busy
        shortcut: App.settings.get(SettingKey.SHORTCUTS_CHECK_FOR_UPDATE).valu
        text: qsTr("Check for update")
        onTriggered: Updater.check()
        Component.onCompleted: Actions.checkForUpdates = checkForUpdatesAction
    }

    Action {
        id: showAboutAction
        shortcut: App.settings.get(SettingKey.SHORTCUTS_ABOUT).value
        text: qsTr("About")
        onTriggered: aboutDialog.open()
        Component.onCompleted: Actions.showAbout = showAboutAction
    }

    Action {
        id: quitAction
        shortcut: App.settings.get(SettingKey.SHORTCUTS_QUIT).value
        text: qsTr("Quit")
        onTriggered: MainWindow.requestQuit()
        Component.onCompleted: Actions.quit = quitAction
    }


    QtObject {
        id: d

        property int previousVisibility: ApplicationWindow.Windowed
        property bool forceQuit: false;
        property string page: MainWindow.currentPage

        property bool fullScreen: MainWindow.fullScreen
        onFullScreenChanged: {
            if (fullScreen) {
                d.previousVisibility = mainWindow.visibility
                mainWindow.showFullScreen();
                fullScreenNotification.visible = true;
            }
            else {
                mainWindow.visibility = d.previousVisibility
                mainWindow.showNormal()
                if (d.previousVisibility === ApplicationWindow.Maximized)
                    mainWindow.showMaximized()
            }
        }

        onPageChanged: {
            if (MainWindow.currentPage === MainWindow.selectServicePage) {
                if (runningServices !== null && runningServices.currentWebView !== null)
                    runningServices.currentWebView.updateImage();
                var selectServices = stack.push(selectServicePageComponent);
                selectServices.quitRequested.connect(function() {
                    MainWindow.toggleActivePage()
                });
            }
            else if (MainWindow.currentPage === MainWindow.runningServicesPage) {
                if (stack.depth <= 1) {
                    runningServices = stack.push(runningServicesPageComponent)
                }
                else {
                    stack.pop();
                }
            }
        }

        function hideWindow() {
            mainWindow.hide();
        }

        function restoreWindow() {
            mainWindow.visible = true;
            mainWindow.raise();
            mainWindow.requestActivate();
        }

        function saveGeometry() {
            App.settings.get(SettingKey.PRIVATE_WINDOW_WIDTH).value = mainWindow.width;
            App.settings.get(SettingKey.PRIVATE_WINDOW_HEIGHT).value = mainWindow.height;
        }

        function handleCloseEvent(close) {
            saveGeometry();
            var closeToTray = App.settings.get(SettingKey.MAIN_CLOSE_TO_TRAY).value
            if (closeToTray && !forceQuit) {
                var showMessageSetting = App.settings.get(SettingKey.PRIVATE_SHOW_CLOSE_TO_TRAY_MESSAGE)
                if (showMessageSetting.value) {
                    showMessageSetting.value = false;
                    exitToTrayMsgBox.open();
                }
                else {
                    MainWindow.visible = false;
                }
                close.accepted = false;
            }
        }

        function quit() {
            saveGeometry();
            var confirmExit = App.settings.get(SettingKey.MAIN_CONFIRM_EXIT).value;
            if (confirmExit) {
                d.restoreWindow();
                confirmQuitMsgBox.open();
                confirmQuitMsgBox.forceActiveFocus();
            }
            else {
                App.quit();
            }
        }
    }
}
