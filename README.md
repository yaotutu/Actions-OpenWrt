# GL.iNet GL-MT3000 OpenWrt Builder

Repository: https://github.com/yaotutu/gl-mt3000-openwrt

这是一个独立的 OpenWrt 固件构建仓库，用于在 GitHub Actions 中为 **GL.iNet GL-MT3000 / Beryl AX** 生成定制固件。

它不是 `P3TERX/Actions-OpenWrt` 的维护分支：不追求与该模板保持同步，也不会把该模板当作 upstream 进行合并。项目按自身需求维护，只跟随必要的 OpenWrt stable 版本和 PassWall 相关软件源。

## 固件配置

- 设备：GL.iNet GL-MT3000 / Beryl AX
- 目标：`mediatek/filogic`
- 架构：`aarch64_cortex-a53`
- Profile：`glinet_gl-mt3000`
- 界面：LuCI、HTTPS、简体中文
- 代理：PassWall2，并包含 Xray、SingBox、Hysteria、NaiveProxy、Shadowsocks 组件
- DNS：`dnsmasq-full`
- 无线漫游：`wpad-mbedtls`、`usteer`
- 默认 LAN：`192.168.55.1`

## 工作流

| Workflow | 用途 |
| --- | --- |
| `Build OpenWrt (ImageBuilder)` | 快速构建路径。使用固定版本 OpenWrt 24.10.8，下载官方 ImageBuilder，加入 PassWall 预编译软件源并生成固件。 |
| `Build OpenWrt (source)` | 从固定的 OpenWrt 24.10.8 源码完整编译。适合深度定制，耗时长、磁盘占用高。 |

构建产物会上传到 GitHub Actions Artifacts 和 Releases。

## 手动构建

1. 打开 GitHub 仓库的 **Actions** 页面。
2. 选择要运行的 workflow：
   - 日常使用建议选择 **Build OpenWrt (ImageBuilder)**。
   - 需要源码级定制时选择 **Build OpenWrt (source)**。
3. 点击 **Run workflow**。版本已在 workflow 中固定为 OpenWrt 24.10.8，无需填写。
4. 构建完成后，从 Artifacts 或 Releases 下载固件。

## 维护策略

- 这是一个独立维护的构建配置仓库，不设置、不合并、不同步 `P3TERX/Actions-OpenWrt`。
- 当前固定使用 OpenWrt 24.10.8；这是有意决策，避免运行时自动选择 PassWall feed 尚未支持的新版本。
- PassWall 相关 feed 按兼容性需要更新，不盲目追逐开发分支。
- 修改设备、软件包或默认配置时，需要同时检查 ImageBuilder 和源码编译两条路径。
- 不提交本地 `buildspace/`、`imagebuilder/`、下载缓存、固件输出等生成物。

## 验证

本仓库没有单元测试框架，常规改动至少执行：

```bash
bash -n custom-config.sh custom-feeds.sh custom-packages.sh prebuild-misc.sh files/etc/uci-defaults/99_custom_network
git diff --check
```

如本机有 Ruby，可再解析 workflow YAML：

```bash
ruby -e 'require "yaml"; %w[.github/workflows/build-imagebuilder.yml .github/workflows/build-openwrt.yml].each { |f| YAML.safe_load_file(f, aliases: true) }'
```

## 致谢

本项目历史上衍生自 MIT 授权的 Actions-OpenWrt 模板，并使用了以下项目或服务：

- [OpenWrt](https://github.com/openwrt/openwrt)
- [OpenWrt Passwall](https://github.com/Openwrt-Passwall)
- [GitHub Actions](https://github.com/features/actions)

## License

[MIT](./LICENSE). 原始模板版权声明保留在 LICENSE 文件中。
