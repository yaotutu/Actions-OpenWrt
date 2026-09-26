# GL.iNet GL-MT3000 OpenWrt Firmware

这是一个独立维护的 GL.iNet **GL-MT3000 / Beryl AX** OpenWrt 固件构建项目，使用 GitHub Actions 生成可刷写的定制固件。

- 仓库：<https://github.com/yaotutu/gl-mt3000-openwrt>
- 最新固件：<https://github.com/yaotutu/gl-mt3000-openwrt/releases/latest>

## 当前固件

| 项目 | 配置 |
| --- | --- |
| 硬件 | GL.iNet GL-MT3000 / Beryl AX |
| OpenWrt | `24.10.8`（固定版本） |
| Target | `mediatek/filogic` |
| 架构 | `aarch64_cortex-a53` |
| Profile | `glinet_gl-mt3000` |
| 管理界面 | LuCI、HTTPS、简体中文 |
| 无线 / 漫游 | `wpad-mbedtls`、`usteer` |
| 代理 | PassWall2、Xray、SingBox、Hysteria、NaiveProxy、Shadowsocks 组件 |
| DNS | `dnsmasq-full` |
| 默认 LAN 地址 | `192.168.55.1` |

固件包含的主要目的：

- 为 GL-MT3000 提供一个可重复构建、可验证的 OpenWrt 24.10.8 版本
- 内置 LuCI 中文管理界面和 HTTPS 访问
- 内置 PassWall2 及常用核心，避免刷机后再手动安装依赖
- 使用 `wpad-mbedtls` 与 `usteer`，方便作为有线 AP / 漫游节点使用
- 保留官方 OpenWrt sysupgrade 镜像结构，方便常规升级

## 下载固件

[Releases](https://github.com/yaotutu/gl-mt3000-openwrt/releases/latest)

通常下载这个文件即可：

```text
openwrt-24.10.8-mediatek-filogic-glinet_gl-mt3000-squashfs-sysupgrade.bin
```

同时建议下载 `sha256sums`，确认固件哈希一致后再刷写。

可以用以下方式校验：

```bash
sha256sum openwrt-24.10.8-mediatek-filogic-glinet_gl-mt3000-squashfs-sysupgrade.bin
sha256sum -c sha256sums
```

具体哈希以对应 Release 发布的 `sha256sums` 为准。

## 在线检查与升级

固件内置 `gl-mt3000-update`，它只查询**本仓库自己的 GitHub Releases**，不会使用 OpenWrt 官方升级源，也不会自动把固件切到官方默认包组合。

可以在 LuCI 中打开：

```text
System → Online Update / 在线更新
```

页面支持：

- 查询最新 Release
- 下载并校验固件
- 在线升级
- 可选强制同版本重刷

也可以在 SSH 中执行：

```bash
# 只检查是否有新版本
gl-mt3000-update check

# 下载并校验固件
gl-mt3000-update download

# 下载、校验、测试镜像并升级
gl-mt3000-update upgrade
```

更新流程为：

1. 查询 `yaotutu/gl-mt3000-openwrt` 的最新 GitHub Release
2. 下载对应的 GL-MT3000 sysupgrade 镜像
3. 从 Release 中的 `sha256sums` 校验 SHA256
4. 执行 `sysupgrade -T` 检查镜像
5. 通过 `sysupgrade` 在线升级

默认保留路由器配置。在线更新相关的源仓库和策略配置在：

```text
/etc/config/gl-mt3000-update
```

注意：当前已经刷在设备上的旧固件不会自动获得这个新脚本。需要先手动刷入一次包含 `gl-mt3000-update` 的固件；之后的新版本就可以在路由器上直接在线检查和升级。

## 刷机注意

本项目只面向 GL.iNet GL-MT3000 / Beryl AX，不要刷到其它设备。

重要提醒：

1. 首次启动后，LAN 地址为：

   ```text
   192.168.55.1
   ```

2. OpenWrt 出厂默认通常没有 root 密码。请首次进入 LuCI 后立即设置密码。
3. 如果从其它 OpenWrt 固件升级，优先使用 LuCI 的 **System → Backup / Flash Firmware** 或 `sysupgrade`。
4. 从非 OpenWrt 固件切换时，请先确认 GL.iNet 设备的分区和恢复方式，不要盲目使用这个 sysupgrade 镜像。
5. 刷机前请确认电源稳定，并保留原厂固件或可恢复方案。
6. 如果不确定当前分区状态，先不要勾选保留配置，避免旧配置与新固件不兼容。

## 构建

本项目提供两条手动构建路径，不需要在运行时填写 OpenWrt 版本。

### 推荐：ImageBuilder 快速构建

适合生成日常固件：

1. 打开仓库的 **Actions** 页面。
2. 选择 **Build OpenWrt (ImageBuilder)**。
3. 点击 **Run workflow**。
4. 构建完成后，从 Artifacts 或 Releases 下载固件。

ImageBuilder 会：

- 下载并校验 OpenWrt `24.10.8` 官方 ImageBuilder
- 添加 PassWall 预编译软件源，并使用仓库内固定的签名公钥
- 安装本项目配置的软件包
- 生成 GL-MT3000 的 sysupgrade 镜像、manifest、BOM 和校验文件
- 构建后校验 `sha256sums`，并确认必备/排除包没有漂移

### 备用：源码完整编译

适合需要修改 OpenWrt 源码或深度定制时使用：

1. 打开仓库的 **Actions** 页面。
2. 选择 **Build OpenWrt (source)**。
3. 选择是否开启 SSH 调试。
4. 点击 **Run workflow**。

源码编译会锁定 OpenWrt `v24.10.8` tag，并使用本仓库中的 `custom-*.sh` 脚本加载定制配置。

## 文件结构

```text
.github/workflows/build-imagebuilder.yml  # ImageBuilder 构建流程
.github/workflows/build-openwrt.yml       # 源码完整编译流程
custom-config.sh                          # 源码编译的 .config 定制
custom-feeds.sh                           # 源码编译的 PassWall feed
custom-packages.sh                        # 源码编译的 files/ 覆盖
prebuild-misc.sh                          # 源码编译前的兼容修补
files/etc/uci-defaults/99_custom_network  # 首次启动设置 LAN 地址
files/etc/config/gl-mt3000-update        # 在线更新源和策略配置
files/etc/gl-mt3000-release              # 当前固件对应的构建标识
files/usr/sbin/gl-mt3000-update          # 本仓库 Release 在线更新脚本
files/www/luci-static/resources/view/gl-mt3000-update.js
                                          # LuCI 在线更新页面
files/usr/share/luci/menu.d/luci-app-gl-mt3000-update.json
                                          # LuCI 菜单注册
files/usr/share/rpcd/acl.d/luci-app-gl-mt3000-update.json
                                          # LuCI 页面执行权限
keys/passwall.ipk.pub                    # 固定的 PassWall feed 签名公钥
dependencies-ubuntu.txt                   # 源码编译依赖
```

## 版本策略

本项目固定使用 **OpenWrt 24 stable 家族**，当前版本为 `24.10.8`。

维护规则：

- 只考虑 OpenWrt 24 家族内的更新，不自动切换到 `25.12` 或更新的版本系列。
- 如果出现新的 `24.10.x` patch 版本，或 `24.11` 这类 24 家族新系列，更新前会先确认。
- 升级前必须确认 OpenWrt tag 存在，且 PassWall 二进制 feed 提供对应的 `packages-<series>`。
- PassWall 相关 feed 按兼容性需要更新，不盲目跟随开发分支。
- 版本固定在两个 workflow 的 `OPENWRT_VERSION` 环境变量中，运行时没有版本输入。

## 开发与验证

本仓库没有单元测试框架。常规改动至少执行：

```bash
bash -n custom-config.sh custom-feeds.sh custom-packages.sh prebuild-misc.sh files/etc/uci-defaults/99_custom_network
git diff --check
```

也可解析 workflow YAML：

```bash
ruby -e 'require "yaml"; %w[.github/workflows/build-imagebuilder.yml .github/workflows/build-openwrt.yml].each { |f| YAML.safe_load_file(f, aliases: true) }'
```

不要提交以下生成物：

```text
buildspace/
imagebuilder/
*.tar.zst
*.tar.xz
bin/
```

完整固件编译耗时较长。除非明确需要，优先使用 GitHub Actions 验证。

## 致谢

- [OpenWrt](https://github.com/openwrt/openwrt)
- [OpenWrt PassWall](https://github.com/Openwrt-Passwall)
- [GitHub Actions](https://github.com/features/actions)
- 历史模板 [Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)

## License

[MIT](./LICENSE)
