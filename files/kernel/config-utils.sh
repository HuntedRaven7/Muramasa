#!/bin/sh
# Tiny helper used by elements/base/kernel-ogc.bst. Sourced from the kernel
# source directory during configure.
set -eu

require_config() {
    sym="$1"
    if ! grep -q "^${sym}=y$" .config && ! grep -q "^${sym}=m$" .config; then
        echo "Missing required kernel option: ${sym}" >&2
        exit 1
    fi
}
