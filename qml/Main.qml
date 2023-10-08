import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    width: 960
    height: 640
    visible: true
    title: qsTr("hcdp客户端")
    x: 0

    readonly property int margin: 10

    ToastManager {
        id: toast
    }


    Rectangle {
        anchors.fill: parent
        color: '#F3F9FF'
        Item {
            anchors.fill: parent
            anchors.margins: margin
            Header {
                id: header
                height: 60
                width: parent.width
            }

            HcdpContent {
                id: content
                anchors.top: header.bottom
                anchors.topMargin: margin
                height: parent.height * 0.42
                width: parent.width
            }

            Footer {
                anchors.top: content.bottom
                anchors.topMargin: margin
                anchors.bottom: parent.bottom
                width: parent.width
            }

        }
    }

    Component.onCompleted: {
    }


    Connections {
        target: sm

        function onShowToast(msg) {
            console.log("showToast msg = "+ msg);
            toast.show(msg, 3000);
        }
    }
}
