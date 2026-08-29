#!/bin/bash

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source

#添加额外源
echo "src-git UA3F https://github.com/SunBK201/UA3F.git" >> feeds.conf.default
