FROM arm64v8/ros:noetic-perception-focal

LABEL maintainer =  "B-SKY Lab"


ARG DEBIAN_FRONTEND=noninteractive

# ----------------------------------------------------------------------------
# Environment variables (from the first Dockerfile)
# ----------------------------------------------------------------------------
ENV USER=docker
ENV PASSWORD=docker
ENV HOME=/home/${USER}
ENV SHELL=/bin/bash

# Install basic tools
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y vim-gtk
RUN apt-get install -y git
RUN apt-get install -y tmux
RUN apt-get install -y bash-completion
RUN apt-get install -y sudo
RUN apt-get install -y mesa-utils
RUN apt-get install -y x11-apps 

# Install ROS tools
RUN apt-get install -y python3-osrf-pycommon
RUN apt-get install -y python3-catkin-tools
RUN apt-get install -y python3-rosdep
RUN apt-get install -y python3-rosinstall
RUN apt-get install -y python3-rosinstall-generator
RUN apt-get install -y python3-wstool 
RUN apt-get install -y build-essential

RUN apt-get install -y ros-noetic-rosserial-arduino ros-noetic-rosserial
RUN apt-get install -y ros-noetic-joy
RUN apt-get install -y ros-noetic-desktop-full
RUN apt-get install -y ros-noetic-jsk-visualization

RUN apt-get install -y python3-dev
RUN apt-get install -y python3-setuptools
RUN apt-get install -y python-is-python3
RUN apt-get install -y openssh-client
RUN apt-get install -y emacs
RUN apt-get install -y gtk2-engines-pixbuf
RUN apt-get install -y libcanberra-gtk-module
RUN apt-get install -y libcanberra-gtk3-module
RUN apt-get install -y ros-noetic-roseus
RUN apt-get install -y ros-noetic-pr2eus
RUN apt-get install -y ros-noetic-jskeus
RUN apt-get install -y ros-noetic-realsense2-camera
RUN apt-get install -y ros-noetic-realsense2-description
RUN apt-get install -y ros-noetic-ddynamic-reconfigure
RUN apt-get install -y ros-noetic-catkin-virtualenv
RUN apt-get install -y python3-vcstool
RUN apt-get install -y ros-noetic-joint-trajectory-controller
RUN apt-get install -y ros-noetic-jsk-tools
RUN apt-get install -y ros-noetic-urdfdom-py
RUN apt-get install -y wget
RUN apt-get install -y ros-noetic-ridgeback-control
RUN apt-get install -y ros-noetic-jsk-perception
RUN apt-get install -y ros-noetic-jsk-recognition
RUN apt-get install -y ros-noetic-jsk-recognition-msgs
RUN apt-get install -y ros-noetic-jsk-tools

# Fonts (to resolve issue #2)
RUN apt-get install -y xfonts-base
RUN apt-get install -y xfonts-100dpi
RUN apt-get install -y xfonts-75dpi
RUN apt-get install -y xfonts-scalable
RUN apt-get install -y xfonts-cyrillic

# librealsense build dependencies
RUN apt-get install -y libssl-dev
RUN apt-get install -y libusb-1.0-0-dev
RUN apt-get install -y libudev-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y libgtk-3-dev
RUN apt-get install -y cmake
RUN apt-get install -y v4l-utils

RUN apt-get install -y libgl1-mesa-glx libgl1-mesa-dri

# Clean up after all installations to save space
RUN rm -rf /var/lib/apt/lists/*

# Install pip packages
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository universe
RUN apt-get update && apt-get install -y python3-pip
RUN pip3 install feetech-servo-sdk
RUN pip3 install readchar


# Set Completion
RUN rm /etc/apt/apt.conf.d/docker-clean


# Create user and add to sudo group
RUN useradd --user-group --create-home --shell /bin/false ${USER}
RUN gpasswd -a ${USER} sudo
RUN echo "${USER}:${PASSWORD}" | chpasswd
RUN sed -i.bak "s#${HOME}:#${HOME}:${SHELL}#" /etc/passwd
RUN gpasswd -a ${USER} dialout
RUN chown -R ${USER}:${USER} ${HOME}


# Set defalut user
USER ${USER}
WORKDIR ${HOME}
RUN cd ${HOME}

# Create a directory for your workspace
RUN mkdir -p catkin_ws/src

# Change to the src directory and initialize the workspace
RUN cd catkin_ws/src && . /opt/ros/noetic/setup.sh && catkin_init_workspace

# Move to the home directory, then catkin_ws and build the workspace
RUN cd catkin_ws && . /opt/ros/noetic/setup.sh && catkin build


# Set name color on terminal to Light Cyan
RUN touch .bashrc
RUN echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> .bashrc
RUN echo "alias ls='ls --color=auto'" >> .bashrc

# Set Completion
RUN ["/bin/bash", "-c", "source /etc/bash_completion"]

# Set 256 color at tmux
RUN touch ${HOME}/.tmux.conf
RUN echo "set-option -g default-command 'bash --init-file ~/.bashrc'">> ${HOME}/.tmux.conf
RUN echo "set-option -g default-terminal screen-256color">> ${HOME}/.tmux.conf
RUN echo "set -g terminal-overrides 'xterm:colors=256'">> ${HOME}/.tmux.conf


# Setup ROS
RUN echo "source /opt/ros/noetic/setup.bash" >> ${HOME}/.bashrc
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ${HOME}/.bashrc

