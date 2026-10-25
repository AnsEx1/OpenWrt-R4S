#!/bin/bash

fix_libgcc_version() {
    local makefile="package/libs/toolchain/Makefile"
    local gcc_bin gcc_ver current_ver

    if command -v aarch64-openwrt-linux-musl-gcc >/dev/null 2>&1; then
        gcc_bin="aarch64-openwrt-linux-musl-gcc"
    elif command -v arm-openwrt-linux-musl-gcc >/dev/null 2>&1; then
        gcc_bin="arm-openwrt-linux-musl-gcc"
    elif command -v gcc >/dev/null 2>&1; then
        gcc_bin="gcc"
    else
        echo "未找到 gcc，跳过版本修复"
        return 1
    fi

    gcc_ver=$($gcc_bin -dumpversion 2>/dev/null | cut -d. -f1-3)
    if [ -z "$gcc_ver" ]; then
        echo "无法获取 gcc 版本，跳过修复"
        return 1
    fi

    if [ ! -f "$makefile" ]; then
        echo "未找到 $makefile，跳过"
        return 1
    fi

    current_ver=$(grep -E '^PKG_VERSION\s*:=' "$makefile" | head -1 | sed 's/.*:=//' | xargs)
    echo "当前 PKG_VERSION: $current_ver"

    if echo "$current_ver" | grep -qi "unknown"; then
        echo "修复 PKG_VERSION -> $gcc_ver"
        sed -i "s/^PKG_VERSION\s*:=.*/PKG_VERSION:=$gcc_ver/" "$makefile"
        rm -rf build_dir/target-*/toolchain
    else
        echo "PKG_VERSION 正常，无需修复"
    fi
}

fix_libgcc_version
