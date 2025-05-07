#!/bin/bash

# -----------------------------------------------------------------------------
# show_nonprintable.sh — detect invisible and non-printable Unicode characters
#                        in DOCX documents (e.g., U+200B, U+202F, U+FEFF, etc.)
#
# Usage:
#   ./show_nonprintable.sh <file.docx>
#
# Description:
#   This script extracts text from a .docx Word document, removes XML tags,
#   and scans for suspicious non-printable or zero-width Unicode characters.
#   It prints their position, Unicode code point, and official name.
#
# Dependencies:
#   - unzip    (to extract .docx contents)
#   - sed      (to strip XML tags)
#   - python3  (for Unicode analysis)
#
# Tested on macOS and Linux.
# -----------------------------------------------------------------------------

if [ -z "$1" ]; then
  echo "Usage: $0 <file.docx>"
  exit 1
fi

DOCX_FILE="$1"
TMP_DIR=$(mktemp -d)
TEXT_FILE="$TMP_DIR/text.txt"
PYTHON_SCRIPT="$(dirname "$0")/process_text.py"

# Проверка наличия Python скрипта
if [ ! -f "$PYTHON_SCRIPT" ]; then
  echo "Error: Python script not found at $PYTHON_SCRIPT"
  exit 1
fi

# Распаковываем .docx
unzip -qq "$DOCX_FILE" -d "$TMP_DIR"

XML="$TMP_DIR/word/document.xml"
if [ ! -f "$XML" ]; then
  echo "Error: document.xml not found"
  rm -rf "$TMP_DIR"
  exit 1
fi

# Извлекаем текст без XML-тегов и сохраняем в файл
sed 's/<[^>]*>//g' "$XML" > "$TEXT_FILE"

# Запуск Python скрипта
python3 "$PYTHON_SCRIPT" "$TEXT_FILE"

# Очистка
rm -rf "$TMP_DIR"
