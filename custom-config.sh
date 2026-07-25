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

# Wired AP roaming support
echo '# CONFIG_PACKAGE_wpad-basic-mbedtls is not set' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_wpad-mbedtls=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_usteer=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_luci-app-usteer=y' >> "$BUILD_ROOT/.config"

# PassWall2
echo 'CONFIG_PACKAGE_luci-app-passwall2=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_luci-i18n-passwall2-zh-cn=y' >> "$BUILD_ROOT/.config"

# dnsmasq-full replaces the default dnsmasq (required by PassWall2 nftset/dns features).
echo '# CONFIG_PACKAGE_dnsmasq is not set' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_dnsmasq-full=y' >> "$BUILD_ROOT/.config"

# Basic cores: both Xray and SingBox.
echo 'CONFIG_PACKAGE_luci-app-passwall2_Basic_Core_All=y' >> "$BUILD_ROOT/.config"

# Optional components; each select pulls in the correct package from the feed.
echo 'CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Hysteria=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_NaiveProxy=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Client=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Client=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Simple_Obfs=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_V2ray_Plugin=y' >> "$BUILD_ROOT/.config"

# GeoIP/GeoSite data built into the firmware (no runtime download needed).
echo 'CONFIG_PACKAGE_v2ray-geoip=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_v2ray-geosite=y' >> "$BUILD_ROOT/.config"
echo 'CONFIG_PACKAGE_geoview=y' >> "$BUILD_ROOT/.config"
