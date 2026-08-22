cmake_minimum_required(VERSION 3.16)

project(AutomotiveCluster VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick Network)

qt_standard_project_setup()

qt_add_executable(appAutomotiveCluster
    main.cpp
    DashboardAPI.h
    DashboardAPI.cpp
    LocalSocketServer.h
    LocalSocketServer.cpp
)

qt_add_qml_module(appAutomotiveCluster
    URI AutomotiveCluster
    VERSION 1.0
    NO_CACHEGEN
    QML_FILES
        Main.qml
        components/TopHeader.qml
        components/ArcGauge.qml
        components/GearSelector.qml
        components/CarStatus.qml
        components/SimulationController.qml
        components/SettingsScreen.qml
        components/HelpScreen.qml
        components/AboutScreen.qml
    RESOURCES
        assets/car_blueprint.svg
        assets/hexagon_pattern.svg
        assets/headlight_beam.svg
        assets/icons/weather_sunny.svg
        assets/icons/weather_snow.svg
        assets/icons/tire_pressure.svg
        assets/icons/door_outline.svg
        assets/icons/seatbelt.svg
        assets/icons/parking_brake.svg
        assets/icons/indicator_left.svg
        assets/icons/indicator_right.svg
        assets/icons/high_beam.svg
        assets/icons/battery_icon.svg
        assets/icons/cruise_control.svg
        assets/icons/electrical_fault.svg
        assets/icons/abs_warning.svg
        assets/icons/settings_gear.svg
)

target_link_libraries(appAutomotiveCluster
    PRIVATE Qt6::Quick Qt6::Network
)
