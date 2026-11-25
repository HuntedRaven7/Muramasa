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

`BST_CACHE_KEY` is derived from the graph definitions and is written only by a
successful build. Incomplete builds publish two other tags:
`BST_CACHE_FALLBACK_KEY`, an immutable snapshot named for the run and attempt,
and `BST_CACHE_LATEST_KEY`, a rolling pointer to the newest snapshot. Pull
tries the exact key, then the rolling pointer, then this run's snapshot, so a
long build converges across attempts without a partial cache ever claiming to
be complete.

The build has a 270-minute soft budget inside the 360-minute job limit. A
`timeout` exit of 124 is treated as a checkpoint: the normal cache-save step
still runs, and image export/signing steps are skipped for that attempt. The
build also checkpoints every 5 minutes and uses `--on-error quit`. Sources are
kept in a separate GitHub Actions cache and excluded from the GHCR CAS archive.

Before archiving, CI stops any leftover `bst2` container and checks that at
least 1 GiB of disk is free. The archive excludes volatile scratch state
(`sources/*`, `casserver-*.sock`, `cas/tmp/*`, `cas/staging/*` and `tmp/*`),
which is recreated on restore. Transient files that disappear mid-read are
ignored. Each push logs the source size, archive size and destination tag. The
archive uses a relative path because `oras` rejects
absolute paths. The FSDK junction mirrors Dakota's boolean `x86_64_v3`
conditional so artifact keys match the upstream caches; passing a string
variable would change every key and force a full rebuild.
Plugin junctions are pinned to Dakota's versions (`buildstream-plugins` 2.8.0
and `buildstream-plugins-community` 2.4.0) so GBM's plugin declarations resolve
with matching keys. `cache-clean.yml` prunes old cache tags.

## Local use

```sh
BST_CACHE_REF=ghcr.io/huntedraven7/muramasa-cache \
BST_CACHE_KEY=$(git rev-parse HEAD) \
just cache-pull
```
