# Math tagging notes

## Changelog

- 2026-05-18: Switched the default sample entry point in `main.tex` to the PDF/UA-1 validation target and enabled LaTeX's `math/alt/use` tagging setup so Formula structure elements have an `/Alt` fallback, especially for inline math.

## Audit summary

- Compiled entry points found in this repository: `main.tex`, `tests/note-alignment-fixture.tex`, `tests/toc-hyperlink-fixture.tex`, and `tests/math-tagging-fixture.tex`. No `.sty` files were present in the repository audit.
- `main.tex` declares `\DocumentMetadata` before `\documentclass`; this is the default/sample disquisition entry point.
- Before this change, `main.tex`, `tests/note-alignment-fixture.tex`, and `tests/toc-hyperlink-fixture.tex` requested tagged PDF output and explicitly used `pdfstandard=ua-2`; no checked-in `.log` or `.pdf` files were present to inspect before building, and the current container has no TeX engine installed to generate new ones.
- The default sample in `main.tex` now targets `pdfstandard=ua-1` because the current validation report being investigated is PDF/UA-1.
- `math/alt/use` is enabled in the `\DocumentMetadata` block in `main.tex` and in the focused `tests/math-tagging-fixture.tex` test entry point. The existing non-math regression fixtures were left unchanged to avoid broadening this focused change set.
- The class already provides `\mathalt{...}` for human-readable display-equation descriptions and hooks it into display math environments such as `equation` and `align`. That workflow was preserved unchanged.
- The class also provides `\equationlistentry{...}` and List of Equations support. Those macros were not changed.

## Default PDF/UA-1 math-alt behavior

The default sample enables Formula `/Alt` fallback through `main.tex`:

```tex
\DocumentMetadata{
  tagging=on,
  pdfstandard=ua-1,
  lang=en-US,
  tagging-setup={
    math/alt/use
  }
}
```

This setting is intended to address PAC Alternative Descriptions failures caused by Formula tags without `/Alt`. The fallback may be based on the LaTeX math source rather than ideal spoken mathematics, so it is not a substitute for explanatory prose.

## Display-equation descriptions

The existing `\mathalt{...}` workflow remains available for important display equations. In the focused math fixture, a numbered `equation` uses `\mathalt{...}` immediately before the environment so maintainers can verify that the intended description is still present while `math/alt/use` supplies fallback behavior.

Known limitations:

- Automatic math alternative text may be based on LaTeX source and may not be ideal spoken math.
- Authors still need nearby explanatory prose and variable definitions.
- More polished manual equation descriptions may require future public LaTeX tagging-project support or a tested project-level wrapper.
- PAC, Acrobat, and manual review are still required before making any accessibility, Section 508, WCAG, or PDF/UA claim.

## PDF/UA-2 MathML experiment

Do not switch the default student template to PDF/UA-2 while the active validation target is PDF/UA-1. If maintainers want a future-facing MathML experiment, use a separate test file or temporary branch with a metadata pattern like this:

```tex
\DocumentMetadata{
  tagging=on,
  pdfstandard=ua-2,
  lang=en-US,
  tagging-setup={
    math/setup=mathml-SE
  }
}
```

Treat this as experimental for this project until maintainers choose PDF/UA-2 as the validation target and test the generated PDF with the expected review tools.

## Consultant troubleshooting notes

- If PAC reports Alternative Descriptions failures, inspect whether the failed structure elements are Formula tags.
- Check whether inline math Formula elements have `/Alt`.
- Check whether display-equation descriptions created with `\mathalt{...}` still work.
- If only math Alternative Descriptions failures remain, test `math/alt/use` before attempting PDF-level remediation.
- Do not tell students that a PDF is accessible, Section 508 conforming, WCAG conforming, or PDF/UA compliant unless the complete review process passes.

## Test notes

- Compiler required: LuaLaTeX.
- TeX Live version: not available in the current container because no TeX engine is installed.
- Suggested main build command: `latexmk -lualatex -interaction=nonstopmode -halt-on-error main.tex`.
- Suggested focused fixture build command: `lualatex -interaction=nonstopmode -halt-on-error tests/math-tagging-fixture.tex`.
- PAC was not run in the current Linux container; PAC must be run manually on Windows or another supported environment.
- Alternative Descriptions before this change: user-reported PAC result was 114 passed and 4 failed, with Formula tags suspected.
- Expected targeted result after this change: Alternative Descriptions failures caused only by Formula tags without `/Alt` should drop from 4 to 0.
- Remaining unrelated failures or warnings must be recorded after PAC, Acrobat, and manual review; do not claim PDF/UA compliance from this targeted fix alone.
