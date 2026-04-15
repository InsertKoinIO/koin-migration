#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/skills/di-migration"
SKILL_OUT="$ROOT/di-migration-skill.skill"
PLUGIN_OUT="$ROOT/koin-migration-plugin.zip"

# --- validate sources -------------------------------------------------------

[[ -f "$SRC/SKILL.md" ]]                  || { echo "error: $SRC/SKILL.md not found" >&2; exit 1; }
[[ -f "$ROOT/.claude-plugin/plugin.json" ]] || { echo "error: .claude-plugin/plugin.json missing" >&2; exit 1; }
[[ -f "$ROOT/LICENSE" ]]                  || { echo "error: LICENSE missing" >&2; exit 1; }
[[ -f "$ROOT/README.md" ]]                || { echo "error: README.md missing" >&2; exit 1; }

# basic plugin.json sanity check
python3 -c "import json,sys; m=json.load(open('$ROOT/.claude-plugin/plugin.json')); [sys.exit(f'plugin.json missing field: {f}') for f in ('name','version','description','license','repository') if f not in m]"

# --- build .skill bundle (portable single-skill archive, flat layout) ------

rm -f "$SKILL_OUT"
(cd "$SRC" && zip -rq "$SKILL_OUT" SKILL.md references $([[ -d evals ]] && echo evals) \
   -x "*/.DS_Store" "*.DS_Store")
echo "built: $SKILL_OUT"

# --- build plugin .zip (marketplace submission layout) ----------------------

rm -f "$PLUGIN_OUT"
(cd "$ROOT" && zip -rq "$PLUGIN_OUT" \
  .claude-plugin \
  skills \
  README.md \
  LICENSE \
  CHANGELOG.md \
  -x "skills/*/.DS_Store" "*.DS_Store")
echo "built: $PLUGIN_OUT"

echo
echo "--- plugin contents ---"
unzip -l "$PLUGIN_OUT"
