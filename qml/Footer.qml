import QtQuick

import QtQuick.Controls
import QtQuick.Layouts

Rectangle {

    border.color: '#50A0FF'
    border.width: 1
    anchors.left: left.right
    anchors.leftMargin: 4
    height: parent.height
    width: parent.width
    Text {
        z: 1
        text:"log output"
        font.pixelSize: 30
        anchors.centerIn: parent
        opacity: 0.3
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 2
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        TextArea {
            id: area
            wrapMode: Text.Wrap
            font.pointSize: 8
            textFormat: Text.RichText
            font.family: "Consolas"
            selectByMouse: true
        }
    }

    Connections {
        target: sm

        function onSerialData(msg) {
            if (msg.length === 0) {
                area.text = ""
            } else {
                area.text += msg
                area.cursorPosition = area.length - 1
            }
        }
    }
}
