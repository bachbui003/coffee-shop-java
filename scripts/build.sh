#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
maven_cmd=${MAVEN_CMD:-mvn}
args=(-B -ntp)
if [ -n "${MAVEN_SETTINGS_FILE:-}" ]; then args+=(-s "$MAVEN_SETTINGS_FILE"); fi
if [ -n "${COFFEE_MAVEN_CACHE:-}" ]; then args+=("-Dmaven.repo.local=$COFFEE_MAVEN_CACHE"); fi
"$maven_cmd" "${args[@]}" package
