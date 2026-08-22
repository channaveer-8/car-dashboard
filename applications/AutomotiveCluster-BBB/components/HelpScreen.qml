import QtQuick

Item {
    id: root
    width: 700
    height: 490

    signal backRequested()

    Rectangle {
        anchors.fill: parent
        color: "#1A1D25"
        radius: 15
        border.color: "#3A404D"
        border.width: 2

        // Title
        Text {
            id: titleText
            text: "DASHBOARD GUIDE"
            color: "#00FFCC"
            font.pixelSize: 20
            font.bold: true
            font.letterSpacing: 3
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
        }

        // Divider
        Rectangle {
            height: 1
            color: "#3A404D"
            anchors.left: parent.left; anchors.right: parent.right
            anchors.top: titleText.bottom
            anchors.topMargin: 12
            anchors.leftMargin: 20; anchors.rightMargin: 20
        }

        // Signal rows
        Column {
            anchors.top: titleText.bottom
            anchors.topMargin: 30
            anchors.left: parent.left; anchors.right: parent.right
            anchors.margins: 30
            spacing: 14

            Repeater {
                model: [
                    { icon: "qrc:/AutomotiveCluster/assets/icons/tire_pressure.svg",   color: "#FFA500", title: "Tire Pressure Warning",   desc: "Low tire pressure detected on front-left" },
                    { icon: "qrc:/AutomotiveCluster/assets/icons/seatbelt.svg",        color: "#FF3333", title: "Seatbelt Warning",         desc: "Driver seatbelt is not fastened" },
                    { icon: "qrc:/AutomotiveCluster/assets/icons/cruise_control.svg",  color: "#00FFCC", title: "Cruise Control Active",    desc: "Cruise control system is engaged" },
                    { icon: "qrc:/AutomotiveCluster/assets/icons/electrical_fault.svg",color: "#FF3333", title: "Electrical System Fault",  desc: "Battery / electrical system fault detected" },
                    { icon: "qrc:/AutomotiveCluster/assets/icons/abs_warning.svg",     color: "#FFA500", title: "ABS Warning",              desc: "Anti-lock braking system fault detected" }
                ]

                delegate: Rectangle {
                    width: parent.width
                    height: 60
                    color: "#22262F"
                    radius: 10
                    border.color: "#2F3540"
                    border.width: 1

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        spacing: 18

                        Image {
                            source: modelData.icon
                            sourceSize.width: 36
                            sourceSize.height: 36
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 3
                            Text {
                                text: modelData.title
                                color: modelData.color
                                font.pixelSize: 16
                                font.bold: true
                            }
                            Text {
                                text: modelData.desc
                                color: "#999999"
                                font.pixelSize: 13
                            }
                        }
                    }
                }
            }
        }

        // Back Button
        Rectangle {
            id: backBtn
            width: 100; height: 38; radius: 10
            color: "#2F3540"
            border.color: "#00FFCC"; border.width: 1
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 18
            Text {
                anchors.centerIn: parent
                text: "← Back"
                color: "#00FFCC"
                font.pixelSize: 15; font.bold: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: root.backRequested()
            }
        }
    }
}
