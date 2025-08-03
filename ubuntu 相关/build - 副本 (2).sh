#!/usr/bin/env bash
set -e

# 1. 按需加 swap（只做一次）
if ! swapon --show | grep -q /swapfile; then
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
fi

# 2. 限制并发
export CARGO_BUILD_JOBS=1
# 3. 强制用宿主 x86_64 版 linuxdeploy
export TAURI_LINUXDEPLOY_PATH=/usr/local/bin/linuxdeploy-x86_64.AppImage

# 4. 交叉编译环境
export PKG_CONFIG_SYSROOT_DIR=/opt/arm64
export PKG_CONFIG_PATH=/opt/arm64/usr/lib/aarch64-linux-gnu/pkgconfig:/opt/arm64/usr/share/pkgconfig
export PKG_CONFIG_ALLOW_CROSS=1

# 5. 开始构建
bun tauri build --target aarch64-unknown-linux-gnu --verbose
