# Contributing

Muramasa uses two branches: `testing` for all development and `stable` for
promoted releases. `main` is a historical pointer.

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
