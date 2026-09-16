.PHONY: help build package pkg rust-build release install install-package clean \
	validate lint fmt fmt-check clippy test tests check audit deny machete changelog

.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@echo "  make build           - validate and create the local Arch package"
	@echo "  make rust-build      - build the Rust workspace in debug mode"
	@echo "  make release         - build the Rust workspace in release mode"
	@echo "  make package         - create the package in build/dist/"
	@echo "  make install         - install the locally built package (sudo pacman -U)"
	@echo "  make clean           - remove build/ and cargo outputs"
	@echo "  make validate        - validate scripts and PKGBUILD metadata"
	@echo "  make check           - run formatting, lint and Rust tests"
	@echo "  make changelog       - regenerate CHANGELOG.md with git-cliff"

lint:
	@shellcheck tools/sh/pkgbuild_local.sh
	@echo "Lint Shell Script OK"

fmt:
	@cargo fmt --all

fmt-check:
	@cargo fmt --all -- --check

clippy:
	@cargo clippy --workspace --all-targets --all-features -- -D warnings

test:
	@cargo test --workspace --locked

tests: test

audit:
	@cargo audit

deny:
	@cargo deny check

machete:
	@cargo machete

check: lint fmt-check clippy test

rust-build:
	@cargo build --workspace --locked

release: check
	@cargo build --workspace --release --locked

package: check
	@tools/sh/pkgbuild_local.sh

pkg: package

build: package

install: package
	@sudo pacman -U build/dist/*.zst --overwrite="*" --noconfirm

install-package: install

validate:
	@shellcheck tools/sh/pkgbuild_local.sh
	@cargo metadata --locked --no-deps --format-version 1 >/dev/null
	@cd packaging/arch/ci && makepkg -p PKGBUILD --printsrcinfo >/dev/null
	@cd packaging/arch/local && makepkg -p PKGBUILD --printsrcinfo >/dev/null
	@echo "Validation OK"

changelog:
	@git-cliff -o CHANGELOG.md

clean:
	@cargo clean
	@rm -rf build/
