import QtQuick

Item {
    id: root
    height: 60
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: 20

    signal openSettings()

    // Time update timer
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timeText.text = Qt.formatDateTime(new Date(), "ddd, MMM d | hh:mm ap")
        }
    }

    Text {
        id: timeText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
        font.pixelSize: 22
        font.bold: true
        font.family: "Inter"
        text: Qt.formatDateTime(new Date(), "ddd, MMM d | hh:mm ap")
    }

    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Image {
            source: DashboardAPI.temperature <= 3 ? "qrc:/AutomotiveCluster/assets/icons/weather_snow.svg" : "qrc:/AutomotiveCluster/assets/icons/weather_sunny.svg"
            sourceSize.width: 32
            sourceSize.height: 32
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            Text {
                text: Math.round(DashboardAPI.temperature) + "°C"
                color: DashboardAPI.temperature <= 3 ? "#00BFFF" : "white"
                font.pixelSize: 20
                font.bold: true
            }
            Text {
                text: DashboardAPI.temperature <= 3 ? "Icy" : "Sunny"
                color: "#cccccc"
                font.pixelSize: 14
            }
        }

        // Settings Button
        Item {
            width: 40
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            
            Image {
                id: settingsIcon
                source: "qrc:/AutomotiveCluster/assets/icons/settings_gear.svg"
                anchors.centerIn: parent
                sourceSize.width: 28
                sourceSize.height: 28
                opacity: settingsMouse.pressed ? 0.6 : 1.0
            }
            
            MouseArea {
                id: settingsMouse
                anchors.fill: parent
                onClicked: root.openSettings()
            }
        }
    }
}
