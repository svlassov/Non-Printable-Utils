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

# Распаковываем .docx
unzip -qq "$DOCX_FILE" -d "$TMP_DIR"

XML="$TMP_DIR/word/document.xml"
if [ ! -f "$XML" ]; then
  echo "Error: document.xml not found"
  rm -rf "$TMP_DIR"
  exit 1
fi

# Извлекаем текст без XML-тегов
TEXT=$(sed 's/<[^>]*>//g' "$XML")

# Передаём в Python через stdin
echo "$TEXT" | python3 -c '
import sys
import unicodedata

# Символы, которые считаем подозрительными/невидимыми
bad_chars = {
    0x00A0,  # NO-BREAK SPACE
    0x200B,  # ZERO WIDTH SPACE
    0x200C,  # ZERO WIDTH NON-JOINER
    0x200D,  # ZERO WIDTH JOINER
    0x202C,  # POP DIRECTIONAL FORMATTING
    0x202E,  # RIGHT-TO-LEFT OVERRIDE
    0x202F,  # NARROW NO-BREAK SPACE
    0x2060,  # WORD JOINER
    0xFEFF   # BOM
}

text = sys.stdin.read()
for i, ch in enumerate(text, 1):
    code = ord(ch)
    if code in bad_chars:
        try:
            name = unicodedata.name(ch)
        except ValueError:
            name = "UNKNOWN"
        print(f"Position: {i}, Char: U+{code:04X}, Name: {name}")
'

# Очистка
rm -rf "$TMP_DIR"
