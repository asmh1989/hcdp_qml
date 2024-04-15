import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Popup {
    id: messageDialog

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: 300
    height: 300
    parent: Overlay.overlay
    modal: true

    FolderDialog {
        id: folderDialog
        onAccepted: {
            var url = folderDialog.currentFolder + ""
            sm.logPath = url.replace("file:///", "")
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        Rectangle {
            Layout.fillWidth: parent
            Layout.preferredHeight: 40
            Text {
                id: title
                text: "Settings"
                anchors.centerIn: parent
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: parent

            Column {
                anchors.fill: parent
                spacing: 2

                Item {
                    width: parent.width
                    height: 24
                    Row {
                        anchors.centerIn: parent
                        height: parent.height
                        Text {
                            text: "停止位: "
                            Layout.alignment: Qt.AlignVCenter
                            verticalAlignment: Text.AlignVCenter
                            height: parent.height
                        }

                        ComboBox {
                            width: 40
                            height: parent.height
                            currentIndex: appSettings.stopIndex
                            model: stopArr

                            onCurrentIndexChanged: {
                                appSettings.stopIndex = currentIndex
                            }
                        }

                        Item {
                            width: 6
                            height: 1
                        }

                        Text {
                            text: "校验位: "
                            Layout.alignment: Qt.AlignVCenter
                            verticalAlignment: Text.AlignVCenter
                            height: parent.height
                        }
                        ComboBox {
                            width: 50
                            height: parent.height
                            currentIndex: appSettings.parityIndex
                            model: parityArr

                            onCurrentIndexChanged: {
                                appSettings.parityIndex = currentIndex
                            }
                        }
                    }
                }


                Item {
                    width: parent.width
                    height: 24
                    Row {
                        anchors.centerIn: parent
                        Text {
                            text: "SSD: "
                            Layout.alignment: Qt.AlignVCenter
                            verticalAlignment: Text.AlignVCenter
                            height: parent.height
                        }

                        TextField {
                            text: appSettings.ssd
                            width: 30
                            Layout.alignment: Qt.AlignVCenter
                            validator: RegularExpressionValidator {
                                regularExpression: /^[a-zA-Z0-9]{1,2}$/
                            }

                            onTextChanged: {
                                appSettings.ssd = text
                            }
                        }
                        Item {
                            width: 3
                            height: 1
                        }

                        Text {
                            text: "ESD: "
                            Layout.alignment: Qt.AlignVCenter
                            verticalAlignment: Text.AlignVCenter
                            height: parent.height
                        }
                        TextField {
                            text: appSettings.esd
                            width: 30
                            Layout.alignment: Qt.AlignVCenter
                            validator: RegularExpressionValidator {
                                regularExpression: /^[a-zA-Z0-9]{1,2}$/
                            }

                            onTextChanged: {
                                appSettings.esd = text
                            }
                        }
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 24
                    Text {
                        text: "Encode: "
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    ComboBox {
                        id: encode
                        width: 60
                        height: parent.height
                        currentIndex: appSettings.encodeIndex
                        model: encodeArr

                        onCurrentIndexChanged: {
                            appSettings.encodeIndex = encode.currentIndex
                        }
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 24
                    Text {
                        text: qsTr("Scale:")
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    ComboBox {
                        id: scale
                        width: 60
                        height: parent.height
                        currentIndex: 0
                        model: ["1.0", "1.25", "1.5", "2.0"]

                        onCurrentIndexChanged: {
                            var now = scale.model[currentIndex]
                            if (now !== sm.getScaleCache()) {
                                sm.setScaleCache(now + "")
                                sm.showGlobalToast("scale = " + now + " 重启生效!")
                            }
                        }

                        Component.onCompleted: () => {
                                                   var now = sm.getScaleCache()
                                                   scale.currentIndex = scale.model.indexOf(
                                                       now)
                                               }
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 24
                    Text {
                        text: qsTr("AutoSaveLog ")
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    CheckBox {
                        checked: appSettings.saveLog
                        anchors.verticalCenter: parent.verticalCenter
                        onCheckedChanged: {
                            appSettings.saveLog = checked
                        }
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 24
                    Text {
                        text: qsTr("LogPath ")
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    ItemDelegate {
                        height:parent.height
                        width: dd.width
                        Text {
                            id: dd
                            text: sm.logPath
                            clip: true
                            width: 200
                            elide: Text.ElideLeft
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        onClicked: {
                            folderDialog.currentFolder = "file:///"+ sm.logPath
                            folderDialog.open()
                        }
                    }
                }

            }
        }

        Row {
            spacing: 6
            Layout.preferredHeight: 40
            Layout.preferredWidth: parent.width

            Button {
                id: rbtn
                text: "OK"
                highlighted: true
                width: parent.width
                height: parent.height
                onClicked: {
                    close()
                }
            }
        }
    }

    Connections {
        target: sm
    }
}
