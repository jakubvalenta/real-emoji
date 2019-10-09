# Emojis for grown-ups

30 new emojis that go beyond the hugs and kisses of the standard emoji set.

![Emojis for grown-ups](data/emojis-for-grownups.png)

You can install the emojis as a custom font. Then you can write the new emojis
by writing a sequence of standard emojis.

![Emojis for grown-ups usage](data/emojis-for-grownups-usage.gif)

## Installation

### iOS

1. Download the [Emojis for grown-ups iOS configuration
   profile](dist/emojis-for-grownups-ios-profile).
2. Install the profile:

![iOS configuration profile installation instructions](data/ios-install.png)

### Android [technical instructions]

1. Download the [Emojis for grown-ups font file](dist/EmojisForGrownUps.ttf).
2. Replace the default emoji font using Android Debugger:

```
adb shell cp /system/fonts/NotoColorEmoji.ttf /system/fonts/NotoColorEmoji.ttf.bak
adb push EmojisForGrownUps.ttf /system/fonts/NotoColorEmoji.ttf
```

### Desktop (Windows, Mac, Linux) [general instructions]

1. Download the [Emojis for grown-ups font file](dist/EmojisForGrownUps.ttf).
2. Copy it in your operating system's font directory.
3. Change your operating systems settings to use this font.

### Web

If you're a web designer, you can download an use the [Emojis for grown-ups
webfont](dist/EmojisForGrownUps-webfont.ttf).

## Development

Install the following dependencies using your package manager:

- make
- librsvg
- nototools (available in [Arch Linux User
  Repository](https://aur.archlinux.org/packages/nototools-git/))
- optipng
- pngquant
- svgo

Build the required Docker image:

```
cd twemoji-color-font/scfbuild && make
```

### Building the font file

```
make
```

If everything succeeds, you will find the TTF file in the `dist/` directory.

### Rendering a preview of the font

Dependencies:

- webify (available in [Arch Linux User
  Repository](https://aur.archlinux.org/packages/webify/))
- woff2
- hugo

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
2.0](http://www.apache.org/licenses/LICENSE-2.0).

The graphics (emoji SVG images) are licensed under the [Creative Commons
Attribution-ShareAlike 4.0 International
License](http://creativecommons.org/licenses/by-sa/4.0/).
