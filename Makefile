name = RealEmoji
version = 0.1.0
author = Jakub Valenta
url = https://lab.saloun.cz:8443/jakub/emoji
license = Creative Commons Attribution 4.0 International
license_url = http://creativecommons.org/licenses/by/4.0/

_python_pkg = emoji
curr_dir = $(shell pwd)
twemoji_color_font_dir = $(curr_dir)/twemoji-color-font
build_dir = $(curr_dir)/build/$(name)
src_dir = static/svg
svg_dir = $(build_dir)/svg
svg_twemoji = $(twemoji_color_font_dir)/assets/twemoji-svg
svg_extra_bw = $(twemoji_color_font_dir)/assets/svg-bw
build_font = $(build_dir)/$(name).ttf
emojis_json = emojis.json
web_fonts_dir = $(curr_dir)/static/fonts
web_font = $(web_fonts_dir)/$(name).ttf
web_fonts = $(web_fonts_dir)/$(name).eot $(web_fonts_dir)/$(name).woff $(web_fonts_dir)/$(name).svg
web_font_woff2 = $(web_fonts_dir)/$(name).woff2
web_data_dir = data/$(name)
web_data_file = $(web_data_dir)/emojis.json
web_assets_dir = assets
web_npm_installed = $(web_assets_dir)/node_modules/normalize.css/normalize.css
web_deps = $(web_data_file) $(web_fonts) $(web_font_woff2) $(web_npm_installed)

.PHONY: font clean clean-font-only serve try clean-try setup setup-dev lint reformat help

font: $(web_font)  ## Build the TTF file

$(web_fonts_dir):
	mkdir -p "$@"

$(web_font): $(build_font) | $(web_fonts_dir)
	cp -a "$<" "$@"

$(svg_dir): $(_python_pkg)/copy.py $(emojis_json) $(src_dir)
	mkdir -p "$@"
	python3 -m emoji.copy -s "$(src_dir)" -d "$@" < $(emojis_json)

$(build_font): | $(svg_dir)
	cd $(twemoji_color_font_dir) && \
	$(MAKE) BUILD_DIR="$(build_dir)" \
		FONT_PREFIX="$(name)" \
		SVG_TWEMOJI="$(svg_twemoji)" \
		SVG_EXTRA_BW="$(svg_extra_bw)" \
		SVG_EXTRA="$(svg_dir)"

clean:  ## Remove the built TTF file, webfonts, and intermediate SVG files
	-rm -r "$(build_dir)"
	-rm -r "$(font_dir)"

clean-font-only:  ## Remove the built TTF files
	-rm -f $(build_dir)/$(name)*.ttf

$(web_fonts): $(web_font)
	webify "$<"

$(web_font_woff2): $(web_font)
	woff2_compress "$<"

$(web_npm_installed):
	cd "$(web_assets_dir)" && npm install

$(web_data_dir):
	mkdir -p "$@"

$(web_data_file): $(_python_pkg)/build.py $(emojis_json) $(build_font) | $(web_data_dir)
	python3 -m emoji.build < $(emojis_json) > $(web_data_file)

build: $(web_deps)  ## Build website
	hugo

serve: $(web_deps)  ## Serve website
	hugo server

build/RealEmojiTry/emojis.json: $(_python_pkg)/try.py emojis.json
	mkdir -p build/RealEmojiTry
	python3 -m emoji.try < emojis.json > "$@"

try: build/RealEmojiTry/emojis.json  ## Render sequence testing page
	$(MAKE) serve \
		name="RealEmojiTry" \
		emojis_json="build/RealEmojiTry/emojis.json"

clean-try:  ## Clean sequence testing files
	-rm -r build/RealEmojiTry/svg
	-rm -f build/RealEmojiTry/*.ttf
	-rm build/RealEmojiTry/emojis.json

setup:  ## Create Pipenv virtual environment and install dependencies.
	pipenv --three --site-packages
	pipenv install
	bundler install --path vendor/bundle

setup-dev:  ## Install development dependencies
	pipenv install --dev

lint:  ## Run linting
	pipenv run flake8 $(_python_pkg)
	pipenv run mypy $(_python_pkg) --ignore-missing-imports
	pipenv run isort -c -rc $(_python_pkg)

reformat:  ## Reformat Python code using Black
	black -l 79 --skip-string-normalization $(_python_pkg)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
