#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

sync_loon_rule() {
  local url="$1"
  local target="$2"

  echo "Syncing loon-formatted rule ${target} from ${url}"
  curl -fsSL --retry 3 --connect-timeout 20 "$url" -o "${ROOT_DIR}/${target}"
}

sync_domain_suffix_rule() {
  local url="$1"
  local target="$2"
  local tmp_file

  tmp_file="$(mktemp)"

  echo "Syncing domain list ${target} from ${url}"
  curl -fsSL --retry 3 --connect-timeout 20 "$url" -o "${tmp_file}"
  {
    echo "# Source: ${url}"
    echo "# Generated: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    sed '/^\s*$/d; /^\s*#/d' "${tmp_file}" | sed 's/^/DOMAIN-SUFFIX,/'
  } > "${ROOT_DIR}/${target}"
  rm -f "${tmp_file}"
}

dedupe_rule_file() {
  local file="$1"
  local tmp_file

  tmp_file="$(mktemp)"

  awk '
    /^[[:space:]]*$/ { next }
    /^[[:space:]]*#/ { print; next }
    !seen[$0]++ { print }
  ' "${file}" > "${tmp_file}"

  mv "${tmp_file}" "${file}"
}

dedupe_all_rules() {
  local rule_file

  for rule_file in "${ROOT_DIR}"/rules/*.list; do
    [ -f "${rule_file}" ] || continue
    echo "Deduplicating ${rule_file}"
    dedupe_rule_file "${rule_file}"
  done
}

sync_domain_suffix_rule \
  "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/china-list.txt" \
  "rules/10_domestic_direct.list"

sync_loon_rule \
  "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/Global/Global.list" \
  "rules/20_global_proxy.list"

dedupe_all_rules

echo "Upstream rule sync completed."
