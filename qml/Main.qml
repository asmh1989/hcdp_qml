import QtQuick
import QtQuick.Window
import QtQuick.Controls

Window {
    width: 1000
    height: 640
    visible: true
    title: qsTr("hcdp客户端")
    // x: 0

    readonly property int margin: 10

    property int cellWidth: 50
    property bool isOpen: false

    property int sendFrames: 0
    property int recvFrames: 0
    property int errorFrames: 0

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
                anchors.bottomMargin: ss.height + 10
                width: parent.width
            }

            FooterStatus {
                id: ss
                height: 20
                anchors.bottom: parent.bottom
                width: parent.width
            }

        }
    }

    Component.onCompleted: {
    }

    onIsOpenChanged: {
        if(isOpen){
            sendFrames = 0
            recvFrames = 0
            errorFrames = 0
        }
    }

    Connections {
        target: sm

        function onShowToast(msg) {
            console.log("showToast msg = "+ msg);
            toast.show(msg, 3000);
        }
    }
}
