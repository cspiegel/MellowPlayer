import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import MellowPlayer 3.0


ApplicationWindow {
    id: mainWindow

    property string selectServicePage: "select"
    property string runningServicesPage: "running"
    property var runningServices: null
    property string page
    property bool isOnRunningServicesPage: page === runningServicesPage
    property bool hasRunningServices: runningServices !== null && runningServices.currentIndex !== -1

    function toggleActivePage() {
        if (page === selectServicePage)
            page = runningServicesPage;
        else
            page = selectServicePage;
    }

    function openWebPopup(request, profile) {
        if (request.userInitiated) {
            d.applicationRoot.createDialog(profile).open(request, profile)
        }
    }

    function toggleFullScreen(request) {
        if (request.toggleOn) {
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
        request.accept();
    }

    function activateService(service) {
        _streamingServices.currentService = service;
        page = runningServicesPage;
        var index = runningServices.indexOf(service);
        if (index === -1) {
            runningServices.add(service);
            index = runningServices.count - 1;
        }
        runningServices.currentIndex = index;
    }

    minimumWidth: 960; minimumHeight: 540
    width: _settings.get(SettingKey.PRIVATE_WINDOW_WIDTH).value;
    height: _settings.get(SettingKey.PRIVATE_WINDOW_HEIGHT).value;
    title: _streamingServices.currentService !== null ? _streamingServices.currentService.name : ""

    onClosing: d.handleCloseEvent(close);
    onPageChanged: {
        if (page === selectServicePage) {
            if (runningServices !== null && runningServices.currentWebView !== null)
                runningServices.currentWebView.updateImage();
            var selectServices = stack.push(selectServicePageComponent);
            selectServices.quitRequested.connect(function() {
                stack.slideTransitions = false;
                mainWindow.toggleActivePage()
            });
        }
        else if (page === runningServicesPage) {
            if (stack.depth <= 1) {
                runningServices = stack.push(runningServicesPageComponent)
            }
            else {
                stack.pop();
            }
        }
    }

    Component.onCompleted: {
        if (_streamingServices.currentService !== null)
            activateService(_streamingServices.currentService)
        else
            page = selectServicePage;
    }
    Material.accent: _theme.accent
    Material.background: _theme.background
    Material.foreground: _theme.foreground
    Material.primary: _theme.primary
    Material.theme: _theme.dark ? Material.Dark : Material.Light

    header: MainToolBar {
        id: mainToolBar

        visible: _settings.get(SettingKey.APPEARANCE_TOOLBAR_VISIBLE).value && mainWindow.visibility !== ApplicationWindow.FullScreen
    }

    footer: UpdateToolBar { }

    StackView {
       id: stack

       property bool slideTransitions: false

       anchors.fill: parent

       pushEnter: Transition {
           PropertyAnimation {
               property: "opacity"
               from: 0
               to:1
               duration: 200
           }
       }
       pushExit: Transition {
           PropertyAnimation {
               property: "opacity"
               from: 1
               to:0
               duration: 200
           }
       }

       popEnter: slideTransitions ? slideInLeft : fadeIn
       popExit: slideTransitions ? slideOutRight : fadeOut

       property Transition slideInLeft: Transition {
           NumberAnimation { property: "x"; from: (stack.mirrored ? -0.5 : 0.5) *  -stack.width; to: 0; duration: 200; easing.type: Easing.OutCubic }
           NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
       }

       property Transition slideOutRight: Transition {
           NumberAnimation { property: "x"; from: 0; to: (stack.mirrored ? -0.5 : 0.5) * stack.width; duration: 200; easing.type: Easing.OutCubic }
           NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200; easing.type: Easing.OutCubic }
       }

       property Transition fadeIn: Transition {
           PropertyAnimation {
               property: "opacity"
               from: 0
               to:1
               duration: 200
           }
       }
       property Transition fadeOut: Transition {
           PropertyAnimation {
               property: "opacity"
               from: 1
               to:0
               duration: 200
           }
       }

       Component { id: selectServicePageComponent; SelectServicePage { id: selectServicePage } }
       Component { id: runningServicesPageComponent; RunningServicesPage { id: runningServicesPage } }
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
            _window.visible = false;
            mainWindow.visible = false;
        }
    }

    NewPluginWizard {
        id: newPluginWizard

        property real scaleFactor: 0.9

        modal: true
        width: 1152; height: 648
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

    ReportIssueDialog {
        id: reportIssueDialog
    }

    StreamingServiceSettingsDialog {
        id: settingsDialog

        height: 540; width: 960
        x: parent.width / 2 - width / 2; y: parent.height / 2 - height / 2
    }

    Connections {
        target: _window;

        function onVisibleChanged() { _window.visible ? d.restoreWindow() : d.hideWindow() }
        function onQuitRequest() { d.quit() }
        function onForceQuitRequest() { d.forceQuit = true; _app.quit() }
        function onRaiseRequested() { d.restoreWindow() }
    }

    Connections {
        target: _streamingServices;

        function onActivationRequested(service) { mainWindow.activateService(service) }
    }

    Shortcut {
        sequence: _settings.get(SettingKey.SHORTCUTS_SELECT_SERVICE).value
        onActivated: {
            stack.slideTransitions = false;
            toggleActivePage();
        }
    }

    Shortcut {
        sequence: _settings.get(SettingKey.SHORTCUTS_SHOW_TOOLBAR).value
        onActivated: {
            console.warn("CTRL+T")
            _settings.get(SettingKey.APPEARANCE_TOOLBAR_VISIBLE).value = !_settings.get(SettingKey.APPEARANCE_TOOLBAR_VISIBLE).value
        }
    }

    QtObject {
        id: d

        property int previousVisibility: ApplicationWindow.Windowed
        property QtObject applicationRoot: ApplicationRoot { }
        property bool forceQuit: false;

        function hideWindow() {
            mainWindow.hide();
        }

        function restoreWindow() {
            mainWindow.visible = true;
            mainWindow.raise();
            mainWindow.requestActivate();
        }

        function saveGeometry() {
            _settings.get(SettingKey.PRIVATE_WINDOW_WIDTH).value = mainWindow.width;
            _settings.get(SettingKey.PRIVATE_WINDOW_HEIGHT).value = mainWindow.height;
        }

        function handleCloseEvent(close) {
            saveGeometry();
            var closeToTray = _settings.get(SettingKey.MAIN_CLOSE_TO_TRAY).value
            if (closeToTray && !forceQuit) {
                var showMessageSetting = _settings.get(SettingKey.PRIVATE_SHOW_CLOSE_TO_TRAY_MESSAGE)
                if (showMessageSetting.value) {
                    showMessageSetting.value = false;
                    exitToTrayMsgBox.open();
                }
                else {
                    _window.visible = false;
                    mainWindow.visible = false;
                }
                close.accepted = false;
            }
        }

        function quit() {
            saveGeometry();
            var confirmExit = _settings.get(SettingKey.MAIN_CONFIRM_EXIT).value;
            if (confirmExit) {
                d.restoreWindow();
                confirmQuitMsgBox.open();
                confirmQuitMsgBox.forceActiveFocus();
            }
            else {
                _app.quit();
            }
        }
    }
}
