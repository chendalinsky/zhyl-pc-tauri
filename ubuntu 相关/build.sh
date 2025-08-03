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

# 3. 先编译，不打包
bun tauri build --target aarch64-unknown-linux-gnu --no-bundle

# 4. 手动生成 AppImage（排除 gtk 插件）
APP_NAME="tauri-rust-2"
APPDIR="target/aarch64-unknown-linux-gnu/release/bundle/appimage/${APP_NAME}.AppDir"
LINUXDEPLOY="/usr/local/bin/linuxdeploy-aarch64.AppImage"

chmod +x "$LINUXDEPLOY"
"$LINUXDEPLOY" \
  --appdir "$APPDIR" \
  --exclude-plugin gtk \
  --output appimage \
  --desktop-file "$APPDIR/usr/share/applications/${APP_NAME}.desktop" \
  --icon-file "$APPDIR/usr/share/icons/hicolor/128x128/apps/${APP_NAME}.png"

echo "AppImage 已生成：$(ls target/aarch64-unknown-linux-gnu/release/bundle/appimage/*.AppImage)"