# ros-noetic-docker
This repository provides a Dockerfile to run ROS Noetic (ROS1 distribution for Ubuntu 20.04) is a Docker virtual environment on Ubunt 24.04 (and Ubuntu 22.04)

The advantage of the Docker module provided by this repository is that it makes building and running Docker containers easy through submodule management using shell scripts.

*This is my first time making Dockerfile, so please feel free to submit pull requests for any improvements or corrections.*

## Usage
0. For those new to Docker, please refer to the following link to install Docker Engine:
   `https://docs.docker.com/engine/install`
1. Clone this repository:
   ```
   git clone git@github.com:Michi-Tsubaki/ros-noetic-docker.git
   cd ros-noetic-docker
   ```
2. Build the Docker image:
   ```
   ./noetic_docker_build.sh
   ```
3. Run the Docker Container:
   ```
   ./noetic_docker_run.sh
   ```
4. Duplicate the Docker Container terminal:
   ```
   ./noetic_docker_attach.sh
   ```
    (↑ when you use rviz, rqt_reconfigure, rostopic echo,..., run command above after devide terminal screen.)

## Feature of this Dockerfile / Docker Container
This Dockerfile is designed to set up a development environment based on the ROS Noetic distribution, using the `noetic-desktop-full` image as its base. It installs a variety of essential packages for ROS development, including Python tools, SSH, and several ROS-related packages.

### 1. ROS Noetic Packages
- **`ros-noetic-roseus`**: A package for interfacing with ROS using the Lisp programming language (EusLisp).
- **`ros-noetic-pr2eus`**: A package specifically for interacting with the PR2 robot hardware using EusLisp.
- **`ros-noetic-jskeus`**: A package for interacting with JSK Robotics projects using EusLisp.
- **`ros-noetic-realsense2-camera`**: A package for integrating Intel RealSense cameras with ROS for depth sensing.
- **`ros-noetic-realsense2-description`**: Provides the URDF descriptions for RealSense devices.
- **`ros-noetic-ddynamic-reconfigure`**: Enables real-time configuration of parameters through dynamic reconfiguration.
- **`ros-noetic-catkin-virtualenv`**: A tool for creating isolated Python virtual environments for ROS packages.
- **`ros-noetic-joint-trajectory-controller`**: A package for controlling robot joints with trajectories.
- **`ros-noetic-jsk-tools`, `ros-noetic-jsk-recognition`, `ros-noetic-jsk-recognition-msgs`**: Tools for robot perception, including recognition and sensor data message definitions.
- **`ros-noetic-ridgeback-control`**: A package related to controlling the Ridgeback robot.
- **`ros-noetic-urdfdom-py`**: A package for interacting with URDF (Unified Robot Description Format) models in Python.

### 2. Workspace Setup
- The Dockerfile creates a catkin workspace (`catkin_ws`) and initializes it using `catkin_init_workspace`.
- After initializing the workspace, it builds the workspace with `catkin build`.
- Two GitHub repositories are cloned and integrated into the workspace:
  - **`ddynamic_reconfigure`**: Cloned from the official repository and built.
  - **`catkin_virtualenv`**: Cloned from Locus Robotics and built.
- Both repositories are cloned to `/root/catkin_ws/src` and the workspace is rebuilt after integration.

### 3. Additional Features
- **SSH Setup**: The Dockerfile creates a `/root/.ssh` directory and sets proper permissions, potentially useful for SSH access.
- **NVIDIA GPU Support**: The Dockerfile sets the environment variables `NVIDIA_VISIBLE_DEVICES` and `NVIDIA_DRIVER_CAPABILITIES`, indicating potential use of NVIDIA GPUs for graphical rendering or other tasks.
- **Automatic ROS Environment Setup**: The ROS setup script and the catkin workspace setup script are automatically sourced in the `.bashrc` file, ensuring the ROS environment is ready when a new terminal session is started.

## References
This project is based on the following website for reference:
- https://wiki.ros.org/docker/Tutorials/Docker
- https://qiita.com/Yuya-Shimizu/items/3d9fc18f42aee40f23b3
- https://qiita.com/porizou1/items/d6ff78035544999d7c1c
- https://note.com/npaka/n/ne9530038d80b
- 

## License

This project is licensed under the BSD-3 License.
