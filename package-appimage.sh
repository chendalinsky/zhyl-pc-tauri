#!/bin/bash

# 确保脚本在出错时停止
set -e

# 1. 构建 Tauri 项目的 release 版本
cargo tauri build --release

# 2. 定义路径（根据你的实际存放位置修改）
LINUXDEPLOY="./plugin/linuxdeploy-aarch64.AppImage"
GTK_PLUGIN="./plugin/linuxdeploy-plugin-gtk.sh"
GSTREAMER_PLUGIN="./plugin/linuxdeploy-plugin-gstreamer.sh"

# 3. 指定 Tauri 构建输出的可执行文件路径
APP_BIN="./out/release/zhyl-tauri-rust"  # 替换为实际的可执行文件名

# 4. 调用 linuxdeploy 打包，指定插件路径
$LINUXDEPLOY \
  --appdir AppDir \
  --executable $APP_BIN \
  --plugin $GTK_PLUGIN \
  --plugin $GSTREAMER_PLUGIN \
  --output appimage