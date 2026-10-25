# ImmortalWrt for NanoPi R4S

基于 GitHub Actions 自动编译 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 固件，为 **FriendlyElec NanoPi R4S** 定制。

---

## 固件信息

| 项目 | 值 |
|---|---|
| 源码 | [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) |
| 分支 | `openwrt-25.12`（默认）/ `openwrt-24.10` |
| 目标平台 | `rockchip` / `armv8` |
| 设备 | `friendlyarm_nanopi-r4s` |
| 内核分区 | 32 MB |
| 根文件系统分区 | 2048 MB |
| 软件包数 | 154 |

---

## 使用方法

### 触发构建

进入 **Actions** → **OpenWrt Build** → **Run workflow**

| 参数 | 说明 |
|---|---|
| **源码分支** | 选择 `openwrt-25.12`（默认）或 `openwrt-24.10` |
| **缓存加速** | 勾选后缓存 `dl` 目录和 ccache，后续构建更快<br>首次构建无缓存，仍需全量编译 |

### 下载固件

**方式一：Release（保留最新 3 个版本）**

右侧 **Releases** → 选择最新版本 → 下载 `*sysupgrade*.img.gz`

**方式二：Artifacts（保留 3 天）**

Actions 运行详情页底部 → **Artifacts** → 下载 `openwrt-firmware-*`

### 刷入设备

```bash
# 上传到路由器
scp immortalwrt-*-sysupgrade.img.gz root@192.168.1.1:/tmp/

# 校验并刷入（保留配置）
ssh root@192.168.1.1
sysupgrade -k /tmp/immortalwrt-*-sysupgrade.img.gz
```

---

## 预装软件

### 网络代理与分流

| 软件 | 说明 |
|---|---|
| **OpenClash** | Clash Meta 内核，支持 fake-ip / TPROXY |
| **MosDNS** | DNS 分流、缓存、广告过滤 |
| **geo2txt** | geoip/geosite 数据解包工具 |
| **v2ray-geoip / geosite** | GeoIP / GeoSite 数据 |

DNS 链路：

```
LAN 客户端 → dnsmasq(53) → MosDNS(5335) ─┬─ 国内域名 → 国内 DNS
                                          ├─ 国外域名 → Clash(7874) fake-ip
                                          └─ 广告域名 → 0.0.0.0
```

### 校园网认证

| 软件 | 说明 |
|---|---|
| **ESurfingClient** | 天翼校园网认证客户端 |
| **luci-app-esurfingclient** | Web 配置界面 |

### 组网与远程

| 软件 | 说明 |
|---|---|
| **EasyTier** | 去中心化组网（含 Web 控制台） |
| **UA3F** | UA 伪装 |
| **ttyd** | 网页终端 |
| **FileBrowser** | 网页文件管理 |

### 系统工具

| 软件 | 说明 |
|---|---|
| **fancontrol** | 风扇温控，支持自定义曲线 |
| **luci-app-diskman** | 磁盘管理 |
| **luci-app-upnp** | UPnP / NAT-PMP |
| **luci-app-wol** | 网络唤醒 |
| **LuCI Argon 主题** | 界面主题 |

### 内核与性能

| 配置 | 说明 |
|---|---|
| **BBR** | TCP 拥塞控制 |
| **fq_codel** | 默认队列规则 |
| **flowtable** | nftables 流量卸载 |
| **r8168 驱动** | WAN 口使用 Realtek 官方驱动 |
| **MT7921U** | USB WiFi 6 网卡支持 |

---

## 仓库结构

```
.
├── .config                     # 固件配置
├── diy-part1.sh                # 克隆第三方软件源
├── diy-part2.sh                # 编译前修改
├── .github/workflows/build.yml # 构建流程
└── README.md
```

### `diy-part1.sh`

从以下仓库克隆官方 feed 之外的软件：

| 仓库 | 提供的包 |
|---|---|
| [SunBK201/UA3F](https://github.com/SunBK201/UA3F) | `ua3f` |
| [JiaY-shi/fancontrol](https://github.com/JiaY-shi/fancontrol) | `fancontrol` / `luci-app-fancontrol` |
| [EasyTier/luci-app-easytier](https://github.com/EasyTier/luci-app-easytier) | `easytier` / `luci-app-easytier` |
| [sbwml/luci-app-mosdns](https://github.com/sbwml/luci-app-mosdns) | `mosdns` / `luci-app-mosdns` / `geo2txt` |
| [BadGhost520/ESurfingClient-CVersion](https://github.com/BadGhost520/ESurfingClient-CVersion) | `esurfingclient` / `luci-app-esurfingclient` |

### `.config`

在官方默认配置基础上：

**新增**

```
CONFIG_PACKAGE_esurfingclient=y
CONFIG_PACKAGE_luci-app-esurfingclient=y
CONFIG_PACKAGE_mosdns=y
CONFIG_PACKAGE_luci-app-mosdns=y
CONFIG_PACKAGE_geo2txt=y
CONFIG_PACKAGE_v2ray-geoip=y
CONFIG_PACKAGE_v2ray-geosite=y
```

**移除**

| 包 | 原因 |
|---|---|
| `luci-app-turboacc` | 与 nft flowtable 功能冲突 |
| `r8169-firmware` | WAN 口使用 r8168 驱动 |
| `iptables-mod-*` / `kmod-ipt-*` 系列 | 系统使用 nft |

### `.github/workflows/build.yml`

构建流程共 23 个步骤：

```
Checkout
  ↓
Show build target          ← 打印仓库/分支/配置/缓存状态
  ↓
Initialization environment ← 安装编译依赖
  ↓
Check disk space           ← 要求 ≥ 20GB
  ↓
Clone source code          ← 浅克隆指定分支
  ↓
Load custom feeds          ← 执行 diy-part1.sh
  ↓
Update / Install feeds
  ↓
Load custom configuration  ← 按分支选择 .config
  ↓
Apply custom modifications ← 执行 diy-part2.sh
  ↓
Migrate .config            ← diffconfig 精简
  ↓
Restore build cache        ← 可选
  ↓
Download package
  ↓
Save build cache           ← 可选
  ↓
Compile the firmware       ← 全量编译
  ↓
Check firmware existence
  ↓
Upload to Artifact + Release
```

主要特性：

| 特性 | 说明 |
|---|---|
| **缓存两阶段** | restore / save 分离，确保缓存有效 |
| **并发控制** | 同分支重复触发时取消旧构建 |
| **超时限制** | 300 分钟上限 |
| **编译日志** | 失败时上传 `build.log` 便于排查 |
| **失败重试** | 并行失败自动降级单线程 |
| **分支配置** | 支持 `.config.<版本>` 专属配置 |

---

## 常见问题

### 构建失败怎么看原因？

1. 进入失败的 Actions 运行
2. 下载底部 **Artifacts** 中的 `build-log-*`
3. 搜索 `Error` 或 `failed`

### 如何增删软件包？

编辑 `.config`：

```ini
# 添加
CONFIG_PACKAGE_包名=y

# 移除（任选其一）
# CONFIG_PACKAGE_包名 is not set
删掉该行（make defconfig 会补默认值）
```

### 如何添加第三方软件源？

在 `diy-part1.sh` 末尾追加：

```bash
clone_pkg https://github.com/用户名/仓库名.git package/目录名
```

然后在 `.config` 中加入对应包名。需确认仓库**根目录直接是 package 目录**（含 `Makefile`）。

### 24.10 分支能构建吗？

可以尝试，但 `.config` 基于 25.12 编写：

- 部分包在 24.10 feed 中可能不存在
- 构建时会输出 `::warning::` 提示
- 如需稳定构建，请创建 `.config.24.10` 针对该分支调整

---

## 升级注意事项

OpenWrt 默认只保留 `/etc/config/`、`/etc/passwd`、`/etc/shadow`、`/etc/dropbear/`。

本项目使用的 OpenClash、MosDNS 等配置**不在此列**，升级前需手动处理。

**1. 补充保留路径**

编辑 `/etc/sysupgrade.conf`，追加：

```
/etc/openclash/custom/
/etc/openclash/config/
/etc/openclash/rule_provider/
/etc/openclash/history/
/etc/mosdns/rule/
/etc/mosdns/config_custom.yaml
/etc/apk/repositories.d/
```

**2. 备份配置**

```bash
tar -czf /tmp/config-backup.tar.gz \
  /etc/config \
  /etc/openclash/custom \
  /etc/openclash/config \
  /etc/mosdns \
  /etc/apk
```

**3. 记录已装包**

```bash
apk list --installed > /tmp/pkg-before-upgrade.txt
```

**4. 升级后重装**

以下包不在官方源，升级后需重新安装：

- `luci-app-openclash` / `openclash`
- `mosdns` / `luci-app-mosdns` / `geo2txt`
- `v2ray-geoip` / `v2ray-geosite`
- `esurfingclient` / `luci-app-esurfingclient`
- `ua3f` / `fancontrol` / `easytier`

---

## 已知限制

| 项目 | 说明 |
|---|---|
| **WiFi 单频** | MT7921U 单网卡，2.4G 与 5G 不能同时工作 |
| **校园网认证** | `esurfingclient` 依赖校园网环境，非该校用户建议移除 |
| **IPv6** | 上游未下发 RA，需网络侧支持 |
| **编译时长** | 全量编译约 2-3 小时 |

---

## 致谢

本仓库基于 [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) 模板。

- [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) — 固件源码
- [vernesong/OpenClash](https://github.com/vernesong/OpenClash) — OpenClash
- [sbwml/luci-app-mosdns](https://github.com/sbwml/luci-app-mosdns) — MosDNS 及其 LuCI
- [BadGhost520/ESurfingClient-CVersion](https://github.com/BadGhost520/ESurfingClient-CVersion) — 校园网认证
- [EasyTier](https://github.com/EasyTier/EasyTier) — 组网工具
- [SunBK201/UA3F](https://github.com/SunBK201/UA3F) — UA 伪装
- [JiaY-shi/fancontrol](https://github.com/JiaY-shi/fancontrol) — 风扇控制
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release) — Release 发布
- [Mattraks/delete-workflow-runs](https://github.com/Mattraks/delete-workflow-runs) — 清理历史运行
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases) — 清理旧发布

## License

[MIT](LICENSE) © [P3TERX](https://github.com/P3TERX)
