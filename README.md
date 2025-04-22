# Non Printable Utils

## /docx/show_nonprintable.sh

**`/docx/show_nonprintable.sh`** is a Bash script that detects invisible and non-printable Unicode characters in Microsoft Word `.docx` documents. It is useful for:
- Identifying hidden characters copied from PDFs, AI tools, or foreign sources;
- Troubleshooting problematic characters in text processing;
- Detecting steganographic markers or anti-copy tricks (e.g., `U+202E`, `U+200B`, etc.).

**`Usage /docx/show_nonprintable.sh`** 

./show_nonprintable.sh <file.docx>

**Dependencies:**
- unzip    (to extract .docx contents)
- sed      (to strip XML tags)
- python3  (for Unicode analysis)

**Recognized Characters**

The script detects characters such as:
- U+00A0 — NO-BREAK SPACE
- U+200B — ZERO WIDTH SPACE
- U+200C — ZERO WIDTH NON-JOINER
- U+200D — ZERO WIDTH JOINER
- U+202E — RIGHT-TO-LEFT OVERRIDE
- U+202F — NARROW NO-BREAK SPACE
- U+2060 — WORD JOINER
- U+FEFF — BOM (Byte Order Mark)
