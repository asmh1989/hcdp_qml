import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Qt.labs.settings 1.0

Window {
    width: 1000
    height: 640
    visible: true
    title: qsTr("hcdp客户端V0.1")
    x: 0

    readonly property int margin: 10
    property int cellWidth: 50

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
                height: 30
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

    Settings {
        id: appSettings
        property string ssd: ""
        property string esd: ""
    }

    Connections {
        target: sm

        function onShowToast(msg) {
            console.log("showToast msg = " + msg)
            toast.show(msg, 3000)
        }
    }
}
