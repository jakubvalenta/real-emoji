import json
import unicodedata
from typing import IO, Any


def unicode_name_to_code(name: str) -> str:
    try:
        char = unicodedata.lookup(name)
    except KeyError:
        return name
    return hex(ord(char))[2:]


def write_json(data: Any, f: IO):
    json.dump(data, f, ensure_ascii=False, sort_keys=True, indent=2)
    f.write('\n')
