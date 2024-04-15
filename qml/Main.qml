import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtCore

Window {
    width: 1000
    height: 640
    visible: true
    title: qsTr("Serial Frame Monitor  V 0.1.1")
    x: 0

    readonly property int margin: 10
    property int cellWidth: 50
    property bool isOpen: false

    property var encodeArr: ["base64", "ascii"]

    property var stopArr: ["1", "1.5", "2"]

    property var parityArr: ["No", "Even", "Odd", "Space", "Mark"]

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

    Settings {
        id: appSettings
        property string ssd: "24"
        property string esd: "0d"
        property int encodeIndex: 0
        property bool saveLog: true
        property int stopIndex: 0
        property int parityIndex: 0
        Component.onCompleted: {
            sm.frameStart = ssd
            sm.frameEnd = esd
            sm.encodeIndex = encodeIndex
            sm.setStopBits(stopIndex)
            sm.setParity(parityIndex)
            sm.setAutoSaveLog(saveLog)
        }

        onEncodeIndexChanged: {
            sm.encodeIndex = encodeIndex
        }

        onSsdChanged: {
            sm.frameStart = ssd
        }

        onEsdChanged: {
            sm.frameEnd = esd
        }

        onParityIndexChanged: {
            sm.setParity(parityIndex)
        }

        onStopIndexChanged: {
            sm.setStopBits(stopIndex)
        }
        onSaveLogChanged: {
            sm.setAutoSaveLog(saveLog)
        }
    }

    Connections {
        target: sm

        function onShowToast(msg) {
            console.log("showToast msg = " + msg)
            toast.show(msg, 3000)
        }
    }
}
