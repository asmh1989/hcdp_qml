import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Rectangle{
    color: 'transparent'
    border.color: '#50A0FF'
    border.width: 1
    radius: 4

    property bool isOpen: false
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
            selectTextByMouse: true
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            model:sm.getSerialPortList()
        }

        Button {
            height: parent.height
            width: 80
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("Refresh")

            onClicked: ()=> {
                           //                           console.log("refresh ...")
                           port.model = sm.getSerialPortList();
                       }
        }

        GrayLabel {
            text: qsTr("Rate")
            width: 60
        }

        ComboBox {
            id: rate
            width: 80
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            currentIndex: 3
            model:[9600, 19200, 38400, 115200]
        }

        Button {
            id: btn
            height: parent.height
            width: 80
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("OpenSerial")
            onClicked: ()=> {
                           if(!isOpen){
                               var res = sm.openSerialPort(port.currentIndex, rate.currentValue);
                               if (res.length === 0) {
                                   isOpen = true;
                                   btn.text = "CloseSerial"
                               } else {
                                   sm.showGlobalToast(res);
                               }
                           } else {
                               sm.closeSerialPort();
                               isOpen = false;
                               btn.text = "OpenSerial"
                           }

                       }
        }

        Button {
            height: parent.height
            width: 80
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("ClearCache")
            onClicked: sm.clearCache()
        }


        Button {
            height: parent.height
            width: 80
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("SelectFile")
            onClicked: ()=>{
                           // 打开文件选择对话框
                           fileDialog.open();
                       }
        }

        Button {
            height: parent.height
            width: 80
            enabled: !timer.running
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("AutoRun")
            onClicked: ()=>{
                           if(!timer.running){
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
            onTriggered: ()=>{
                             var d = sm.serialDataList;
                             if (times < d.length){
                                 var c = d[times]
                                 var res = sm.sendData(c.addr, c.code, c.data, false);
                                 if (res.length !== 0) {
                                     sm.showGlobalToast(res);
                                     timer.stop()
                                     return;
                                 } else {
                                     times +=1
                                 }
                             } else  if(times === d.length){
                                 sm.showGlobalToast("auto send "+ d.length+" sussess!!")
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
            nameFilters:["Json files (*.json)"]
            //            folder: shortcuts.home // 设置默认文件夹
            onAccepted: {
                // 用户选择了文件
                console.log("Selected file:", fileDialog.selectedFile);
                var res = sm.selectFile(fileDialog.selectedFile);
                if(res.length !== 0) {
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

        //        ComboBox {
        //            width: 60
        //            height: parent.height
        //            anchors.verticalCenter: parent.verticalCenter
        //            currentIndex: 1
        //            model:[150, 200, 250, 300,400]
        //        }

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
