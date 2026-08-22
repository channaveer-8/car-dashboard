import QtQml

// Pure live simulation driver - starts when called simTimer.start()
QtObject {
    id: simController
    property int tick: 0

    property Timer simTimer: Timer {
        id: simTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            simController.tick++
            const t = simController.tick

            DashboardAPI.setThrottle(50 + 45 * Math.sin(t * 0.5))

            const bat = DashboardAPI.battery
            DashboardAPI.setBattery(bat > 5 ? bat - 1.5 : 100)

            const tempNow = DashboardAPI.temperature
            if (tempNow > 0 && t < 30)
                DashboardAPI.setTemperature(tempNow - 0.8)
            else
                DashboardAPI.setTemperature(2 + 3 * Math.sin(t * 0.2))

            const gears = ["P", "R", "N", "D"]
            DashboardAPI.setGear(gears[Math.floor((t / 5) % gears.length)])

            DashboardAPI.setLeftDoorOpen(t % 10 < 3)
            DashboardAPI.setRightDoorOpen(t % 12 < 3)
            DashboardAPI.setTirePressureLow(t % 15 < 5)
            DashboardAPI.setSeatbeltWarning(t % 8 < 4)
            DashboardAPI.setCruiseControlActive(t % 40 < 20)
            DashboardAPI.setElectricalFault(t % 50 < 25)
            DashboardAPI.setAbsWarning(t % 35 < 15)

            if (t % 20 < 5) {
                DashboardAPI.setLeftIndicator(true)
                DashboardAPI.setRightIndicator(false)
                DashboardAPI.setBrakePressed(true)
            } else if (t % 20 < 10) {
                DashboardAPI.setLeftIndicator(false)
                DashboardAPI.setRightIndicator(true)
                DashboardAPI.setBrakePressed(false)
            } else {
                DashboardAPI.setLeftIndicator(false)
                DashboardAPI.setRightIndicator(false)
                DashboardAPI.setBrakePressed(DashboardAPI.throttle < 10)
            }
            DashboardAPI.setHighBeam(t % 30 < 10)
        }
    }
}
