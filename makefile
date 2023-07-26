mdbook-version = 0.4.32
mdbook-toc-version = 0.12.0
admonish-version = 2.0.1

build:
	mdbook build

serve:
	mdbook serve

prod:
	cargo install --version $(mdbook-version) mdbook --force
	cargo install --version $(mdbook-toc-version) mdbook-toc --force
	cargo install --version $(admonish-version) mdbook-admonish --force