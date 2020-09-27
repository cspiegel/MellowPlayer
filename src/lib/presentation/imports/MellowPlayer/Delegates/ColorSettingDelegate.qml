import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

import MellowPlayer 3.0

ItemDelegate {
    bottomPadding: 3; topPadding: 3
    enabled: model.enabled
    hoverEnabled: true
    onClicked: colorDialog.open()

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: parent.leftPadding
        anchors.rightMargin: parent.rightPadding
        anchors.topMargin: parent.topPadding
        anchors.bottomMargin: parent.bottomPadding

        Label {
            text: SettingsTranslator.translateName(model.name)
            font.pixelSize: 16
            Layout.fillWidth: true
        }

        Button {
            hoverEnabled: true
            text: model.qtObject.value
            onTextChanged: model.qtObject.value = text
            onClicked: colorDialog.open()

            Material.background: model.qtObject.value
            Material.foreground: ActiveTheme.isDark(model.qtObject.value) ? "white" : "#303030"

            Tooltip {
                text: SettingsTranslator.translateToolTip(model.toolTip)
            }

            ColorDialog {
                id: colorDialog

                title: qsTr("Please choose a color")
                color: model.qtObject.value
                onColorChanged: model.qtObject.value = color
            }
        }
    }
}
