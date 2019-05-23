name = Emoji
version = 0.1.0
author = Jakub Valenta
url = https://lab.saloun.cz/jakub/emoji
license = Creative Commons Attribution 4.0 International
license_url = http://creativecommons.org/licenses/by/4.0/

noto_emoji_dir = noto-emoji
twemoji_png_dir = twemoji/2/72x72
curr_dir = $(shell pwd)
dist_dir = $(curr_dir)/dist
png_dir := $(curr_dir)/png/72
svg_dir := $(curr_dir)/svg

_make_args := PYTHON=python2 EMOJI=$(name) FLAGS= FLAG_GLYPH_NAMES=
_custom_svg_names = $(notdir $(wildcard $(svg_dir)/*.svg))
_custom_png_names = $(_custom_svg_names:%.svg=%.png)
_custom_svgs = $(addprefix $(svg_dir)/,$(_custom_svg_names))
_custom_pngs = $(addprefix $(png_dir)/,$(_custom_png_names))
_twemoji_src_pngs = $(wildcard $(twemoji_png_dir)/*.png)
_twemoji_pngs = $(addprefix $(png_dir)/emoji_u,$(subst -,_,$(notdir $(_twemoji_src_pngs))))
_all_pngs = $(_custom_pngs) $(_twemoji_pngs)

.PHONY: font clean debug serve help

font: $(dist_dir)/$(name).ttf  ## Build the TTF file

$(dist_dir)/$(name).ttf: $(noto_emoji_dir)/$(name).tmpl.ttx.tmpl $(_all_pngs) | $(dist_dir)
	cd $(noto_emoji_dir) && \
	make $(_make_args) EMOJI_SRC_DIR=$(png_dir) BODY_DIMENSIONS=76x72
	cp $(noto_emoji_dir)/$(name).ttf $(dist_dir)/

$(png_dir) $(dist_dir):
	mkdir -p "$@"

$(noto_emoji_dir)/$(name).tmpl.ttx.tmpl: $(noto_emoji_dir)/NotoColorEmoji.tmpl.ttx.tmpl
	sed 's/Noto Color Emoji/$(name)/; s/NotoColorEmoji/$(name)/; s/Copyright .* Google Inc\./$(author)/; s/ Version .*/ $(version)/; s/.*is a trademark.*//; s/Google, Inc\./($author)/; s,http://www.google.com/get/noto/,$(url),; s/.*is licensed under.*/      $(license)/; s,http://scripts.sil.org/OFL,$(license_url),' "$<" > "$@"

$(_twemoji_pngs): $(_twemoji_src_pngs) | $(png_dir)
	cp $(twemoji_png_dir)/$(subst _,-,$(subst emoji_u,,$(notdir $@))) $@

$(_custom_pngs): $(png_dir)/%.png: $(svg_dir)/%.svg | $(png_dir)
	rsvg-convert -w 72 -h 72 "$<" > "$@"

clean:  ## Remove the built TTF file, TTX file and PNG files
	cd $(noto_emoji_dir) && \
	$(MAKE) $(_make_args) clean
	-rm $(noto_emoji_dir)/$(name).tmpl.ttx.tmpl
	-rm $(dist_dir)/$(name).*
	-rm $(png_dir)/*.png

clean-font-only:  ## Remove the built TTF file and TTX file
	-rm $(noto_emoji_dir)/$(name).ttf
	-rm $(noto_emoji_dir)/$(name).tmpl.ttf
	-rm $(noto_emoji_dir)/$(name).tmpl.ttx
	-rm $(dist_dir)/$(name).*

debug:  ## Print all PNG file paths
	@echo "Custom PNGs:"
	@echo $(_custom_pngs)
	@echo "Twemoji PNGs:"
	@echo $(_twemoji_pngs)

$(dist_dir)/$(name).eot $(dist_dir)/$(name).woff $(dist_dir)/$(name).svg: $(dist_dir)/$(name).ttf
	webify "$<"

$(dist_dir)/$(name).woff2: $(dist_dir)/$(name).ttf
	woff2_compress "$<"

node_modules/normalize.css/normalize.css:
	npm install

_data/all_emojis.json _data/custom_emojis.json: emoji.py emoji.csv $(dist_dir)/$(name).ttf
	python3 emoji.py

serve: _data/all_emojis.json _data/custom_emojis.json $(dist_dir)/$(name).eot $(dist_dir)/$(name).woff $(dist_dir)/$(name).woff2 $(dist_dir)/$(name).svg $(dist_dir)/$(name).ttf node_modules/normalize.css/normalize.css  ## Serve preview HTML
	jekyll serve --livereload

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
