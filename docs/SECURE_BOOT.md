# Secure Boot

Muramasa builds a Unified Kernel Image at
`/boot/EFI/Linux/muramasa.efi`. bootc installs it to the EFI System
Partition, so signing that file is the critical path.

## Keys

Development keys are generated locally and never committed:

```sh
scripts/gen-dev-keys.sh
```

- Private key: `files/boot-keys/private/secure-boot.key` (gitignored)
- Public certificate: `files/boot-keys/public/secure-boot.crt` (committed)

The public certificate is installed into the image at
`/usr/share/muramasa/secure-boot/secure-boot.crt`.

## Signing

`elements/oci/muramasa.bst` signs the UKI with `sbsign` whenever the private
key is present in the build sandbox. Set the BuildStream option
`-o secure_boot_signing true` to make the intent explicit; CI sets it when the
`SECURE_BOOT_KEY` and `SECURE_BOOT_CERT` repository secrets are configured.

Kernel modules are not signed yet — that requires the kernel's `sign-file`
helper and module signing key to be staged into the kernel build sandbox.

## Enrollment

After booting the image:

```sh
ujust enroll-secure-boot-key
```

This imports the certificate with `mokutil`; complete enrollment in the
firmware MOK manager and reboot. If `mokutil` is unavailable, copy the
certificate from the path above into your firmware's key store manually.

## Known gap

The certificate is a development key. Production images should use a
hardware-backed or CI-managed production key and rotate the dev key out.
