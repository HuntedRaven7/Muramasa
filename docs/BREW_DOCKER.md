# Homebrew and Docker

Homebrew is installed exactly as in Dakota: the framework files come from
`elements/tooling/brew.bst` and the per-architecture tarball from
`tooling/brew-tarball.bst`, pinned by manifest digest in
`include/versions.yml`.

## Extras

The system Brewfile is installed at `/etc/muramasa/brew/Brewfile` and
currently requests:

- `docker`
- `docker-compose`
- `docker-buildx`

Install them after first boot with:

```sh
ujust install-docker
```

That command runs `brew bundle --file /etc/muramasa/brew/Brewfile` and enables
`docker-brew.service`, which launches `dockerd` from the Homebrew prefix.

## Verification checklist

Because Homebrew resolves formulae at install time, the following must be
verified on a real boot before treating Docker as supported:

1. `brew --prefix` resolves to the Linuxbrew prefix in this image.
2. `brew bundle` installs the formulae without a compiler toolchain gap.
3. `dockerd` starts and `docker info` succeeds.
4. The seated user is in the `docker` group (the ujust command prints a
   reminder; group membership is not yet automated).

Podman is also installed from FSDK for daemonless containers and is the
recommended fallback if the Homebrew Docker path proves unworkable.

## Automatic package preinstall

`brew-preinstall.service` applies the image-managed Brewfiles in
`/usr/share/muramasa/brew/preinstall.d/` at first login. It is content-addressed:
packages added to a Brewfile are installed, packages removed are uninstalled,
and user-installed packages are left alone. Add agent/CLI tooling to
`cli.Brewfile` in a reviewed PR; that is the intended place for your own set.

## Steam

Native Steam is baked in from Valve's versioned launcher `.deb` and backed by
Dakota's full i686 compatibility slice. The client self-updates into the
user's home on first launch. Verify with `ujust verify-steam` and by checking
`/usr/lib/steam/steam.sh` in the image.
