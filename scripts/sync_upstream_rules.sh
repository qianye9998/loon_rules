#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

sync_rule() {
  local url="$1"
  local target="$2"

  echo "Syncing ${target} from ${url}"
  curl -fsSL --retry 3 --connect-timeout 20 "$url" -o "${ROOT_DIR}/${target}"
}

sync_rule \
  "https://raw.githubusercontent.com/fmz200/wool_scripts/main/Loon/rule/GFWlist.list" \
  "rules/20_global_proxy.list"

sync_rule \
  "https://raw.githubusercontent.com/fmz200/wool_scripts/main/Loon/rule/AdBlock.list" \
  "rules/21_adblock_reject.list"

sync_rule \
  "https://raw.githubusercontent.com/fmz200/wool_scripts/main/Loon/rule/Proxy-List.list" \
  "rules/22_proxy_list.list"

sync_rule \
  "https://raw.githubusercontent.com/fmz200/wool_scripts/main/Loon/rule/AI.list" \
  "rules/40_ai_proxy.list"

echo "Upstream rule sync completed."

