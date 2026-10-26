# NDSU disquisition LaTeX template

`main.tex` is the entry point. Keep the class, bibliography and content folders together. This directory is the complete public source bundle.

1. Import the ZIP into Overleaf, or open its extracted contents locally.
2. Select `main.tex` and LuaLaTeX. The bibliography uses Biber.
3. Replace the guide's placeholder metadata and content. The example uses `[draft]`; switch to `[final]` after completing the required fields.
4. Compile until references and generated lists settle, then review the PDF.

The repaired source requires LaTeX 2026-06-01 or newer and its declared packages. Times New Roman is required by default; fonts are not bundled. Overleaf compatibility depends on the selected environment and has not been verified here.

Use `./build.ps1` in PowerShell with LuaLaTeX and Biber on PATH, or:

```sh
latexmk -lualatex -interaction=nonstopmode -halt-on-error main.tex
```

`README.tex` contains the supplied Markdown guide despite its extension; it is not a LaTeX entry point. See [repair notes](REPAIR-NOTES.txt) for author options and validation limits. Developer fixtures mentioned in those documents are kept outside this public bundle and are not needed to compile `main.tex`.

## Current review status

The October 14 revision restores the earlier approval-page appearance and rendered indentation of bulleted/numbered body-list markers while retaining the other supplied source repairs. It preserves co-chair identification, aligned final fields and explicit overflow checks. The full manual review remains pending; a successful build does not establish formatting or accessibility compliance.

For GitHub, extract the ZIP and put its contents at the repository root. No parent-directory files are required. The supplied archive includes no license file; this repackaging does not add licensing terms.

### Keeping listings together

Numbered code listings float like figures and tables when the complete block fits within the text area. Their caption and supplied note travel with them, and subsequent prose can fill space on the preceding page. Listings taller than one page remain in the text flow and can continue across pages. To include a note in the same pagination decision, place `\nextcodelistingnote{Note text}` immediately before `\begin{ndsucodelisting}[Caption]`. Put figure and table notes inside their respective float environments so they travel with the object and caption.

Deferred floats use the body line spacing when calculating their separation from surrounding prose, including floats placed at the top or bottom of a page. Tune the named float-spacing controls in the class rather than inserting manual blank lines.


### Chapter references and whole-document references

Use any combination independently:

- Add `\printchapterreferences` at the end of a chosen chapter file, before the next `\chapter`. It prints that chapter's cited sources under an unnumbered **References** subsection, included in the table of contents. Use `\printchapterreferences[Works Cited]` to change its title.
- Keep `\printreferences` for a whole-document reference section. It includes cited sources from every chapter, even chapters that do not print a local list. A source cited in multiple chapters appears in each relevant local list and only once in the whole-document list.
- Omit either command wherever that list is not wanted. Chapters without a local list need no special handling. A chapter with no cited sources produces no local list.

Example in `main.tex` (the chapter files contain their own `\chapter` commands):

```tex
\input{chapters/chapter-01-introduction.tex}
\printchapterreferences % optional for this chapter
\input{chapters/chapter-02-adding-content.tex}
% no local reference subsection for this chapter
\input{chapters/chapter-03-producing-pdf.tex}
\printchapterreferences % optional for this chapter
% ... remaining chapters and appendices ...
\printreferences        % optional whole-document list
```

The existing sample keeps its whole-document References before the appendices; you may move that command after the appendices if you want it at the very end. Biber includes citations from the complete document regardless of where this command is placed.

Keep the existing `biblatex`/Biber setup and resource declarations. The class starts a citation segment at each ordinary (non-starred) chapter, including appendices, without isolating its bibliography from the document. Do not add separate `refsection` environments or automatic `refsection`/`refsegment` options for this workflow. Unnumbered `\chapter*` headings do not start new citation segments. `\nocite{key}` adds an uncited entry to the current chapter and document lists; `\nocite{*}` requests all entries. Compile with LuaLaTeX, Biber, then LuaLaTeX until references settle (or use `build.ps1`).
