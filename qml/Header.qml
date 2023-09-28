import QtQuick
import QtQuick.Controls


Rectangle{
    color: 'transparent'
    border.color: '#50A0FF'
    border.width: 1
    radius: 4
    width: parent.width

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
            width: 160
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            model:["First", "Second", "Third"]
        }

        Button {
            height: parent.height
            width: 80
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("Refresh")
        }

        GrayLabel {
            text: qsTr("Rate")
            width: 60
        }

        ComboBox {
            width: 80
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            currentIndex: 3
            model:[9600, 19200, 38400, 115200]
        }

        Button {
            height: parent.height
            width: 80
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("OpenPort")
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

}
