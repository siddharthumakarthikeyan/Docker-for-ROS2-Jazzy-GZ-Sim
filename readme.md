DOCKER_BUILDKIT=1 docker build -f docker/ros2_gzsim_x86_64.dockerfile -t ros2_gzsim:x86_64 .

xhost +local:root

#only gazebo test
docker run --gpus all -it --rm --network host -e DISPLAY="$DISPLAY" -e XDG_RUNTIME_DIR=/tmp/runtime-root -e NVIDIA_DRIVER_CAPABILITIES=all -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.0:/usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.0:ro -v /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.0:/usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.0:ro -v /usr/share/vulkan/icd.d/nvidia_icd.json:/usr/share/vulkan/icd.d/nvidia_icd.json:ro --device /dev/dri:/dev/dri --privileged ros2_gzsim:x86_64 /bin/bash -lc 'export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH; gz sim'


apt-get update

apt-get install -y ros-jazzy-______________



