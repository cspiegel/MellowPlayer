import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtWebEngine 1.5

import MellowPlayer 3.0

Page {
    id: page

    signal quitRequested()

    Shortcut {
        sequence: "Escape"
        enabled: page.visible

        onActivated: page.quitRequested()
    }

    ServicesOverview {
        anchors.fill: parent
    }
}

