import QtQuick

Rectangle {
    property alias myInput: inputField.text

    height: parent.height
    border.color: '#50A0FF'
    border.width: 1
    radius: 4

    TextInput {
        anchors.margins: 4
        id: inputField
        anchors.fill: parent
        //        anchors.margins: 2
        font.pointSize: 10
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        selectByMouse: true
        clip: true
    }
}
