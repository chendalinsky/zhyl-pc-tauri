#!/usr/bin/env bash

set -euo pipefail

# 进入你的项目根目录
cd /home/dalin/workspace/projects/zhyl-tauri || exit

export CARGO_TARGET_DIR="$(pwd)/.target"

# 设定环境变量并重新打包
export LINUXDEPLOY=/home/dalin/workspace/projects/zhyl-tauri/plugin/linuxdeploy-aarch64.AppImage
export LINUXDEPLOY_PLUGIN_GTK=/home/dalin/workspace/projects/zhyl-tauri/plugin/linuxdeploy-plugin-gtk.sh
export APPIMAGETOOL=/home/dalin/workspace/projects/zhyl-tauri/plugin/appimagetool-aarch64.AppImage

# 如果还担心网络，可完全禁用下载：
export TAURI_SKIP_APPIMAGE_DOWNLOAD=1   # 1.6+ 版本已支持
# 旧版本可用：
# export TAURI_APPIMAGE_DOWNLOAD=never

# 开始打包
cargo tauri build --bundles appimage