import sys
import unicodedata

if len(sys.argv) != 2:
    print("Usage: python process_text.py <text_file>")
    sys.exit(1)

file_path = sys.argv[1]

print(f"Processing file: {file_path}")

# Список невидимых/непечатаемых символов
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

try:
    with open(file_path, 'r', encoding='utf-8') as f:
        text = f.read()
except UnicodeDecodeError:
    with open(file_path, 'rb') as f:
        text = f.read().decode('utf-8', errors='ignore')

print(f"File content length: {len(text)} characters")

# Обработка текста
for i, ch in enumerate(text, 1):
    code = ord(ch)
    if code in bad_chars:
        try:
            name = unicodedata.name(ch)
        except ValueError:
            name = 'UNKNOWN'
        ascii_representation = unidecode(ch)
        print(f"Position: {i}, Char: U+{code:04X}, Name: {name}, ASCII: {ascii_representation}")
