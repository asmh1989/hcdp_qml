import QtQuick
import QtQuick.Controls
import QtQuick.Layouts



Rectangle{
    color: 'transparent'
    border.color: '#50A0FF'
    border.width: 1
    radius: 4
    width: parent.width

    Item {
        anchors.leftMargin: 16
        anchors.topMargin: 16
        anchors.bottomMargin: 16

        anchors.fill: parent

        Column {
            anchors.fill: parent
            spacing: 6
            clip: true
            id: root

            RowLayout {
                id: header
                width: parent.width - 20
                spacing: 6

                GrayLabel {
                    id: h_addr
                    text: qsTr("Address")
                    padding: 6
                    Layout.minimumWidth: 60
                }
                GrayLabel {
                    id: h_code
                    Layout.minimumWidth: 60
                    text: qsTr("Code")
                    padding: 6
                }

                GrayLabel {
                    id:h_data
                    Layout.fillWidth: true
                    Layout.minimumWidth: 300
                    Layout.preferredWidth: 400
                    Layout.maximumWidth: 2000
                    text: qsTr("Data")
                    padding: 6
                }

                GrayLabel {
                    id: h_circle
                    Layout.minimumWidth: 60
                    text: qsTr("CircleSend")
                    padding: 6
                }

                GrayLabel {
                    id: h_name
                    Layout.fillWidth: true
                    Layout.minimumWidth: 150
                    Layout.preferredWidth: 200
                    Layout.maximumWidth: 1000
                    text: qsTr("Names")
                    padding: 6
                }

                GrayLabel {
                    id: h_save
                    Layout.minimumWidth: 60
                    text: qsTr("Save")
                    padding: 6
                }

                GrayLabel {
                    id: h_click
                    Layout.minimumWidth: 60
                    text: qsTr("ClickSend")
                    padding: 6
                }
            }

            ListView {

                id: listView
                width: parent.width - 4
                height: root.height - header.height
                boundsBehavior: Flickable.StopAtBounds
                boundsMovement: Flickable.StopAtBounds
                clip: true
                ScrollBar.vertical: ScrollBar {
                    active: true
                }
                model: ListModel {
                    ListElement {
                        address: "30"
                        code: "06"
                        sdata: "20030010 0000"
                        circleSend: false
                        name: "【获取电源数据】"
                    }
                    ListElement {
                        address: "30"
                        code: "06"
                        sdata: "20030010 0000"
                        circleSend: false
                        name: "【获取电源数据】"
                    }

                    ListElement {
                        address: "30"
                        code: "06"
                        sdata: "20030010 0000"
                        circleSend: false
                        name: "【获取电源数据】"
                    }

                    ListElement {
                        address: "30"
                        code: "06"
                        sdata: "20030010 0000"
                        circleSend: false
                        name: "【获取电源数据】"
                    }

//                    ListElement {
//                        address: "30"
//                        code: "06"
//                        sdata: "20030010 0000"
//                        circleSend: false
//                        name: "【获取电源数据】"
//                    }

//                    ListElement {
//                        address: "36"
//                        code: "06"
//                        sdata: "20030010 0000"
//                        circleSend: false
//                        name: "【获取电源数据】"
//                    }

//                    ListElement {
//                        address: "37"
//                        code: "06"
//                        sdata: "20030010 0000"
//                        circleSend: false
//                        name: "【获取电源数据】"
//                    }

//                    ListElement {
//                        address: "38"
//                        code: "06"
//                        sdata: "20030010 0000"
//                        circleSend: false
//                        name: "【获取电源数据】"
//                    }
                }
                delegate:Column {
                    height: header.height+6
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

                        Item {
                            height: parent.height
                            width: h_circle.width
                            CheckBox {
                                anchors.centerIn: parent
                                checked: circleSend
                            }
                        }

                        HcdpInput {
                            width: h_name.width
                            myInput: name
                        }

                        Button {
                            height: parent.height
                            width: h_save.width
                            text: qsTr("Save")
                            onClicked: ()=> {
                                           console.log("h_addr.height: "+ h_addr.height
                                                       +" header.height =" + header.height
                                                       +" listView.height = "+ listView.height
                                                       +" root.height = "+ root.height)
                                       }
                        }

                        Button {
                            height: parent.height
                            width: h_click.width
                            text: qsTr("ClickSend")
                        }
                    }
                }
            }
        }
    }
}
