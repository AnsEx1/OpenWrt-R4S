#!/bin/bash

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source

# --- 添加额外软件 ---
curl -sSL https://raw.githubusercontent.com/mufeng05/turboacc/main/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
git clone https://github.com/SunBK201/UA3F.git package/UA3F
git clone https://github.com/JiaY-shi/fancontrol.git package/fancontrol
git clone https://github.com/EasyTier/luci-app-easytier.git package/luci-app-easytier
