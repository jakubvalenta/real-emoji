#!/usr/bin/env python3

import argparse
import json
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--dst-dir', required=True)
    args = parser.parse_args()
    emojis = json.load(sys.stdin)
    out_dir_path = Path(args.dst_dir)
    for i, emoji in enumerate(emojis):
        title = emoji['display_name'] or emoji['name']
        datetime_ = f'2019-10-10T00:00:{i:02}+02:00'
        svg_filename = emoji['filename']
        post_filename = Path(svg_filename).with_suffix('.html')
        post_path = out_dir_path / post_filename
        post_content = f'''---
title: {title}
filename: {svg_filename}
date: {datetime_}
---
'''
        post_path.write_text(post_content)


if __name__ == '__main__':
    main()
