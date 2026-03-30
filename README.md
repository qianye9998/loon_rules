# loon-rules

Personal Loon rules repository for GitHub hosting.

## Structure

```text
loon-rules/
|-- README.md
|-- Loon.conf
|-- .github/workflows/sync-upstream-rules.yml
|-- scripts/sync_upstream_rules.sh
`-- rules/
    |-- 00_custom_proxy.list
    |-- 01_custom_direct.list
    |-- 02_custom_reject.list
    |-- 10_domestic_direct.list
    |-- 20_global_proxy.list
    `-- auto-synced from upstream
```

## Usage

1. Upload this repository to GitHub.
2. Replace the placeholder raw URL in `Loon.conf`.
3. Import `Loon.conf` into Loon or copy the rule lines into your own profile.

## Auto Sync

This repository includes a GitHub Actions workflow that can update upstream rules on a schedule.

Current upstream mapping:

- `rules/20_global_proxy.list` <= `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/Global/Global.list`
- `rules/10_domestic_direct.list` <= converted from `https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/china-list.txt`

The workflow file is:

```text
.github/workflows/sync-upstream-rules.yml
```

You can trigger it manually from the GitHub Actions page, or let it run on schedule after pushing the repository to GitHub.

## Upstream Notes

`Global.list` is already in Loon rule format and is saved directly.

`china-list.txt` is a plain domain list rather than Loon syntax, so the sync script converts each domain into:

```text
DOMAIN-SUFFIX,example.com
```

## Raw URL Example

```text
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/20_global_proxy.list
```
