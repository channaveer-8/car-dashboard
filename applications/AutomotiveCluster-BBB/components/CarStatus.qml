import QtQuick

Item {
    id: root
    width: 350
    height: 450

    property string activeGear:          "P"
    property bool   bootActive:          true
    property bool   leftDoorOpen:        false
    property bool   rightDoorOpen:       false
    property bool   tirePressureLow:     false
    property bool   seatbeltWarning:     false
    property bool   leftIndicator:       false
    property bool   rightIndicator:      false
    property bool   brakePressed:        false
    property bool   highBeam:            false
    property bool   cruiseControlActive: false
    property bool   electricalFault:     false
    property bool   absWarning:          false

    // Hexagon Seamless Pattern Background
    Image {
        anchors.fill: parent
        source: "qrc:/AutomotiveCluster/assets/hexagon_pattern.svg"
        fillMode: Image.Tile
        opacity: 0.05
    }

    // 1. Base Car Body
    Image {
        id: body
        width: 150
        height: 350
        anchors.centerIn: parent
        source: "qrc:/AutomotiveCluster/assets/car_blueprint.svg"
        opacity: 0.8

        // 2. Brake Lights
        Rectangle {
            id: leftBrakeLight
            width: 30; height: 10
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.bottomMargin: 10
            color: "#ff0000"
            visible: root.brakePressed
        }
        
        Rectangle {
            id: rightBrakeLight
            width: 30; height: 10
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.bottomMargin: 10
            color: "#ff0000"
            visible: root.brakePressed
        }

        // 3. Headlights / Flash Lights
        Image {
            id: headLight
            z: -1
            source: "qrc:/AutomotiveCluster/assets/headlight_beam.svg"
            width: 300; height: 180
            anchors.bottom: parent.top
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.highBeam
            opacity: 0.9
        }

        // Left Blinker (Front Corner)
        Rectangle {
            id: leftBlinker
            z: 10
            width: 30; height: 15; radius: 5
            color: "#FFAA00"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.topMargin: 10
            visible: root.leftIndicator && blinkerActive
        }

        // Right Blinker (Front Corner)
        Rectangle {
            id: rightBlinker
            z: 10
            width: 30; height: 15; radius: 5
            color: "#FFAA00"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 2
            anchors.topMargin: 10
            visible: root.rightIndicator && blinkerActive
        }
    }

    // Indicator blink timer
    property bool blinkerActive: false
    Timer {
        interval: 500
        running: root.leftIndicator || root.rightIndicator
        repeat: true
        onTriggered: blinkerActive = !blinkerActive
    }

    // 5. Door Status
    Rectangle {
        width: 4; height: 80
        color: "red"
        anchors.right: body.left
        anchors.top: body.top
        anchors.topMargin: 140
        transform: Rotation { 
            origin.x: 4; origin.y: 0; 
            angle: root.leftDoorOpen ? 45 : 0 
            Behavior on angle { NumberAnimation { duration: 250 } }
        }
        visible: root.leftDoorOpen
    }
    
    Rectangle {
        width: 4; height: 80
        color: "red"
        anchors.left: body.right
        anchors.top: body.top
        anchors.topMargin: 140
        transform: Rotation { 
            origin.x: 0; origin.y: 0; 
            angle: root.rightDoorOpen ? -45 : 0 
            Behavior on angle { NumberAnimation { duration: 250 } }
        }
        visible: root.rightDoorOpen
    }

    // Parking text
    Text {
        anchors.centerIn: body
        z: 5
        text: "P"
        font.pixelSize: 54
        font.bold: true
        color: "#FF3333"
        visible: root.activeGear === "P"
    }

    // Tire Warning
    Image {
        source: "qrc:/AutomotiveCluster/assets/icons/tire_pressure.svg"
        sourceSize.width: 32
        sourceSize.height: 32
        anchors.right: body.left
        anchors.top: body.top
        anchors.topMargin: 40
        visible: root.bootActive || root.tirePressureLow
    }

    // Seatbelt Warning
    Image {
        source: "qrc:/AutomotiveCluster/assets/icons/seatbelt.svg"
        sourceSize.width: 32
        sourceSize.height: 32
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: body.bottom
        anchors.bottomMargin: -40
        visible: root.bootActive || root.seatbeltWarning
    }

    // Cruise Control Mode
    Image {
        source: "qrc:/AutomotiveCluster/assets/icons/cruise_control.svg"
        sourceSize.width: 32
        sourceSize.height: 32
        anchors.left: body.right
        anchors.top: body.top
        anchors.topMargin: 40
        visible: root.bootActive || root.cruiseControlActive
    }

    // Electrical System Fault
    Image {
        source: "qrc:/AutomotiveCluster/assets/icons/electrical_fault.svg"
        sourceSize.width: 32
        sourceSize.height: 32
        anchors.right: body.left
        anchors.top: body.top
        anchors.topMargin: 80
        visible: root.bootActive || root.electricalFault
    }

    // ABS System Warning
    Image {
        source: "qrc:/AutomotiveCluster/assets/icons/abs_warning.svg"
        sourceSize.width: 32
        sourceSize.height: 32
        anchors.left: body.right
        anchors.top: body.top
        anchors.topMargin: 80
        visible: root.bootActive || root.absWarning
    }
}
