# argvus-removable-devices

Argvus Removable Devices is the official removable-device application for Argvus. It is written in Rust, watches UDisks2 events and feeds the Argvus Waybar storage module.

It also owns the Hyprland/menu compatibility launcher:

```text
/usr/share/argvus/removable-devices/sh/removable-devices-menu.sh
```

## Build from source

```sh
make build
make install
```

The Rust workspace is under `crates/main/`. Arch packaging recipes live in
`packaging/arch/ci/` for tagged releases and `packaging/arch/local/` for the
current working tree. Project-owned installed resources are under
`resources/`.

## Documentation

- User documentation: https://argvus.github.io/docs/storage/
- Official apps: https://argvus.github.io/docs/official-apps/
- Development workflow: [DEVELOPMENT.md](./DEVELOPMENT.md)
- Contribution guide: [CONTRIBUTING.md](./CONTRIBUTING.md)
- Arch packaging recipes: [packaging/arch/ci/PKGBUILD](./packaging/arch/ci/PKGBUILD) and [packaging/arch/local/PKGBUILD](./packaging/arch/local/PKGBUILD)

## Related repositories

- [`argvus`](https://github.com/argvus/argvus)
- [`packages`](https://github.com/argvus/packages)
