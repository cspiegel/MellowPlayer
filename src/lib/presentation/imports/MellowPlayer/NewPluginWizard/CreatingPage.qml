import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

WizardPage {
    id: root

    property string svName
    property string svUrl
    property string authorName
    property string authorUrl
    property bool allPlatforms
    property bool linuxPlatform
    property bool appImagePlatform
    property bool osxPlatform
    property bool windowsPlatform

    property string directory: ""

    signal goNextRequested()

    title: qsTr("Creating plugin")
    description: qsTr("Please wait...")
    goBackVisible: false
    goNextVisible: true
    finishVisible: false
    goNextEnabled: !busyIndicator.running

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: root.directory == ""
    }

    Component.onCompleted: {
        StreamingServices.createService(svName, svUrl, authorName, authorUrl, allPlatforms, linuxPlatform, appImagePlatform, osxPlatform, windowsPlatform)
    }

    Connections {
        target: StreamingServices
        onServiceCreated: {
            root.directory = directory
            root.goNextRequested()
        }
    }
}
