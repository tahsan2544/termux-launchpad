#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
fail=0
while IFS= read -r -d '' file; do
  if ! bash -n "$file"; then echo "Syntax error: $file" >&2; fail=1; fi
done < <(find "$ROOT" -type f \( -name '*.sh' -o -path '*/bin/launchpad' -o -path '*/.githooks/pre-commit' \) -print0)
[ "$fail" -eq 0 ] || exit 1
bash "$ROOT/tests/test-version-bump.sh"
bash "$ROOT/tests/test-hook.sh"
bash "$ROOT/tests/test-dispatcher.sh"
python3 "$ROOT/tests/test-opencode-config.py"
python3 "$ROOT/tests/test-command-map.py"
python3 - "$ROOT/scripts/configure-opencode-omni.py" <<'PYCODE'
import ast, sys
from pathlib import Path
ast.parse(Path(sys.argv[1]).read_text(encoding="utf-8"))
PYCODE
echo "All local checks passed. For style linting, install ShellCheck and run: shellcheck -S error scripts/*.sh lib/*.sh bin/launchpad .githooks/pre-commit tests/*.sh"
