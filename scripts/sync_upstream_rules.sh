#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

normalize_rule_stream() {
  sed 's/\r$//' \
    | sed '/^[[:space:]]*$/d; /^[[:space:]]*#/d' \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
    | sed 's/,[[:space:]]*/,/g'
}

sync_combined_rules() {
  local target="$1"
  shift
  local url
  local tmp_file

  tmp_file="$(mktemp)"

  {
    echo "# Generated: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo "# Sources:"
    for url in "$@"; do
      echo "# ${url}"
    done
  } > "${tmp_file}"

  for url in "$@"; do
    echo "Syncing ${target} from ${url}"
    curl -fsSL --retry 3 --connect-timeout 20 "$url" \
      | normalize_rule_stream >> "${tmp_file}"
  done

  mv "${tmp_file}" "${ROOT_DIR}/${target}"
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
  local generated_rules=(
    "${ROOT_DIR}/rules/10_domestic_direct.list"
    "${ROOT_DIR}/rules/20_global_proxy.list"
    "${ROOT_DIR}/rules/25_ai_proxy.list"
  )
  local rule_file

  for rule_file in "${generated_rules[@]}"; do
    [ -f "${rule_file}" ] || continue
    echo "Deduplicating ${rule_file}"
    dedupe_rule_file "${rule_file}"
  done
}

sync_combined_rules \
  "rules/10_domestic_direct.list" \
  "https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/ChinaDomian.list" \
  "https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/ChinaCompanyIp.list" \
  "https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/WeChat.list" \
  "https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/cn.list"

sync_combined_rules \
  "rules/20_global_proxy.list" \
  "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/Global/Global.list"

sync_combined_rules \
  "rules/25_ai_proxy.list" \
  "https://raw.githubusercontent.com/Moli-X/Tool/X/Loon/Rules/AI.list"

dedupe_all_rules

echo "Upstream rule sync completed."
