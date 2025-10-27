# 🐳 Docker for ROS 2 Jazzy + Gazebo Sim (GZ Sim)

This repository provides a ready-to-use **Docker environment** for running **ROS 2 Jazzy** with **Gazebo Sim (Fortress/Garden)** on systems with **NVIDIA GPU acceleration**.  
It supports both simulation and development workflows with hardware-accelerated rendering.

---

## 🚀 Build the Docker Image

Enable BuildKit for faster multi-stage builds and run:

```bash
DOCKER_BUILDKIT=1 docker build \
  -f docker/ros2_gzsim_x86_64.dockerfile \
  -t ros2_gzsim:x86_64 .
```

---

## 🚗 1. Teleoperation

Manually control the robot in simulation.

### Launch Commands

```bash
# Launch simulation
ros2 launch diffbot_learning sim.launch.py

# Run velocity mapper node
python3 src/scripts/vel_mapper.py

# Teleoperate using keyboard
ros2 run teleop_twist_keyboard teleop_twist_keyboard
```

---

## 🖥️ Enable X11 Access for GUI Apps

Allow Docker containers to access your host display (for Gazebo GUI):

```bash
xhost +local:root
```

---

🔒 Note: This temporarily allows root (the container) to access your display.
After use, revoke permission with:

```bash
xhost -local:root

```

---

## 🧩 Run the Container (Gazebo Only Test)

Launch the container with GPU, display forwarding, and host networking enabled:

```bash
docker run --gpus all -it --rm \
  --network host \
  -e DISPLAY="$DISPLAY" \
  -e XDG_RUNTIME_DIR=/tmp/runtime-root \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e QT_X11_NO_MITSHM=1 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.0:/usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.0:ro \
  -v /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.0:/usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.0:ro \
  -v /usr/share/vulkan/icd.d/nvidia_icd.json:/usr/share/vulkan/icd.d/nvidia_icd.json:ro \
  --device /dev/dri:/dev/dri \
  --privileged \
  ros2_gzsim:x86_64 /bin/bash -lc \
  'export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH && gz sim'

```

---

This will open Gazebo Sim GUI from within the container on your host screen.
