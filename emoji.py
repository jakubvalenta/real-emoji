#!/usr/bin/env python3

import csv
import json
import os
import re
from dataclasses import dataclass
from typing import Dict, List


@dataclass
class Emoji:
    path: str
    name: str
    sequence: List[str]

    @property
    def html(self) -> str:
        return ''.join(f'&#x{code};' for code in self.sequence)

    @property
    def sequence_html(self) -> str:
        return '&#200B;'.join(f'&#x{code};' for code in self.sequence)

    @property
    def sequence_text(self) -> str:
        return ' + '.join(f'U+{code}' for code in self.sequence)

    @classmethod
    def from_path(cls, path: str, names: Dict[str, str]) -> 'Emoji':
        name = names.get(path)
        m = re.search(r'^emoji_u(?P<sequence>.*)\.png$', path)
        sequence = [x.upper() for x in m.group('sequence').split('_')]
        return cls(path=path, name=name, sequence=sequence)

    def to_dict(self) -> dict:
        return {
            'path': self.path,
            'name': self.name,
            'html': self.html,
            'sequence': self.sequence,
            'sequence_html': self.sequence_html,
            'sequence_text': self.sequence_text,
        }


def main(
    png_dir: str = './noto-emoji/build/quantized_pngs/',
    csv_file: str = './emoji.csv',
    output_file: str = './_data/emoji.json',
):
    with open(csv_file) as f:
        reader = csv.reader(f)
        names = {path + '.png': name for path, name in reader}
    emojis = [
        Emoji.from_path(path, names).to_dict()
        for path in sorted(os.listdir(png_dir))
    ]
    with open(output_file, 'w') as f:
        json.dump(emojis, f, sort_keys=True, indent=2)


if __name__ == '__main__':
    main()
