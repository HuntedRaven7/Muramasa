---
name: muramasa-troubleshooting
description: Diagnose build failures, cache misses, boot problems, and compositor startup issues in Muramasa.
---

# Troubleshooting

## Build fails immediately
- Run `just check-pins`. Placeholder pins are the most common cause.
- Confirm the FSDK junction `ref` matches `fsdk-ref` in `include/versions.yml`.
- Check that every `path:` under a `kind: local` source exists in the repo.

## Cache miss on every run
- Verify `BST_CACHE_REF=ghcr.io/huntedraven7/muramasa-cache`.
- `BST_CACHE_KEY` must be unset on a failed build so partial caches are not
  published. This is handled by the build workflow.

## Image boots to a text console
- Mango starts from the tty1 autologin configured in `files/session/`.
- Check `/usr/share/muramasa/kernel-version` and that
  `/boot/EFI/Linux/muramasa.efi` exists.
- Confirm the kernel has `CONFIG_SCHED_CLASS_EXT` and `CONFIG_NTSYNC`; the OGC
  element fails the build when either is dropped.

## Compositor starts but the shell is missing
- That is expected. Quickshell configuration is intentionally supplied by the
  image owner after installation. Do not add it to the repository.
