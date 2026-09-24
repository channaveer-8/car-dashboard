<h1 align="center">
  Car Dashboard
</h1>

<h4 align="center">
  A lightweight, fully digital automotive instrument cluster built for the BeagleBone Black.
</h4>

<p align="center">
  <img src="https://img.shields.io/badge/C%2B%2B-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white"/>
  <img src="https://img.shields.io/badge/Qt%2FQML-41CD52?style=for-the-badge&logo=qt&logoColor=white"/>
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
  <img src="https://img.shields.io/badge/Embedded%20Linux-Custom%20BSP-FCC624?style=for-the-badge&logo=linux&logoColor=black"/>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/channaveer-8/car-dashboard/main/docs/Car%20Dashboard.png" alt="Car Dashboard UI Screenshot" width="50%">
</p>

---

## 💡 The Big Picture

Modern cars have beautiful digital dashboards, but they require powerful computers. **The goal of this project was to build a fluid, real-time car dashboard that can run on a highly resource-constrained microcomputer** (the BeagleBone Black, which only has a 1GHz processor and 512MB of RAM).

To achieve the necessary performance, I discarded off-the-shelf operating systems and built a **Custom Board Support Package (BSP)** from the ground up. The resulting headless system boots incredibly fast and streams the live dashboard to a display via a VNC server.

---

## ⚙️ How It Works: The Journey of a Signal

To keep the dashboard fast and prevent the small computer from crashing, the workload is split into three specific jobs. Here is how data travels from the car to the screen in real-time:

```mermaid
graph LR
    A[Car Sensors] -->|Serial/Bluetooth| B(Python Gateway)
    B -->|UNIX Socket| C(C++ Backend)
    C -->|Qt Signals| D[QML Frontend]
