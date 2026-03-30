# loon-rules

Personal Loon rules repository for GitHub hosting.

## Structure

```text
loon-rules/
|-- README.md
|-- Loon.conf
`-- rules/
    |-- 00_custom_proxy.list
    |-- 01_custom_direct.list
    |-- 02_custom_reject.list
    |-- 10_domestic_direct.list
    |-- 20_global_proxy.list
    |-- 21_adblock_reject.list
    |-- 22_proxy_list.list
    |-- 30_streaming_proxy.list
    `-- 40_ai_proxy.list
```

## Usage

1. Upload this repository to GitHub.
2. Replace the placeholder raw URL in `Loon.conf`.
3. Import `Loon.conf` into Loon or copy the rule lines into your own profile.

## Auto Sync

This repository includes a GitHub Actions workflow that can update upstream rules on a schedule.

Current upstream mapping:

- `rules/20_global_proxy.list` <= `GFWlist.list`
- `rules/21_adblock_reject.list` <= `AdBlock.list`
- `rules/22_proxy_list.list` <= `Proxy-List.list`
- `rules/40_ai_proxy.list` <= `AI.list`

The workflow file is:

```text
.github/workflows/sync-upstream-rules.yml
```

You can trigger it manually from the GitHub Actions page, or let it run on schedule after pushing the repository to GitHub.

## Proxy-List Notice

`Proxy-List.list` is synced into the repository for review, but it is not enabled in `Loon.conf` by default.
Its format may not belong in the `[Rule]` section depending on the upstream content.

## Raw URL Example

```text
https://raw.githubusercontent.com/qianye9998/loon_rules/main/rules/40_ai_proxy.list
```
