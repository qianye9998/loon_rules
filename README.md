# loon-rules

Personal proxy rules repository for GitHub hosting.

## Structure

```text
loon-rules/
|-- README.md
|-- shadowrocket.conf
|-- .github/workflows/sync-upstream-rules.yml
|-- scripts/sync_upstream_rules.sh
`-- rules/
    |-- 10_domestic_direct.list
    |-- 20_custom_direct.list
```

## Usage

1. Upload this repository to GitHub.
2. Use `shadowrocket.conf` directly, or reference the rule URLs from an existing profile.

## Auto Sync

This repository includes a GitHub Actions workflow that updates the upstream rules every day.
For the synced categories, the script reads upstream rule URLs, writes them into the target file, and then deduplicates every maintained `.list` file under `rules/`.
The repository keeps `rules/10_domestic_direct.list` as the synced upstream direct file.
The repository keeps `rules/20_custom_direct.list` for manual maintenance and deduplicates it during each sync run.

Current upstream mapping:

- `rules/10_domestic_direct.list` <= combined from:
  - `https://raw.githubusercontent.com/Loyalsoldier/surge-rules/release/direct.txt`
  - `https://cdn.jsdelivr.net/gh/Loyalsoldier/surge-rules@release/direct.txt`
  - `https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaDomain.list`
  - `https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaIp.list`
  - `https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaCompanyIp.list`
  - `https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/LocalAreaNetwork.list`
  - `https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/Download.list`
  - `https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf`
  - `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/ChinaMax/ChinaMax.list`
- `rules/20_custom_direct.list` <= maintained manually, deduplicated daily

The workflow file is:

```text
.github/workflows/sync-upstream-rules.yml
```

You can trigger it manually from the GitHub Actions page, or let it run on schedule after pushing the repository to GitHub.

## Upstream Notes

The direct sources include a mix of plain domain lists, Clash/Surge-style rule lists, and dnsmasq domain pools.
The sync script converts plain domains and dnsmasq entries into `DOMAIN-SUFFIX` rules, strips upstream comments and empty lines, normalizes whitespace, and then deduplicates the merged result.

## Raw URL Example

```text
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/10_domestic_direct.list
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/20_custom_direct.list
```

Config URL:

```text
https://raw.githubusercontent.com/qianye9998/loon_rules/main/shadowrocket.conf
```
