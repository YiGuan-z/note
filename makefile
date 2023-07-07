mdbook-version = 0.4.31
mdbook-toc-version = 0.12.0

build:
	mdbook build

server:
	mdbook server

dependence:
	cargo install --version $(mdbook-version) mdbook
	cargo install --version $(mdbook-toc-version) mdbook-toc