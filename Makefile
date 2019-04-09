name = Emoji
version = 0.1.0
author = Jakub Valenta
url = https://lab.saloun.cz/jakub/emoji
license = Creative Commons Attribution 4.0 International
license_url = http://creativecommons.org/licenses/by/4.0/

noto_emoji_dir = noto-emoji
curr_dir = $(shell pwd)
dist_dir = $(curr_dir)/dist
png_dir := $(curr_dir)/png/72
svg_dir := $(curr_dir)/svg

_make_args := PYTHON=python2 EMOJI=$(name) FLAGS= FLAG_GLYPH_NAMES=
_svg_names = $(notdir $(wildcard $(svg_dir)/*.svg))
_png_names = $(_svg_names:%.svg=%.png)
_all_svgs = $(addprefix $(svg_dir)/,$(_svg_names))
_all_pngs = $(addprefix $(png_dir)/,$(_png_names))

.PHONY: all debug clean

all: $(dist_dir)/$(name).ttf  ## Build the TTF file

$(dist_dir)/$(name).ttf: $(noto_emoji_dir)/$(name).tmpl.ttx.tmpl $(_all_pngs) | $(dist_dir)
	cd $(noto_emoji_dir) && \
	make $(_make_args) EMOJI_SRC_DIR=$(png_dir) BODY_DIMENSIONS=76x72
	cp $(noto_emoji_dir)/$(name).ttf $(dist_dir)/

$(png_dir) $(dist_dir):
	mkdir -p "$@"

$(noto_emoji_dir)/$(name).tmpl.ttx.tmpl: $(noto_emoji_dir)/NotoColorEmoji.tmpl.ttx.tmpl
	sed 's/Noto Color Emoji/$(name)/; s/NotoColorEmoji/$(name)/; s/Copyright .* Google Inc\./$(author)/; s/ Version .*/ $(version)/; s/.*is a trademark.*//; s/Google, Inc\./($author)/; s,http://www.google.com/get/noto/,$(url),; s/.*is licensed under.*/      $(license)/; s,http://scripts.sil.org/OFL,$(license_url),' "$<" > "$@"

$(png_dir)/%.png: $(svg_dir)/%.svg | $(png_dir)
	rsvg-convert -w 72 -h 72 "$<" > "$@"

clean:  ## Remove built TTF file and temporary files
	cd $(noto_emoji_dir) && \
	$(MAKE) $(_make_args) clean
	-rm $(noto_emoji_dir)/$(name).tmpl.ttx.tmpl
	-rm $(dist_dir)/$(name).ttf
	-rm $(png_dir)/*.png

debug:  ## Print all SVG and PNG file paths
	@echo "SVGs:"
	@echo $(_all_svgs)
	@echo "PNGs:"
	@echo $(_all_pngs)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
