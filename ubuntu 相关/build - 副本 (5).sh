#!/usr/bin/env bash
set -e# 预建 immodules 目录和缓存，防止 linuxdeploy-plugin-gtk 404
APPDIR="target/aarch64-unknown-linux-gnu/release/bundle/appimage/$(basename "$PWD").AppDir"
mkdir -p "$APPDIR/usr/lib/aarch64-linux-gnu/gtk-3.0/3.0.0"
echo "" > "$APPDIR/usr/lib/aarch64-linux-gnu/gtk-3.0/3.0.0/immodules.cache"

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
export PKG_CONFIG_ALLOW_CROSS=1
export DEPLOY_GTK_VERSION=3

# 4. 预拷贝 arm64 GTK 运行时，避免 immodules.cache 404
APPDIR="target/aarch64-unknown-linux-gnu/release/bundle/appimage/$(basename "$PWD").AppDir"
GTK_ARM_SYSROOT="/opt/arm64/usr/lib/aarch64-linux-gnu"
GTK_APPDIR="$APPDIR/usr/lib/aarch64-linux-gnu"

mkdir -p "$GTK_APPDIR/gtk-3.0/3.0.0"
cp -r "$GTK_ARM_SYSROOT/gtk-3.0/3.0.0/immodules" "$GTK_APPDIR/gtk-3.0/3.0.0/" 2>/dev/null || true
cp -r "$GTK_ARM_SYSROOT/gtk-3.0/3.0.0/typelibs" "$GTK_APPDIR/gtk-3.0/3.0.0/" 2>/dev/null || true

# 如果交叉环境里有 gtk-query-immodules-3.0，就生成缓存；否则留空
if [ -x /opt/arm64/usr/bin/gtk-query-immodules-3.0 ]; then
    chroot /opt/arm64 /usr/bin/gtk-query-immodules-3.0 > "$GTK_APPDIR/gtk-3.0/3.0.0/immodules.cache" 2>/dev/null
else
    touch "$GTK_APPDIR/gtk-3.0/3.0.0/immodules.cache"
fi

# 5. 开始构建
bun tauri build --target aarch64-unknown-linux-gnu --verbose