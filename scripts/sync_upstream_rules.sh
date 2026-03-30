#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

sync_rule_required() {
  local url="$1"
  local target="$2"

  echo "Syncing required rule ${target} from ${url}"
  curl -fsSL --retry 3 --connect-timeout 20 "$url" -o "${ROOT_DIR}/${target}"
}

sync_rule_optional() {
  local url="$1"
  local target="$2"
  local tmp_file

  tmp_file="$(mktemp)"

  echo "Syncing optional rule ${target} from ${url}"
  if curl -fsSL --retry 3 --connect-timeout 20 "$url" -o "${tmp_file}"; then
    mv "${tmp_file}" "${ROOT_DIR}/${target}"
    echo "Updated ${target}"
  else
    rm -f "${tmp_file}"
    echo "Warning: upstream unavailable, keeping existing ${target}"
  fi
}

sync_rule_optional \
  "https://raw.githubusercontent.com/fmz200/wool_scripts/main/Loon/rule/GFWlist.list" \
  "rules/20_global_proxy.list"

sync_rule_required \
  "https://raw.githubusercontent.com/fmz200/wool_scripts/main/Loon/rule/rejectAd.list" \
  "rules/21_adblock_reject.list"

sync_rule_optional \
  "https://raw.githubusercontent.com/fmz200/wool_scripts/main/Loon/rule/Proxy-List.list" \
  "rules/22_proxy_list.list"

sync_rule_required \
  "https://raw.githubusercontent.com/fmz200/wool_scripts/main/Loon/rule/AI.list" \
  "rules/40_ai_proxy.list"

echo "Upstream rule sync completed."
