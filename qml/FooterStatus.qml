import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Rectangle {
    color: '#d2f4f2'

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent

        Row {
            Layout.fillHeight: true
            Layout.preferredWidth: cellWidth * 2.4
            Text {
                text: "SendFrames: "
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: sendFrames
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Row {
            Layout.fillHeight: true
            Layout.preferredWidth: cellWidth * 2.4
            Text {
                text: "RxFrames: "
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: recvFrames
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Row {
            Layout.fillHeight: true
            Layout.preferredWidth: cellWidth * 2

            Text {
                text: "RxErrors: "
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: errorFrames
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            Layout.fillHeight: true
            Layout.preferredWidth: cellWidth * 2

            Text {
                text: "sendFreg: "
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: sendFreq
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            Layout.fillHeight: true
            Layout.preferredWidth: cellWidth * 2

            Text {
                text: "recvFreg: "
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: recvFreg
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Row {
        //     Layout.fillHeight: true
        //     Layout.preferredWidth: cellWidth*1.2
        //     Text {
        //         text:"Head: 0x"
        //         anchors.verticalCenter: parent.verticalCenter
        //     }

        //     Text {
        //         text: appSettings.ssd
        //         anchors.verticalCenter: parent.verticalCenter
        //     }
        // }

        // Row {
        //     Layout.fillHeight: true
        //     Layout.preferredWidth: cellWidth*1.2
        //     Text {
        //         text:"Tail: 0x"
        //         anchors.verticalCenter: parent.verticalCenter
        //     }

        //     Text {
        //         text: appSettings.esd
        //         anchors.verticalCenter: parent.verticalCenter
        //     }
        // }
        // Item {
        //     Layout.fillHeight: true
        //     Layout.preferredWidth: cellWidth
        //     Text {
        //         anchors.centerIn: parent
        //         text: encodeArr[appSettings.encodeIndex]
        //     }
        // }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Rectangle {
        //     Layout.fillHeight: true
        //     Layout.preferredWidth: cellWidth * 2
        //     color:'#00b050'
        //     Text {
        //         anchors.centerIn: parent
        //         text: appSettings.saveLog ?  "Auto Save Log" : "Not Save Log"
        //         color: 'white'
        //     }
        // }
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: cellWidth * 1.2
            color: '#00b050'
            Text {
                id: tt
                anchors.centerIn: parent
                text: isOpen ? "RUNNING" : "CLOSED"
                color: 'white'
            }
        }
    }

    Connections {
        target: sm

        function onSerialData(msg) {
            var nn = new Date().getTime()

            if (msg.includes("Send")) {
                sendFrames += 1
                if (sendTime === 0) {
                    sendTime = new Date().getTime()
                } else {
                    sendFreq = nn - sendTime
                    sendTime = nn
                }
            } else {
                if (msg.includes("Recv")) {
                    recvFrames += 1
                    if (msg.includes("ERROR")) {
                        errorFrames += 1
                    }

                    if (recvTime === 0) {
                        recvTime = new Date().getTime()
                    } else {
                        recvFreg = nn - recvTime
                        recvTime = nn
                    }
                }
            }
        }
    }
}
