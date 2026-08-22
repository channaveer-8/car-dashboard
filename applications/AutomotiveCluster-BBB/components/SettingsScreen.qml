import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 500
    height: 400

    signal closeRequested()
    signal openHelp()
    signal openAbout()

    Rectangle {
        anchors.fill: parent
        color: "#1E2229"
        radius: 15
        border.color: "#3A404D"
        border.width: 2

        Text {
            text: "SETTINGS"
            color: "white"
            font.pixelSize: 24
            font.bold: true
            font.letterSpacing: 2
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
        }

        Column {
            anchors.centerIn: parent
            spacing: 20
            width: 300

            Rectangle {
                width: parent.width
                height: 60
                color: "#2A2E37"
                radius: 10
                border.color: "#00FFCC"
                border.width: helpArea.pressed ? 2 : 0
                Text {
                    anchors.centerIn: parent
                    text: "Help Screen"
                    color: "white"
                    font.pixelSize: 20
                }
                MouseArea {
                    id: helpArea
                    anchors.fill: parent
                    onClicked: root.openHelp()
                }
            }

            Rectangle {
                width: parent.width
                height: 60
                color: "#2A2E37"
                radius: 10
                border.color: "#00FFCC"
                border.width: aboutArea.pressed ? 2 : 0
                Text {
                    anchors.centerIn: parent
                    text: "About"
                    color: "white"
                    font.pixelSize: 20
                }
                MouseArea {
                    id: aboutArea
                    anchors.fill: parent
                    onClicked: root.openAbout()
                }
            }
        }

        // Close Button
        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: "#FF3333"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 15
            Text {
                anchors.centerIn: parent
                text: "X"
                color: "white"
                font.bold: true
                font.pixelSize: 18
            }
            MouseArea {
                anchors.fill: parent
                onClicked: root.closeRequested()
            }
        }
    }
}
