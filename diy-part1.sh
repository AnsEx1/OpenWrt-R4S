#!/bin/bash

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source

# --- 添加额外软件 ---
# echo "src-git UA3F https://github.com/SunBK201/UA3F.git" >> feeds.conf.default
# echo "src-git fancontrol https://github.com/JiaY-shi/fancontrol.git" >> feeds.conf.default
# echo "src-git easytier https://github.com/EasyTier/luci-app-easytier.git" >> feeds.conf.default

# --- 克隆函数：失败立即退出，避免构建到后期才报错 ---
clone_pkg() {
    local url="$1" dest="$2"
    echo "==> Cloning $url"
    if ! git clone --depth=1 "$url" "$dest"; then
        echo "ERROR: Failed to clone $url"
        exit 1
    fi
}

# --- 现有软件 ---
clone_pkg https://github.com/SunBK201/UA3F.git package/UA3F
clone_pkg https://github.com/JiaY-shi/fancontrol.git package/fancontrol
clone_pkg https://github.com/EasyTier/luci-app-easytier.git package/luci-app-easytier

# --- MosDNS 全家桶 ---
# 默认分支 v5 提供: mosdns 5.3.4 + luci-app-mosdns 1.7.14 + geo2txt 1.0.0
clone_pkg https://github.com/sbwml/luci-app-mosdns.git package/mosdns-full

# --- 校园网认证 ---
# 提供: esurfingclient + luci-app-esurfingclient
clone_pkg https://github.com/BadGhost520/ESurfingClient-CVersion.git package/esurfingclient-full