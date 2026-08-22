#pragma once

#include <QObject>
#include <QString>
#include <qqml.h>

/**
 * @brief DashboardAPI - C++ singleton exposing all dashboard signals independently.
 *
 * Each signal has:
 *   - A Q_PROPERTY for reactive QML binding
 *   - A Q_INVOKABLE setter callable from QML or C++
 *   - A 'Changed' notify signal
 *
 * Usage from QML:
 *   DashboardAPI.setThrottle(75.0)
 *   DashboardAPI.setGear("D")
 *   DashboardAPI.setBattery(42.5)
 */
class DashboardAPI : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    // ── Gauges ──────────────────────────────────────────────────────────────
    Q_PROPERTY(double throttle           READ throttle           WRITE setThrottle           NOTIFY throttleChanged)
    Q_PROPERTY(double battery            READ battery            WRITE setBattery            NOTIFY batteryChanged)
    Q_PROPERTY(double temperature        READ temperature        WRITE setTemperature        NOTIFY temperatureChanged)

    // ── Transmission ────────────────────────────────────────────────────────
    Q_PROPERTY(QString gear              READ gear               WRITE setGear               NOTIFY gearChanged)

    // ── Door Status ──────────────────────────────────────────────────────────
    Q_PROPERTY(bool leftDoorOpen         READ leftDoorOpen       WRITE setLeftDoorOpen       NOTIFY leftDoorOpenChanged)
    Q_PROPERTY(bool rightDoorOpen        READ rightDoorOpen      WRITE setRightDoorOpen      NOTIFY rightDoorOpenChanged)

    // ── Driver Warnings ──────────────────────────────────────────────────────
    Q_PROPERTY(bool tirePressureLow      READ tirePressureLow    WRITE setTirePressureLow    NOTIFY tirePressureLowChanged)
    Q_PROPERTY(bool seatbeltWarning      READ seatbeltWarning    WRITE setSeatbeltWarning    NOTIFY seatbeltWarningChanged)
    Q_PROPERTY(bool cruiseControlActive  READ cruiseControlActive WRITE setCruiseControlActive NOTIFY cruiseControlActiveChanged)
    Q_PROPERTY(bool electricalFault      READ electricalFault    WRITE setElectricalFault    NOTIFY electricalFaultChanged)
    Q_PROPERTY(bool absWarning           READ absWarning         WRITE setAbsWarning         NOTIFY absWarningChanged)

    // ── Lighting & Indicators ────────────────────────────────────────────────
    Q_PROPERTY(bool leftIndicator        READ leftIndicator      WRITE setLeftIndicator      NOTIFY leftIndicatorChanged)
    Q_PROPERTY(bool rightIndicator       READ rightIndicator     WRITE setRightIndicator     NOTIFY rightIndicatorChanged)
    Q_PROPERTY(bool brakePressed         READ brakePressed       WRITE setBrakePressed       NOTIFY brakePressedChanged)
    Q_PROPERTY(bool highBeam             READ highBeam           WRITE setHighBeam           NOTIFY highBeamChanged)

    // ── System ───────────────────────────────────────────────────────────────
    Q_PROPERTY(bool bootActive           READ bootActive         WRITE setBootActive         NOTIFY bootActiveChanged)

public:
    explicit DashboardAPI(QObject *parent = nullptr);
    static DashboardAPI *create(QQmlEngine *, QJSEngine *) { return instance(); }
    static DashboardAPI *instance();

    // ── Getters ──────────────────────────────────────────────────────────────
    double  throttle()            const { return m_throttle; }
    double  battery()             const { return m_battery; }
    double  temperature()         const { return m_temperature; }
    QString gear()                const { return m_gear; }
    bool    leftDoorOpen()        const { return m_leftDoorOpen; }
    bool    rightDoorOpen()       const { return m_rightDoorOpen; }
    bool    tirePressureLow()     const { return m_tirePressureLow; }
    bool    seatbeltWarning()     const { return m_seatbeltWarning; }
    bool    cruiseControlActive() const { return m_cruiseControlActive; }
    bool    electricalFault()     const { return m_electricalFault; }
    bool    absWarning()          const { return m_absWarning; }
    bool    leftIndicator()       const { return m_leftIndicator; }
    bool    rightIndicator()      const { return m_rightIndicator; }
    bool    brakePressed()        const { return m_brakePressed; }
    bool    highBeam()            const { return m_highBeam; }
    bool    bootActive()          const { return m_bootActive; }

public slots:
    // ── Setters (callable from QML and C++) ───────────────────────────────────
    Q_INVOKABLE void setThrottle(double v);
    Q_INVOKABLE void setBattery(double v);
    Q_INVOKABLE void setTemperature(double v);
    Q_INVOKABLE void setGear(const QString &v);
    Q_INVOKABLE void setLeftDoorOpen(bool v);
    Q_INVOKABLE void setRightDoorOpen(bool v);
    Q_INVOKABLE void setTirePressureLow(bool v);
    Q_INVOKABLE void setSeatbeltWarning(bool v);
    Q_INVOKABLE void setCruiseControlActive(bool v);
    Q_INVOKABLE void setElectricalFault(bool v);
    Q_INVOKABLE void setAbsWarning(bool v);
    Q_INVOKABLE void setLeftIndicator(bool v);
    Q_INVOKABLE void setRightIndicator(bool v);
    Q_INVOKABLE void setBrakePressed(bool v);
    Q_INVOKABLE void setHighBeam(bool v);
    Q_INVOKABLE void setBootActive(bool v);

signals:
    // ── Change notifications ──────────────────────────────────────────────────
    void throttleChanged(double value);
    void batteryChanged(double value);
    void temperatureChanged(double value);
    void gearChanged(const QString &value);
    void leftDoorOpenChanged(bool value);
    void rightDoorOpenChanged(bool value);
    void tirePressureLowChanged(bool value);
    void seatbeltWarningChanged(bool value);
    void cruiseControlActiveChanged(bool value);
    void electricalFaultChanged(bool value);
    void absWarningChanged(bool value);
    void leftIndicatorChanged(bool value);
    void rightIndicatorChanged(bool value);
    void brakePressedChanged(bool value);
    void highBeamChanged(bool value);
    void bootActiveChanged(bool value);

private:
    static DashboardAPI *s_instance;

    double  m_throttle            { 0.0 };
    double  m_battery             { 100.0 };
    double  m_temperature         { 24.0 };
    QString m_gear                { QStringLiteral("P") };
    bool    m_leftDoorOpen        { false };
    bool    m_rightDoorOpen       { false };
    bool    m_tirePressureLow     { false };
    bool    m_seatbeltWarning     { true };
    bool    m_cruiseControlActive { false };
    bool    m_electricalFault     { false };
    bool    m_absWarning          { false };
    bool    m_leftIndicator       { false };
    bool    m_rightIndicator      { false };
    bool    m_brakePressed        { false };
    bool    m_highBeam            { false };
    bool    m_bootActive          { true };
};
