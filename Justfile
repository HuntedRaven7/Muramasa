# Muramasa build tasks. BuildStream runs inside the pinned FSDK bst2 container;
# BST is not installed on the host.

podman := env("PODMAN", "podman")
image_name := env("BUILD_IMAGE_NAME", "muramasa")
image_tag := env("BUILD_IMAGE_TAG", "latest")
bst2_image := env("BST2_IMAGE", "registry.gitlab.com/freedesktop-sdk/infrastructure/freedesktop-sdk-docker-images/bst2:64eb0b4930d57a92710822898fb73af6cc1ae35d")
registry := env("IMAGE_REGISTRY", "ghcr.io/huntedraven7")
nvidia := env("BUILD_NVIDIA", "false")

# Run any bst command inside the bst2 container.
bst *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p "${HOME}/.cache/buildstream" .build-out
    {{podman}} run --rm --privileged --device /dev/fuse --network=host \
      -v "{{justfile_directory()}}:/src:rw" \
      -v "${HOME}/.cache/buildstream:/root/.cache/buildstream:rw" \
      -w /src "{{bst2_image}}" \
      bash -c 'bst --colors "$@"' -- --no-interactive {{ARGS}}

# Flavor-aware shortcut: `just flavor-build nvidia` builds -o nvidia true.
flavor-build flavor="base":
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{flavor}}" in
      base)   just bst build oci/muramasa.bst ;;
      nvidia) just bst -o nvidia true build oci/muramasa.bst ;;
      *) echo "usage: just flavor-build {base|nvidia}" >&2; exit 2 ;;
    esac

cache-pull:
    scripts/bst-cache-oci.sh pull

cache-push:
    scripts/bst-cache-oci.sh push

# Validate the element graph without building.
validate:
    just check-pins
    just bst show oci/muramasa.bst

check-pins:
    python3 scripts/check-pins.py

bst-build:
    just bst build oci/muramasa.bst

# Checkout the OCI layout and load it into podman.
export:
    #!/usr/bin/env bash
    set -euo pipefail
    rm -rf .build-out
    just bst artifact checkout oci/muramasa.bst --directory /src/.build-out
    IMAGE_ID=$({{podman}} pull -q oci:.build-out)
    {{podman}} tag "$IMAGE_ID" "{{image_name}}:{{image_tag}}"
    {{podman}} images | grep -E '{{image_name}}|REPOSITORY' || true

# Generate an SPDX 2.3 SBOM from the BuildStream source graph.
sbom:
    #!/usr/bin/env bash
    set -euo pipefail
    REF=$(grep 'bst-sbom-ref:' include/versions.yml | sed -E 's/.*"(.*)"/\1/')
    python3 -m pip install --quiet --user "git+https://gitlab.com/BuildStream/buildstream-sbom.git@${REF}"
    mkdir -p sbom_out
    just bst show oci/muramasa.bst --deps all >/dev/null
    ~/.local/bin/buildstream-sbom oci/muramasa.bst \
      --spdx-name muramasa \
      --spdx-namespace "https://github.com/HuntedRaven7/Muramasa/sbom/$(git rev-parse HEAD)" \
      --spdx-creator "Tool: buildstream-sbom" \
      --spdx-creator "Organization: Muramasa" \
      --deps all \
      --output /src/sbom_out/muramasa.spdx.json

build: bst-build export

lint:
    {{podman}} run --rm --privileged "{{image_name}}:{{image_tag}}" bootc container lint

# Static checks that do not require the built image.
test: check-pins
    python3 -m compileall -q scripts tests

# Full image content assertions (requires a built image).
test-image image="{{image_name}}:{{image_tag}}":
    python3 tests/test_image_contents.py "{{image}}"

image-diff old="{{registry}}/muramasa:testing" new="localhost/muramasa:latest" out="image-diff.md":
    ./scripts/image-diff.sh "{{old}}" "{{new}}" "{{out}}"

# Re-track every mutable source. Review the resulting diff before merging.
track:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Re-tracking sources. Review include/versions.yml afterwards."
    for e in elements/freedesktop-sdk.bst \
             elements/plugins/*.bst \
             elements/compositor/*.bst \
             elements/gaming/gamescope.bst \
             elements/tooling/brew.bst; do
      echo "== $e"
      just bst -o arch x86_64 source track "$e" || true
    done

# Cut a stable release by promoting a tested :testing digest.
release *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail
    apply=false
    sha=""
    for arg in {{ARGS}}; do
      case "$arg" in
        --apply) apply=true ;;
        sha=*) sha="${arg#sha=}" ;;
        *) echo "usage: just release [--apply] [sha=<40-char-sha>]" >&2; exit 2 ;;
      esac
    done
    if [ -n "$sha" ] && ! [[ "$sha" =~ ^[0-9a-f]{40}$ ]]; then
      echo "sha must be a full 40-character lowercase SHA" >&2
      exit 2
    fi
    echo "repo:      HuntedRaven7/Muramasa"
    echo "workflow:  execute-release.yml @ testing"
    echo "mode:      $([ "$apply" = true ] && echo APPLY || echo 'preflight (dry run)')"
    gh workflow run execute-release.yml --ref testing \
      -f dry_run=$([ "$apply" = true ] && echo false || echo true) \
      -f promote_sha="$sha"
    echo "Dispatched. Watch with: gh run watch"

clean:
    rm -rf .build-out sbom_out
    {{podman}} rmi "{{image_name}}:{{image_tag}}" || true

# Check host prerequisites without building anything.
doctor:
    #!/usr/bin/env bash
    set -euo pipefail
    for tool in just podman python3 git gh oras skopeo; do
      if command -v "$tool" >/dev/null 2>&1; then
        echo "ok: $tool"
      else
        echo "missing: $tool" >&2
      fi
    done
