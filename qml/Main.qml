import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 1000
    height: 640
    visible: true
    title: qsTr("hcdp客户端")


    readonly property int margin: 10

    Rectangle {
        anchors.fill: parent
        color: '#F3F9FF'
        Item {
            anchors.fill: parent
            anchors.margins: margin
            Header {
                id: header
                height: 60

            }

            HcdpContent {
                id: content
                anchors.top: header.bottom
                anchors.topMargin: margin
                height: parent.height * 0.42
            }

            Footer {
                anchors.top: content.bottom
                anchors.topMargin: margin
                anchors.bottom: parent.bottom
            }

        }
    }
}
