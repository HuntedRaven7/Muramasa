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
`elements/freedesktop-sdk.bst`. A build writes the key only when it succeeds;
a failed build clears the key so a partial cache is never advertised as
complete. `cache-clean.yml` prunes old cache tags.

## Local use

```sh
BST_CACHE_REF=ghcr.io/huntedraven7/muramasa-cache \
BST_CACHE_KEY=$(git rev-parse HEAD) \
just cache-pull
```
