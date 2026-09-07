#!/bin/bash

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source

# --- 添加额外软件 ---
# echo "src-git UA3F https://github.com/SunBK201/UA3F.git" >> feeds.conf.default
# echo "src-git fancontrol https://github.com/JiaY-shi/fancontrol.git" >> feeds.conf.default
# echo "src-git easytier https://github.com/EasyTier/luci-app-easytier.git" >> feeds.conf.default
git clone https://github.com/SunBK201/UA3F.git package/UA3F
git clone https://github.com/JiaY-shi/fancontrol.git package/fancontrol
git clone https://github.com/EasyTier/luci-app-easytier.git package/luci-app-easytier
