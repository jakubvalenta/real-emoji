#!/usr/bin/env python

import csv
import dataclasses
import json
import os
import re
from typing import Dict, List


@dataclasses.dataclass
class Emoji:
    name: str
    sequence: List[str]

    @classmethod
    def from_path(cls, path: str, names: Dict[str, str]) -> 'Emoji':
        name = names.get(path)
        m = re.search(r'^emoji_u(?P<sequence>.*)\.png$', path)
        sequence = [x.upper() for x in m.group('sequence').split('_')]
        return cls(name=name, sequence=sequence)


def main(
    png_dir: str = './noto-emoji/build/quantized_pngs/',
    csv_file: str = './emoji.csv',
    output_file: str = './_data/emoji.json',
):
    with open(csv_file) as f:
        reader = csv.reader(f)
        names = {path + '.png': name for path, name in reader}
    emojis = [
        dataclasses.asdict(Emoji.from_path(path, names))
        for path in sorted(os.listdir(png_dir))
    ]
    with open(output_file, 'w') as f:
        json.dump(emojis, f, sort_keys=True, indent=2)


if __name__ == '__main__':
    main()
