#!/usr/bin/env bash
# Installs the pre-commit format hook into the Accel-Sim and GPGPU-Sim repos.
set -euo pipefail

THIS_DIR="$( cd "$( dirname "$BASH_SOURCE" )" && pwd )"
ROOT="$(cd "$THIS_DIR/../.." && pwd)"
HOOK="$THIS_DIR/pre-commit"
chmod +x "$HOOK"

for repo in "$ROOT" "$ROOT/gpu-simulator/gpgpu-sim"; do
    [ -e "$repo/.git" ] || continue
    hooks_dir="$(git -C "$repo" rev-parse --absolute-git-dir)/hooks"
    mkdir -p "$hooks_dir"
    target="$hooks_dir/pre-commit"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$target.bak"
        echo "Backed up existing hook to $target.bak"
    fi
    ln -sf "$HOOK" "$target"
    echo "Installed pre-commit hook in $repo"
done
