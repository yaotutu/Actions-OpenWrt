#!/bin/bash

set -e

# Nikki: transparent proxy with Mihomo on OpenWrt.
echo 'src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;v1.26.1' >> "$BUILD_ROOT/feeds.conf.default"
