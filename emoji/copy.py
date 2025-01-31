#!/usr/bin/env python3

import argparse
import json
import logging
import os.path
import shutil
import sys

from emoji.common import unicode_name_to_code

logger = logging.getLogger(__name__)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--src-dir", required=True)
    parser.add_argument("-d", "--dst-dir", required=True)
    args = parser.parse_args()
    for emoji in json.load(sys.stdin):
        src = os.path.join(args.src_dir, emoji["filename"])
        dst = os.path.join(
            args.dst_dir,
            "-".join(map(unicode_name_to_code, emoji["sequence"])) + ".svg",
        )
        if not os.path.exists(dst):
            logger.warning(f"Copying {src} to {dst}")
            shutil.copy2(src, dst)
        else:
            logger.warning(f"Target file {dst} already exists")


if __name__ == "__main__":
    main()
