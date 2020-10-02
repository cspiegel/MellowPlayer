import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

import MellowPlayer 3.0
import "../Dialogs.js" as Dialogs

Dialog {
    id: root

    modal: true
    padding: 16

    onVisibleChanged: stackLayout.currentIndex = 0
    Component.onCompleted: Dialogs.keepCenteredOnMainWindow(root)

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: 0

        ColumnLayout {
            spacing: 24

            RowLayout {
                spacing: 0
                Layout.fillHeight: true
                Layout.fillWidth: true

                Pane {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    padding: 16

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 24

                        ColumnLayout {
                            Layout.fillWidth: true

                            Label {
                                horizontalAlignment: "AlignHCenter"
                                text: qsTr("Report the issue on gitlab")
                                font.bold: true

                                Layout.minimumWidth: longestLabel.implicitWidth
                            }

                            Label {
                                text: qsTr("Requires a gitlab account")

                                font { italic: true; pixelSize: 10 }

                                Material.foreground: Material.color(Material.Red)
                                Layout.alignment: Qt.AlignHCenter
                            }

                        }

                        Image {
                            sourceSize.height: 38
                            sourceSize.width: 38
                            source: "qrc:/MellowPlayer/Presentation/icons/gitlab.svg"

                            Layout.alignment: Qt.AlignHCenter
                        }

                        Button {
                            text: qsTr("Report issue")
                            highlighted: true

                            onClicked: {
                                Qt.openUrlExternally("https://gitlab.com/ColinDuquesnoy/MellowPlayer/issues/new?issue")
                                stackLayout.currentIndex = 1;
                            }

                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                ToolSeparator {
                    Layout.fillHeight: true
                }

                Pane {
                    id: mailPane

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    padding: 16

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 24

                        ColumnLayout {
                            Layout.fillWidth: true

                            Label {
                                text: qsTr("Report the issue via e-mail")
                                horizontalAlignment: "AlignHCenter"
                                font.bold: true

                                Layout.fillWidth: true
                            }

                            Label {
                                id: longestLabel

                                text: "incoming+ColinDuquesnoy/MellowPlayer@incoming.gitlab.com"
                                font { italic: true; pixelSize: 8 }
                                wrapMode: "WordWrap"

                                Layout.fillWidth: true
                            }


                        }

                        Label {
                            text: MaterialIcons.icon_email
                            font {
                                family: MaterialIcons.family
                                pixelSize: 48
                            }

                            Layout.alignment: Qt.AlignHCenter
                        }

                        Button {
                            text: qsTr("Report issue")
                            highlighted: true

                            onClicked: {
                                Qt.openUrlExternally("mailto: incoming+ColinDuquesnoy/MellowPlayer@incoming.gitlab.com")
                                stackLayout.currentIndex = 1;
                            }

                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }

            Link {
                name: qsTr("Please, read the contributing guidelines before submitting the bug report!")
                url: "https://gitlab.com/ColinDuquesnoy/MellowPlayer/blob/master/CONTRIBUTING.md#reporting-bugs-or-wishes"

                Layout.alignment: Qt.AlignHCenter
            }
        }

        Pane {
            padding: 16

            ColumnLayout {
                anchors.fill: parent

                Item {
                    Layout.fillHeight: true
                }

                Label {
                    text: qsTr("Thank you for taking the time to report the issue!")
                    font.bold: true
                    horizontalAlignment: "AlignHCenter"

                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    Layout.fillHeight: true
                }

                Label {
                    text: MaterialIcons.icon_thumb_up
                    font { family: MaterialIcons.family; pixelSize: 48 }

                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    Layout.fillHeight: true
                }

                Button {
                    text: qsTr("Close")
                    highlighted: true

                    onClicked: root.close()

                    Layout.alignment: Qt.AlignHCenter
                }

            }
        }
    }
}
