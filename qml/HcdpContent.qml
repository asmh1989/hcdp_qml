import QtQuick
import QtQuick.Controls
import QtQuick.Layouts



Rectangle{
    color: 'transparent'
    border.color: '#50A0FF'
    border.width: 1
    radius: 4
    width: parent.width
    height: parent.height * 0.4

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 6

        RowLayout {
            id: header
            width: parent.width
            height: 30
            spacing: 6

            GrayLabel {
                id: h_addr
                text: qsTr("Address")
                Layout.minimumWidth: 60

            }
            GrayLabel {
                id: h_code
                Layout.minimumWidth: 60
                text: qsTr("Code")
            }

            GrayLabel {
                id:h_data
                Layout.fillWidth: true
                Layout.minimumWidth: 300
                Layout.preferredWidth: 400
                Layout.maximumWidth: 2000
                text: qsTr("Data")
            }

            GrayLabel {
                id: h_circle
                Layout.minimumWidth: 60
                text: qsTr("CircleSend")
            }

            GrayLabel {
                id: h_name
                Layout.fillWidth: true
                Layout.minimumWidth: 150
                Layout.preferredWidth: 200
                Layout.maximumWidth: 1000
                text: qsTr("Names")
            }

            GrayLabel {
                id: h_save
                Layout.minimumWidth: 60
                text: qsTr("Save")
            }

            GrayLabel {
                id: h_click
                Layout.minimumWidth: 60
                text: qsTr("ClickSend")
            }
        }

        ListView {

            id: listView
            width: parent.width
            Layout.fillHeight: true
            Layout.minimumHeight: 200
            Layout.preferredHeight: 400
            Layout.maximumHeight: 2000

            model: ListModel {
                ListElement {
                    address: "30"
                    code: "06"
                    sdata: "20030010 0000"
                    circleSend: false
                    name: "【获取电源数据】"
                }
            }
            delegate:Column {
                Row {
                    width: listView.width
                    spacing: 6
                    height: header.height
                    HcdpInput {
                        width: h_addr.width
                        myInput: address
                    }
                    HcdpInput {
                        width: h_code.width
                        myInput: code
                    }
                    HcdpInput {
                        width: h_data.width
                        myInput: sdata
                    }

                    GrayLabel {
                        width: h_circle.width
                        text: qsTr("CircleSend")
                    }

                    GrayLabel {
                        width: h_name.width
                        text: qsTr("Names")
                    }

                    GrayLabel {
                        width: h_save.width
                        text: qsTr("Save")
                    }

                    GrayLabel {
                        width: h_click.width
                        text: qsTr("ClickSend")
                    }
                }

                Item {
                    width: 1
                    height: 6
                }
            }
        }
    }
}
