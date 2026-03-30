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
    |-- 10_domestic_direct.list
    |-- 20_global_proxy.list
    `-- 30_custom_proxy.list
```

## Usage

1. Upload this repository to GitHub.
2. Use the three rule URLs in your existing Loon profile, or copy the `[Rule]` snippet from `Loon.conf`.

## Auto Sync

This repository includes a GitHub Actions workflow that updates the upstream rules every day.
After each sync, the script deduplicates every `.list` file under `rules/`.

Current upstream mapping:

- `rules/20_global_proxy.list` <= `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/Global/Global.list`
- `rules/10_domestic_direct.list` <= converted from `https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/china-list.txt`
- `rules/30_custom_proxy.list` <= maintained manually, deduplicated daily

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
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/10_domestic_direct.list
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/20_global_proxy.list
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/30_custom_proxy.list
```
