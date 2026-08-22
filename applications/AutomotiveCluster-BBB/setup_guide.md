# BeagleBone Black & Host PC Qt 6.11.1 Setup & Deployment Guide

This comprehensive guide describes how to configure, compile, and run the **Automotive Cluster GUI** on both your **Host PC (x86_64)** and the **BeagleBone Black (ARMv7)** target hardware.

---

## 🗺️ System Directory Map
Here are the key locations on the Host PC:
* **Project Root:** `/home/channaveeragouda/bbb-dev/applications/AutomotiveCluster-BBB`
* **Qt Source Code:** `/home/channaveeragouda/bbb-dev/qt/source/qt-everywhere-src-6.11.1`
* **ARM Toolchain:** `/home/channaveeragouda/bbb-dev/toolchain/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-linux-gnueabihf`
* **BeagleBone Black Sysroot:** `/home/channaveeragouda/bbb-dev/bbb-rootfs`
* **Local Sysroot Updates (libudev, brotli):** `/home/channaveeragouda/bbb-dev/qt/sysroot-updates`
* **Staged Qt Host Install:** `/home/channaveeragouda/bbb-dev/qt/host`
* **Staged Qt Target Install (ARM):** `/home/channaveeragouda/bbb-dev/qt/install`

---

## 🛠️ Step 1: Compiling Qt 6.11.1 for the Host PC
Before cross-compiling Qt for the ARM target, you must build a host version of Qt. This provides matching host development utilities (like the Meta-Object Compiler `moc`, Resource Compiler `rcc`, and User Interface Compiler `uic`).

1. Open a terminal on your Host PC and create a host build directory:
   ```bash
   mkdir -p /home/channaveeragouda/bbb-dev/qt/build-host
   cd /home/channaveeragouda/bbb-dev/qt/build-host
   ```
2. Configure the host Qt build:
   ```bash
   ../source/qt-everywhere-src-6.11.1/configure \
     -release \
     -nomake tests \
     -nomake examples \
     -prefix /home/channaveeragouda/bbb-dev/qt/host
   ```
3. Compile and install:
   ```bash
   cmake --build . --parallel $(nproc)
   cmake --install .
   ```
This installs the Qt host tools to `/home/channaveeragouda/bbb-dev/qt/host`.

---

## 🛠️ Step 2: Preparing Target Dependencies (Sysroot & Sysroot-Updates)
Since the base sysroot (`/home/channaveeragouda/bbb-dev/bbb-rootfs`) lacks some development headers needed to build Qt, we download and extract them locally into a workspace directory (`sysroot-updates`).

1. Run the dependency configuration script to download and extract `libudev-dev` and `libbrotli-dev` packages:
   ```bash
   cd /home/channaveeragouda/bbb-dev/qt
   ./setup_dev_deps.sh
   ```
   *This extracts target files into `/home/channaveeragouda/bbb-dev/qt/sysroot-updates` and automatically fixes absolute symlinks to be relative.*

---

## 🛠️ Step 3: Compiling Qt 6.11.1 for the BeagleBone Black
Using the host utilities and the cross-compiler toolchain, we configure and compile the target library binaries.

1. Create a target build directory:
   ```bash
   mkdir -p /home/channaveeragouda/bbb-dev/qt/build
   cd /home/channaveeragouda/bbb-dev/qt/build
   ```
2. Configure the target build. We skip modules that are not required for the Automotive Cluster to speed up build times:
   ```bash
   export PATH="/home/channaveeragouda/bbb-dev/toolchain/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-linux-gnueabihf/bin:$PATH"

   ../source/qt-everywhere-src-6.11.1/configure \
     -top-level \
     -release \
     -nomake tests \
     -nomake examples \
     -no-opengl \
     -qt-host-path /home/channaveeragouda/bbb-dev/qt/host \
     -prefix /usr/local/qt6 \
     -extprefix /home/channaveeragouda/bbb-dev/qt/install \
     -skip qt3d,qtgraphs,qtopcua,qtquick3d,qtquick3dphysics,qtscxml,qtvirtualkeyboard,qtwayland,qtwebengine,qtwebview,qtlottie,qtconnectivity,qtcoap,qtlocation,qtsensors,qtgrpc,qtwebsockets,qtserialport,qtserialbus,qtspeech,qtmultimedia,qtdatavis3d,qtimageformats,qtlanguageserver,qt5compat,qtactiveqt,qtcanvaspainter,qtcharts,qtopenapi,qtquickeffectmaker,qtquicktimeline,qtremoteobjects,qttranslations,qtwebchannel \
     -- -DCMAKE_TOOLCHAIN_FILE=/home/channaveeragouda/bbb-dev/qt/toolchain.cmake --fresh
   ```
3. Compile and install target libraries:
   ```bash
   cmake --build . --parallel $(nproc)
   cmake --install .
   ```
This installs the staged target Qt binaries to `/home/channaveeragouda/bbb-dev/qt/install`.

---

## 🛠️ Step 4: Setting up Qt Creator Kits
To manage both configurations directly within Qt Creator:

### Kit A: Host PC (Qt 6.9.0 Desktop)
* **Purpose:** For rapid testing and visual iteration on your local computer.
* **Compiler:** Local GCC (x86_64).
* **Qt Version:** Points to your local desktop Qt installation (`/home/channaveeragouda/Qt/6.9.0/gcc_64/bin/qmake`).
* **Build Directories:** 
  * Debug: `/home/channaveeragouda/bbb-dev/applications/AutomotiveCluster-BBB/build/Qt_6_9_0-Debug`
  * Release: `/home/channaveeragouda/bbb-dev/applications/AutomotiveCluster-BBB/build/Qt_6_9_0-Release`

### Kit B: BeagleBone Black Qt 6.11.1 (ARM Target)
* **Purpose:** For building target binaries to deploy to the actual hardware.
* **Compilers:** `arm-none-linux-gnueabihf-gcc` / `arm-none-linux-gnueabihf-g++`.
* **Sysroot:** `/home/channaveeragouda/bbb-dev/bbb-rootfs`
* **Qt Version:** Points to `/home/channaveeragouda/bbb-dev/qt/install/bin/qmake6`.
* **CMake Toolchain File:**
  * Must be configured to use: `/home/channaveeragouda/bbb-dev/qt/install/lib/cmake/Qt6/qt.toolchain.cmake`
  * *Note: This relocatable toolchain file automatically chainloads your local compiler configurations and injects critical include paths (`-isystem`) and library directories (`-L`).*
* **Build Directory:** `/home/channaveeragouda/bbb-dev/applications/AutomotiveCluster-BBB/build-qt6.11`
* **CMake Generator:** `Ninja`

---

## 🚀 Step 5: Compiling and Testing the Application

### Method 1: Local Host Testing
1. In Qt Creator, select the **Qt 6.9.0** kit at the bottom left.
2. Build (**Ctrl+B**) and run (**Ctrl+R**). 
3. The dashboard UI will open locally as a window on your desktop.

### Method 2: Target Hardware Deployment
To deploy the application to the BeagleBone Black, a pre-compiled helper script is available in your workspace root.

1. In Qt Creator, select the **BeagleBone Black Qt 6.11.1** kit.
2. Build the project (**Ctrl+B**). This produces the ARM binary inside `/home/channaveeragouda/bbb-dev/applications/AutomotiveCluster-BBB/build-qt6.11/appAutomotiveCluster`.
3. In a terminal, run the automated deployment script:
   ```bash
   cd /home/channaveeragouda/bbb-dev/applications/AutomotiveCluster-BBB
   ./deploy_to_bbb.sh
   ```
   *This script checks connection, copies the ARM binary, extracts Qt libraries to the board, uploads missing fonts, and starts the GUI on the target board.*

---

## 📺 Step 6: Accessing the Display on the BeagleBone Black
Because the BeagleBone Black runs a headless OS (no native display server), the GUI runs as a VNC server:

1. On the Host PC, launch your VNC client (like **Remmina**).
2. Connect to the board's virtual ethernet interface:
   * **Address:** `192.168.7.2`
   * **Port:** `5900`
3. You will see the Automotive Cluster dashboard rendering directly on the hardware display output.

### ⚠️ Performance & Brownout Optimization
Running a complex QML application on a single-core Cortex-A8 (512MB RAM) without a GPU requires optimizing the render parameters to prevent lag and current overload (which causes the board to crash or reboot):
* **Resolution:** Set to `800x480` or `640x480`.
* **Refresh Rate:** Set `-platform vnc:draw-rate=10` to limit VNC redraws to 10 FPS. This keeps CPU usage around 20-30% and keeps power consumption stable.
