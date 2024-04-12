import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Rectangle {
    property bool isOpen: false
    property int times: 0

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6
        anchors.fill: parent

        GrayLabel {
            text: qsTr("Port")
            Layout.fillHeight: true
            Layout.preferredWidth: 40
        }

        ComboBox {
            id: port
            Layout.preferredWidth: 200
            editable: true
            enabled: !isOpen
            selectTextByMouse: true
            Layout.fillHeight: true
            model: sm.getSerialPortList()
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: 60
            text: qsTr("Refresh")

            onClicked: () => {
                           port.model = sm.getSerialPortList()
                       }
        }

        ComboBox {
            id: rate
            Layout.preferredWidth: 60
            Layout.fillHeight: true
            currentIndex: 3
            model: [9600, 19200, 38400, 115200]
        }

        Button {
            id: btn
            Layout.fillHeight: true
            Layout.preferredWidth: 40
            text: qsTr("Open")
            onClicked: () => {
                           if (port.model.length === 0) {
                               sm.showGlobalToast("no serial port found!!")
                               return
                           }
                           if (!isOpen) {
                               var res = sm.openSerialPort(port.currentIndex,
                                                           rate.currentValue)
                               if (res.length === 0) {
                                   isOpen = true
                                   btn.text = "Close"
                               } else {
                                   sm.showGlobalToast(res)
                               }
                           } else {
                               sm.closeSerialPort()
                               isOpen = false
                               btn.text = "Open"
                           }
                       }
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: 80
            text: qsTr("ClearRecv")
            onClicked: sm.clearCache()
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: 80
            text: qsTr("ClearLog")
            onClicked: sm.clearLog()
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: 80
            text: qsTr("addDemo")
            onClicked: sm.addDemo()
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: 80
            text: qsTr("SelectFile")
            visible: false
            onClicked: () => {
                           // 打开文件选择对话框
                           fileDialog.open()
                       }
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: 70
            enabled: !timer.running
            text: qsTr("AutoRun")
            visible: false
            onClicked: () => {
                           if (!timer.running) {
                               times = 0
                               timer.start()
                           }
                       }
        }

        Timer {
            id: timer
            triggeredOnStart: true
            repeat: true
            interval: 1500
            onTriggered: () => {
                             var d = sm.serialDataList
                             if (times < d.length) {
                                 var c = d[times]
                                 var res = sm.sendData(c.addr, c.code,
                                                       c.data, false)
                                 if (res.length !== 0) {
                                     sm.showGlobalToast(res)
                                     timer.stop()
                                     return
                                 } else {
                                     times += 1
                                 }
                             } else if (times === d.length) {
                                 sm.showGlobalToast(
                                     "auto send " + d.length + " sussess!!")
                                 timer.stop()
                             }
                         }
        }

        function delay(delayTime, cb) {
            timer.interval = delayTime
            timer.repeat = false
            timer.triggered.connect(cb)
            timer.start()
        }

        FileDialog {
            id: fileDialog
            title: "Select a File"
            nameFilters: ["Json files (*.json)"]
            //            folder: shortcuts.home // 设置默认文件夹
            onAccepted: {
                // 用户选择了文件
                console.log("Selected file:", fileDialog.selectedFile)
                var res = sm.selectFile(fileDialog.selectedFile)
                if (res.length !== 0) {
                    sm.showToast(res)
                } else {
                    sm.showToast("load success!")
                }
            }

            onRejected: {
                // 用户取消选择文件
                console.log("File selection canceled")
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Item {
            Layout.preferredWidth: 60
            Layout.fillHeight: true
            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                Text {
                    text: "SSD"
                    Layout.alignment: Qt.AlignVCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                }

                TextField {
                    text: sm.frameStart
                    width: 30
                    Layout.alignment: Qt.AlignVCenter
                    validator: RegularExpressionValidator {
                        regularExpression: /^[a-zA-Z0-9]{1,2}$/
                    }

                    onTextChanged: {
                        sm.frameStart = text
                    }
                }
            }
        }

        Item {
            Layout.preferredWidth: 60
            Layout.fillHeight: true
            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                Text {
                    text: "ESD"
                    Layout.alignment: Qt.AlignVCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                }
                TextField {
                    text: sm.frameEnd
                    width: 30
                    Layout.alignment: Qt.AlignVCenter
                    validator: RegularExpressionValidator {
                        regularExpression: /^[a-zA-Z0-9]{1,2}$/
                    }

                    onTextChanged: {
                        sm.frameEnd = text
                    }
                }
            }
        }

        ComboBox {
            id: encode
            Layout.preferredWidth: 58
            Layout.fillHeight: true
            currentIndex: sm.encodeIndex
            model: ["base64", "ascii"]

            onCurrentIndexChanged: {
                sm.encodeIndex = encode.currentIndex
            }

            // Component.onCompleted: () => {
            //     scale.currentIndex = sm.encodeIndex
            // }
        }

        GrayLabel {
            text: qsTr("Scale")
            Layout.preferredWidth: 40
            Layout.fillHeight: true
        }

        ComboBox {
            id: scale
            Layout.preferredWidth: 48
            Layout.fillHeight: true
            currentIndex: 0
            model: ["1.0", "1.25", "1.5", "2.0"]

            onCurrentIndexChanged: {
                // 当用户改变了ComboBox的选择时，更新someValue的值
                var now = scale.model[currentIndex]
                if (now !== sm.getScaleCache()) {
                    sm.setScaleCache(now + "")
                    sm.showGlobalToast("scale = " + now + " 重启生效!")
                }
            }

            Component.onCompleted: () => {
                                       var now = sm.getScaleCache()
                                       console.log(" now = " + now)
                                       scale.currentIndex = scale.model.indexOf(
                                           now)
                                   }
        }

        //        CheckBox {
        //            height: parent.height
        //            anchors.verticalCenter: parent.verticalCenter
        //            text: qsTr("CircleSend")
        //        }
    }

    Connections {
        target: sm
    }
}
