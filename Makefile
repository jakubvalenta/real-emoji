name = RealEmoji
version = 0.1.0
author = Jakub Valenta
url = https://real-emoji.ooooo.page
license = Creative Commons Attribution 4.0 International
license_url = http://creativecommons.org/licenses/by/4.0/

_python_pkg = emoji
curr_dir = $(shell pwd)
twemoji_color_font_dir = $(curr_dir)/twemoji-color-font
build_dir = $(curr_dir)/build/$(name)
src_dir = svg
svg_dir = $(build_dir)/svg
svg_twemoji = $(twemoji_color_font_dir)/assets/twemoji-svg
svg_extra_bw = $(twemoji_color_font_dir)/assets/svg-bw
emojis_json = emojis.json
web_svg_dir = static/svg
web_png_dir = static/png
dist_dir = $(curr_dir)/static/fonts
ttf_font = $(dist_dir)/$(name).ttf
mac_font = $(dist_dir)/$(name)-OSX-$(version).zip
web_fonts = $(dist_dir)/$(name).eot $(dist_dir)/$(name).woff $(dist_dir)/$(name).svg
web_font_woff2 = $(dist_dir)/$(name).woff2
web_data_dir = data/$(name)
web_data_file = $(web_data_dir)/emojis.json
web_assets_dir = static
web_posts_dir = content
web_npm_installed = $(web_assets_dir)/node_modules/normalize.css/normalize.css
web_deps = $(web_svg_dir) $(web_png_dir) $(web_data_file) $(web_fonts) $(web_font_woff2) $(web_npm_installed) $(web_posts_dir)

.PHONY: font
font: $(ttf_font) $(mac_font)  ## Build the TTF file and the macOS font package

$(dist_dir):
	mkdir -p "$@"

$(svg_dir): $(_python_pkg)/copy.py $(emojis_json) $(src_dir)
	mkdir -p "$@"
	poetry run python3 -m emoji.copy -s "$(src_dir)" -d "$@" < $(emojis_json)

$(web_svg_dir): $(svg_dir)
	rm -r "$(web_svg_dir)" || true
	mkdir -p "$(web_svg_dir)"
	cp -a "$(src_dir)"/*.svg "$(web_svg_dir)"
	rm "$(web_svg_dir)"/*-src.svg
	for f in "$(web_svg_dir)"/*.svg; do svgo -i "$$f"; done

$(web_png_dir): $(web_svg_dir)
	rm -r "$@" || true
	mkdir -p "$@"
	for path_in in "$<"/*.svg; do \
		path_in_basename=$$(basename "$$path_in"); \
		path_out="$@/$${path_in_basename%.*}.png"; \
		inkscape -o "$$path_out" -w 512 -h 512 "$$path_in"; \
		optipng -preserve "$$path_out"; \
	done

$(web_png_dir)/_telegram.png: $(web_svg_dir)/violence.svg
	inkscape -o "$@" -w 100 -h 100 "$<"
	optipng -preserve "$@"

$(ttf_font): | $(svg_dir) $(dist_dir)
	cd $(twemoji_color_font_dir) && \
	$(MAKE) all \
		BUILD_DIR="$(build_dir)" \
		VERSION="$(version)" \
		FONT_PREFIX="$(name)" \
		SVG_TWEMOJI="$(svg_twemoji)" \
		SVG_EXTRA_BW="$(svg_extra_bw)" \
		SVG_EXTRA="$(svg_dir)"
	cp -a "$(build_dir)/$(name).ttf" "$@"

$(mac_font): | $(svg_dir) $(dist_dir)
	cd $(twemoji_color_font_dir) && \
	$(MAKE) osx-package \
		BUILD_DIR="$(build_dir)" \
		VERSION="$(version)" \
		FONT_PREFIX="$(name)" \
		SVG_TWEMOJI="$(svg_twemoji)" \
		SVG_EXTRA_BW="$(svg_extra_bw)" \
		SVG_EXTRA="$(svg_dir)"
	cp -a "$(build_dir)/$(name)-OSX-$(version).zip" "$@"

$(web_posts_dir):
	mkdir -p "$@"
	poetry run python3 -m emoji.posts -d "$(web_posts_dir)" < $(emojis_json)

.PHONY: clean
clean:  ## Remove the built TTF file, webfonts, and intermediate SVG files
	-rm -r "$(build_dir)" || true
	-rm -f $(dist_dir)/$(name)*.ttf
	-rm -f $(dist_dir)/$(name)*.zip

.PHONY: clean-font-only
clean-font-only:  ## Remove the built TTF files and macOS font packages
	-rm -f $(build_dir)/$(name)*.ttf
	-rm -f $(build_dir)/$(name)*.zip

$(web_fonts): $(ttf_font)
	webify "$<"

$(web_font_woff2): $(ttf_font)
	woff2_compress "$<"

$(web_npm_installed):
	cd "$(web_assets_dir)" && npm install

$(web_data_dir):
	mkdir -p "$@"

$(web_data_file): $(_python_pkg)/build.py $(emojis_json) | $(web_data_dir)
	poetry run python3 -m emoji.build < $(emojis_json) > $(web_data_file)

build: $(web_deps)  ## Build website
	zola build

.PHONY: serve
serve: $(web_deps)  ## Serve website
	zola serve

build/RealEmojiTry/emojis.json: $(_python_pkg)/try.py emojis.json
	mkdir -p build/RealEmojiTry
	poetry run python3 -m emoji.try < emojis.json > "$@"

.PHONY: try
try: build/RealEmojiTry/emojis.json  ## Render sequence testing page
	$(MAKE) serve \
		name="RealEmojiTry" \
		emojis_json="build/RealEmojiTry/emojis.json"

.PHONY: clean-try
clean-try:  ## Clean sequence testing files
	-rm -r build/RealEmojiTry/svg
	-rm -f build/RealEmojiTry/*.ttf
	-rm build/RealEmojiTry/emojis.json

.PHONY: setup
setup:  ## Install Python dependencies
	poetry install

.PHONY: test
test:  ## Test Python code
	poetry run pytest $(_python_pkg)

.PHONY: lint
lint:  ## Lint Python code
	poetry run ruff check $(_python_pkg)
	poetry run mypy $(_python_pkg)

.PHONY: format
format:  ## Format Python code
	poetry run ruff format $(_python_pkg)

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
