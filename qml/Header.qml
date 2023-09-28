import QtQuick
import QtQuick.Controls

Rectangle{
    color: 'transparent'
    border.color: '#50A0FF'
    border.width: 1
    radius: 4
    width: parent.width

    property bool isOpen: false

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
//                                   console.log("err : "+ res);
                                   sm.showToast(res);
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
        }

        ComboBox {
            width: 60
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            currentIndex: 1
            model:[150, 200, 250, 300,400]
        }

        CheckBox {
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("CircleSend")
        }
    }

//    Component.onCompleted: {
//        sm.onShowToast.connect(showToast2);
//    }


    Connections {
        target: sm
    }

}
