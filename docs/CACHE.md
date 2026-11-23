# Cache

Muramasa uses three caches:

| Cache | URL | Direction |
| --- | --- | --- |
| GNOME build cache | `https://gbm.gnome.org:11003` | pull only |
| Bluefin cache | `https://cache.projectbluefin.io:11001` | pull only |
| Muramasa cache | `ghcr.io/huntedraven7/muramasa-cache` | pull + push |

The upstream caches are FSDK-based, so they contain reusable artifacts for our
junction even though Muramasa does not ship GNOME Shell. They are configured in
`project.conf` under both `artifacts` and `source-caches`.

## Why the Muramasa cache is in GHCR

GitHub Actions cache has a 10 GB per-repository cap. A full FSDK cache is much
larger and gets evicted, which makes every CI run cold. GHCR artifacts are free
and uncapped for public projects, so `scripts/bst-cache-oci.sh` moves the cache
directory as an OCI artifact.

## Key scheme

`BST_CACHE_KEY` is derived from `project.conf`, `include/versions.yml`, and
`elements/freedesktop-sdk.bst` and is written only by a successful build.
Failed or timed-out builds write `BST_CACHE_FALLBACK_KEY`, a rolling
`-partial` tag. Pull tries the complete key first and falls back to the
partial tag, so a long source build accumulates artifacts across attempts
instead of starting cold each time. The partial tag never claims a build was
complete. Before archiving, CI stops any leftover `bst2` container so
BuildStream cannot mutate files mid-tar. The archive excludes volatile scratch
state (`casserver-*.sock`, `cas/tmp/*`, `cas/staging/*`), which is recreated on
restore. `cache-clean.yml` prunes old cache tags.

## Local use

```sh
BST_CACHE_REF=ghcr.io/huntedraven7/muramasa-cache \
BST_CACHE_KEY=$(git rev-parse HEAD) \
just cache-pull
```
