#!/bin/bash

set -e

# PassWall2: packages feed + LuCI app feed.
echo 'src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main' >> "$BUILD_ROOT/feeds.conf.default"
echo 'src-git passwall2 https://github.com/Openwrt-Passwall/openwrt-passwall2.git;main' >> "$BUILD_ROOT/feeds.conf.default"
