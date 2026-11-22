kind: manual
description: |
  Agent-oriented defaults: contributor guidance, skills, and ujust recipes.
  These are documentation and automation only; no agent CLI is preinstalled.

build-depends:
- core/sandbox-tools.bst

sources:
- kind: local
  path: AGENTS.md
  directory: agent-doc
- kind: local
  path: CLAUDE.md
  directory: agent-doc
- kind: local
  path: .agents/skills
  directory: agent-skills
- kind: local
  path: files/agent

config:
  install-commands:
  - |
    set -eu
    install -Dm644 agent-doc/AGENTS.md \
      "%{install-root}%{datadir}/muramasa/agent/AGENTS.md"
    install -Dm644 agent-doc/CLAUDE.md \
      "%{install-root}%{datadir}/muramasa/agent/CLAUDE.md"
    cp -a agent-skills/. "%{install-root}%{datadir}/muramasa/agent/skills/"
    install -Dm755 ujust "%{install-root}%{prefix}/bin/ujust"
    install -Dm644 ujust.just "%{install-root}%{datadir}/ujust/ujust.just"
