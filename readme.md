# Docker for Ubuntu 24.04 + ROS 2 Jazzy + Gazebo Sim (GZ Sim)

This repository provides a ready-to-use **Docker environment** for running **ROS 2 Jazzy** with **Gazebo Sim (Fortress/Garden)** on systems with **NVIDIA GPU acceleration**.  
It supports both simulation and development workflows with hardware-accelerated rendering.

## 1. Create the workspace
```bash
cd
mkdir -p /ros_ws && cd /ros_ws
git clone https://github.com/siddharthumakarthikeyan/Docker-for-ROS2-Jazzy-GZ-Sim.git .
```

---

## 2. Build the Docker Image

Enable BuildKit for faster multi-stage builds and run:

```bash
DOCKER_BUILDKIT=1 docker build \
  -f docker/ros2_gzsim_x86_64.dockerfile \
  -t ros2_gzsim:x86_64 .
```

---

## 3. Enable X11 Access for GUI Apps

Allow Docker containers to access your host display (for Gazebo GUI):

```bash
xhost +local:root
```

---

🔒 Note: This temporarily allows root (the container) to access your display.
After use, revoke permission with: (Not required)

```bash
xhost -local:root

```

---

## 4. Run the Container 

Launch the container with GPU, display forwarding, and host networking enabled:

```bash
docker run --gpus all -it --rm --network host -e DISPLAY="$DISPLAY" -e XDG_RUNTIME_DIR=/tmp/runtime-root -e NVIDIA_DRIVER_CAPABILITIES=all -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.0:/usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.0:ro -v /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.0:/usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.0:ro -v /usr/share/vulkan/icd.d/nvidia_icd.json:/usr/share/vulkan/icd.d/nvidia_icd.json:ro --device /dev/dri:/dev/dri --privileged ros2_gzsim:x86_64 /bin/bash

```

---
## 5. Inside the docker image
```bash
gz sim

```

This will open Gazebo Sim GUI from within the container on your host screen.
