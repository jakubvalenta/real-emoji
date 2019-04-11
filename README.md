# Emoji

## Installation

Install the following dependencies using your package manager:

- make
- librsvg
- nototools (available in [Arch Linux User Repository](https://aur.archlinux.org/packages/nototools-git/))
- optipng
- pngquant

## Build the TTF file

```
make
```

If everything succeeds, you will find the TTF file in the `dist/` directory.

## Preview the font

Dependencies:

- webify (available in [Arch Linux User Repository](https://aur.archlinux.org/packages/webify/))
- woff2
- jekyll

```
make serve
```

## Credits

The build system is inspired by how the [Twemoji package of Fedora
Linux](https://src.fedoraproject.org/rpms/twitter-twemoji-fonts) is built. It
uses scripts from the [Noto Emoji
font](https://github.com/googlei18n/noto-emoji).

The standard emojis are copied from the [Twemoji
font](https://twitter.github.io/twemoji/) by Twitter licensed under
[CC-BY](http://creativecommons.org/licenses/by-sa/4.0/).

## Contributing

__Feel free to remix this project.__

The code is licensed under the [Apache License, Version
2.0.](http://www.apache.org/licenses/LICENSE-2.0).

The graphics (emoji SVG images) are licensed under the [Creative Commons
Attribution-ShareAlike 4.0 International
License](http://creativecommons.org/licenses/by-sa/4.0/).
