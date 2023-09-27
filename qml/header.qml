import QtQuick
import QtQuick.Controls


Control {
    width: parent.width
    height: 64
    padding: 16

    background: Rectangle{
        color: 'transparent'
        border.color: '#50A0FF'
        border.width: 1
        radius: 4
        anchors.fill: parent
    }

    contentItem:Row {
        height: 24
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6
        GrayLabel {
            text: qsTr("SerialPort")
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
