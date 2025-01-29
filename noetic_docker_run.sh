#!/bin/bash

# SSHキーの存在確認
if [ ! -f ~/.ssh/id_rsa ] && [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "エラー: SSHキーが見つかりません。"
    echo "~/.ssh/id_rsa または ~/.ssh/id_ed25519 が必要です。"
    exit 1
fi

# 既存のコンテナを停止・削除
docker stop ros1_noetic 2>/dev/null || true
docker rm ros1_noetic 2>/dev/null || true

xhost +local:docker

# コンテナを起動
docker run -it \
    --privileged \
    --name ros1_noetic \
    --net=host \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$HOME/ros1/noetic-docker/noetic:/root/noetic" \
    --volume="$HOME/.ssh:/root/.ssh:ro" \
    noetic:0.1.1
