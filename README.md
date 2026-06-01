# loon-rules

Personal Loon rules repository for GitHub hosting.

## Structure

```text
loon-rules/
|-- README.md
|-- Loon.conf
|-- shadowrocket.conf
|-- .github/workflows/sync-upstream-rules.yml
|-- scripts/sync_upstream_rules.sh
`-- rules/
    |-- 10_domestic_direct.list
    |-- 20_custom_direct.list
    |-- 25_ai_proxy.list
```

## Usage

1. Upload this repository to GitHub.
2. Use `Loon.conf` or `shadowrocket.conf` directly, or reference the rule URLs from an existing profile.

## Auto Sync

This repository includes a GitHub Actions workflow that updates the upstream rules every day.
For the synced categories, the script reads upstream rule URLs, writes them into the target file, and then deduplicates every maintained `.list` file under `rules/`.
The repository keeps `rules/10_domestic_direct.list` intentionally empty and keeps only `rules/20_custom_direct.list` for direct rules.
The repository keeps `rules/25_ai_proxy.list` as a synced file in git and refreshes it on each script or workflow run.
The repository keeps `rules/20_custom_direct.list` for manual maintenance and deduplicates it during each sync run.

Current upstream mapping:

- `rules/10_domestic_direct.list` <= intentionally empty
- `rules/20_custom_direct.list` <= maintained manually, deduplicated daily
- `rules/25_ai_proxy.list` <= combined from:
  - `https://raw.githubusercontent.com/Moli-X/Tool/X/Loon/Rules/AI.list`

The workflow file is:

```text
.github/workflows/sync-upstream-rules.yml
```

You can trigger it manually from the GitHub Actions page, or let it run on schedule after pushing the repository to GitHub.

## Upstream Notes

The synced proxy source is a Clash/Surge-style rule list.
The sync script strips upstream comments and empty lines, normalizes whitespace, and then deduplicates the merged result.

## Raw URL Example

```text
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/10_domestic_direct.list
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/20_custom_direct.list
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/25_ai_proxy.list
```

Config URL:

```text
https://raw.githubusercontent.com/qianye9998/loon_rules/main/Loon.conf
https://raw.githubusercontent.com/qianye9998/loon_rules/main/shadowrocket.conf
```
