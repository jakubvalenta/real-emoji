import json
from typing import IO, Any


def write_json(data: Any, f: IO):
    json.dump(data, f, ensure_ascii=False, sort_keys=True, indent=2)
    f.write('\n')
