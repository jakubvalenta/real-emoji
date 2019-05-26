#!/usr/bin/env python3

import itertools
import json
import sys
import unicodedata
from typing import Any, Dict, Iterator, List

from emoji.common import write_json


def codes(names: List[str]) -> List[str]:
    return [
        name
        if name.startswith('1f')
        else hex(ord(unicodedata.lookup(name)))[2:]
        for name in names
    ]


def join_list(l: list, sep: Any) -> Iterator:
    for i, x in enumerate(l):
        yield x
        if i != len(l) - 1:
            yield sep


def product(emojis: List[Dict]) -> Iterator[Dict]:
    for emoji in emojis:
        for sequence in itertools.product(
            emoji['try_chars'], emoji['try_chars']
        ):
            new_emoji = emoji.copy()
            new_emoji['sequence'] = codes(sequence)
            yield new_emoji
            new_emoji_with_zwj = emoji.copy()
            new_emoji_with_zwj['sequence'] = list(
                join_list(new_emoji['sequence'], '200d')
            )
            yield new_emoji_with_zwj


def main():
    emojis = json.load(sys.stdin)
    emojis_try = list(product(emojis))
    write_json(emojis_try, sys.stdout)


if __name__ == '__main__':
    main()
