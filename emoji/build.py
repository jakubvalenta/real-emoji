#!/usr/bin/env python3

import json
import sys

from emoji.common import unicode_name_to_code, write_json


def main():
    emojis = json.load(sys.stdin)
    for emoji in emojis:
        emoji['display_name'] = emoji['display_name'] or emoji['name']
        emoji['chars'] = [
            f'&#x{hex_str};'
            for hex_str in map(unicode_name_to_code, emoji['sequence'])
        ]
        emoji['string'] = ''.join(emoji['chars'])
    write_json(emojis, sys.stdout)


if __name__ == '__main__':
    main()
