import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Rectangle {
    color: 'transparent'
    border.color: '#50A0FF'
    border.width: 1
    radius: 4

    property int times: 0

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6
        anchors.fill: parent
        anchors.margins: 16

        GrayLabel {
            text: qsTr("SerialPort")
            width: 80
        }

        ComboBox {
            id: port
            width: 200
            editable: true
            enabled: !isOpen
            selectTextByMouse: true
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            model: sm.getSerialPortList()
        }

        Button {
            height: parent.height
            width: 80
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Refresh")

            onClicked: () => {
                //                           console.log("refresh ...")
                port.model = sm.getSerialPortList();
            }
        }

        GrayLabel {
            text: qsTr("Rate")
            width: 40
        }

        ComboBox {
            id: rate
            width: 80
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            currentIndex: 3
            model: [9600, 19200, 38400, 115200]
        }

        Button {
            id: btn
            height: parent.height
            width: 80
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("OpenSerial")
            onClicked: () => {
                if (port.model.length === 0) {
                    sm.showGlobalToast("no serial port found!!");
                    return;
                }
                if (!isOpen) {
                    var res = sm.openSerialPort(port.currentIndex, rate.currentValue);
                    if (res.length === 0) {
                        isOpen = true;
                        btn.text = "CloseSerial";
                    } else {
                        sm.showGlobalToast(res);
                    }
                } else {
                    sm.closeSerialPort();
                    isOpen = false;
                    btn.text = "OpenSerial";
                }
            }
        }

        Button {
            height: parent.height
            width: 80
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("ClearCache")
            onClicked: sm.clearCache()
        }

        // Button {
        //     height: parent.height
        //     width: 80
        //     anchors.verticalCenter: parent.verticalCenter
        //     text: qsTr("SelectFile")
        //     onClicked: () => {
        //         // 打开文件选择对话框
        //         fileDialog.open();
        //     }
        // }

        ComboBox {
            id: intervalT
            width: 60
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            currentIndex: 2
            model: [30, 50, 60, 80, 100, 150, 200]
        }

        Button {
            height: parent.height
            width: 70
            // enabled: !timer.running
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("AutoRun")
            onClicked: () => {
                if (!timer.running) {
                    times = 0;
                    timer.start();
                                        sm.serialData("start\n")

                } else {
                    timer.stop();
                    sm.serialData("stop\n")
                }
            }
        }

        Timer {
            id: timer
            triggeredOnStart: true
            repeat: true
            interval: intervalT.currentValue
            onTriggered: () => {
                var d = sm.serialDataList;
                if (times < 1000) {
                    var c = d[times % d.length];
                    console.log(" send times = "+ times);
                    var res = sm.sendData(c.addr, c.code, c.data, false);
                    if (res.length !== 0) {
                        sm.showGlobalToast(res);
                        timer.stop();
                        return;
                    } else {
                        times += 1;
                    }
                } else  {
                    sm.showGlobalToast("auto send " + times + " sussess!!");
                    sm.serialData("auto send " + times + " sussess!!\n")

                    timer.stop();
                }
            }
        }

        function delay(delayTime, cb) {
            timer.interval = delayTime;
            timer.repeat = false;
            timer.triggered.connect(cb);
            timer.start();
        }

        FileDialog {
            id: fileDialog
            title: "Select a File"
            nameFilters: ["Json files (*.json)"]
            //            folder: shortcuts.home // 设置默认文件夹
            onAccepted: {
                // 用户选择了文件
                console.log("Selected file:", fileDialog.selectedFile);
                var res = sm.selectFile(fileDialog.selectedFile);
                if (res.length !== 0) {
                    sm.showToast(res);
                } else {
                    sm.showToast("load success!");
                }
            }

            onRejected: {
                // 用户取消选择文件
                console.log("File selection canceled");
            }
        }

        GrayLabel {
            text: qsTr("Scale:")
            width: 40
        }

        ComboBox {
            id: scale
            width: 48
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            currentIndex: 0
            model: ["1.0", "1.25", "1.5", "2.0"]

            onCurrentIndexChanged: {
                // 当用户改变了ComboBox的选择时，更新someValue的值
                var now = scale.model[currentIndex];
                if (now !== sm.getScaleCache()) {
                    sm.setScaleCache(now + "");
                    sm.showGlobalToast("scale = " + now + " 重启生效!");
                }
            }

            Component.onCompleted: () => {
                var now = sm.getScaleCache();
                console.log(" now = " + now);
                scale.currentIndex = scale.model.indexOf(now);
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
