#!/bin/bash

TOOLCHAIN_MK="package/libs/toolchain/Makefile"
GCC_BIN=$(command -v aarch64-openwrt-linux-musl-gcc || command -v arm-openwrt-linux-musl-gcc || command -v gcc)
GCC_VER=$($GCC_BIN -dumpversion 2>/dev/null | cut -d. -f1-3)

if [ -n "$GCC_VER" ] && [ -f "$TOOLCHAIN_MK" ] \
   && grep -qE '^PKG_VERSION[[:space:]]*:=[[:space:]]*unknown' "$TOOLCHAIN_MK"; then
    sed -i "s/^PKG_VERSION[[:space:]]*:=.*/PKG_VERSION:=$GCC_VER/" "$TOOLCHAIN_MK"
    rm -rf build_dir/target-*/toolchain
fi

ES_MK="package/esurfingclient-c/esurfingclient/Makefile"
if [ -f "$ES_MK" ]; then
    sed -i 's|-DCMAKE_EXE_LINKER_FLAGS="-static -lpthread -latomic"|-DCMAKE_EXE_LINKER_FLAGS="-static -lpthread -latomic" -DCMAKE_C_STANDARD_LIBRARIES="-lnghttp2 -lssl -lcrypto -lz -lpthread -latomic"|' "$ES_MK"
fi
