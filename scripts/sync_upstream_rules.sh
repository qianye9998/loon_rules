#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fetch_url() {
  local url="$1"

  env -u http_proxy -u https_proxy -u HTTP_PROXY -u HTTPS_PROXY -u all_proxy -u ALL_PROXY \
    curl -fsSL --retry 3 --retry-all-errors --connect-timeout 20 --max-time 300 "$url"
}

normalize_standard_rule_stream() {
  sed 's/\r$//' \
    | sed '/^[[:space:]]*$/d; /^[[:space:]]*#/d' \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
    | sed 's/,[[:space:]]*/,/g'
}

normalize_plain_domain_stream() {
  sed 's/\r$//' \
    | sed '/^[[:space:]]*$/d; /^[[:space:]]*#/d' \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
    | awk '
        /^[^,[:space:]]+$/ {
          gsub(/^\./, "", $0)
          print "DOMAIN-SUFFIX," $0
        }
      '
}

normalize_dnsmasq_domain_stream() {
  sed 's/\r$//' \
    | awk -F/ '
        /^[[:space:]]*server=\// {
          domain=$2
          if (domain != "") {
            print "DOMAIN-SUFFIX," domain
          }
        }
      '
}

normalize_by_type() {
  local source_type="$1"

  case "${source_type}" in
    standard)
      normalize_standard_rule_stream
      ;;
    plain_domain)
      normalize_plain_domain_stream
      ;;
    dnsmasq_domain)
      normalize_dnsmasq_domain_stream
      ;;
    *)
      echo "Unsupported source type: ${source_type}" >&2
      return 1
      ;;
  esac
}

sync_combined_rules() {
  local target="$1"
  shift
  local source
  local source_type
  local url
  local tmp_file
  local succeeded=0

  tmp_file="$(mktemp)"

  {
    echo "# Generated: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo "# Sources:"
    for source in "$@"; do
      url="${source#*|}"
      echo "# ${url}"
    done
  } > "${tmp_file}"

  for source in "$@"; do
    source_type="${source%%|*}"
    url="${source#*|}"

    echo "Syncing ${target} from ${url} (${source_type})"
    if fetch_url "$url" | normalize_by_type "${source_type}" >> "${tmp_file}"; then
      succeeded=$((succeeded + 1))
    else
      echo "Warning: failed to sync ${url}" >&2
    fi
  done

  if [ "${succeeded}" -eq 0 ]; then
    echo "No sources could be synced for ${target}" >&2
    rm -f "${tmp_file}"
    return 1
  fi

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
  local rule_files=(
    "${ROOT_DIR}/rules/10_domestic_direct.list"
    "${ROOT_DIR}/rules/20_custom_direct.list"
    "${ROOT_DIR}/rules/25_ai_proxy.list"
  )
  local rule_file

  for rule_file in "${rule_files[@]}"; do
    [ -f "${rule_file}" ] || continue
    echo "Deduplicating ${rule_file}"
    dedupe_rule_file "${rule_file}"
  done
}

sync_combined_rules \
  "rules/10_domestic_direct.list" \
  "plain_domain|https://raw.githubusercontent.com/Loyalsoldier/surge-rules/release/direct.txt" \
  "plain_domain|https://cdn.jsdelivr.net/gh/Loyalsoldier/surge-rules@release/direct.txt" \
  "standard|https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaDomain.list" \
  "standard|https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaIp.list" \
  "standard|https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaCompanyIp.list" \
  "standard|https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/LocalAreaNetwork.list" \
  "standard|https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Download.list" \
  "dnsmasq_domain|https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf" \
  "standard|https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/ChinaMax/ChinaMax.list"

sync_combined_rules \
  "rules/25_ai_proxy.list" \
  "standard|https://raw.githubusercontent.com/Moli-X/Tool/X/Loon/Rules/AI.list"

dedupe_all_rules

echo "Upstream rule sync completed."
