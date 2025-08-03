#!/usr/bin/env bash
set -e

export NO_GTK=1

# 预建 immodules 目录和缓存，防止 linuxdeploy-plugin-gtk 404
APPDIR="target/aarch64-unknown-linux-gnu/release/bundle/appimage/$(basename "$PWD").AppDir"
#mkdir -p "$APPDIR/usr/lib/aarch64-linux-gnu/gtk-3.0/3.0.0"
#echo "" > "$APPDIR/usr/lib/aarch64-linux-gnu/gtk-3.0/3.0.0/immodules.cache"

# 1. 按需加 swap（只做一次）
if ! swapon --show | grep -q /swapfile; then
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
fi

# 2. 限制并发
export CARGO_BUILD_JOBS=1
export TAURI_LINUXDEPLOY_PATH=/usr/local/bin/linuxdeploy-aarch64.AppImage

# 3. 交叉编译环境
export PKG_CONFIG_SYSROOT_DIR=/opt/arm64
export PKG_CONFIG_PATH=/opt/arm64/usr/lib/aarch64-linux-gnu/pkgconfig:/opt/arm64/usr/share/pkgconfig
export PKG_