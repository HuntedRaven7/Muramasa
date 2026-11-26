# Source updates

Pinned git refs live in `include/versions.yml`; elements reference them as
`%{variable}`. A weekly `auto-pins` workflow (and `workflow_dispatch`) runs
`scripts/update-pins.py`, which resolves each upstream track and rewrites the
pins. The script follows the pattern used by `projectbluefin/Mjolnir`: a
version/track change is separate from the hash that pins the download.

If anything changed, the workflow opens a PR against `testing`. Reviewers must
check upstream changelogs before merging, because a pin change invalidates
BuildStream artifact keys and triggers rebuilds. To preview locally:

```sh
python3 scripts/update-pins.py --check
```

HTTP-delivered artifacts (Steam's launcher, Homebrew tarballs, Zig, Voxtype)
are not handled by this script yet; their checksums are updated by hand after
verifying the upstream signed manifest.
