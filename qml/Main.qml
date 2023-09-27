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

            Header {

            }
        }
    }

}
