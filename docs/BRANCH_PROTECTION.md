# Branch protection

Muramasa has two protected branches:

| Branch | Role |
| --- | --- |
| `testing` | Primary/default branch. All development lands here via PR. |
| `stable` | Promotion branch. Receives released digests, never rebuilds. |

**Nothing is pushed directly to either branch.** Work happens on topic
branches, CI passes, and merges are squashed. Force pushes, branch deletion and
direct commits are blocked, including for admins.

A pull request is required, but `required_approving_review_count` is `0` so a
solo maintainer is not locked out: GitHub does not let you approve your own PR.
Once a second reviewer exists, change both payloads to `1` (and set
`require_last_push_approval` to `true`), re-run the apply workflow, and PRs
will need that review.

## Rules

`testing` requires these status checks before merge:

- `validate` (pin check + BuildStream graph)
- `image (base, false)` and `image (nvidia, true, -nvidia)` (both GPU flavors)
- `pre-commit`, `codeql`, `scorecard`

`stable` has no required checks because CI does not run on that branch; it is
protected only by the PR/review and no-force-push rules.

Both branches require:
- a pull request
- dismissal of stale reviews (enabled, but no approvals are required yet)
- linear history and resolved conversations
- no force pushes or deletions

## Applying the rules

The desired state is checked in as GitHub REST API payloads:

```
.github/branch-protection/testing.json
.github/branch-protection/stable.json
```

The built-in `GITHUB_TOKEN` cannot modify branch protection. Add a repository
secret named `ADMIN_TOKEN` containing a personal access token (or GitHub App
token) with repository administration rights, then run the
`configure-branch-protection` workflow from Actions. Re-run it after any change
to the JSON payloads.

From your machine the equivalent is:

```sh
ADMIN_TOKEN=<token> just protect
```

`just protect` calls `scripts/apply-branch-protection.sh`, which uses `gh api`
to PUT each payload to `/repos/{owner}/{repo}/branches/{branch}/protection`.

## Verify

```sh
gh api repos/HuntedRaven7/Muramasa/branches/testing/protection
gh api repos/HuntedRaven7/Muramasa/branches/stable/protection
```

## Relationship to releases

`stable` branch protection applies to **commits**. Image releases are tag
promotions performed by `execute-release.yml` (`docker://...:testing` →
`:stable`) and do not require commits to the `stable` branch, so the protection
rules do not interfere with promotion or rollback.
