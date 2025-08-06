#!/usr/bin/env bash
set -e

# 本地文件路径
LINUXDEPLOY="./plugin/linuxdeploy-aarch64.AppImage"
GTK_PLUGIN="./plugin/linuxdeploy-plugin-gtk.sh"
GST_PLUGIN="./plugin/linuxdeploy-plugin-gstreamer.sh"

BINARY="out/release/zhyl_tauri_rust"
DESKTOP="out/release/bundle/appimage/zhyl_tauri_rust.desktop"
ICON="src-tauri/icons/128x128.png"

# 1. 准备 AppDir
rm -rf AppDir
mkdir -p AppDir/usr/bin
cp "$BINARY" AppDir/usr/bin/

# 2. 图标 & .desktop
mkdir -p AppDir/usr/share/icons/hicolor/128x128/apps
cp "$ICON" AppDir/usr/share/icons/hicolor/128x128/apps/zhyl_tauri_rust.png
cp "$DESKTOP" AppDir/

# 3. 离线打包
"$LINUXDEPLOY" \
  --appdir AppDir \
  --plugin gtk --plugin gstreamer \
  --executable AppDir/usr/bin/zhyl_tauri_rust \
  --desktop-file AppDir/zhyl_tauri_rust.desktop \
  --icon-file AppDir/usr/share/icons/hicolor/128x128/apps/zhyl_tauri_rust.png \
  --output appimage