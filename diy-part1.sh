#!/bin/bash

# 克隆官方 feed 之外的软件包；失败立即退出，避免构建后期才报错
clone_pkg() {
    local url="$1" dest="$2"
    echo "==> Cloning $url"
    if ! git clone --depth=1 "$url" "$dest"; then
        echo "ERROR: Failed to clone $url"
        exit 1
    fi
}

clone_pkg https://github.com/SunBK201/UA3F.git package/UA3F
clone_pkg https://github.com/JiaY-shi/fancontrol.git package/fancontrol
clone_pkg https://github.com/EasyTier/luci-app-easytier.git package/luci-app-easytier
# mosdns 5.3.4 + luci-app-mosdns + geo2txt（默认分支 v5）
clone_pkg https://github.com/sbwml/luci-app-mosdns.git package/mosdns-full
