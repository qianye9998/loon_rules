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
    |-- 25_ai_proxy.list
    `-- 30_custom_proxy.list
```

## Usage

1. Upload this repository to GitHub.
2. Use the four rule URLs in your existing Loon profile, or copy the `[Rule]` snippet from `Loon.conf`.

## Auto Sync

This repository includes a GitHub Actions workflow that updates the upstream rules every day.
For the synced categories, the script first reads multiple upstream rule URLs, writes them into the target file, and then deduplicates every `.list` file under `rules/`.
The repository keeps `rules/10_domestic_direct.list` and `rules/20_global_proxy.list` as empty placeholders in git by default, and they are generated on the first script or workflow run.
The repository also keeps `rules/25_ai_proxy.list` as an empty placeholder in git and generates it the same way.

Current upstream mapping:

- `rules/10_domestic_direct.list` <= combined from:
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/ChinaDomian.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/ChinaCompanyIp.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/WeChat.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/cn.list`
- `rules/20_global_proxy.list` <= combined from:
  - `https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/Global/Global.list`
- `rules/25_ai_proxy.list` <= combined from:
  - `https://raw.githubusercontent.com/Moli-X/Tool/X/Loon/Rules/AI.list`
- `rules/30_custom_proxy.list` <= maintained manually, deduplicated daily

The workflow file is:

```text
.github/workflows/sync-upstream-rules.yml
```

You can trigger it manually from the GitHub Actions page, or let it run on schedule after pushing the repository to GitHub.

## Upstream Notes

All current upstream files are already in Loon rule format.
The sync script strips upstream comments and empty lines, merges the rule lines, normalizes whitespace, and then deduplicates them.

## Raw URL Example

```text
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/10_domestic_direct.list
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/20_global_proxy.list
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/25_ai_proxy.list
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/30_custom_proxy.list
```
