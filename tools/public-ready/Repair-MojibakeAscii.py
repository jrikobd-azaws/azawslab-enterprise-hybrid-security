import argparse
import subprocess
from pathlib import Path

TEXT_SUFFIXES = {
    ".md", ".txt", ".json", ".yml", ".yaml", ".tf", ".tfvars",
    ".ps1", ".sh", ".py", ".gitignore", ".gitattributes", ".editorconfig"
}

TEXT_NAMES = {
    ".gitignore", ".gitattributes", ".editorconfig"
}

SKIP_PREFIXES = (
    ".git/",
    ".terraform/",
    "node_modules/",
    ".tmp/",
    ".tmp-public-audit/",
    ".migration-backups/"
)

SKIP_FILES = {
    "docs/portfolio-migration-reports/cycle0-encoding-artifact-report.md"
}

BAD_MARKERS = (
    "\u00c3",
    "\u00c2",
    "\u00e2\u20ac",
    "\ufffd",
    "\u00c6",
    "\u00a2",
    "\u00ac"
)

def normalize_path(path):
    return path.replace("\\", "/").lstrip("./")

def is_text_file(path):
    p = Path(path)
    return p.suffix.lower() in TEXT_SUFFIXES or p.name in TEXT_NAMES

def should_skip(path):
    normalized = normalize_path(path)
    if normalized in SKIP_FILES:
        return True
    return any(normalized.startswith(prefix) for prefix in SKIP_PREFIXES)

def tracked_files(root):
    result = subprocess.run(
        ["git", "ls-files"],
        cwd=root,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=True
    )
    return [line.strip() for line in result.stdout.splitlines() if line.strip()]

CHAR_TO_BYTE = {}

for b in range(256):
    try:
        ch = bytes([b]).decode("cp1252")
    except UnicodeDecodeError:
        ch = chr(b)
    CHAR_TO_BYTE[ch] = b

for b in range(256):
    CHAR_TO_BYTE.setdefault(chr(b), b)

def sloppy_cp1252_bytes(text):
    out = bytearray()
    for ch in text:
        b = CHAR_TO_BYTE.get(ch)
        if b is None:
            raise UnicodeError("character cannot be mapped through sloppy cp1252")
        out.append(b)
    return bytes(out)

def suspicious_score(text):
    score = 0
    for marker in BAD_MARKERS:
        score += text.count(marker) * 5
    score += sum(1 for ch in text if 0x80 <= ord(ch) <= 0x9f)
    return score

def repair_once(text):
    try:
        return sloppy_cp1252_bytes(text).decode("utf-8")
    except Exception:
        return text

def repair_mojibake(text):
    current = text

    for _ in range(5):
        repaired = repair_once(current)
        if repaired == current:
            break

        if suspicious_score(repaired) <= suspicious_score(current):
            current = repaired
        else:
            break

    return current

def ascii_normalize(text):
    replacements = {
        "\ufeff": "",
        "\u00a0": " ",
        "\u2010": "-",
        "\u2011": "-",
        "\u2012": "-",
        "\u2013": "-",
        "\u2014": "-",
        "\u2015": "-",
        "\u2212": "-",
        "\u2018": "'",
        "\u2019": "'",
        "\u201a": "'",
        "\u201b": "'",
        "\u201c": '"',
        "\u201d": '"',
        "\u201e": '"',
        "\u201f": '"',
        "\u2026": "...",
        "\u2022": "-",
        "\u00b7": "-",
        "\u2192": "->",
        "\u21d2": "=>",
        "\u2190": "<-",
        "\u21d0": "<=",
        "\u2194": "<->",
        "\u251c\u2500\u2500": "|--",
        "\u2514\u2500\u2500": "`--",
        "\u2502": "|",
        "\u2500": "-",
        "\u251c": "|",
        "\u2514": "`",
    }

    output = text
    for old, new in replacements.items():
        output = output.replace(old, new)

    return output

def process_file(path, apply):
    original_bytes = path.read_bytes()

    try:
        original_text = original_bytes.decode("utf-8")
    except UnicodeDecodeError:
        original_text = original_bytes.decode("cp1252")

    repaired = repair_mojibake(original_text)
    repaired = ascii_normalize(repaired)
    repaired = repaired.replace("\r\n", "\n").replace("\r", "\n")

    if repaired == original_text:
        return False

    if apply:
        path.write_text(repaired, encoding="utf-8", newline="\n")

    return True

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    if not args.apply and not args.dry_run:
        raise SystemExit("Use --dry-run first, then --apply.")

    root = Path(args.root).resolve()
    changed = []

    for rel in tracked_files(root):
        rel_norm = normalize_path(rel)

        if should_skip(rel_norm):
            continue

        if not is_text_file(rel_norm):
            continue

        full_path = root / rel_norm

        if not full_path.exists():
            continue

        if process_file(full_path, apply=args.apply):
            changed.append(rel_norm)

    for item in changed:
        print(item)

    print("")
    print(f"Files {'changed' if args.apply else 'that would change'}: {len(changed)}")

if __name__ == "__main__":
    main()