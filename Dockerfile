# osrfが提供するrosイメージ（タグがnoetic-desktop-full）をベースとしてダウンロード
FROM osrf/ros:noetic-desktop-full

# パッケージリストの更新とパッケージのインストール
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

# rosdepの更新
RUN rosdep update

# SSHディレクトリを作成
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Docker実行してシェルに入ったときの初期ディレクトリ（ワークディレクトリ）の設定
WORKDIR /root/

# nvidia-container-runtime（描画するための環境変数の設定）
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# ROSの環境整理
# ROSのセットアップシェルスクリプトを.bashrcファイルに追記
RUN echo "source /opt/ros/noetic/setup.sh" >> .bashrc

# 自分のワークスペース作成のためにフォルダを作成
RUN mkdir -p catkin_ws/src

# srcディレクトリまで移動して，catkin_init_workspaceを実行．
RUN cd catkin_ws/src && . /opt/ros/noetic/setup.sh && catkin_init_workspace

# ~/に移動してから，catkin_wsディレクトリに移動して，catkin buildを実行．
RUN cd && cd catkin_ws && . /opt/ros/noetic/setup.sh && catkin build

RUN cd /root && \
    git clone https://github.com/pal-robotics/ddynamic_reconfigure.git && \
    cd ddynamic_reconfigure && \
    git checkout master && \
    cd .. && \
    mv ddynamic_reconfigure /root/catkin_ws/src/ && \
    cd catkin_ws && \
    catkin build

# catkin_virtualenvのインストール
RUN cd /root && \
    git clone https://github.com/locusrobotics/catkin_virtualenv.git && \
    cd catkin_virtualenv && \
    git checkout master && \
    cd .. && \
    mv catkin_virtualenv /root/catkin_ws/src/ && \
    cd catkin_ws && \
    catkin build

# 自分のワークスペースが反映されるように，.bashrcファイルに追記．
RUN echo "source ./catkin_ws/devel/setup.bash" >> .bashrc
