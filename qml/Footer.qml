import QtQuick

import QtQuick.Controls
import QtQuick.Layouts



Rectangle{
    color: 'transparent'
    border.color: '#50A0FF'
    border.width: 1
    radius: 4
    width: parent.width

    Item {
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.topMargin: 4
        anchors.bottomMargin: 4

        anchors.fill: parent

        Item {
            width: parent.width
            height: parent.height

            Rectangle{
                id: left
                border.color: 'black'
                border.width: 1
                height: parent.height
                anchors.left: parent.left
                width: parent.width* 0.45
            }

            Rectangle{
                border.color: '#50A0FF'
                border.width: 1
                anchors.left: left.right
                anchors.leftMargin: 4
                radius: 4
                height: parent.height
                width: parent.width * 0.55 - 6

                ScrollView {
                    anchors.fill: parent
                    anchors.margins: 2

                    TextArea {

                        wrapMode: Text.Wrap
                        font.pointSize: 10
                        selectByMouse: true

                    }
                }


            }
        }
    }
}
