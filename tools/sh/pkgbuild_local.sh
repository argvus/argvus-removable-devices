#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/../.." && pwd)"

BUILD_DIR="$ROOT_DIR/build"
ARTIFACTS_DIR="$BUILD_DIR/artifacts"
DIST_DIR="$BUILD_DIR/dist"

PKGBUILD_DIR="$ROOT_DIR/packaging/arch/local"
PKGBUILD="$PKGBUILD_DIR/PKGBUILD"

read -r pkgname pkgver <<<"$(bash -c 'source "$1"; printf "%s %s" "$pkgname" "$pkgver"' bash "$PKGBUILD")"

mkdir -p "$ARTIFACTS_DIR" "$DIST_DIR"
find "$DIST_DIR" -maxdepth 1 -type f -name "${pkgname}-*.pkg.tar.*" -delete

archive="$ARTIFACTS_DIR/${pkgname}-${pkgver}.tar.gz"

echo "Creating local source archive: $archive"
tar -czf "$archive" \
  --exclude='./.git' \
  --exclude='./.release' \
  --exclude='./packages-repo' \
  --exclude='./build' \
  --exclude='./dist' \
  --exclude='./target' \
  --exclude='./tools' \
  --exclude='./packaging/arch/local/src' \
  --exclude='./packaging/arch/local/pkg' \
  --exclude='./packaging/arch/local/PKGBUILD.local' \
  --exclude='./packaging/arch/local/*.pkg.tar*' \
  --exclude='./packaging/arch/local/*.tar.gz' \
  --exclude='./packaging/arch/ci/src' \
  --exclude='./packaging/arch/ci/pkg' \
  --transform "s#^\./#${pkgname}-${pkgver}/#" \
  -C "$ROOT_DIR" .

if [[ -n "${MAKEPKG_FLAGS:-}" ]]; then
  # shellcheck disable=SC2206
  flags=(${MAKEPKG_FLAGS})
else
  flags=(--nodeps --noconfirm --needed --cleanbuild --force --check)
fi

cd "$PKGBUILD_DIR"
export BUILDDIR="$ARTIFACTS_DIR"
export SRCDEST="$ARTIFACTS_DIR"
export PKGDEST="$DIST_DIR"

cp "$PKGBUILD" "$PKGBUILD_DIR/PKGBUILD.local"
trap 'rm -f "$PKGBUILD_DIR/PKGBUILD.local"' EXIT

sha256="$(sha256sum "$archive" | awk '{print $1}')"
sed -i "s/^sha256sums=.*/sha256sums=(\"${sha256}\")/" "$PKGBUILD_DIR/PKGBUILD.local"

makepkg -p PKGBUILD.local "${flags[@]}" "$@"

printf 'Packages created in %s:\n' "$DIST_DIR"
find "$DIST_DIR" -maxdepth 1 -type f -name "${pkgname}-*.pkg.tar.zst" -printf '  %f\n' | sort

printf 'Artifacts kept in %s:\n' "$ARTIFACTS_DIR"
find "$ARTIFACTS_DIR" -mindepth 1 -maxdepth 1 -printf '  %f\n' | sort
