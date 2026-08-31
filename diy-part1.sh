#!/bin/bash

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source

#添加额外源
echo "src-git UA3F https://github.com/SunBK201/UA3F.git" >> feeds.conf.default
echo "src-git fancontrol https://github.com/JiaY-shi/fancontrol.git" >> feeds.conf.default
echo "src-git passwall2 https://github.com/Openwrt-Passwall/openwrt-passwall2.git" >> feeds.conf.default
