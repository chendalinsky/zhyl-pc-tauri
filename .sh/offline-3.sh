#!/usr/bin/env bash

set -euo pipefail

# 进入你的项目根目录
cd /home/dalin/workspace/projects/zhyl-tauri || exit

export CARGO_TARGET_DIR="$(pwd)/.target"

# 设定环境变量并重新打包
export LINUXDEPLOY=/home/dalin/workspace/projects/zhyl-tauri/plugin/linuxdeploy-aarch64.AppImage
export LINUXDEPLOY_PLUGIN_GTK=/home/dalin/workspace/projects/zhyl-tauri/plugin/linuxdeploy-plugin-gtk.sh
export LINUXDEPLOY_PLUGIN_GTK_PATH=/home/dalin/workspace/projects/zhyl-tauri/plugin/linuxdeploy-plugin-gtk.sh
export LINUX_DEPLOY_PLUGIN_GTK_PATH=/home/dalin/workspace/projects/zhyl-tauri/plugin/linuxdeploy-plugin-gtk.sh
export LINUX_DEPLOY_PLUGIN_GTK=/home/dalin/workspace/projects/zhyl-tauri/plugin/linuxdeploy-plugin-gtk.sh
export APPIMAGETOOL=/home/dalin/workspace/projects/zhyl-tauri/plugin/appimagetool-aarch64.AppImage

# 如果还担心网络，可完全禁用下载：
export TAURI_SKIP_APPIMAGE_DOWNLOAD=1   # 1.6+ 版本已支持
# 旧版本可用：
# export TAURI_APPIMAGE_DOWNLOAD=never

# 开始打包
exec cargo tauri build --bundles appimage



# 2. 定义路径（根据你的实际存放位置修改）
LINUXDEPLOY="/home/dalin/workspace/projects/zhyl-tauri/plugin/linuxdeploy-aarch64.AppImage"
GTK_PLUGIN="/home/dalin/workspace/projects/zhyl-tauri/plugin/linuxdeploy-plugin-gtk.sh"
GSTREAMER_PLUGIN="/home/dalin/workspace/projects/zhyl-tauri/plugin/linuxdeploy-plugin-gstreamer.sh"

# 3. 指定 Tauri 构建输出的可执行文件路径
APP_BIN="/home/dalin/workspace/projects/zhyl-tauri/out/release/zhyl_tauri_rust"  # 替换为实际的可执行文件名
#APP_BIN="/home/dalin/workspace/projects/zhyl-tauri/output/release/zhyl_tauri_rust"  # 替换为实际的可执行文件名

# 4. 调用 linuxdeploy 打包，指定插件路径
$LINUXDEPLOY \
  --appdir AppDir \
  --executable $APP_BIN \
  --plugin $GTK_PLUGIN \
  --plugin $GSTREAMER_PLUGIN \
  --output appimage