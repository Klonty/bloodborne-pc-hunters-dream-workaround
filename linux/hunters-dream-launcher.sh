#!/usr/bin/env bash
set -euo pipefail

export BB_HUNTERS_DREAM=1

if ! command -v wine >/dev/null 2>&1; then
    echo "wine was not found in PATH." >&2
    echo "Install Wine or run the Windows .bat through your Proton/Steam setup." >&2
    exit 1
fi

port_dir="${BBPORT_DIR:-.}"
target="${1:-$port_dir/Bloodborne.exe}"

if [[ ! -f "$target" ]]; then
    echo "Bloodborne.exe was not found: $target" >&2
    echo "Usage: $0 [/path/to/Bloodborne.exe]" >&2
    echo "   or: BBPORT_DIR=/path/to/bbport $0" >&2
    exit 1
fi

exec wine "$target" "${@:2}"
