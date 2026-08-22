#include "DashboardAPI.h"
#include <algorithm>

DashboardAPI *DashboardAPI::s_instance = nullptr;

DashboardAPI::DashboardAPI(QObject *parent) : QObject(parent)
{
    s_instance = this;
    // ── Boot state: all warnings active, gauges at zero ──────────────────────
    m_throttle            = 0.0;
    m_battery             = 0.0;   // Will sweep up during boot sequence
    m_bootActive          = true;
    m_leftDoorOpen        = true;
    m_rightDoorOpen       = true;
    m_tirePressureLow     = true;
    m_seatbeltWarning     = true;
    m_leftIndicator       = true;
    m_rightIndicator      = true;
    m_brakePressed        = true;
    m_highBeam            = true;
    m_cruiseControlActive = true;
    m_electricalFault     = true;
    m_absWarning          = true;
}

DashboardAPI *DashboardAPI::instance()
{
    if (!s_instance)
        s_instance = new DashboardAPI();
    return s_instance;
}

// ─────────────────────────────────────────────────────────────────────────────
// Setters — each one guards against redundant updates (no-change → no signal)
// ─────────────────────────────────────────────────────────────────────────────

void DashboardAPI::setThrottle(double v)
{
    v = std::clamp(v, 0.0, 100.0);
    if (qFuzzyCompare(m_throttle, v)) return;
    m_throttle = v;
    emit throttleChanged(v);
}

void DashboardAPI::setBattery(double v)
{
    v = std::clamp(v, 0.0, 100.0);
    if (qFuzzyCompare(m_battery, v)) return;
    m_battery = v;
    emit batteryChanged(v);
}

void DashboardAPI::setTemperature(double v)
{
    if (qFuzzyCompare(m_temperature, v)) return;
    m_temperature = v;
    emit temperatureChanged(v);
}

void DashboardAPI::setGear(const QString &v)
{
    if (m_gear == v) return;
    m_gear = v;
    emit gearChanged(v);
}

void DashboardAPI::setLeftDoorOpen(bool v)
{
    if (m_leftDoorOpen == v) return;
    m_leftDoorOpen = v;
    emit leftDoorOpenChanged(v);
}

void DashboardAPI::setRightDoorOpen(bool v)
{
    if (m_rightDoorOpen == v) return;
    m_rightDoorOpen = v;
    emit rightDoorOpenChanged(v);
}

void DashboardAPI::setTirePressureLow(bool v)
{
    if (m_tirePressureLow == v) return;
    m_tirePressureLow = v;
    emit tirePressureLowChanged(v);
}

void DashboardAPI::setSeatbeltWarning(bool v)
{
    if (m_seatbeltWarning == v) return;
    m_seatbeltWarning = v;
    emit seatbeltWarningChanged(v);
}

void DashboardAPI::setCruiseControlActive(bool v)
{
    if (m_cruiseControlActive == v) return;
    m_cruiseControlActive = v;
    emit cruiseControlActiveChanged(v);
}

void DashboardAPI::setElectricalFault(bool v)
{
    if (m_electricalFault == v) return;
    m_electricalFault = v;
    emit electricalFaultChanged(v);
}

void DashboardAPI::setAbsWarning(bool v)
{
    if (m_absWarning == v) return;
    m_absWarning = v;
    emit absWarningChanged(v);
}

void DashboardAPI::setLeftIndicator(bool v)
{
    if (m_leftIndicator == v) return;
    m_leftIndicator = v;
    emit leftIndicatorChanged(v);
}

void DashboardAPI::setRightIndicator(bool v)
{
    if (m_rightIndicator == v) return;
    m_rightIndicator = v;
    emit rightIndicatorChanged(v);
}

void DashboardAPI::setBrakePressed(bool v)
{
    if (m_brakePressed == v) return;
    m_brakePressed = v;
    emit brakePressedChanged(v);
}

void DashboardAPI::setHighBeam(bool v)
{
    if (m_highBeam == v) return;
    m_highBeam = v;
    emit highBeamChanged(v);
}

void DashboardAPI::setBootActive(bool v)
{
    if (m_bootActive == v) return;
    m_bootActive = v;
    emit bootActiveChanged(v);
}
