import QtQuick

Rectangle {
    property string myInput:""
    height: parent.height
    border.color: '#50A0FF'
    border.width: 1
    radius: 4

    TextInput {
        anchors.fill: parent
//        anchors.margins: 2
        font.pointSize: 10
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        text: myInput
        selectByMouse: true
    }
}
