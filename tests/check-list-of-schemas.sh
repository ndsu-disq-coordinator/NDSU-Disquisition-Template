#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

copy_project() {
  local dest="$1"
  mkdir -p "$dest"
  (cd "$repo_root" && tar \
    --exclude='.git' \
    --exclude='*.pdf' \
    --exclude='*.aux' \
    --exclude='*.bbl' \
    --exclude='*.bcf' \
    --exclude='*.blg' \
    --exclude='*.fdb_latexmk' \
    --exclude='*.fls' \
    --exclude='*.lof' \
    --exclude='*.log' \
    --exclude='*.loe' \
    --exclude='*.los' \
    --exclude='*.lot' \
    --exclude='*.out' \
    --exclude='*.run.xml' \
    --exclude='*.toc' \
    -cf - .) | (cd "$dest" && tar -xf -)
}

compile_project() {
  local dest="$1"
  (cd "$dest" && latexmk -lualatex -pdf -interaction=nonstopmode main.tex >/tmp/ndsudisq-schema-test.log 2>&1) || {
    cat /tmp/ndsudisq-schema-test.log >&2
    return 1
  }
}

extract_pdf_text() {
  local dest="$1"
  pdftotext "$dest/main.pdf" -
}

# State A: default main.tex keeps \includelistofschemas commented out.
disabled="$tmpdir/disabled"
copy_project "$disabled"
compile_project "$disabled"
if extract_pdf_text "$disabled" | grep -q 'LIST OF SCHEMAS'; then
  echo 'State A failed: disabled PDF contains LIST OF SCHEMAS.' >&2
  exit 1
fi
if ! extract_pdf_text "$disabled" | grep -q 'Example qualitative coding schema'; then
  echo 'State A failed: schema body caption is missing when the list is disabled.' >&2
  exit 1
fi

# State B: enable the optional list and confirm heading, entry, TOC entry, body, and reference settling.
enabled="$tmpdir/enabled"
copy_project "$enabled"
perl -0pi -e 's/%\s*\\includelistofschemas/\\includelistofschemas/' "$enabled/main.tex"
compile_project "$enabled"
if ! extract_pdf_text "$enabled" | grep -q 'LIST OF SCHEMAS'; then
  echo 'State B failed: enabled PDF does not contain LIST OF SCHEMAS.' >&2
  exit 1
fi
if ! extract_pdf_text "$enabled" | grep -q 'Example qualitative coding schema'; then
  echo 'State B failed: enabled PDF does not contain the sample schema caption.' >&2
  exit 1
fi
if ! grep -q 'LIST OF SCHEMAS' "$enabled/main.toc"; then
  echo 'State B failed: table of contents file does not include LIST OF SCHEMAS.' >&2
  exit 1
fi
if ! grep -q 'Example qualitative coding schema' "$enabled/main.los"; then
  echo 'State B failed: schema list file does not include the sample schema caption.' >&2
  exit 1
fi
if extract_pdf_text "$enabled" | grep -q 'Schema ??'; then
  echo 'State B failed: schema cross-reference did not resolve.' >&2
  exit 1
fi

echo 'List of Schemas checks passed.'
