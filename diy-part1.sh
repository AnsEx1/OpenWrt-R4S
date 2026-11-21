#!/bin/bash

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
clone_pkg https://github.com/sbwml/luci-app-mosdns.git package/mosdns-full
clone_pkg https://github.com/BadGhost520/ESurfingClient-CVersion.git package/esurfingclient-c
clone_pkg https://github.com/timsaya/openwrt-bandix.git package/bandix
clone_pkg https://github.com/timsaya/luci-app-bandix.git package/luci-app-bandix
