#!/usr/bin/env python3

import itertools
import json
import sys
from typing import Iterator

from emoji.common import unicode_name_to_code, write_json


def product(emojis: list[dict]) -> Iterator[dict]:
    for emoji in emojis:
        try_chars = emoji.get("try")
        if not try_chars:
            continue
        for sequence in itertools.product(try_chars, try_chars):
            new_emoji = emoji.copy()
            new_emoji["sequence"] = list(map(unicode_name_to_code, sequence))
            yield new_emoji


def main():
    emojis = json.load(sys.stdin)
    emojis_try = list(product(emojis))
    write_json(emojis_try, sys.stdout)


if __name__ == "__main__":
    main()
