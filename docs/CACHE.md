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

Pulling from these caches means trusting two third parties to have built the
artifacts from exactly the pinned sources. BuildStream verifies artifact keys
against the local element and source definitions, so a mismatched or tampered
artifact is rejected rather than used. We still depend on GNOME and Bluefin
being available and honest about their cache contents; the pin set in
`include/versions.yml` is what anchors that trust.

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
instead of starting cold each time. Because a full FSDK bootstrap exceeds a
single 6-hour job, the build step also checkpoints the partial cache every 15
minutes; a timed-out run hands its completed artifacts to the next attempt.
The partial tag never claims a build was
complete. Before archiving, CI stops any leftover `bst2` container so
BuildStream cannot mutate files mid-tar. The archive excludes volatile scratch
state (`casserver-*.sock`, `cas/tmp/*`, `cas/staging/*`), which is recreated on
restore. The archive is written with a relative path because `oras` rejects
absolute file paths. The FSDK junction mirrors Dakota's boolean
`x86_64_v3` conditional so artifact keys match the upstream caches; passing a
string variable would change every key and force a full rebuild.
Plugin junctions are pinned to Dakota's versions (`buildstream-plugins` 2.8.0
and `buildstream-plugins-community` 2.4.0) so GBM's plugin declarations resolve
with matching keys. `cache-clean.yml` prunes old cache tags.

## Local use

```sh
BST_CACHE_REF=ghcr.io/huntedraven7/muramasa-cache \
BST_CACHE_KEY=$(git rev-parse HEAD) \
just cache-pull
```
