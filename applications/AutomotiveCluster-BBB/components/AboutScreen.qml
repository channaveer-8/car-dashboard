import QtQuick

Item {
    id: root
    width: 600
    height: 400

    signal backRequested()

    Rectangle {
        anchors.fill: parent
        color: "#1E2229"
        radius: 15
        border.color: "#3A404D"
        border.width: 2

        Text {
            text: "ABOUT"
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
            spacing: 15
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Automotive Cluster OS v1.0.0"
                color: "white"
                font.pixelSize: 20
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Built with Qt 6.2 & QML"
                color: "#ff3333"
                font.pixelSize: 16
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "A highly dynamic, fully responsive scalable UI designed\nfor modern electric vehicle dashboards."
                horizontalAlignment: Text.AlignHCenter
                color: "#cccccc"
                font.pixelSize: 14
                lineHeight: 1.5
            }
        }

        // Back Button
        Rectangle {
            width: 80
            height: 40
            radius: 10
            color: "#3A404D"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
            Text {
                anchors.centerIn: parent
                text: "Back"
                color: "white"
                font.pixelSize: 16
            }
            MouseArea {
                anchors.fill: parent
                onClicked: root.backRequested()
            }
        }
    }
}
