# SELinux

Muramasa ships SELinux userspace (`libselinux`, `audit`) and logs denials, but
it does **not yet ship a compiled policy**. freedesktop-sdk 26.08 provides no
policy or policy-compiler element, so booting with `security=selinux` would
fail with "policy not found".

Until a policy element lands, the UKI command line includes `selinux=0`, and
the shared testsuite is called with `selinux_enforcing: false`. This is a
known security gap, not a final posture.

## Planned work

1. Add a pinned `refpolicy` source element and a `checkpolicy` build element.
2. Build a targeted policy with Muramasa-specific allowances (notably Ly's
   process transition — see Ly's README for the AVC pattern).
3. Add `security=selinux enforcing=1` to the UKI command line.
4. Flip `selinux_enforcing` to `true` in `.github/workflows/testsuite.yml`
   and enable the AVC gate.

Until step 4, do not treat SELinux checks as passing in the shared suite.
