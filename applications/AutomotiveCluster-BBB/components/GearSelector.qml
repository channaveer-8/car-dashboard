import QtQuick

Item {
    id: root
    width: childrenRect.width
    height: 60

    property string activeGear: "P"
    property bool bootActive: false
    property var gears: ["P", "R", "N", "D"]

    Row {
        spacing: 15

        Repeater {
            model: root.gears
            delegate: Item {
                width: 60
                height: 60

                Rectangle {
                    id: btnRect
                    anchors.fill: parent
                    radius: 8
                    color: (root.bootActive || root.activeGear === modelData) ? "#222222" : "#333333"
                    border.color: (root.bootActive || root.activeGear === modelData) ? "#00FFCC" : "#555555"
                    border.width: (root.bootActive || root.activeGear === modelData) ? 2 : 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: (root.bootActive || root.activeGear === modelData) ? "#00FFCC" : "white"
                        font.pixelSize: 28
                        font.bold: true
                    }
                }
            }
        }
    }
}
