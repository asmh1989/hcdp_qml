import QtQuick
import QtQuick.Controls
import QtQuick.Layouts



Rectangle{
    color: 'transparent'
    border.color: '#50A0FF'
    border.width: 1
    radius: 4

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
                model: sm.serialDataList
                delegate:Column {
                    height: header.height+6
                    Row {
                        width: listView.width
                        spacing: 6
                        height: header.height

                        HcdpInput {
                            id: s_addr
                            width: h_addr.width
                            myInput: modelData.addr
                        }
                        HcdpInput {
                            id: s_code
                            width: h_code.width
                            myInput: modelData.code
                        }
                        HcdpInput {
                            id: s_data
                            width: h_data.width
                            myInput: modelData.data
                        }

                        Item {
                            height: parent.height
                            width: h_circle.width
                            CheckBox {
                                id: checked
                                anchors.centerIn: parent
                                checked: modelData.circle
                            }
                        }

                        HcdpInput {
                            width: h_name.width
                            myInput: modelData.name
                        }

                        Button {
                            height: parent.height
                            width: h_save.width
                            text: qsTr("Save")
                            onClicked: ()=> {
                                           var d = sm.saveSerialDataList;
                                           d.push(modelData)
                                           sm.saveSerialDataList = d
                                       }
                        }

                        Button {
                            height: parent.height
                            width: h_click.width
                            text: qsTr("ClickSend")
                            onClicked: ()=> {


                                           var res = sm.sendData(s_addr.myInput, s_code.myInput, s_data.myInput, checked.checked);
                                           if (res.length !== 0) {
                                               sm.showGlobalToast(res);
                                           } else {
                                               if(s_addr.myInput !== modelData.addr || s_code.myInput !== modelData.code || s_data.myInput !== modelData.data) {
                                                   var d = sm.serialDataList;
                                                   var d2 = d[index];
                                                   d2.addr = s_addr.myInput;
                                                   d2.code = s_code.myInput;
                                                   d2.data = s_data.myInput;
                                                   sm.serialDataList =  d;
                                               }
                                           }
                                       }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        // 将 QVariant 转换为 JSON 字符串
        //        var jsonStr = JSON.stringify(sm.serialDataList);

        //        // 将 JSON 字符串解析为 JavaScript 对象
        //        var jsonObject = JSON.parse(jsonStr);

        // 打印 JSON 对象
        //        console.log("JSON Object:", jsonStr, "  ");
    }

    Connections {
        target: sm
    }

}
