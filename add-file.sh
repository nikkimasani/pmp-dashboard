#!/usr/bin/env bash
# -------------------------------------------------------
# add-file.sh — add a new PMP study file to the dashboard
#
# Usage:
#   ./add-file.sh "/c/Users/nikki/OneDrive/PMP/mynotes.pdf"
#
# What it does:
#   1. Copies the file into files/ (preserving subfolders)
#   2. Stages it with git add
#   3. Prints the ALL_FILES entry to paste into index.html
#   4. Gives you the one-liner to commit and push
# -------------------------------------------------------

set -e

PMP_ROOT="/c/Users/nikki/OneDrive/PMP"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
FILES_DIR="$REPO_DIR/files"

# ── Argument check ──────────────────────────────────────
if [ -z "$1" ]; then
  echo ""
  echo "Usage: ./add-file.sh <path-to-file>"
  echo ""
  echo "Examples:"
  echo "  ./add-file.sh \"/c/Users/nikki/OneDrive/PMP/new-study-guide.pdf\""
  echo "  ./add-file.sh \"/c/Users/nikki/OneDrive/PMP/pmiitest/new-exercise.pdf\""
  exit 1
fi

SRC="$1"

if [ ! -f "$SRC" ]; then
  echo ""
  echo "❌  File not found: $SRC"
  exit 1
fi

# ── Resolve relative path from PMP root ─────────────────
if [[ "$SRC" == "$PMP_ROOT/"* ]]; then
  REL="${SRC#$PMP_ROOT/}"
else
  REL="$(basename "$SRC")"
  echo "ℹ️  File is outside OneDrive/PMP — placing in files/ root."
fi

DEST="$FILES_DIR/$REL"
DEST_DIR="$(dirname "$DEST")"

# ── Copy ────────────────────────────────────────────────
mkdir -p "$DEST_DIR"
cp "$SRC" "$DEST"
echo ""
echo "✅  Copied  →  files/$REL"

# ── Git stage ───────────────────────────────────────────
git -C "$REPO_DIR" add "files/$REL"
echo "✅  Staged in git"

# ── Pick icon by extension ──────────────────────────────
EXT="${SRC##*.}"
case "${EXT,,}" in
  pdf)       ICON="📄" ;;
  pptx|ppt)  ICON="📊" ;;
  xlsx|xls)  ICON="📋" ;;
  docx|doc)  ICON="📝" ;;
  epub)      ICON="📗" ;;
  *)         ICON="📁" ;;
esac

FILENAME="$(basename "$SRC")"
NAME="${FILENAME%.*}"

# ── Print ALL_FILES entry ────────────────────────────────
echo ""
echo "────────────────────────────────────────────────────────"
echo " Add this line to ALL_FILES in index.html (~line 1307):"
echo "────────────────────────────────────────────────────────"
echo ""
echo "  { icon:\"$ICON\", name:\"$NAME\", desc:\"\", pri:\"MED\", rel:\"$REL\" },"
echo ""
echo "────────────────────────────────────────────────────────"
echo " Then commit and push:"
echo "────────────────────────────────────────────────────────"
echo ""
echo "  git add index.html && git commit -m \"feat: add $FILENAME\" && git push"
echo ""
