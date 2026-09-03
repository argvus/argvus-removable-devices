.DEFAULT_GOAL := help

.PHONY: help build build-bin check test clean

help:
	@echo "Available targets:"
	@echo "  make build"
	@echo "  make build-bin"
	@echo "  make check"
	@echo "  make test"
	@echo "  make clean"

build:
	@tools/build-local-package.sh

build-bin:
	cargo build --release --locked

check:
	cargo clippy --locked --all-targets --all-features -- -D warnings
	cargo test --locked

test:
	cargo test --locked

clean:
	cargo clean
	rm -f packaging/arch/*.zst packaging/arch/*.tar.gz
