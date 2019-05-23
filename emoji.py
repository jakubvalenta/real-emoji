#!/usr/bin/env python3

import csv
import json
import os
import os.path
import re
import unicodedata
from typing import Any, List, Optional, Sequence


class Emoji:
    path_base: str
    string: str

    def __init__(self, path_base: str, string: str):
        self.path_base = path_base
        self.string = string

    @property
    def name(self) -> Optional[str]:
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
    def sequence(self) -> List[str]:
        return list(self.string)

    @property
    def code(self) -> str:
        hex_strs = (hex(ord(char))[2:] for char in self.string)
        return ' '.join(f'U+{hex_str.upper()}' for hex_str in hex_strs)

    @classmethod
    def from_path_base(cls, path_base: str) -> 'Emoji':
        m = re.search(r'^emoji_u(?P<sequence>.*)$', path_base)
        string = ''.join(
            chr(int(hex_str, 16)) for hex_str in m.group('sequence').split('_')
        )
        return cls(path_base=path_base, string=string)

    def to_dict(self) -> dict:
        return {
            'path_base': self.path_base,
            'name': self.name,
            'string': self.string,
            'sequence': self.sequence,
            'code': self.code,
        }


class CustomEmoji(Emoji):
    _name: str
    category: str
    _display_name: str
    description: str
    related: Sequence[str]

    def __init__(
        self,
        path_base: str,
        string: str,
        name: str,
        display_name: str,
        description: str,
        category: str,
        related: Sequence[str],
    ):
        super().__init__(path_base, string)
        self._name = name
        self.category = category
        self._display_name = display_name
        self.description = description
        self.related = related

    @property
    def name(self) -> str:
        return self._name

    @property
    def display_name(self) -> str:
        return self._display_name or self._name

    @classmethod
    def from_path_base(cls, path_base: str, **kwargs):
        emoji = Emoji.from_path_base(path_base)
        return cls(path_base=emoji.path_base, string=emoji.string, **kwargs)

    def to_dict(self) -> dict:
        return dict(
            **super().to_dict(),
            category=self.category,
            display_name=self.display_name,
            description=self.description,
            related=self.related,
        )


def write_json(data: Any, path: str):
    with open(path, 'w') as f:
        json.dump(data, f, ensure_ascii=False, sort_keys=True, indent=2)


def main(
    png_dir: str = './noto-emoji/build/quantized_pngs/',
    csv_file: str = './emoji.csv',
    all_emojis_output_file: str = './_data/all_emojis.json',
    custom_emojis_output_file: str = './_data/custom_emojis.json',
):
    with open(csv_file) as f:
        custom_emojis = [
            CustomEmoji.from_path_base(
                path_base=row['path_base'],
                name=row['name'],
                display_name=row['display_name'],
                description=row['description'],
                category=row['category'],
                related=(row['related'] or '').split(','),
            ).to_dict()
            for row in csv.DictReader(f)
        ]
    all_emojis = [
        Emoji.from_path_base(os.path.splitext(path)[0]).to_dict()
        for path in sorted(os.listdir(png_dir))
    ]
    write_json(custom_emojis, custom_emojis_output_file)
    write_json(all_emojis, all_emojis_output_file)


if __name__ == '__main__':
    main()
