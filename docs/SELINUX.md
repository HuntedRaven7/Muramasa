# SELinux

Muramasa ships a compiled **targeted SELinux policy** and boots with
`security=selinux enforcing=1` in the UKI command line.

## What is included

- `security/checkpolicy.bst` builds `checkpolicy` from pinned upstream SELinux
  tools.
- `security/selinux-policy.bst` builds a monolithic targeted policy from pinned
  `SELinuxProject/refpolicy`, plus a small local module
  (`files/selinux/muramasa.te`) that allows Ly's system-service → user-session
  transition.
- `/etc/selinux/config` sets `SELINUX=enforcing` and `SELINUXTYPE=targeted`.
- The runtime includes `libselinux` and `audit` for denial logging.
- The shared testsuite is called with `selinux_enforcing: true`, so its AVC and
  enforcing-mode gates are active.

## Remaining work

File contexts are compiled by refpolicy, but `policycoreutils` tools such as
`restorecon` are not yet installed. Files written outside bootc-managed paths
may therefore be unlabeled until those tools are added. If the testsuite
reports AVC denials, check `ausearch -m avc -ts recent` in the VM and extend
`files/selinux/muramasa.te` rather than turning enforcement off.
