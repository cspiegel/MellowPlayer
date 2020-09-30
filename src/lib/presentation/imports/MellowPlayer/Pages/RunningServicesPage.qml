import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import MellowPlayer 3.0

StackLayout {
    id: root

    property WebView currentWebView

    currentIndex: MainWindow.runningServices.currentIndex

    Action {
        id: goBack

        onTriggered: root.currentWebView.goBack()
        Component.onCompleted: Actions.goBack = goBack
    }

    Action {
        id: goForward

        onTriggered: root.currentWebView.goForward()
        Component.onCompleted: Actions.goForward = goForward
    }

    Action {
        id: goHome

        onTriggered: {
            console.warn("GoHome", root.currentWebView.url, root.currentWebView.service.url);
            root.currentWebView.url = "";
            root.currentWebView.url = root.currentWebView.service.url;
        }
        Component.onCompleted: Actions.goHome = goHome
    }

    Action {
        id: reload

        shortcut: App.settings.get(SettingKey.SHORTCUTS_RELOAD).value

        onTriggered: root.currentWebView.reload()
        Component.onCompleted: Actions.reload = reload
    }

    Shortcut {
        sequence: "Ctrl++"
        onActivated: root.currentWebView.zoomIn()
    }

    Shortcut {
        sequence: "Ctrl+-"
        onActivated: root.currentWebView.zoomOut()
    }

    Shortcut {
        sequence: "Ctrl+0"
        onActivated: root.currentWebView.resetZoom()
    }

    Shortcut {
        property Setting setting: App.settings.get(SettingKey.SHORTCUTS_SELECT_NEXT_SERVICE)

        sequence: setting.value
        onActivated: StreamingServices.next()
    }

    Shortcut {
        property Setting setting: App.settings.get(SettingKey.SHORTCUTS_SELECT_PREVIOUS_SERVICE)

        sequence: setting.value
        onActivated: StreamingServices.previous()
    }

    Repeater {
        model: MainWindow.runningServices.model
        delegate: WebView {
            id: webView

            required property int index
            required property StreamingService qtObject
            property bool isCurrent: index === root.currentIndex

            service: qtObject
            onIsCurrentChanged: root.currentWebView = webView

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
