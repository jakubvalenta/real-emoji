---
layout: default
---

# {{ site.title }}

{{ site.description }}

<h2 class="sr-only">New emojis</h2>

<ul class="emojis emojis--custom">
  {% for emoji in site.data.custom_emojis %}
  <li class="emoji">
    <img
      src="svg/{{ emoji.path_base }}.svg"
      alt="{{ emoji.display_name }} emoji"
      class="emoji-img"
    />
    <h3>{{ emoji.display_name }}</h3>
    <p class="emoji-description">{{ emoji.description }}</p>
  </li>
  {% endfor %}
</ul>

## Try it out

You can write the new emojis by writing specific sequences of the standard
emojis.

<ul class="emojis emojis--sequences">
  {% for emoji in site.data.custom_emojis %}
  <li class="emoji">
    <span class="emoji-string" title="{{ emoji.display_name }} emoji"
      >{{ emoji.string }}</span
    >
    =
    <span class="emoji-string">{{ emoji.sequence }}</span>
  </li>
  {% endfor %}
</ul>
<!-- TODO On screen keyboard -->

## Download

Emojis for grown-ups are currently available as an Emoji font. This font is
based on [Twitter's emojis](https://twitter.github.io/twemoji/) so it also
contains [all standard emojis](#all-emojis).

- Linux and Android: [Emoji.ttf](dist/Emoji.ttf)
- Webfont: [Emoji.zip](dist/Emoji.zip)
- Windows: Not technically possible, because Windows doesn't support the format
  of Twitter's emoji font. <!-- TODO: Add name of the font format -->
- iOS: Not technically possible, because Apple doesn't allow changing the system
  font. <!-- TODO: Cite some source -->

## Making these emojis official

Emojis are approved by the Unicode consorcium. There are rigorous rules to that.

A table of submissions:

| emoji | status | reason |
|-|-|-|
| foo | bar | baz |

## Contributing and contact

If you have a suggestion for more emojis to add or if you have technical
problems with the emojis, please file a [GitHub issue](https://www.github.com/jakubvalenta/emoji/issues).

You can also write me an email (for whatever reason) to

<script>
  document.write(
    '<n uers="rzbwv@znvyobk.bet" ery="absbyybj">rzbwv@znvyobk.bet</n>'.replace(
      /[a-zA-Z]/g,
      function(c) {
        return String.fromCharCode(
          (c <= 'Z' ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26
        );
      }
    )
  );
</script>

## All emojis

For reference, here is a full list of all standard emojis plus the new ones:

<ul class="emojis emojis--all">
  {% for emoji in site.data.all_emojis %}
  <li class="emoji{% if emoji.custom %} emoji--custom{% endif %}">
    <h3 class="emoji-string" title="{{ emoji.code }} {{ emoji.name }}">
      {{ emoji.string }}
    </h3>
  </li>
  {% endfor %}
</ul>
