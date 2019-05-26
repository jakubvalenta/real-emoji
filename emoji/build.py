#!/usr/bin/env python3

import json
import sys

from emoji.common import write_json


def main():
    emojis = json.load(sys.stdin)
    for emoji in emojis:
        emoji['display_name'] = emoji['display_name'] or emoji['name']
        emoji['chars'] = [
            # chr(int(hex_str, 16)) for hex_str in emoji['sequence']
            f'&#x{hex_str};'
            for hex_str in emoji['sequence']
        ]
        emoji['string'] = ''.join(emoji['chars'])
    write_json(emojis, sys.stdout)


if __name__ == '__main__':
    main()
