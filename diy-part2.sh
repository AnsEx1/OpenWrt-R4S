#!/bin/bash

# --- TTYD 免登录配置 ---
# sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# --- 添加 turboacc 加速插件 ---
# curl -sSL https://raw.githubusercontent.com/mufeng05/turboacc/main/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

# --- esurfingclient 构建依赖修正 ---
# 上游 Makefile 写的是 PKG_BUILD_DEPENDS:=libcurl
# 但 OpenWrt 的 PKG_BUILD_DEPENDS 需要【源码目录名】而非子包名
# 实际目录是 package/net/curl/（libcurl 是它产出的子包）
# 依赖名错误导致 libcurl 不被预编译，CMake find_package(CURL REQUIRED) 直接失败
fix_esurfingclient_dep() {
    local makefile="package/esurfingclient-full/esurfingclient/Makefile"

    if [ ! -f "$makefile" ]; then
        echo "⚠️ 未找到 $makefile，跳过"
        return 0
    fi

    if grep -q '^PKG_BUILD_DEPENDS:=libcurl$' "$makefile"; then
        echo "🔧 修正 esurfingclient 构建依赖: libcurl -> curl"
        sed -i 's/^PKG_BUILD_DEPENDS:=libcurl$/PKG_BUILD_DEPENDS:=curl/' "$makefile"
    else
        echo "✅ esurfingclient 依赖正常或已修正"
    fi

    echo "   当前值: $(grep -E '^PKG_BUILD_DEPENDS' "$makefile" || echo '未设置')"
}

# --- 版本号 ---
fix_libgcc_version() {
    local makefile="package/libs/toolchain/Makefile"
    local gcc_bin
    local gcc_ver
    local current_ver

    # 1. 尝试从工具链中获取正确的版本
    # 优先使用交叉编译的 gcc，如果不存在则使用宿主 gcc
    if command -v aarch64-openwrt-linux-musl-gcc >/dev/null 2>&1; then
        gcc_bin="aarch64-openwrt-linux-musl-gcc"
    elif command -v arm-openwrt-linux-musl-gcc >/dev/null 2>&1; then
        gcc_bin="arm-openwrt-linux-musl-gcc"
    elif command -v gcc >/dev/null 2>&1; then
        gcc_bin="gcc"
    else
        echo "⚠️ 未找到 gcc，跳过版本修复"
        return 1
    fi

    gcc_ver=$($gcc_bin -dumpversion 2>/dev/null | cut -d. -f1-3)
    if [ -z "$gcc_ver" ]; then
        echo "⚠️ 无法获取 gcc 版本，跳过修复"
        return 1
    fi

    echo "✅ 检测到 GCC 版本: $gcc_ver"

    # 2. 检查 Makefile 中的当前 PKG_VERSION
    if [ -f "$makefile" ]; then
        current_ver=$(grep -E '^PKG_VERSION\s*:=' "$makefile" | head -1 | sed 's/.*:=//' | xargs)
        echo "当前 PKG_VERSION: $current_ver"

        # 如果版本号是 "unknown" 或以 "unknown" 开头，则进行修复
        if echo "$current_ver" | grep -qi "unknown"; then
            echo "🔧 检测到 PKG_VERSION 为 unknown，正在修复为 $gcc_ver"
            sed -i "s/^PKG_VERSION\s*:=.*/PKG_VERSION:=$gcc_ver/" "$makefile"
            # 同时清理构建状态
            rm -rf build_dir/target-*/toolchain
            echo "✅ 已修复并清理构建目录"
        else
            echo "✅ PKG_VERSION 正常，无需修复"
        fi
    else
        echo "⚠️ 未找到 $makefile，跳过"
    fi
}

# 执行修复
fix_esurfingclient_dep
fix_libgcc_version
