#!/usr/bin/env bash
set -e

# 1. 按需加 swap（只做一次）
if ! swapon --show | grep -q /swapfile; then
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
fi

# 2. 并发 / 交叉编译
export CARGO_BUILD_JOBS=1
export PKG_CONFIG_SYSROOT_DIR=/opt/arm64
export PKG_CONFIG_PATH=/opt/arm64/usr/lib/aarch64-linux-gnu/pkgconfig:/opt/arm64/usr/share/pkgconfig
export PKG_CONFIG_ALLOW_CROSS=1
export DEPLOY_GTK_VERSION=3

# 3. 强制排除 gtk 插件
EXTRA_ARGS="--exclude-plugin gtk"

# 4. 开始构建
bun tauri build --target aarch64-unknown-linux-gnu -- $EXTRA_ARGS