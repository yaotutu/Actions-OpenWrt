#!/bin/bash

set -e

# GL.iNet GL-MT3000 / Beryl AX
echo 'CONFIG_TARGET_mediatek=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_TARGET_mediatek_filogic=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_TARGET_mediatek_filogic_DEVICE_glinet_gl-mt3000=y' >> "$BUILD_ROOT/.config"

# LuCI
echo 'CONFIG_PACKAGE_luci=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_luci-ssl=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_LUCI_LANG_zh_Hans=y' >> "$BUILD_ROOT/.config"

# Nikki
echo 'CONFIG_PACKAGE_mihomo-meta=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_nikki=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_luci-app-nikki=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_luci-i18n-nikki-zh-cn=y' >> "$BUILD_ROOT/.config"

# Keep proxy stack surface limited to Nikki.
echo '# CONFIG_PACKAGE_sing-box is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_momo is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_luci-app-momo is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_luci-i18n-momo-zh-cn is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_mihomo is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_mihomo-alpha is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_luci-app-mihomo is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_luci-i18n-mihomo-zh-cn is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_luci-app-openclash is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_luci-app-passwall is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_luci-app-passwall2 is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_luci-app-ssr-plus is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_clash is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_daed is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_dae is not set' >> "$BUILD_ROOT/.config"
echo '# CONFIG_PACKAGE_luci-app-daed is not set' >> "$BUILD_ROOT/.config"
