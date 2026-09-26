# AGENTS.md

## 项目概览

这是一个用于自动构建 OpenWrt 固件的 GitHub Actions 配置仓库，当前主要面向 **GL.iNet GL-MT3000 / Beryl AX**：

- 目标：`mediatek/filogic`
- 架构：`aarch64_cortex-a53`
- Profile：`glinet_gl-mt3000`
- 语言/界面：LuCI、HTTPS（`luci-ssl`）、简体中文
- 无线/漫游：`wpad-mbedtls` 和 `usteer`
- 代理栈：PassWall2 及 Xray、SingBox、Hysteria、NaiveProxy、Shadowsocks 等相关组件
- DNS：用 `dnsmasq-full` 替换默认 `dnsmasq`
- 首次启动网络默认值：LAN 地址 `192.168.55.1`

仓库本身只包含构建配置和 workflow，不包含 OpenWrt 源码，也不包含常规单元测试。

## 仓库关系和维护政策

这个仓库按独立项目维护，不再把 `P3TERX/Actions-OpenWrt` 视为 upstream：

- 不要为它添加名为 `upstream` 的 remote。
- 不要尝试 merge、rebase 或同步该模板。
- 该模板只在历史来源和 MIT 许可证中保留署名，不参与后续维护决策。
- 需要跟随的外部构建输入是 OpenWrt stable release 和 PassWall 相关 feed，不是 P3TERX 模板。
- 如果你决定让 GitHub 仓库脱离 fork network，应使用 GitHub 仓库 Settings 中的 **Leave fork network**；这是仓库元数据变更，不需要修改本仓库文件。

## 目录职责

- `.github/workflows/build-imagebuilder.yml`：推荐/主要的快速构建入口。下载官方 OpenWrt ImageBuilder，添加 PassWall 二进制软件源，生成固件、Artifact 和 Release。
- `.github/workflows/build-openwrt.yml`：从 OpenWrt 源码完整编译；只支持手动 `workflow_dispatch`，耗时和磁盘占用远高于 ImageBuilder。
- `.github/workflows/update-checker.yml`：每天检查 OpenWrt 最新 tag；有新 tag 时通过 `repository_dispatch` 触发 `build-imagebuilder.yml`。注意它不触发 `build-openwrt.yml`。
- `custom-feeds.sh`：源码编译时把 PassWall2 相关 feed 插入到 `BUILD_ROOT/feeds.conf.default` 的最前面，以便优先于官方重复包。
- `custom-config.sh`：源码编译时追加目标设备、LuCI、PassWall2、联网和 DNS 配置到 `BUILD_ROOT/.config`。
- `custom-packages.sh`：源码编译时把本仓库 `files/` 复制到 OpenWrt 的 `files/` 目录。
- `prebuild-misc.sh`：源码编译前的兼容修补；当前会调整 Rust 编译参数并把 Go feed 升级到 25.x 分支。
- `files/etc/uci-defaults/99_custom_network`：首次启动时设置 LAN 地址 `192.168.55.1`。
- `dependencies-ubuntu.txt`：源码编译 workflow 的 Ubuntu 依赖列表。

## 构建路径差异

ImageBuilder 和源码编译不是简单共享同一套 helper 脚本：

- ImageBuilder workflow 内嵌 `TARGET`、`ARCH`、`PROFILE`、PassWall 仓库地址和 `PACKAGES` 列表；它不执行 `custom-*.sh`。
- 源码编译 workflow 调用 `custom-feeds.sh`、`custom-packages.sh`、`custom-config.sh` 和 `prebuild-misc.sh`。
- 因此修改目标设备、软件包、feed 或默认网络时，必须检查两条构建路径是否需要同步更新。
- PassWall 在源码编译中使用 GitHub feed；在 ImageBuilder 中使用预编译二进制 feed。包名或依赖变化可能只在其中一条路径失败。
- `custom-config.sh` 使用 `CONFIG_PACKAGE_luci-app-passwall2_*` 之类的选择项；ImageBuilder 直接指定具体 ipk 包名。不要假定二者完全同名或一一对应。

### Workflow 触发关系和已知坑

- `update-checker.yml` 每天 UTC 16:00（Asia/Shanghai 次日 00:00）运行，发现新 OpenWrt tag 后发送 `Source Code Update` 的 `repository_dispatch`。
- `build-imagebuilder.yml` 的 `repository_dispatch:` 没有限定 `types:`，因此它会响应这个 dispatch 事件并执行快速构建。
- `build-openwrt.yml` 只有手动 `workflow_dispatch`。它包含读取 `github.event.client_payload.version` 的自动选 tag 步骤，但当前没有 `repository_dispatch` 触发器，所以该分支实际不可达；调整前先确认用户想要自动触发哪条构建路径。

## 本地脚本约定

- `custom-config.sh`、`custom-feeds.sh` 和 `custom-packages.sh` 假设环境变量 `BUILD_ROOT` 指向已准备好的 OpenWrt 源码目录。
- 如果手动执行这些脚本，先设置 `BUILD_ROOT`，例如：
  ```bash
  BUILD_ROOT=/path/to/openwrt ./custom-feeds.sh
  ```
- `prebuild-misc.sh` 定义并执行两个函数，同样依赖 `BUILD_ROOT`。
- 这些脚本当前不是可执行文件；源码 workflow 会先执行 `chmod +x *.sh`，本地验证可直接用 `bash`/`.sh` 调用或先手动赋予执行权限。
- 不要提交 `buildspace/`、`imagebuilder/`、下载的压缩包、固件输出或其它 CI 生成物。

## 修改建议

- 修改设备/Profile 时，同步更新 `custom-config.sh` 和 `build-imagebuilder.yml` 的 `TARGET`、`ARCH`、`PROFILE` 与包列表。
- 增删 PassWall2 组件时，对照源码 feed 的 config 选择项和 ImageBuilder 二进制包名，避免两条构建路径配置漂移。
- 修改默认网络时，更新 `files/etc/uci-defaults/99_custom_network`，并确认源码和 ImageBuilder 都会覆盖该目录。
- 修改依赖时，核实 Ubuntu 24.04 可安装，并保留 `--no-install-recommends` 的低占用策略。
- Workflow 拥有 `contents: write`，会创建/删除 Release 和 tag。不要在验证脚本改动时意外触发这些清理或发布步骤。
- CI Release tag（例如 `IB_*`、`SNAPSHOT_*`）由 workflow 生成；不要为了本地调试手动创建或推送 tag。
- GitHub Actions 使用 `${{ github.event.inputs.version }}` 之类表达式时，注意 `workflow_dispatch` 和 `repository_dispatch` 的事件输入路径不同，当前 workflow 已经依赖这个差异。

## 验证

本仓库没有测试框架。改动后至少执行：

```bash
bash -n custom-config.sh custom-feeds.sh custom-packages.sh prebuild-misc.sh files/etc/uci-defaults/99_custom_network
git diff --check
```

如果本机有 Ruby，建议再解析 workflow YAML：

```bash
ruby -e 'require "yaml"; %w[.github/workflows/build-imagebuilder.yml .github/workflows/build-openwrt.yml .github/workflows/update-checker.yml].each { |f| YAML.safe_load_file(f, aliases: true) }'
```

完整 OpenWrt 编译和 ImageBuilder 下载耗时较长且会产生大量临时文件。除非用户明确要求，不要在本地执行完整构建；优先依赖语法检查、静态检查和 GitHub Actions 验证。
