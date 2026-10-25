# ImmortalWrt for NanoPi R4S

基于 GitHub Actions 自动编译 [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) 固件，为 **FriendlyElec NanoPi R4S** 定制。

- 源码分支：`openwrt-25.12` / `openwrt-24.10`
- 预装 OpenClash、MosDNS、EasyTier、UA3F、fancontrol 等
- 使用方式：Actions → `OpenWrt Build` → Run workflow，完成后在 Releases 下载固件
- 校园网认证 `ESurfingClient` **不编入固件**（上游静态链接方式与 buildroot 冲突），刷机后手动安装官方预编译 apk

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
