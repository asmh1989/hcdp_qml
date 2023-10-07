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
        anchors.rightMargin: 16
        anchors.topMargin: 4
        anchors.bottomMargin: 4

        anchors.fill: parent

        Item {
            width: parent.width
            height: parent.height

            Rectangle{
                id: left
                border.color: 'black'
                border.width: 1
                height: parent.height
                anchors.left: parent.left
                width: parent.width* 0.45


                ListView {
                    id: listView
                    anchors.fill: parent
                    anchors.margins: 1
                    boundsBehavior: Flickable.StopAtBounds
                    boundsMovement: Flickable.StopAtBounds
                    clip: true
                    ScrollBar.vertical: ScrollBar {
                        active: true
                    }
                    header: Text {
                        text: " 先选中, 在右键进行操作"
                        wrapMode: Text.Wrap
                        font.pointSize: 10
                        font.family: "Consolas"
                    }

                    model: sm.saveSerialDataList
                    //modelData.name+"_"+modelData.addr+"_"+modelData.code+"_"+modelData.data
                    delegate:
                        Item {
                        width: parent.width
                        height: 20


                        Rectangle {
                            id:rectangle
                            width: parent.width
                            height: parent.height
                            // 根据选中状态设置背景颜色
                            color: listView.currentIndex === index ? "lightblue" : "white"

                            Text {
                                text: modelData.name+"_"+modelData.addr+"_"+modelData.code+"_"+modelData.data


                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton

                                onClicked: (mouse) => {
                                    if (mouse.button === Qt.LeftButton) {
                                        listView.currentIndex = index;
                                    } else if (mouse.button === Qt.RightButton && listView.currentIndex == index ) {
                                        // 计算鼠标点击的位置，并将位置信息传递给Menu
                                        contextMenu.x = mouseArea.mouseX;
                                        contextMenu.y = mouseArea.mouseY;
                                        contextMenu.open();                                    }

                                }

                            }

                            Menu {
                                id: contextMenu
                                MenuItem {
                                    text: "Action 1"
                                    onTriggered: {
                                        console.log("Action 1 triggered for item:", model.name);
                                    }
                                }
                                MenuItem {
                                    text: "Action 2"
                                    onTriggered: {
                                        console.log("Action 2 triggered for item:", model.name);
                                    }
                                }

//                                function open(x, y) {
//                                    contextMenu.x = x;
//                                    contextMenu.y = y;
//                                    contextMenu.open();
//                                }
                            }
                        }

                        states: [
                            State {
                                name: "selected"
                                when: listView.currentIndex === index
                                PropertyChanges { target: rectangle; color: "lightblue" }
                            }
                        ]

                        transitions: Transition {
                            from: "*"
                            to: "selected"
                            reversible: true
                            ColorAnimation { properties: "color"; duration: 200 }
                        }
                    }


                }
            }


            Rectangle{
                border.color: '#50A0FF'
                border.width: 1
                anchors.left: left.right
                anchors.leftMargin: 4
                radius: 4
                height: parent.height
                width: parent.width * 0.55 - 6

                ScrollView {
                    anchors.fill: parent
                    anchors.margins: 2
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                    TextArea {
                        id: area
                        wrapMode: Text.Wrap
                        font.pointSize: 10
                        font.family: "Consolas"
                        selectByMouse: true
                    }
                }


            }
        }
    }

    Connections {
        target: sm

        function onSerialData(msg) {

            if (msg.length === 0) {  // clear
                area.text = ""
            } else {
                area.text += msg
                area.text += "...................................................................\n"
                area.cursorPosition = area.length-1
            }

        }
    }

}
