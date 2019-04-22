#!/usr/bin/env python3

import csv
import json
import os
import re
import unicodedata
from dataclasses import dataclass
from typing import Dict, List, Optional


@dataclass
class Emoji:
    path: str
    string: str
    custom_name: Optional[str]

    @property
    def name(self) -> Optional[str]:
        if self.custom_name:
            return self.custom_name
        if not self.char:
            return None
        try:
            return unicodedata.name(self.char)
        except ValueError:
            return None

    @property
    def char(self) -> Optional[str]:
        if len(self.string) == 1:
            return self.string[0]
        return None

    @property
    def sequence(self) -> str:
        return '\N{ZERO WIDTH SPACE}'.join(self.string)

    @property
    def code(self) -> str:
        hex_strs = (hex(ord(char))[2:] for char in self.string)
        return ' + '.join(f'U+{hex_str.upper()}' for hex_str in hex_strs)

    @property
    def title(self) -> str:
        return ' | '.join(x for x in [self.name, self.code] if x)

    @property
    def standard(self) -> bool:
        return not self.custom_name

    @classmethod
    def from_path(cls, path: str, custom_names: Dict[str, str]) -> 'Emoji':
        custom_name = custom_names.get(path)
        m = re.search(r'^emoji_u(?P<sequence>.*)\.png$', path)
        string = ''.join(
            chr(int(hex_str, 16)) for hex_str in m.group('sequence').split('_')
        )
        return cls(path=path, string=string, custom_name=custom_name)

    def to_dict(self) -> dict:
        return {
            'path': self.path,
            'name': self.name,
            'string': self.string,
            'sequence': self.sequence,
            'code': self.code,
            'title': self.title,
            'standard': self.standard,
        }


def main(
    png_dir: str = './noto-emoji/build/quantized_pngs/',
    csv_file: str = './emoji.csv',
    output_file: str = './_data/emoji.json',
):
    with open(csv_file) as f:
        reader = csv.reader(f)
        custom_names = {path + '.png': name for path, name in reader}
    emojis = [
        Emoji.from_path(path, custom_names).to_dict()
        for path in sorted(os.listdir(png_dir))
    ]
    with open(output_file, 'w') as f:
        json.dump(emojis, f, ensure_ascii=False, sort_keys=True, indent=2)


if __name__ == '__main__':
    main()
