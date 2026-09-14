# Development

Argvus Storage is a Rust application used by the Argvus Waybar module. It talks to UDisks2 over D-Bus and can present either a Waybar JSON stream or an interactive device menu.

## Requirements

Install Rust and the system libraries used by the GTK menu:

```sh
cargo --version
pkg-config --version
```

On Arch Linux, the runtime/build dependencies are represented by `packaging/PKGBUILD`.

## Commands

```sh
cargo build --release --locked
cargo test --locked
cargo clippy --locked --all-targets --all-features -- -D warnings
```

Local command checks:

```sh
cargo run --locked -- once
cargo run --locked -- list
cargo run --locked -- menu
```

## Configuration files

Source defaults live in this repository under `src/usr/share/argvus/taskbar-storage/config/`:

```text
src/usr/share/argvus/taskbar-storage/config/config.json
src/usr/share/argvus/taskbar-storage/config/theme.css
src/usr/share/argvus/taskbar-storage/config/themes/
```

The Arch package installs them to:

```text
/usr/share/argvus/taskbar-storage/config/config.json
/usr/share/argvus/taskbar-storage/config/theme.css
/usr/share/argvus/taskbar-storage/config/themes/
```

User overrides are read from:

```text
~/.config/argvus/taskbar/storage/config.json
~/.config/argvus/taskbar/storage/theme.css
~/.config/argvus/taskbar/storage/themes/
```

## Release flow

1. Update `Cargo.toml` version.
2. Run tests and clippy.
3. Commit the version change.
4. Tag `vX.Y.Z` and push the tag.
5. Confirm the package workflow builds `argvus-storage-X.Y.Z-1-x86_64.pkg.tar.zst`.
6. Confirm the workflow publishes the package to `argvus/packages` under `public/arch/x86_64/` and updates the Arch repository database.

The project does not create GitHub Releases for package distribution. The built
`.pkg.tar.zst` is kept as a GitHub Actions artifact for one day only; the
permanent package copy lives in `argvus/packages`.
