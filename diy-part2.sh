#!/bin/bash

TOOLCHAIN_MK="package/libs/toolchain/Makefile"
GCC_BIN=$(command -v aarch64-openwrt-linux-musl-gcc || command -v arm-openwrt-linux-musl-gcc || command -v gcc)
GCC_VER=$($GCC_BIN -dumpversion 2>/dev/null | cut -d. -f1-3)

if [ -n "$GCC_VER" ] && [ -f "$TOOLCHAIN_MK" ] \
   && grep -qE '^PKG_VERSION[[:space:]]*:=[[:space:]]*unknown' "$TOOLCHAIN_MK"; then
    sed -i "s/^PKG_VERSION[[:space:]]*:=.*/PKG_VERSION:=$GCC_VER/" "$TOOLCHAIN_MK"
    rm -rf build_dir/target-*/toolchain
fi

# ESurfingClient: PKG_BUILD_DEPENDS 需为源码目录名 curl，而非子包名 libcurl
ES_MK="package/esurfingclient-c/esurfingclient/Makefile"
if [ -f "$ES_MK" ]; then
    sed -i 's/^PKG_BUILD_DEPENDS:=libcurl$/PKG_BUILD_DEPENDS:=curl/' "$ES_MK"
fi
