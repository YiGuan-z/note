mdbook-version = 0.4.27
mdbook-toc-version = 0.12.0

build:
	mdbook build

serve:
	mdbook serve

prod:
	# cargo install --version $(mdbook-version) mdbook --force
	# cargo install --version $(mdbook-toc-version) mdbook-toc --force