import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Control {
    width: parent.width
    height: parent.height * 0.4
    padding: 16

    background: Rectangle{
        color: 'transparent'
        border.color: '#50A0FF'
        border.width: 1
        radius: 4
        anchors.fill: parent
    }



    contentItem:Column {
        anchors.fill: parent

        anchors.margins: 16

        spacing: 6

        RowLayout {
            width: parent.width
            height: 30
            spacing: 6

            GrayLabel {
                text: qsTr("Address")
                Layout.minimumWidth: 68

            }
            GrayLabel {
                Layout.minimumWidth: 68
                text: qsTr("Code")
            }

            GrayLabel {
                Layout.fillWidth: true
                Layout.minimumWidth: 200
                Layout.preferredWidth: 300
                Layout.maximumWidth: 2000
                text: qsTr("Data")
            }

            GrayLabel {
                Layout.minimumWidth: 60
                text: qsTr("CircleSend")
            }

            GrayLabel {
                Layout.fillWidth: true
                Layout.minimumWidth: 150
                Layout.preferredWidth: 200
                Layout.maximumWidth: 1000
                text: qsTr("Names")
            }

            GrayLabel {
                Layout.minimumWidth: 60
                text: qsTr("Save")
            }

            GrayLabel {
                Layout.minimumWidth: 60
                text: qsTr("ClickSend")
            }
        }

        Rectangle{
            width: 200
            height: 100
            color:'red'
        }

        ListView {
            id: list
            width: parent.width


            model: ListModel {
                ListElement {
                    address: "30"
                    code: "06"
                    data:"20030010 0000"
                    circleSend: false
                    name:"【获取电源数据】"
                }
            }
            delegate:Column {

                RowLayout {
                    width: list.width
                    spacing: 6
                    height: 30
                    HcdpInput {
                        Layout.minimumWidth: 68
                        myInput: address
                    }

                    HcdpInput {
                        Layout.minimumWidth: 68
                        myInput: code
                    }

                    HcdpInput {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 300
                        Layout.preferredWidth: 400
                        Layout.maximumWidth: 2000
                        myInput: data
                    }

                    GrayLabel {
                        text: qsTr("CircleSend")
                    }

                    GrayLabel {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 150
                        Layout.preferredWidth: 300
                        Layout.maximumWidth: 1000
                        text: qsTr("Names")
                    }

                    GrayLabel {
                        text: qsTr("Save")
                    }

                    GrayLabel {
                        text: qsTr("ClickSend")
                    }
                }

                Item {
                    width: list.width
                    height: 6
                }
            }
        }
    }
}
