import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

ColumnLayout {
    id: overview
    width: parent.width
    height: parent.height

    Label {
        Layout.fillWidth: true
        text: "Which service would you like to listen to ?"
        font.pixelSize: 32
        horizontalAlignment: Text.AlignHCenter
    }

    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.margins: 50

        GridView {
            id: servicesGridView
            anchors.centerIn: parent
            focus: true
            width: {
                if (mainWindow.width <= 1680 )
                    return 0.90 * mainWindow.width;
                else if( mainWindow.width < 1920)
                    return 0.80 * mainWindow.width;
                else
                    return 0.70 * mainWindow.width;
            }
            height: parent.height
            clip: true

            ScrollBar.vertical: ScrollBar {
                parent: servicesGridView.parent
                anchors.top: servicesGridView.top
                anchors.left: servicesGridView.right
                anchors.bottom: servicesGridView.bottom
                active: hovered
                hoverEnabled: true

            }

            cellWidth: servicesGridView.width / 3
            cellHeight: cellWidth / 16 * 9
            model: streamingServices.model
            delegate: ServiceOverviewDelegate {}
        }
    }
}