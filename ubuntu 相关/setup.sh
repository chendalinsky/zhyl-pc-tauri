#!/usr/bin/env bash
set -e

# 1. 系统依赖
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  gcc-aarch64-linux-gnu g++-aarch64-linux-gnu pkg-config-aarch64-linux-gnu \
  qemu-user-static binfmt-support debootstrap ca-certificates curl git

# 2. Rust（若已装可跳过）
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env
rustup target add aarch64-unknown-linux-gnu

# 3. Bun（若已装可跳过）
curl -fsSL https://bun.sh/install | bash
export PATH=$HOME/.bun/bin:$PATH

# 4. 最小 sysroot（仅 webkit2gtk 及运行时）
sudo rm -rf /opt/arm64  # 若重跑先清理
sudo debootstrap --arch=arm64 --variant=minbase jammy /opt/arm64 http://ports.ubuntu.com/ubuntu-ports
sudo chroot /opt/arm64 /bin/bash -c "
  apt-get update -qq
  apt-get install -yqq libwebkit2gtk-4.0-dev build-essential libssl-dev libayatana-appindicator3-dev librsvg2-dev
  apt-get clean
"

# 5. Cargo 配置
mkdir -p ~/.cargo
cat > ~/.cargo/config.toml <<EOF
[target.aarch64-unknown-linux-gnu]
linker = "aarch64-linux-gnu-gcc"
ar = "aarch64-linux-gnu-ar"
EOF