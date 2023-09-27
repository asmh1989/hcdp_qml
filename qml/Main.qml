import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    width: 1000
    height: 640
    visible: true
    title: qsTr("hcdp客户端")


    readonly property int margin: 10

    Control {
        padding: margin
        anchors.fill: parent

        background: Rectangle {
            anchors.fill: parent
            color: '#F3F9FF'
        }

        contentItem: Column {
            spacing: margin
            Header {

            }

            HcdpContent {

            }

//            Row {
//                spacing: 10
//                anchors.centerIn: parent

//                Text { text: qsTr("请输入密码：") ; font.pointSize: 15
//                    verticalAlignment: Text.AlignVCenter }

//                Rectangle {
//                    width: 30
//                    height: 30
//                    color: "lightgrey"
//                    border.color: "grey"

//                    TextInput {
//                        anchors.fill: parent
//                        anchors.margins: 2
//                        font.pointSize: 15
//                        focus: true
//                    }
//                }
//            }
        }
    }

}
