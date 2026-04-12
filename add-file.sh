#!/usr/bin/env bash
# -------------------------------------------------------
# add-file.sh — add PMP study files to the dashboard
#
# Single file:
#   ./add-file.sh "/c/Users/nikki/OneDrive/PMP/notes.pdf"
#
# Multiple files:
#   ./add-file.sh file1.pdf file2.pptx file3.xlsx
#
# Entire folder (all files inside, any depth):
#   ./add-file.sh --dir "/c/Users/nikki/OneDrive/PMP/pmiitest"
#
# What it does:
#   1. Copies file(s) into files/ (preserving subfolders)
#   2. Stages them with git add
#   3. Prints ALL_FILES entries to paste into index.html
#   4. Gives you the one-liner to commit and push
# -------------------------------------------------------

set -e

PMP_ROOT="/c/Users/nikki/OneDrive/PMP"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
FILES_DIR="$REPO_DIR/files"

# ── Argument check ──────────────────────────────────────
if [ -z "$1" ]; then
  echo ""
  echo "Usage:"
  echo "  ./add-file.sh file.pdf                         # single file"
  echo "  ./add-file.sh file1.pdf file2.pptx file3.xlsx  # multiple files"
  echo "  ./add-file.sh --dir \"/path/to/folder\"          # entire folder"
  exit 1
fi

# ── Collect source files ────────────────────────────────
SOURCES=()
if [ "$1" = "--dir" ]; then
  DIR="$2"
  if [ ! -d "$DIR" ]; then
    echo "❌  Directory not found: $DIR"
    exit 1
  fi
  while IFS= read -r f; do
    SOURCES+=("$f")
  done < <(find "$DIR" -type f)
else
  for arg in "$@"; do
    SOURCES+=("$arg")
  done
fi

if [ ${#SOURCES[@]} -eq 0 ]; then
  echo "❌  No files found."
  exit 1
fi

# ── Icon helper ─────────────────────────────────────────
get_icon() {
  case "${1,,}" in
    pdf)       echo "📄" ;;
    pptx|ppt)  echo "📊" ;;
    xlsx|xls)  echo "📋" ;;
    docx|doc)  echo "📝" ;;
    epub)      echo "📗" ;;
    *)         echo "📁" ;;
  esac
}

# ── Process each file ───────────────────────────────────
ENTRIES=()
FILENAMES=()
SKIPPED=0

echo ""
for SRC in "${SOURCES[@]}"; do
  if [ ! -f "$SRC" ]; then
    echo "⚠️   Skipping (not found): $SRC"
    ((SKIPPED++)) || true
    continue
  fi

  if [[ "$SRC" == "$PMP_ROOT/"* ]]; then
    REL="${SRC#$PMP_ROOT/}"
  else
    REL="$(basename "$SRC")"
  fi

  DEST="$FILES_DIR/$REL"
  mkdir -p "$(dirname "$DEST")"
  cp "$SRC" "$DEST"
  git -C "$REPO_DIR" add "files/$REL"
  echo "✅  files/$REL"

  FILENAME="$(basename "$SRC")"
  EXT="${FILENAME##*.}"
  NAME="${FILENAME%.*}"
  ICON="$(get_icon "$EXT")"
  ENTRIES+=("  { icon:\"$ICON\", name:\"$NAME\", desc:\"\", pri:\"MED\", rel:\"$REL\" },")
  FILENAMES+=("$FILENAME")
done

COPIED=${#ENTRIES[@]}
echo ""
echo "Copied $COPIED file(s)$([ $SKIPPED -gt 0 ] && echo ", skipped $SKIPPED" || echo "")"

# ── Print ALL_FILES entries ──────────────────────────────
echo ""
echo "────────────────────────────────────────────────────────"
echo " Paste these into ALL_FILES in index.html (~line 1307):"
echo "────────────────────────────────────────────────────────"
echo ""
for entry in "${ENTRIES[@]}"; do
  echo "$entry"
done
echo ""
echo "────────────────────────────────────────────────────────"
echo " Then commit and push:"
echo "────────────────────────────────────────────────────────"
echo ""
if [ $COPIED -eq 1 ]; then
  echo "  git add index.html && git commit -m \"feat: add ${FILENAMES[0]}\" && git push"
else
  echo "  git add index.html && git commit -m \"feat: add $COPIED PMP study files\" && git push"
fi
echo ""
