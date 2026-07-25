fix_rust_compile_error() {
    if [ -f "$BUILD_ROOT/feeds/packages/lang/rust/Makefile" ]; then
        sed -i 's/download-ci-llvm=true/download-ci-llvm=false/g' "$BUILD_ROOT/feeds/packages/lang/rust/Makefile"
    fi
}

# openwrt-24.10 ships Go 1.23, but geoview 0.2.x and recent sing-box/xray
# require Go >= 1.25. Replace the feed's golang with a newer toolchain.
upgrade_golang() {
    if [ -d "$BUILD_ROOT/feeds/packages/lang/golang" ]; then
        rm -rf "$BUILD_ROOT/feeds/packages/lang/golang"
        git clone --depth 1 -b 25.x https://github.com/sbwml/packages_lang_golang.git "$BUILD_ROOT/feeds/packages/lang/golang"
    fi
}

fix_rust_compile_error
upgrade_golang