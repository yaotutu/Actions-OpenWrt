#!/bin/bash

# GL.iNet GL-MT3000 / Beryl AX
echo 'CONFIG_TARGET_mediatek=y' >> $BUILD_ROOT/.config
echo 'CONFIG_TARGET_mediatek_filogic=y' >> $BUILD_ROOT/.config
echo 'CONFIG_TARGET_mediatek_filogic_DEVICE_glinet_gl-mt3000=y' >> $BUILD_ROOT/.config

# LuCI
echo 'CONFIG_PACKAGE_luci=y' >> $BUILD_ROOT/.config
echo 'CONFIG_PACKAGE_luci-ssl=y' >> $BUILD_ROOT/.config
echo 'CONFIG_LUCI_LANG_zh_Hans=y' >> $BUILD_ROOT/.config

# daed
echo 'CONFIG_PACKAGE_daed=y' >> $BUILD_ROOT/.config
echo 'CONFIG_PACKAGE_luci-app-daed=y' >> $BUILD_ROOT/.config
echo 'CONFIG_PACKAGE_luci-compat=y' >> $BUILD_ROOT/.config

# daed eBPF requirements
echo 'CONFIG_DEVEL=y' >> $BUILD_ROOT/.config
echo 'CONFIG_KERNEL_DEBUG_INFO=y' >> $BUILD_ROOT/.config
echo 'CONFIG_KERNEL_DEBUG_INFO_REDUCED=n' >> $BUILD_ROOT/.config
echo 'CONFIG_KERNEL_DEBUG_INFO_BTF=y' >> $BUILD_ROOT/.config
echo 'CONFIG_KERNEL_CGROUPS=y' >> $BUILD_ROOT/.config
echo 'CONFIG_KERNEL_CGROUP_BPF=y' >> $BUILD_ROOT/.config
echo 'CONFIG_KERNEL_BPF_EVENTS=y' >> $BUILD_ROOT/.config
echo 'CONFIG_BPF_TOOLCHAIN_HOST=y' >> $BUILD_ROOT/.config
echo 'CONFIG_KERNEL_XDP_SOCKETS=y' >> $BUILD_ROOT/.config
echo 'CONFIG_PACKAGE_kmod-xdp-sockets-diag=y' >> $BUILD_ROOT/.config

# sing-box
echo 'CONFIG_PACKAGE_sing-box=y' >> $BUILD_ROOT/.config
echo '# CONFIG_SING_BOX_BUILD_CLASH_API is not set' >> $BUILD_ROOT/.config
echo '# CONFIG_SING_BOX_BUILD_TAILSCALE is not set' >> $BUILD_ROOT/.config
echo '# CONFIG_SING_BOX_BUILD_ACME is not set' >> $BUILD_ROOT/.config
echo '# CONFIG_SING_BOX_BUILD_DHCP is not set' >> $BUILD_ROOT/.config
echo '# CONFIG_SING_BOX_BUILD_EMBEDDED_TOR is not set' >> $BUILD_ROOT/.config
echo '# CONFIG_SING_BOX_BUILD_V2RAY_API is not set' >> $BUILD_ROOT/.config
echo 'CONFIG_SING_BOX_BUILD_GVISOR=y' >> $BUILD_ROOT/.config
echo 'CONFIG_SING_BOX_BUILD_QUIC=y' >> $BUILD_ROOT/.config
echo 'CONFIG_SING_BOX_BUILD_UTLS=y' >> $BUILD_ROOT/.config

# Explicitly avoid noisy proxy stacks
echo '# CONFIG_PACKAGE_luci-app-openclash is not set' >> $BUILD_ROOT/.config
echo '# CONFIG_PACKAGE_luci-app-passwall is not set' >> $BUILD_ROOT/.config
echo '# CONFIG_PACKAGE_luci-app-passwall2 is not set' >> $BUILD_ROOT/.config
echo '# CONFIG_PACKAGE_luci-app-ssr-plus is not set' >> $BUILD_ROOT/.config
echo '# CONFIG_PACKAGE_mihomo is not set' >> $BUILD_ROOT/.config
echo '# CONFIG_PACKAGE_clash is not set' >> $BUILD_ROOT/.config
