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
For the synced categories, the script first reads multiple upstream rule URLs, writes them into the target file, and then deduplicates every `.list` file under `rules/`.

Current upstream mapping:

- `rules/10_domestic_direct.list` <= combined from:
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/ChinaDomian.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/ChinaCompanyIp.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/WeChat.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/direct/cn.list`
- `rules/20_global_proxy.list` <= combined from:
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/proxy/Telegram.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/proxy/Google.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/proxy/ChatGPT.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/proxy/Claude.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/proxy/Gemini.list`
  - `https://raw.githubusercontent.com/Loon0x00/LoonLiteRules/main/proxy/YouTube.list`
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
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/30_custom_proxy.list
```
