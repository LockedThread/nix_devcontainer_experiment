#!/usr/bin/env sh

echo "Running check-requirements.sh"

ROOT="$(dirname $(dirname $(dirname $(readlink -f "$0"))))"

echo "ROOT=$ROOT"

# Set rpath before changing the interpreter path
# Refs https://github.com/NixOS/patchelf/issues/524
if [ -n "$VSCODE_SERVER_CUSTOM_GLIBC_LINKER" ] && [ -n "$VSCODE_SERVER_CUSTOM_GLIBC_PATH" ] && [ -n "$VSCODE_SERVER_PATCHELF_PATH" ]; then
	echo "Patching glibc from $VSCODE_SERVER_CUSTOM_GLIBC_PATH with $VSCODE_SERVER_PATCHELF_PATH..."
	"$VSCODE_SERVER_PATCHELF_PATH" --set-rpath "$VSCODE_SERVER_CUSTOM_GLIBC_PATH" "$ROOT/node"
	echo "Patching linker from $VSCODE_SERVER_CUSTOM_GLIBC_LINKER with $VSCODE_SERVER_PATCHELF_PATH..."
	"$VSCODE_SERVER_PATCHELF_PATH" --set-interpreter "$VSCODE_SERVER_CUSTOM_GLIBC_LINKER" "$ROOT/node"
	echo "Patching complete."
fi

#"$ROOT/node" "$ROOT/out/server-main.js" "$@"