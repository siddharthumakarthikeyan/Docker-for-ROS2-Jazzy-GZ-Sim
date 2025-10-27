# ros2_gz_x86_64.dockerfile
# Ensures the ubuntu:24.04 base is pulled (first stage triggers pull/cache)
ARG BASE_IMAGE=docker.io/library/ubuntu:24.04

# Stage 0: trigger a pull & cache of the base image
FROM ${BASE_IMAGE} AS base_pull

# Stage 1: actual build
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# basics
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg lsb-release ca-certificates apt-transport-https \
    build-essential sudo wget git locales \
    && rm -rf /var/lib/apt/lists/*

# locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# --- Install ROS 2 Jazzy (binary packages) ---
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
    | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
  | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-desktop \
    && rm -rf /var/lib/apt/lists/*

# Source setup globally
RUN echo "source /opt/ros/jazzy/setup.bash" >> /etc/bash.bashrc

# --- Install Gazebo (gz / gz sim) - OSRF repo ---
RUN mkdir -p /usr/share/keyrings && \
    curl -sSL https://packages.osrfoundation.org/gazebo.gpg -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" \
  | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

RUN apt-get update && apt-get install -y --no-install-recommends \
    gz-jetty \
    && rm -rf /var/lib/apt/lists/*

# ROS <-> Gazebo integration (modern ros_gz meta-package)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-ros-gz \
    || true && rm -rf /var/lib/apt/lists/*

# Global ROS environment (works for all users)
RUN echo "source /opt/ros/jazzy/setup.bash" > /etc/profile.d/ros2_jazzy.sh \
    && chmod +x /etc/profile.d/ros2_jazzy.sh

# Install mesa-utils (non-interactive). Useful for glxinfo / diagnostics.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

# Entrypoint sources ROS environment then drops to an interactive bash
ENTRYPOINT ["/bin/bash", "-lc", "source /opt/ros/jazzy/setup.bash && exec bash"]

