# Contributing

Muramasa uses two branches: `testing` is the primary/default branch for all
development, and `stable` is the promotion branch for released digests.
**All changes must come through a pull request** — direct pushes, force pushes
and deletions on both branches are blocked by branch protection. See
`docs/BRANCH_PROTECTION.md`.

## Before opening a PR

```sh
just validate
just test
```

Use Conventional Commits titles: `feat:`, `fix:`, `chore:`, `docs:`, `ci:`,
`refactor:`, `test:`. Release notes are generated from these titles.

## Rules

- Add third-party pins to `include/versions.yml`, never inline mutable refs.
- Do not add shell configuration or a wallpaper manager to the image.
- Build both flavors from the same element graph (`-o nvidia true`).
- Update documentation when pins, dependencies or streams change.

See [AGENTS.md](AGENTS.md) for the full contributor workflow.
