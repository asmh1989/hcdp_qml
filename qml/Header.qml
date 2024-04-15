import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Rectangle {
    property int times: 0


    SettingDialog{
        id: ss
    }

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
            Layout.preferredWidth: 300
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
            visible: false
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



        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: 80
            text: qsTr("Settings")
            onClicked: () => {
                           ss.open()
                       }
        }




    }

    Connections {
        target: sm
    }
}
