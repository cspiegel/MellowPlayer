import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import MellowPlayer 3.0

ItemDelegate {
    property var values: model.qtObject.values
    property var qtObject: model.qtObject

    bottomPadding: 3; topPadding: 3
    hoverEnabled: true
    enabled: model.enabled
    onClicked: comboBox.popup.open()

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

        ComboBox {
            id: comboBox

            hoverEnabled: true
            model: values
            currentIndex: values.indexOf(qtObject.value)
            onCurrentTextChanged: qtObject.value = currentText

            Layout.preferredWidth: 250

            Tooltip {
                text: SettingsTranslator.translateToolTip(model.toolTip)
            }
        }
    }
}
