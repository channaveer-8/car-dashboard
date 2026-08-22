import QtQuick
import QtQuick.Window
import "components"

Window {
    id: root
    width: 800
    height: 480
    visible: true
    title: qsTr("Automotive Cluster")

    property bool showSettings: false
    property bool showHelp: false
    property bool showAbout: false
    property real scaleFactor: Math.min(width / 1024.0, height / 600.0)

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#22252A" }
            GradientStop { position: 1.0; color: "#0F1115" }
        }
    }

    Item {
        id: container
        width: 1024
        height: 600
        x: (parent.width - width * root.scaleFactor) / 2
        y: (parent.height - height * root.scaleFactor) / 2
        transform: Scale {
            origin.x: 0
            origin.y: 0
            xScale: root.scaleFactor
            yScale: root.scaleFactor
        }

        // ── Boot Sequence (direct Item children — reliable) ────────────────
        property bool bootSweepingUp: true
        property real bootProgress: 0.0

        Timer {
            id: bootTimer
            interval: 16
            running: true
            repeat: true
            onTriggered: {
                container.bootProgress += 1.0 / 75
                const p = Math.min(container.bootProgress, 1.0)
                if (container.bootSweepingUp) {
                    DashboardAPI.setThrottle(p * 100)
                    DashboardAPI.setBattery(p * 100)
                    if (container.bootProgress >= 1.0) {
                        container.bootSweepingUp = false
                        container.bootProgress = 0.0
                    }
                } else {
                    DashboardAPI.setThrottle((1.0 - p) * 100)
                    DashboardAPI.setBattery(100)
                    if (container.bootProgress >= 1.0) {
                        bootTimer.stop()
                        bootFinishTimer.start()
                    }
                }
            }
        }

        Timer {
            id: bootFinishTimer
            interval: 200
            running: false
            repeat: false
            onTriggered: {
                DashboardAPI.setBootActive(false)
                DashboardAPI.setThrottle(0)
                DashboardAPI.setGear("P")
                DashboardAPI.setLeftDoorOpen(false)
                DashboardAPI.setRightDoorOpen(false)
                DashboardAPI.setTirePressureLow(false)
                DashboardAPI.setSeatbeltWarning(true)
                DashboardAPI.setLeftIndicator(false)
                DashboardAPI.setRightIndicator(false)
                DashboardAPI.setBrakePressed(false)
                DashboardAPI.setHighBeam(false)
                DashboardAPI.setCruiseControlActive(false)
                DashboardAPI.setElectricalFault(false)
                DashboardAPI.setAbsWarning(false)
            }
        }

        // ── UI Components ──────────────────────────────────────────────────
        TopHeader {
            id: header
            onOpenSettings: {
                root.showSettings = true
                root.showHelp = false
                root.showAbout = false
            }
        }

        ArcGauge {
            anchors.left: parent.left
            anchors.leftMargin: 60
            anchors.verticalCenter: parent.verticalCenter
            width: 320; height: 320
            value: DashboardAPI.throttle
            title: "THROTTLE"
            unit: "%"
            bootActive: DashboardAPI.bootActive
            gaugeColor: {
                if (value < 60) return "#00FFCC"
                if (value < 85) return "#FFA500"
                return "#FF3333"
            }
        }

        CarStatus {
            anchors.centerIn: parent
            width: 350; height: 450
            anchors.verticalCenterOffset: -30

            activeGear:          DashboardAPI.gear
            bootActive:          DashboardAPI.bootActive
            leftDoorOpen:        DashboardAPI.leftDoorOpen
            rightDoorOpen:       DashboardAPI.rightDoorOpen
            tirePressureLow:     DashboardAPI.tirePressureLow
            seatbeltWarning:     DashboardAPI.seatbeltWarning
            leftIndicator:       DashboardAPI.leftIndicator
            rightIndicator:      DashboardAPI.rightIndicator
            brakePressed:        DashboardAPI.brakePressed
            highBeam:            DashboardAPI.highBeam
            cruiseControlActive: DashboardAPI.cruiseControlActive
            electricalFault:     DashboardAPI.electricalFault
            absWarning:          DashboardAPI.absWarning
        }

        GearSelector {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            bootActive: DashboardAPI.bootActive
            activeGear: DashboardAPI.gear
        }

        ArcGauge {
            anchors.right: parent.right
            anchors.rightMargin: 60
            anchors.verticalCenter: parent.verticalCenter
            width: 320; height: 320
            value: DashboardAPI.battery
            title: "BATTERY"
            unit: "%"
            bootActive: DashboardAPI.bootActive
            gaugeColor: value < 20 ? "#FF3333" : "#00CCFF"
            flashWarning: value < 20
        }

        // ── Overlays ───────────────────────────────────────────────────────
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: (root.showSettings || root.showHelp || root.showAbout) ? 0.7 : 0.0
            visible: opacity > 0
            MouseArea { anchors.fill: parent }
        }
        SettingsScreen {
            anchors.centerIn: parent
            visible: root.showSettings
            onCloseRequested: root.showSettings = false
            onOpenHelp:  { root.showSettings = false; root.showHelp  = true }
            onOpenAbout: { root.showSettings = false; root.showAbout = true }
        }
        HelpScreen {
            anchors.centerIn: parent
            visible: root.showHelp
            onBackRequested: { root.showHelp = false; root.showSettings = true }
        }
        AboutScreen {
            anchors.centerIn: parent
            visible: root.showAbout
            onBackRequested: { root.showAbout = false; root.showSettings = true }
        }
    }
}
