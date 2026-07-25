#!/bin/bash

set -e

# PassWall2: packages feed + LuCI app feed.
# Prepend (not append) so passwall_packages wins over the official packages
# feed for duplicate packages (sing-box, xray-core, v2ray-geodata, ...).
sed -i '1i src-git passwall2 https://github.com/Openwrt-Passwall/openwrt-passwall2.git;main' "$BUILD_ROOT/feeds.conf.default"
sed -i '1i src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main' "$BUILD_ROOT/feeds.conf.default"
