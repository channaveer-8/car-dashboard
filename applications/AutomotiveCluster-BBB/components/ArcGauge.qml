import QtQuick
import QtQuick.Shapes

Item {
    id: root
    width: 260
    height: 260

    property real value: 0 // 0 to 100
    property real minValue: 0
    property real maxValue: 100
    
    // Configurable colors
    property color trackColor: "#333333"
    property color gaugeColor: "#00FF00"
    
    property string title: "GAUGE"
    property string unit: "%"
    property bool flashWarning: false
    property bool bootActive: false



    // Derived angles for 270 degree arc, starting from bottom-left
    // 0 degrees is 3 o'clock. We want to start at 135 deg and end at 45 deg (which is 135 + 270)
    property real startAngle: 135
    property real spanAngle: 270

    // Animate the actual displayed value
    // During boot: instant (0ms) so the 60fps manual sweep is visible
    // After boot: smooth 900ms easing for normal simulation
    property real displayedValue: 0
    Behavior on displayedValue {
        NumberAnimation {
            duration: root.bootActive ? 0 : 900
            easing.type: Easing.InOutQuad
        }
    }

    onValueChanged: {
        displayedValue = Math.max(minValue, Math.min(maxValue, value))
    }

    Shape {
        id: bgShape
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 8

        ShapePath {
            strokeWidth: 8
            strokeColor: trackColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: (root.width / 2) - 10
                radiusY: (root.height / 2) - 10
                startAngle: root.startAngle
                sweepAngle: root.spanAngle
            }
        }
    }

    Shape {
        id: fgShape
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 8

        ShapePath {
            strokeWidth: 8
            strokeColor: flashWarning ? (flashTimer.on ? "red" : "transparent") : gaugeColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: (root.width / 2) - 10
                radiusY: (root.height / 2) - 10
                startAngle: root.startAngle
                sweepAngle: (root.displayedValue / (root.maxValue - root.minValue)) * root.spanAngle
            }
        }
    }

    Timer {
        id: flashTimer
        interval: 300
        running: root.flashWarning
        repeat: true
        property bool on: false
        onTriggered: on = !on
    }

    // Center Text (The "Eyeball")
    Column {
        id: centerTextColumn
        anchors.centerIn: parent
        spacing: 5

        // Initial opacity for the eye blink animation
        opacity: root.bootActive ? 0.0 : 1.0

        // Eye blink animation exactly once on startup
        Component.onCompleted: {
            if (root.bootActive) {
                eyeBlinkAnim.start()
            }
        }

        SequentialAnimation {
            id: eyeBlinkAnim
            // First slow, visible opening synchronized to gauge sweep (1200ms)
            NumberAnimation { target: centerTextColumn; property: "opacity"; to: 1.0; duration: 1200; easing.type: Easing.InOutQuad }
            // Fast blink shut (50ms)
            NumberAnimation { target: centerTextColumn; property: "opacity"; to: 0.0; duration: 50 }
            // Fast blink back open (150ms)
            NumberAnimation { target: centerTextColumn; property: "opacity"; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Math.round(root.displayedValue) + root.unit
            color: "white"
            font.pixelSize: 42
            font.bold: true
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.title
            color: "#aaaaaa"
            font.pixelSize: 14
            font.letterSpacing: 2
        }
    }
}
