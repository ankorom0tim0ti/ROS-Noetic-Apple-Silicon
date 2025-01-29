# Use the OSRF ROS image (tag: noetic-desktop-full) as base image
FROM osrf/ros:noetic-desktop-full

# Update package list and install additional packages
RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    python3-dev \
    python3-setuptools \
    python-is-python3 \
    python3-rosdep \
    python3-catkin-tools \
    openssh-client \
    emacs \
    gtk2-engines-pixbuf \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    ros-noetic-roseus \
    ros-noetic-pr2eus \
    ros-noetic-jskeus \
    ros-noetic-realsense2-camera \
    ros-noetic-realsense2-description \
    ros-noetic-ddynamic-reconfigure \
    ros-noetic-catkin-virtualenv \
    python3-vcstool \
    ros-noetic-joint-trajectory-controller \
    ros-noetic-jsk-tools \
    ros-noetic-urdfdom-py \
    wget \
    ros-noetic-ridgeback-control \
    ros-noetic-jsk-perception \
    ros-noetic-jsk-recognition \
    ros-noetic-jsk-recognition-msgs \
    ros-noetic-jsk-tools \
    && rm -rf /var/lib/apt/lists/*

# Update rosdep
RUN rosdep update

# Create SSH directory
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Set the initial working directory when entering the container
WORKDIR /root/

# Set environment variables for NVIDIA container runtime (needed for graphical rendering)
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# Source ROS setup script in bashrc to set up the ROS environment automatically
RUN echo "source /opt/ros/noetic/setup.sh" >> .bashrc

# Create a directory for your workspace
RUN mkdir -p catkin_ws/src

# Change to the src directory and initialize the workspace
RUN cd catkin_ws/src && . /opt/ros/noetic/setup.sh && catkin_init_workspace

# Move to the home directory, then catkin_ws and build the workspace
RUN cd && cd catkin_ws && . /opt/ros/noetic/setup.sh && catkin build

# Clone the ddynamic_reconfigure repository, checkout master, and build it
RUN cd /root && \
    git clone https://github.com/pal-robotics/ddynamic_reconfigure.git && \
    cd ddynamic_reconfigure && \
    git checkout master && \
    cd .. && \
    mv ddynamic_reconfigure /root/catkin_ws/src/ && \
    cd catkin_ws && \
    catkin build

# Clone the catkin_virtualenv repository, checkout master, and build it
RUN cd /root && \
    git clone https://github.com/locusrobotics/catkin_virtualenv.git && \
    cd catkin_virtualenv && \
    git checkout master && \
    cd .. && \
    mv catkin_virtualenv /root/catkin_ws/src/ && \
    cd catkin_ws && \
    catkin build

# Add the ROS workspace setup to bashrc so it's sourced automatically
RUN echo "source ./catkin_ws/devel/setup.bash" >> .bashrc
