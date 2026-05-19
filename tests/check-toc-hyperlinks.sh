#!/usr/bin/env bash
set -euo pipefail

fixture="tests/toc-hyperlink-fixture.tex"
base="tests/toc-hyperlink-fixture"
pdf="${base}.pdf"
json="${base}.qpdf.json"

for tool in latexmk qpdf pdftotext python3; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required tool: $tool" >&2
    exit 2
  fi
done

latexmk -pdf -lualatex -interaction=nonstopmode -file-line-error "$fixture"
qpdf --json "$pdf" > "$json"
pdftotext "$pdf" "${base}.txt"

python3 - <<'PY'
import json
import re
import subprocess
from pathlib import Path

base = Path("tests/toc-hyperlink-fixture")
pdf = base.with_suffix(".pdf")

for ext in (".toc", ".lof", ".lot"):
    path = base.with_suffix(ext)
    text = path.read_text(encoding="utf-8")
    entries = [line for line in text.splitlines() if "\\contentsline" in line]
    if not entries:
        raise SystemExit(f"{path} contains no \\contentsline entries")
    missing = [line for line in entries if not re.search(r"\}\{[^{}]+\}%?$", line)]
    if missing:
        raise SystemExit(f"{path} has entries without final hyperref destinations: {missing[:2]}")

# Locate pages by extracted text so the check is not tied to a fixed front-matter
# page count.
def page_text(page):
    return subprocess.check_output(
        ["pdftotext", "-f", str(page), "-l", str(page), str(pdf), "-"],
        text=True,
        stderr=subprocess.DEVNULL,
    )

data = json.loads(base.with_suffix(".qpdf.json").read_text(encoding="utf-8"))
pages = data.get("pages", [])
if not pages:
    raise SystemExit("qpdf JSON did not contain page data")
outlines = data.get("outlines")
if outlines is not None and not outlines:
    raise SystemExit("qpdf JSON reports no PDF outlines/bookmarks")

labels = {}
for page_number in range(1, len(pages) + 1):
    text = page_text(page_number)
    if "TABLE OF CONTENTS" in text:
        labels.setdefault("toc", page_number)
    if "LIST OF FIGURES" in text:
        labels.setdefault("lof", page_number)
    if "LIST OF TABLES" in text:
        labels.setdefault("lot", page_number)
for label in ("toc", "lof", "lot"):
    if label not in labels:
        raise SystemExit(f"Could not locate {label} page in extracted PDF text")

objects = {}
for chunk in data.get("qpdf", []):
    for key, value in chunk.items():
        if key.startswith("obj:"):
            objects[key[4:]] = value.get("value", {})

def deref(value):
    if isinstance(value, str) and re.fullmatch(r"\d+ \d+ R", value):
        return objects.get(value, {})
    return value

def page_link_count(page_index):
    page_obj = deref(pages[page_index - 1].get("object"))
    annots = deref(page_obj.get("/Annots", [])) or []
    count = 0
    for annot in annots:
        annot_obj = deref(annot)
        if isinstance(annot_obj, dict) and annot_obj.get("/Subtype") == "/Link":
            count += 1
    return count

for label, page_number in labels.items():
    count = page_link_count(page_number)
    if count == 0:
        raise SystemExit(f"{label} page {page_number} has no /Subtype /Link annotations")
    print(f"{label} page {page_number}: {count} link annotations")

print("TOC/list hyperlink regression checks passed")
PY
