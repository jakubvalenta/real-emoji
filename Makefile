name = Emoji
version = 0.1.0
author = Jakub Valenta
url = https://lab.saloun.cz/jakub/emoji
license = Creative Commons Attribution 4.0 International
license_url = http://creativecommons.org/licenses/by/4.0/

curr_dir = $(shell pwd)
svg_dir = $(curr_dir)/svg
twemoji_color_font_dir = $(curr_dir)/twemoji-color-font
build_dir = $(twemoji_color_font_dir)/build
fonts_dir = $(curr_dir)/fonts

.PHONY: font clean serve help

font: $(fonts_dir)/$(name).ttf  ## Build the TTF file

$(fonts_dir):
	mkdir -p "$@"

$(fonts_dir)/$(name).ttf: $(build_dir)/$(name).ttf | $(fonts_dir)
	cp -a "$<" "$@"

$(build_dir)/$(name).ttf:
	cd $(twemoji_color_font_dir) && \
	$(MAKE) FONT_PREFIX="$(name)" SVG_EXTRA="$(svg_dir)"

clean:  ## Remove the built TTF file, TTX file and PNG files
	cd $(twemoji_color_font_dir) && \
	$(MAKE) clean

clean-font-only:  ## Remove the built TTF files
	-rm $(build_dir)/$(name)*.ttf

$(fonts_dir)/$(name).eot $(fonts_dir)/$(name).woff $(fonts_dir)/$(name).svg: $(fonts_dir)/$(name).ttf
	webify "$<"

$(fonts_dir)/$(name).woff2: $(fonts_dir)/$(name).ttf
	woff2_compress "$<"

node_modules/normalize.css/normalize.css:
	npm install

_data/all_emojis.json _data/custom_emojis.json: emoji.py emoji.csv $(build_dir)/$(name).ttf
	python3 emoji.py

serve: _data/all_emojis.json _data/custom_emojis.json $(fonts_dir)/$(name).eot $(fonts_dir)/$(name).woff $(fonts_dir)/$(name).woff2 $(fonts_dir)/$(name).svg node_modules/normalize.css/normalize.css  ## Serve preview HTML
	jekyll serve --livereload

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
