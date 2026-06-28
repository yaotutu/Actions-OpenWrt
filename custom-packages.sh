#!/bin/bash

set -e

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

if [ -d "$REPO_ROOT/files" ]; then
    mkdir -p "$BUILD_ROOT/files"
    cp -a "$REPO_ROOT/files/." "$BUILD_ROOT/files/"
fi
