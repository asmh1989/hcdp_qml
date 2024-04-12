import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {

    Item {
        anchors.fill: parent

        Column {
            anchors.fill: parent
            clip: true
            id: root

            RowLayout {
                id: header
                width: parent.width
                height: 20
                spacing: 0

                GrayLabel {
                    id: h_1
                    text: qsTr("No.")
                    Layout.minimumWidth: cellWidth
                    Layout.fillHeight: true
                }
                GrayLabel {
                    id: h_2
                    Layout.minimumWidth: cellWidth * 2
                    Layout.fillHeight: true
                    text: qsTr("Time")
                }

                GrayLabel {
                    id: h_3
                    Layout.minimumWidth: cellWidth
                    Layout.fillHeight: true
                    text: qsTr("FmCls")
                }

                GrayLabel {
                    id: h_4
                    Layout.fillHeight: true
                    Layout.minimumWidth: cellWidth
                    text: qsTr("DstAddr")
                }

                GrayLabel {
                    id: h_5
                    Layout.fillHeight: true
                    Layout.minimumWidth: cellWidth
                    text: qsTr("SrcAddr")
                }
                GrayLabel {
                    id: h_6
                    Layout.fillHeight: true
                    Layout.minimumWidth: cellWidth
                    text: qsTr("FmLen")
                }
                GrayLabel {
                    id: h_7
                    Layout.fillHeight: true
                    Layout.minimumWidth: cellWidth
                    text: qsTr("DgTag")
                }
                GrayLabel {
                    id: h_8
                    Layout.fillHeight: true
                    Layout.minimumWidth: cellWidth
                    text: qsTr("DstPt")
                }
                GrayLabel {
                    id: h_9
                    Layout.fillHeight: true
                    Layout.minimumWidth: cellWidth
                    text: qsTr("SrcPt")
                }
                GrayLabel {
                    id: h_10
                    Layout.fillHeight: true
                    Layout.minimumWidth: cellWidth
                    text: qsTr("DgLen")
                }
                GrayLabel {
                    id: h_11
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: qsTr("Data")
                }

                GrayLabel {
                    id: h_12
                    Layout.fillHeight: true
                    Layout.minimumWidth: cellWidth * 2
                    padding: 4
                    text: qsTr("Info")
                }
            }

            ListView {
                id: listView
                width: parent.width
                height: root.height - header.height
                boundsBehavior: Flickable.StopAtBounds
                boundsMovement: Flickable.StopAtBounds
                clip: true
                ScrollBar.vertical: ScrollBar {
                    active: true
                    policy: ScrollBar.AlwaysOn
                }
                model: sm.serialDataList
                delegate: Rectangle {
                    height: 20
                    width: parent.width
                    color: index % 2 === 0 ? 'white' : '#9beec7'

                    Row {
                        anchors.fill: parent
                        CenterText {
                            width: h_1.width
                            height: parent.height
                            text: (index + 1) + ""
                        }
                        CenterText {
                            width: h_2.width
                            height: parent.height
                            text: modelData.time
                        }
                        CenterText {
                            width: h_3.width
                            height: parent.height
                            text: modelData.fmCls
                        }
                        CenterText {
                            width: h_4.width
                            height: parent.height
                            text: modelData.dstAddr
                        }
                        CenterText {
                            width: h_5.width
                            height: parent.height
                            text: modelData.srcAddr
                        }
                        CenterText {
                            width: h_6.width
                            height: parent.height
                            text: modelData.fmLen
                        }
                        CenterText {
                            width: h_7.width
                            height: parent.height
                            text: modelData.dgTag
                        }
                        CenterText {
                            width: h_8.width
                            height: parent.height
                            text: modelData.dstPt
                        }
                        CenterText {
                            width: h_9.width
                            height: parent.height
                            text: modelData.srcPt
                        }
                        CenterText {
                            width: h_10.width
                            height: parent.height
                            text: modelData.dgLen
                        }
                        CenterText {
                            width: h_11.width
                            height: parent.height
                            text: modelData.Data
                        }

                        CenterText {
                            width: h_12.width
                            height: parent.height
                            text: modelData.crc
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {

        // console.log("json = "+ JSON.stringify(sm.serialDataList))
        // listView.model = sm.serialDataList;
    }

    Connections {
        target: sm
    }
}
