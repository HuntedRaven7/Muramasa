# Security policy

## Supported streams

| Stream | Supported |
| --- | --- |
| `stable` / `stable-nvidia` | Yes |
| `testing` / `testing-nvidia` | Best effort |
| `main` branch | No |

## Reporting a vulnerability

Use GitHub's private vulnerability reporting on this repository. Do not open a
public issue for an undisclosed vulnerability. Include the affected image tag,
a description, and reproduction steps if available.

## Supply chain

- All external sources are pinned in `include/versions.yml`.
- Images are scanned with Trivy before push, signed keylessly with cosign, and
  published with an SBOM and SLSA Build L2 provenance.
- OpenSSF Scorecard and CodeQL run in the quality workflow.
