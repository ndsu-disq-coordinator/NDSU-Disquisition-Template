% ndsudisq.cls
% NDSU disquisition class.
% This file controls document structure and formatting.
% Most users should edit main.tex and the content files rather than this class file.
% LAST PATCH 6/15/2026

% --- Class identity and version ---
\NeedsTeXFormat{LaTeX2e}
\newcommand{\ndsudisqversion}{v0.5.15}
\newcommand{\ndsudisqdate}{2026/05/18}
\newcommand{\ndsudisqdesc}{NDSU disquisition class}
\ProvidesClass{ndsudisq}[\ndsudisqdate\space \ndsudisqdesc\space (\ndsudisqversion)]


% --- Options and base class ---
\newif\ifndsu@nonumbered
\ndsu@nonumberedfalse
\newif\ifndsu@debugbookmarks
\ndsu@debugbookmarksfalse
\newif\ifndsu@xitsfonts
\ndsu@xitsfontsfalse
\DeclareOption{nonumbered}{\ndsu@nonumberedtrue}
\DeclareOption{debugbookmarks}{\ndsu@debugbookmarkstrue}
\DeclareOption{equationchapter}{\AtEndOfClass{\equationnumberingbychapter}}
\DeclareOption{equationcontinuous}{\AtEndOfClass{\equationnumberingcontinuous}}
\DeclareOption{xitsfonts}{\ndsu@xitsfontstrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass[12pt,oneside,letterpaper]{report}

% --- Engine requirements and engine/font/language packages ---
\RequirePackage{iftex}
\ifLuaTeX\else
  \ClassError{ndsudisq}{LuaLaTeX is required}{Compile this document with lualatex. XeLaTeX and pdfLaTeX are not supported for the tested tagging and metadata workflow.}%
  \stop
\fi
\RequirePackage{fontspec}
\ifndsu@xitsfonts
  \IfFontExistsTF{XITS}
    {\setmainfont{XITS}}
    {\ClassError{ndsudisq}{The xitsfonts option requires the XITS font}{Install the XITS font family or remove the xitsfonts option.}}
  \RequirePackage{unicode-math}
  \IfFontExistsTF{XITS Math}
    {\setmathfont{XITS Math}}
    {\ClassError{ndsudisq}{The xitsfonts option requires the XITS Math font}{Install XITS Math or remove the xitsfonts option.}}
  \ClassInfo{ndsudisq}{Using XITS/XITS Math font experiment via xitsfonts option}
\else
  \IfFontExistsTF{Times New Roman}
    {\setmainfont{Times New Roman}}
    {%
      \setmainfont{TeX Gyre Termes}%
      \ClassWarningNoLine{ndsudisq}{Times New Roman was not found; using TeX Gyre Termes fallback. Confirm institutional acceptance of this substitute font before submission}%
    }
\fi
\RequirePackage{polyglossia}
\RequirePackage{csquotes}
\RequirePackage{xparse}

% --- Package loading by feature area ---
\RequirePackage[margin=1in]{geometry}
\RequirePackage{setspace}
\RequirePackage{ragged2e}
\RequirePackage{microtype}
\RequirePackage{indentfirst}
\RequirePackage{pdflscape}
\RequirePackage{eso-pic}
\RequirePackage{graphicx}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage{float}
\RequirePackage[section]{placeins}
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{longtable}
\RequirePackage{threeparttable}
\RequirePackage{multirow}
\RequirePackage{titlesec}
\RequirePackage{chngcntr}
\RequirePackage{etoolbox}
\IfFileExists{latex-lab-enumitem.sty}{%
  \RequirePackage{latex-lab-enumitem}%
}{%
  \RequirePackage{enumitem}%
  \ClassWarningNoLine{ndsudisq}{latex-lab-enumitem.sty not found; using enumitem fallback. Tagged list PDFs may need Acrobat L/LI/Lbl/LBody remediation}%
}
\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{fancyvrb}
\RequirePackage{fvextra}
\RequirePackage{listings}
\RequirePackage{needspace}

\makeatletter

% --- Global layout, spacing, counters, language ---
\setmainlanguage[variant=american]{english}
\doublespacing
\setlength{\parindent}{0.5in}
\setlength{\parskip}{0pt}
\newcommand{\ndsu@bodyalignmentsetup}{%
  \setlength{\RaggedRightParindent}{0.5in}%
  \RaggedRight
  \setlength{\parindent}{0.5in}%
  \setlength{\parskip}{0pt}%
}
\ndsu@bodyalignmentsetup
\AtBeginDocument{\ndsu@bodyalignmentsetup}
\setcounter{tocdepth}{3}

% Maintainable list-spacing controls for ordinary semantic lists.
\newlength{\ndsuListTopSep}
\setlength{\ndsuListTopSep}{0.25\baselineskip plus 1pt minus 1pt}
\newlength{\ndsuListItemSep}
\setlength{\ndsuListItemSep}{0pt plus 1pt}
\newlength{\ndsuListParseSep}
\setlength{\ndsuListParseSep}{0pt}
\newlength{\ndsuListPartopSep}
\setlength{\ndsuListPartopSep}{0pt}
\newlength{\ndsuListLeftMargin}
\setlength{\ndsuListLeftMargin}{0.5in}

\newlength{\ndsuItemizeLabelWidth}
\setlength{\ndsuItemizeLabelWidth}{2em}
\newlength{\ndsuItemizeLabelSep}
\setlength{\ndsuItemizeLabelSep}{0.35em}
\newlength{\ndsuItemizeLeftMargin}
\setlength{\ndsuItemizeLeftMargin}{\ndsuListLeftMargin}
\addtolength{\ndsuItemizeLeftMargin}{\ndsuItemizeLabelWidth}
\addtolength{\ndsuItemizeLeftMargin}{\ndsuItemizeLabelSep}

\newlength{\ndsuEnumerateLabelWidth}
\setlength{\ndsuEnumerateLabelWidth}{2em}
\newlength{\ndsuEnumerateLabelSep}
\setlength{\ndsuEnumerateLabelSep}{0.35em}
\newlength{\ndsuEnumerateLeftMargin}
\setlength{\ndsuEnumerateLeftMargin}{\ndsuListLeftMargin}
\addtolength{\ndsuEnumerateLeftMargin}{\ndsuEnumerateLabelWidth}
\addtolength{\ndsuEnumerateLeftMargin}{\ndsuEnumerateLabelSep}

\newcommand{\ndsu@installlistformatting}{%
  \setlist[itemize,1]{%
    labelwidth=\ndsuItemizeLabelWidth,%
    labelsep=\ndsuItemizeLabelSep,%
    leftmargin=\ndsuItemizeLeftMargin,%
    itemindent=0pt,%
    align=left,%
    topsep=\ndsuListTopSep,%
    partopsep=\ndsuListPartopSep,%
    itemsep=\ndsuListItemSep,%
    parsep=\ndsuListParseSep,%
    before={\setlength{\parskip}{0pt}}%
  }%
  \let\ndsu@original@itemize\itemize
  \let\ndsu@original@enditemize\enditemize
  \renewenvironment{itemize}[1][]{%
    \vspace{-1.0\baselineskip}%
    \begin{singlespace}%
    \setlength{\parskip}{0pt}%
    \ifnum\@itemdepth=0
      \ndsu@original@itemize[leftmargin=\ndsuItemizeLeftMargin,topsep=\ndsuListTopSep,partopsep=\ndsuListPartopSep,##1]%
\setlength{\labelwidth}{\ndsuItemizeLabelWidth}%
\setlength{\labelsep}{\ndsuItemizeLabelSep}%
\setlength{\itemindent}{0pt}%
\setlength{\itemsep}{\ndsuListItemSep}%
\setlength{\parsep}{\ndsuListParseSep}%
    \else
      \ndsu@original@itemize[##1]%
    \fi
  }{%
    \ndsu@original@enditemize
    \end{singlespace}%
    \vspace{-0.3\baselineskip}%
  }%
  \@ifpackageloaded{latex-lab-enumitem}{%
  \setlist[enumerate,1]{%
    label-width=\ndsuEnumerateLabelWidth,%
    label-sep=\ndsuEnumerateLabelSep,%
    left-margin=\ndsuEnumerateLeftMargin,%
    item-indent=0pt,%
    label-align=left,%
    begin-vspace=\ndsuListTopSep,%
    begin-extra-vspace=\ndsuListPartopSep,%
    item-vspace=\ndsuListItemSep,%
    para-vspace=\ndsuListParseSep%
  }%
}{%
  \setlist[enumerate,1]{%
    labelwidth=\ndsuEnumerateLabelWidth,%
    labelsep=\ndsuEnumerateLabelSep,%
    leftmargin=\ndsuEnumerateLeftMargin,%
    itemindent=0pt,%
    align=left,%
    topsep=\ndsuListTopSep,%
    partopsep=\ndsuListPartopSep,%
    itemsep=\ndsuListItemSep,%
    parsep=\ndsuListParseSep,%
    before={\setlength{\parskip}{0pt}}%
  }%
}%
  \let\ndsu@original@enumerate\enumerate
  \let\ndsu@original@endenumerate\endenumerate
  \renewenvironment{enumerate}[1][]{%

\vspace{-0.2\baselineskip}%
\begin{doublespace}%
\setlength{\parskip}{0pt}%
    \ifnum\@enumdepth=0
      \ndsu@original@enumerate[leftmargin=\ndsuEnumerateLeftMargin,topsep=\ndsuListTopSep,partopsep=\ndsuListPartopSep,##1]%
      \setlength{\labelwidth}{\ndsuEnumerateLabelWidth}%
      \setlength{\labelsep}{\ndsuEnumerateLabelSep}%
      \setlength{\itemindent}{0pt}%
      \setlength{\itemsep}{\ndsuListItemSep}%
      \setlength{\parsep}{\ndsuListParseSep}%
    \else
      \ndsu@original@enumerate[##1]%
    \fi
  }{%
\ndsu@original@endenumerate
\end{doublespace}%
\vspace{-0.4\baselineskip}%

  }%
  \setlist[description,1]{%
    leftmargin=\ndsuListLeftMargin,%
    topsep=\ndsuListTopSep,%
    partopsep=\ndsuListPartopSep,%
    itemsep=\ndsuListItemSep,%
    parsep=\ndsuListParseSep,%
    before={\setlength{\parskip}{0pt}}%
  }%
  \setlist[itemize,2]{%
    topsep=\ndsuListTopSep,%
    partopsep=0pt,%
    itemsep=\ndsuListItemSep,%
    parsep=0pt,%
    before={\setlength{\parskip}{0pt}}%
  }%
  \setlist[enumerate,2]{%
    topsep=\ndsuListTopSep,%
    partopsep=0pt,%
    itemsep=\ndsuListItemSep,%
    parsep=0pt,%
    before={\setlength{\parskip}{0pt}}%
  }%
  \setlist[description,2]{%
    topsep=\ndsuListTopSep,%
    partopsep=0pt,%
    itemsep=\ndsuListItemSep,%
    parsep=0pt,%
    before={\setlength{\parskip}{0pt}}%
  }%
}
\AtBeginDocument{\ndsu@installlistformatting}

% Maintainable non-text spacing controls.
% Maintainers should tune these named lengths instead of adding manual \vspace
% around individual figures/tables in chapter files.
\newlength{\ndsuFloatTextSkip}
\setlength{\ndsuFloatTextSkip}{10pt plus 2pt minus 2pt}
\newlength{\ndsuFloatFloatSkip}
\setlength{\ndsuFloatFloatSkip}{8pt plus 2pt minus 2pt}
\newlength{\ndsuFigureCaptionSkip}
\setlength{\ndsuFigureCaptionSkip}{0pt}
\newlength{\ndsuTableCaptionSkip}
\setlength{\ndsuTableCaptionSkip}{12pt}
\newlength{\ndsuLongtablePreSkip}
\setlength{\ndsuLongtablePreSkip}{8pt plus 2pt minus 2pt}
\newlength{\ndsuLongtablePostSkip}
\setlength{\ndsuLongtablePostSkip}{8pt plus 2pt minus 2pt}
\newlength{\ndsuFigureNoteSkip}
\setlength{\ndsuFigureNoteSkip}{0pt}
\newlength{\ndsuTableNoteSkip}
\setlength{\ndsuTableNoteSkip}{-14pt}
\newlength{\ndsuNoteAfterSkip}
\setlength{\ndsuNoteAfterSkip}{-6pt}
\newlength{\ndsuSchemaCaptionSkip}
\setlength{\ndsuSchemaCaptionSkip}{6pt plus 1pt minus 1pt}
\setlength{\LTpre}{\ndsuLongtablePreSkip}
\setlength{\LTpost}{\ndsuLongtablePostSkip}
\setlength{\floatsep}{\ndsuFloatFloatSkip}
\setlength{\textfloatsep}{\ndsuFloatTextSkip}
\setlength{\intextsep}{\ndsuFloatTextSkip}
% Keep figures/tables horizontally centered but top-aligned on float-only pages.
\setlength{\@fptop}{0pt}
\setlength{\@fpsep}{\ndsuFloatFloatSkip}
\setlength{\@fpbot}{0pt plus 1fil}

% Displayed math spacing.
% These lengths affect displayed equations and similar math displays.
% They do not control float spacing for figures/tables or list spacing.
\newlength{\ndsu@displayaboveskip}
\setlength{\ndsu@displayaboveskip}{2pt plus 1pt minus 1pt}

\newlength{\ndsu@displaybelowskip}
\setlength{\ndsu@displaybelowskip}{2pt}

\newlength{\ndsu@displayshortaboveskip}
\setlength{\ndsu@displayshortaboveskip}{4pt plus 1pt minus 1pt}

\newlength{\ndsu@displayshortbelowskip}
\setlength{\ndsu@displayshortbelowskip}{4pt plus 2pt minus 2pt}

\AtBeginDocument{%
  \setlength{\abovedisplayskip}{\ndsu@displayaboveskip}%
  \setlength{\belowdisplayskip}{\ndsu@displaybelowskip}%
  \setlength{\abovedisplayshortskip}{\ndsu@displayshortaboveskip}%
  \setlength{\belowdisplayshortskip}{\ndsu@displayshortbelowskip}%
}

% Long/tall equation spacing.
\newlength{\ndsu@longdisplayaboveskip}
\setlength{\ndsu@longdisplayaboveskip}{-4pt}

\newlength{\ndsu@longdisplaybelowskip}
\setlength{\ndsu@longdisplaybelowskip}{0.5\baselineskip}

\NewDocumentEnvironment{longequation}{+b}
  {%
    \par
    \begingroup
    \setlength{\abovedisplayskip}{\ndsu@longdisplayaboveskip}%
    \setlength{\abovedisplayshortskip}{\ndsu@longdisplayaboveskip}%
    \setlength{\belowdisplayskip}{\ndsu@longdisplaybelowskip}%
    \setlength{\belowdisplayshortskip}{\ndsu@longdisplaybelowskip}%
    \begin{equation}
    #1
    \end{equation}%
    \endgroup
  }
  {}

\setlength{\footskip}{0.25in}
\newcommand{\ndsu@pagenumberfont}{\normalfont\normalsize}
\newcommand{\ndsu@pagenumber}{\ndsu@pagenumberfont\thepage}
\def\ps@plain{%
  \let\@mkboth\@gobbletwo%
  \let\@oddhead\@empty%
  \let\@evenhead\@empty%
  \def\@oddfoot{\hfil\ndsu@pagenumber\hfil}%
  \let\@evenfoot\@oddfoot%
}
\pagestyle{plain}

\newif\ifndsu@landscapepage
\newcommand{\ndsu@landscapepagenumber}{%
  \AtPageLowerLeft{%
    \put(\LenToUnit{0.5\paperwidth},\LenToUnit{0.75in}){%
      \makebox(0,0)[c]{\ndsu@pagenumber}%
    }%
  }%
}
\AddToShipoutPictureFG{%
  \ifndsu@landscapepage
    \ndsu@landscapepagenumber
  \fi
}

\NewDocumentEnvironment{ndsulandscape}{}
  {\begin{landscape}\ndsu@landscapepagetrue\pagestyle{empty}\thispagestyle{empty}}
  {\end{landscape}\ndsu@landscapepagefalse\pagestyle{plain}}
\NewDocumentEnvironment{landscapepage}{}
  {\begin{ndsulandscape}}
  {\end{ndsulandscape}}

\newcommand{\ndsu@nohyphenationmode}{%
  \hyphenpenalty=10000\exhyphenpenalty=10000\relax
  \emergencystretch=2em\relax
}
\newcommand{\ndsu@normalhyphenationmode}{%
  \hyphenpenalty=50\exhyphenpenalty=50\relax
  \emergencystretch=0pt\relax
}
\newenvironment{ndsu@nohyphenation}{\ndsu@nohyphenationmode}{%
}

% --- Hyperref/bookmark/metadata setup ---
\RequirePackage{hyperref}
\hypersetup{%
  unicode=true,%
  bookmarks=true,%
  bookmarksopen=true,%
  bookmarksnumbered=true,%
  linktoc=all,%
  pdfdisplaydoctitle=true,%
  hidelinks%
}
\RequirePackage{bookmark}
\newcommand{\ndsu@bookmarktrace}[1]{%
  \ifndsu@debugbookmarks
    \typeout{NDSU TRACE #1}%
  \fi
}
\ifndsu@debugbookmarks
  \typeout{NDSU TRACE BEGIN bookmark diagnostics}
  \typeout{NDSU TRACE meaning addcontentsline = \meaning\addcontentsline}
  \typeout{NDSU TRACE meaning Hy@writebookmark = \meaning\Hy@writebookmark}
  \typeout{NDSU TRACE meaning @chapter = \meaning\@chapter}
  \@ifundefined{NR@chapter}
    {\typeout{NDSU TRACE meaning NR@chapter = UNDEFINED}}
    {\typeout{NDSU TRACE meaning NR@chapter = \meaning\NR@chapter}}
  \@ifundefined{H@old@chapter}
    {\typeout{NDSU TRACE meaning H@old@chapter = UNDEFINED}}
    {\typeout{NDSU TRACE meaning H@old@chapter = \meaning\H@old@chapter}}
  \@ifundefined{Hy@addcontentsline@addbookmark}
    {\typeout{NDSU TRACE meaning Hy@addcontentsline@addbookmark = UNDEFINED}}
    {\typeout{NDSU TRACE meaning Hy@addcontentsline@addbookmark = \meaning\Hy@addcontentsline@addbookmark}}
  \@ifundefined{addcontentslinebookmark}
    {\typeout{NDSU TRACE meaning addcontentslinebookmark = UNDEFINED}}
    {\typeout{NDSU TRACE meaning addcontentslinebookmark = \meaning\addcontentslinebookmark}}

  \let\NDSU@debug@orig@addcontentsline\addcontentsline
  \def\addcontentsline#1#2#3{%
    \typeout{NDSU TRACE addcontentsline ext=[\detokenize{#1}] type=[\detokenize{#2}] text=[\detokenize{#3}]}%
    \NDSU@debug@orig@addcontentsline{#1}{#2}{#3}%
  }%

  \let\NDSU@debug@orig@Hy@writebookmark\Hy@writebookmark
  \def\Hy@writebookmark#1#2#3#4#5{%
    \typeout{NDSU TRACE Hy@writebookmark num=[\detokenize{#1}] text=[\detokenize{#2}] dest=[\detokenize{#3}] level=[\detokenize{#4}] file=[\detokenize{#5}]}%
    \NDSU@debug@orig@Hy@writebookmark{#1}{#2}{#3}{#4}{#5}%
  }%
\fi
\RequirePackage[nameinlink,noabbrev]{cleveref}
\renewcommand{\Hy@numberline}[1]{#1.\space}
\pdfstringdefDisableCommands{%
  \def\numberline#1{#1.\space}%
  \def\ndsu@appendixtocbookmarknumber#1{\ndsu@iflastsingleappendix{APPENDIX}{APPENDIX #1}}%
  \def\ndsu@tocuppercase#1{\MakeUppercase{#1}}%
  \def\textit#1{#1}%
  \def\textbf#1{#1}%
}
\providecommand*{\toclevel@frontmatter}{0}
\providecommand*{\toclevel@prefatory}{0}
\providecommand*{\toclevel@references}{0}
\providecommand*{\toclevel@bibliography}{0}
\providecommand*{\thefrontmatter}{}
\providecommand*{\theprefatory}{}
\providecommand*{\thereferences}{}
\ExplSyntaxOn
\tl_new:N \l_ndsu_title_pdf_bookmark_tl
\cs_new_protected:Npn \ndsu_add_title_pdf_bookmark:
  {
    \tl_set:Nx \l_ndsu_title_pdf_bookmark_tl
      { \text_purify:n { \text_uppercase:n { \ndsutitle } } }
    \pdfbookmark[0]{\tl_use:N \l_ndsu_title_pdf_bookmark_tl}{ndsu-disquisition-title}
  }
\cs_new_eq:NN \NDSUAddTitlePdfBookmark \ndsu_add_title_pdf_bookmark:
\ExplSyntaxOff
\AtBeginDocument{%
  \hypersetup{%
    pdflang={\ndsulanguage},%
    pdftitle={\ndsutitle},%
    pdfauthor={\ndsuauthor},%
    pdfsubject={\ndsusubject},%
    pdfkeywords={\ndsukeywords},%
    pdfcreator={LuaLaTeX with ndsudisq},%
    pdfproducer={LuaLaTeX}%
  }%
}

% --- Public metadata/title/degree commands ---
\newcommand{\ndsutitle}{SAMPLE NDSU DISQUISITION TITLE}
\newcommand{\ndsuauthor}{Student Name}
\newcommand{\ndsudocumenttype}{Dissertation}
\newcommand{\ndsudegree}{DOCTOR OF PHILOSOPHY}
\newcommand{\ndsumajorlabel}{Major Department}
\newcommand{\ndsuprogram}{Program Name}
\newcommand{\ndsudegreeoption}{}
\newcommand{\ndsufinaldefense}{May 2026}
\newcommand{\ndsuapprovaldate}{April 15, 2026}
\newcommand{\ndsudeptchair}{Department Chair Name}
\newcommand{\ndsucommitteechair}{Committee Chair Name}
\newcommand{\ndsucommitteecochair}{}
\newcommand{\ndsucommitteeone}{Committee Member One}
\newcommand{\ndsucommitteetwo}{Committee Member Two}
\newcommand{\ndsucommitteethree}{}
\newcommand{\ndsusubject}{Disquisition submitted to North Dakota State University}
\newcommand{\ndsukeywords}{NDSU, disquisition, thesis, dissertation}
\newcommand{\ndsulanguage}{en-US}

\newcommand{\disquisitiontitle}[1]{\renewcommand{\ndsutitle}{#1}}
\newcommand{\disquisitionauthor}[1]{\renewcommand{\ndsuauthor}{#1}}
\newcommand{\documenttype}[1]{\renewcommand{\ndsudocumenttype}{#1}}
\newcommand{\degree}[1]{\renewcommand{\ndsudegree}{#1}}
\newcommand{\majordepartmentlabel}[1]{\renewcommand{\ndsumajorlabel}{#1}}
\newcommand{\program}[1]{\renewcommand{\ndsuprogram}{#1}}
\newcommand{\degreeoption}[1]{\renewcommand{\ndsudegreeoption}{#1}}
\newcommand{\finaldefense}[1]{\renewcommand{\ndsufinaldefense}{#1}}
\newcommand{\approvaldate}[1]{\renewcommand{\ndsuapprovaldate}{#1}}
\newcommand{\departmentchair}[1]{\renewcommand{\ndsudeptchair}{#1}}
\newcommand{\committeechair}[1]{\renewcommand{\ndsucommitteechair}{#1}}
\newcommand{\committeecochair}[1]{\renewcommand{\ndsucommitteecochair}{#1}}
\newcommand{\committeeone}[1]{\renewcommand{\ndsucommitteeone}{#1}}
\newcommand{\committeetwo}[1]{\renewcommand{\ndsucommitteetwo}{#1}}
\newcommand{\committeethree}[1]{\renewcommand{\ndsucommitteethree}{#1}}
\newcommand{\ndsu@additionalcommittee}{}
\newcommand{\additionalcommitteemember}[1]{\listgadd{\ndsu@additionalcommittee}{#1}}
\newcommand{\subjectinfo}[1]{\renewcommand{\ndsusubject}{#1}}
\newcommand{\keywordsinfo}[1]{\renewcommand{\ndsukeywords}{#1}}
\newcommand{\disquisitionlanguage}[1]{\renewcommand{\ndsulanguage}{#1}}

% --- Front-matter inclusion switches ---
\newif\ifndsu@includeDedication
\newif\ifndsu@includeListOfTables
\newif\ifndsu@includeListOfFigures
\newif\ifndsu@includeListOfEquations
\newif\ifndsu@includeListOfSchemas
\newif\ifndsu@includeAbbreviations
\newif\ifndsu@includeSymbols
\newif\ifndsu@includeAppendixTables
\newif\ifndsu@includeAppendixFigures
\newif\ifndsu@includePreface
\ndsu@includeDedicationfalse
\ndsu@includeListOfTablesfalse
\ndsu@includeListOfFiguresfalse
\ndsu@includeListOfEquationsfalse
\ndsu@includeListOfSchemasfalse
\ndsu@includeAbbreviationsfalse
\ndsu@includeSymbolsfalse
\ndsu@includeAppendixTablesfalse
\ndsu@includeAppendixFiguresfalse
\ndsu@includePrefacefalse
\newcommand{\includededication}{\ndsu@includeDedicationtrue}
\newcommand{\includelistoftables}{\ndsu@includeListOfTablestrue}
\newcommand{\includelistoffigures}{\ndsu@includeListOfFigurestrue}
\newcommand{\includelistofequations}{\ndsu@includeListOfEquationstrue}
\newcommand{\includelistofschemas}{\ndsu@includeListOfSchemastrue}
\newcommand{\includetableofequations}{\includelistofequations}
\newcommand{\includeabbreviations}{\ndsu@includeAbbreviationstrue}
\newcommand{\includesymbols}{\ndsu@includeSymbolstrue}
\newcommand{\includeappendixtables}{%
  \ndsu@includeAppendixTablestrue
  \ClassWarning{ndsudisq}{\string\includeappendixtables\space is reserved for appendix tables front matter, but is not yet implemented.\MessageBreak
    It sets a compatibility flag only and does not add content to the front matter}%
}
\newcommand{\includeappendixfigures}{%
  \ndsu@includeAppendixFigurestrue
  \ClassWarning{ndsudisq}{\string\includeappendixfigures\space is reserved for appendix figures front matter, but is not yet implemented.\MessageBreak
    It sets a compatibility flag only and does not add content to the front matter}%
}
\newcommand{\includepreface}{\ndsu@includePrefacetrue}

% --- Heading numbering, visual formatting, and appendix headings ---
\setcounter{secnumdepth}{3}
\renewcommand{\thechapter}{\arabic{chapter}}
\renewcommand{\thesection}{\thechapter.\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\newcommand{\ndsu@subheadingneedspace}{\Needspace{4\baselineskip}}
\ifndsu@nonumbered
  \setcounter{secnumdepth}{0}
  \titleformat{\chapter}[block]
    {\normalfont\bfseries\centering}
    {CHAPTER \thechapter:\ }
    {0pt}
    {\MakeUppercase}
  \titleformat{\section}[block]
    {\normalfont\bfseries\filcenter}
    {}
    {0pt}
    {}
  \titleformat{\subsection}[block]
    {\normalfont\bfseries}
    {}
    {0pt}
    {}
\else
  \titleformat{\chapter}[block]
    {\normalfont\bfseries\centering}
    {\thechapter.\ }
    {0pt}
    {\MakeUppercase}
  \titleformat{\section}[block]
    {\normalfont\bfseries\filcenter}
    {\thesection.\ }
    {0pt}
    {}
  \titleformat{\subsection}[block]
    {\normalfont\bfseries}
    {\thesubsection.\ }
    {0pt}
    {}
\fi
\titleformat{\subsubsection}[block]
  {\normalfont\bfseries\itshape}
  {\thesubsubsection.\ }
  {0pt}
  {}
\titleformat{\paragraph}[block]
  {\normalfont\itshape}
  {}
  {0pt}
  {}
\titleformat{\subparagraph}[block]
  {\normalfont\itshape}
  {}
  {0pt}
  {}
\titlespacing{\chapter}{0pt}{-30pt}{0pt}
\titlespacing{\section}{0pt}{0pt}{0pt}
\titlespacing{\subsection}{0pt}{0pt}{0pt}
\titlespacing{\subsubsection}{0pt}{0pt}{0pt}
\titlespacing{\paragraph}{0pt}{0pt}{0pt}
\titlespacing{\subparagraph}{0pt}{0pt}{0pt}
% Current tagged-PDF LaTeX builds install heading templates that bypass
% titlesec for chapter headings. Mirror the chapter format there when present.
\ExplSyntaxOn
\cs_new_protected:Npn \ndsu_install_lab_chapter_heading:n #1
  {
    \IfInstanceExistsTF { heading } { chapter }
      {
        \DeclareInstance { headformat } { ndsu-chapter } { hang }
          {
            heading-indent = 0pt,
            number-title-sep = 0pt,
            title-format = \MakeUppercase {##1}
          }
        \DeclareInstance { heading } { chapter } { display }
          {
            name = chapter,
            level = 0,
            placement = top,
            after-penalty-vspace = 0pt,
            after-vspace = 0pt,
            para-indent = true,
            number-format = #1,
            heading-decls = \normalfont \bfseries \centering,
            headformat-instance = ndsu-chapter,
            mark-cmd = \chaptermark {##1},
            contents-extra =
              \addtocontents { lof } { \protect \addvspace { 10pt } }
              \addtocontents { lot } { \protect \addvspace { 10pt } }
          }
      }
      { }
  }
\cs_new_protected:Npn \ndsu_install_standard_lab_chapter_heading:
  {
    \ifndsu@nonumbered
      \ndsu_install_lab_chapter_heading:n { CHAPTER~\thechapter:\space }
    \else
      \ndsu_install_lab_chapter_heading:n { \thechapter.\space }
    \fi
  }
\cs_new_protected:Npn \ndsu_install_appendix_lab_chapter_heading:
  {
    \ndsu_install_lab_chapter_heading:n { \ndsu@appendixchapterlabel }
  }
\cs_gset_eq:NN \ndsu@installstandardlabchapterheading
  \ndsu_install_standard_lab_chapter_heading:
\cs_gset_eq:NN \ndsu@installappendixlabchapterheading
  \ndsu_install_appendix_lab_chapter_heading:
\ExplSyntaxOff
\ndsu@installstandardlabchapterheading
\pretocmd{\section}{\ndsu@subheadingneedspace}{}{}
\pretocmd{\subsection}{\ndsu@subheadingneedspace}{}{}
\pretocmd{\subsubsection}{\ndsu@subheadingneedspace}{}{}
\pretocmd{\paragraph}{\ndsu@subheadingneedspace}{}{}
\pretocmd{\subparagraph}{\ndsu@subheadingneedspace}{}{}
\let\cleardoublepage\clearpage
\pretocmd{\chapter}{\clearpage}{}{}
\newif\ifndsu@appendices
\ndsu@appendicesfalse
\newcounter{ndsu@appendixchapters}
\newcommand{\ndsu@lastappendixchapters}{0}
\newcommand{\ndsu@setappendixchapters}[1]{\gdef\ndsu@lastappendixchapters{#1}}
\newcommand{\ndsu@iflastsingleappendix}[2]{%
  \ifnum\ndsu@lastappendixchapters=1\relax
    #1%
  \else
    #2%
  \fi
}
\newcommand{\ndsu@appendixchapterlabel}{%
  \ndsu@iflastsingleappendix
    {APPENDIX.\space}%
    {APPENDIX~\thechapter.\space}%
}
\newcommand{\ndsu@appendixbookmarkchapterlabel}{%
  \ndsu@iflastsingleappendix
    {APPENDIX}%
    {APPENDIX~\ndsu@saved@thechapter}%
}
\newcommand{\ndsu@appendixtocbookmarknumber}[1]{#1}
\newcommand{\ndsu@appendixbookmarksetup}{%
  \let\ndsu@saved@thechapter\thechapter
  \renewcommand{\thechapter}{\texorpdfstring{\ndsu@saved@thechapter}{\ndsu@appendixbookmarkchapterlabel}}%
}
\newcommand{\ndsu@appendixbookmarkrestore}{%
  \let\thechapter\ndsu@saved@thechapter
  \protected@edef\@currentlabel{\csname p@chapter\endcsname\thechapter}%
}
\let\ndsu@standard@appendix\appendix
\newcommand{\appendicesmatter}{%
  \ifndsu@appendices
  \else
    \clearpage
    \ndsu@appendicestrue
    \setcounter{ndsu@appendixchapters}{0}%
    \ndsu@standard@appendix
    \titleformat{\chapter}[block]{\normalfont\bfseries\centering}{\ndsu@appendixchapterlabel}{0pt}{\MakeUppercase}%
  \fi
}
\renewcommand{\appendix}{\appendicesmatter}
\pretocmd{\@chapter}{%
  \ifndsu@appendices
    \stepcounter{ndsu@appendixchapters}%
    \ndsu@appendixbookmarksetup
  \fi
}{}{}
\apptocmd{\@chapter}{%
  \ifndsu@appendices
    \ndsu@appendixbookmarkrestore
  \fi
}{}{}
\AtEndDocument{%
  \if@filesw
    \immediate\write\@auxout{\string\ndsu@setappendixchapters{\arabic{ndsu@appendixchapters}}}%
  \fi
  \ifndsu@appendices
    \ifnum\value{ndsu@appendixchapters}=\ndsu@lastappendixchapters\relax
    \else
      \ClassWarningNoLine{ndsudisq}{Appendix count changed from \ndsu@lastappendixchapters\space to \arabic{ndsu@appendixchapters}; rerun LuaLaTeX so appendix headings, TOC entries, and bookmarks settle}%
    \fi
  \fi
}

% --- Caption, figure, decorative-image, and artifact helpers ---

\DeclareCaptionLabelSeparator{ndsuboldperiod}{\textbf{.}\space}
\newcommand{\ndsu@periodcaptionlabels}{%
  \captionsetup{labelsep=period}%
  \captionsetup[figure]{labelsep=period}%
  \captionsetup[table]{labelsep=ndsuboldperiod}%
  \captionsetup[longtable]{labelsep=ndsuboldperiod}%
}

\newcommand{\ndsu@captionalignmentsetup}{%
  \captionsetup[figure]{%
    justification=raggedright,%
    singlelinecheck=false,%
    margin=0pt,%
    indention=0pt,%
    parindent=0pt,%
    skip=\ndsuFigureCaptionSkip%
  }%
    \captionsetup[table]{%
        justification=raggedright,%
        singlelinecheck=false,%
        margin=0pt,%
        width=\textwidth,%
        indention=0pt,%
        parindent=0pt,%
        skip=\ndsuTableCaptionSkip%
}%
    
  \captionsetup[longtable]{%
  justification=raggedright,%
  singlelinecheck=false,%
  margin=0pt,%
  indention=0pt,%
  parindent=0pt,%
  skip=0pt%
}%
}
\long\def\ndsu@makeleftcaption#1#2{%
  \def\ndsu@tempcaptype{figure}%
  \ifx\@captype\ndsu@tempcaptype\vspace{-\baselineskip}\fi
  \begingroup
    \singlespacing\normalfont\normalsize\upshape\raggedright
    \setlength{\parindent}{0pt}%
    \setlength{\parskip}{0pt}%
    \noindent{\bfseries #1.}\space #2\par
  \endgroup
}


\newcommand{\ndsu@captionlabelsocketsetup}{%
  \@ifundefined{IfSocketExistsTF}{}{%
    \IfSocketExistsTF{caption/label}{%
      \IfSocketPlugExistsTF{caption/label}{ndsu-period}{}{%
        \NewSocketPlug{caption/label}{ndsu-period}{{\bfseries ##1.}\space}%
      }%
      \AssignSocketPlug{caption/label}{ndsu-period}%
    }{}%
  }%
}
\captionsetup{%
  format=plain,%
  labelsep=period,%
  font=normalsize,%
  labelfont=bf,%
  textfont=normalfont,%
  skip=\ndsuFigureCaptionSkip%
}

% Default placement for ordinary LaTeX floats.
% This does not force exact placement; it only allows LaTeX to try "here".


\def\fps@figure{!htbp}
\def\fps@table{!htbp}
\AtBeginDocument{%
  \ndsu@periodcaptionlabels
  \ndsu@captionalignmentsetup
  \ndsu@captionlabelsocketsetup
  \let\@makecaption\ndsu@makeleftcaption
}
% --- Counter policy for captions and float-like lists ---
% Equations are controlled separately below with \numberwithin from amsmath.
% Figures, tables, schemas, and listings use the chngcntr-provided
% \counterwithin/\counterwithout helpers loaded above. Longtable uses LaTeX's
% table counter, so table policy changes automatically apply to longtable
% captions and List of Tables entries. Schema and listing counters are created
% later by \newfloat; the public switches are used after class loading, when
% those counters exist.
\newif\ifndsu@chaptercaptions \ndsu@chaptercaptionstrue
\newcommand{\ndsu@counterwithinchapter}[1]{%
  \counterwithout{#1}{chapter}%
  \counterwithin{#1}{chapter}%
}
\newcommand{\usechaptercaptions}{%
  \ndsu@chaptercaptionstrue
  \ndsu@counterwithinchapter{table}%
  \ndsu@counterwithinchapter{figure}%
  \ndsu@counterwithinchapter{schema}%
  \ndsu@counterwithinchapter{listing}%
}
\newcommand{\usecontinuouscaptions}{%
  \ndsu@chaptercaptionsfalse
  \counterwithout{table}{chapter}%
  \counterwithout{figure}{chapter}%
  \counterwithout{schema}{chapter}%
  \counterwithout{listing}{chapter}%
  \renewcommand{\thetable}{\arabic{table}}%
  \renewcommand{\thefigure}{\arabic{figure}}%
  \renewcommand{\theschema}{\arabic{schema}}%
  \renewcommand{\thelisting}{\arabic{listing}}%
}

\newcommand{\ndsunoteprefix}{Note:}
\newcommand{\ndsunoteprefixstyle}[1]{\renewcommand{\ndsunoteprefix}{#1}}
\NewDocumentCommand{\ndsunote}{ O{\ndsuFigureNoteSkip} m }{%
  \par\vspace{#1}%
  \begingroup
    \singlespacing\normalfont\normalsize\upshape\raggedright%
    \noindent\textbf{\ndsunoteprefix}~#2\par%
  \endgroup
  \vspace{\ndsuNoteAfterSkip}%
}
\NewDocumentCommand{\ndsucenterednote}{ O{\ndsuFigureNoteSkip} m }{%
  \par\nointerlineskip\vspace{#1}%
  \begingroup
    \singlespacing\normalfont\normalsize\upshape\raggedright%
    \textbf{\ndsunoteprefix}~#2\par%
  \endgroup
  \vspace{\ndsuNoteAfterSkip}%
}
\@ifundefined{note}
  {\NewDocumentCommand{\note}{ m }{\ndsunote{#1}}}
  {\RenewDocumentCommand{\note}{ m }{\ndsunote{#1}}}
\newcommand{\ndsufigurenote}[1]{\ndsucenterednote[\ndsuFigureNoteSkip]{#1}}
\newcommand{\ndsutablenote}[1]{\ndsunote[\ndsuTableNoteSkip]{#1}}
\newcommand{\ndsuschemanote}[1]{\ndsunote[\ndsuFigureNoteSkip]{#1}}

\NewDocumentCommand{\ndsuincludegraphics}{ O{} m m }{\includegraphics[alt={#2},#1]{#3}}

\ExplSyntaxOn
\tl_new:N \l_ndsu_figure_placement_tl
\tl_new:N \l_ndsu_figure_graphics_tl
\tl_new:N \l_ndsu_figure_note_tl
\tl_new:N \l_ndsu_figure_label_tl
\keys_define:nn { ndsu / figure }
  {
    placement .tl_set:N = \l_ndsu_figure_placement_tl,
    placement .initial:n = htbp,
    graphics .tl_set:N = \l_ndsu_figure_graphics_tl,
    graphics .initial:n = ,
    note .tl_set:N = \l_ndsu_figure_note_tl,
    note .initial:n = ,
    label .tl_set:N = \l_ndsu_figure_label_tl,
    label .initial:n =
  }
\NewDocumentCommand{\ndsufigure}{ O{} m m m }
  {
    \group_begin:
      \keys_set:nn { ndsu / figure } { placement=htbp, graphics={}, note={}, label={}, #1 }
      \begin{figure}[\l_ndsu_figure_placement_tl]
      \centering
      \ndsuincludegraphics[\l_ndsu_figure_graphics_tl]{#4}{#2}
      \caption{#3}
      \tl_if_blank:NF \l_ndsu_figure_label_tl { \exp_args:NV \label \l_ndsu_figure_label_tl }
      \tl_if_blank:NF \l_ndsu_figure_note_tl { \ndsufigurenote{\l_ndsu_figure_note_tl} }
      \end{figure}
    \group_end:
  }
\ExplSyntaxOff

\NewDocumentEnvironment{ndsunumberedfigure}{ O{} m }
  {%
    \captionsetup{type=figure}%
    \centering
    \captionof{figure}{#2}%
    \IfNoValueF{#1}{\label{#1}}%
  }
  {}

\NewDocumentCommand{\ndsudecorativegraphic}{ O{} m }{\includegraphics[artifact,#1]{#2}}
\NewDocumentCommand{\ndsudecorativeimage}{ O{} m }{\ndsudecorativegraphic[#1]{#2}}

\newcommand{\ndsu@artifactbegin}{\@ifundefined{tagmcbegin}{}{\tagmcbegin{artifact}}}
\newcommand{\ndsu@artifactend}{\@ifundefined{tagmcend}{}{\tagmcend}}
\NewDocumentEnvironment{ndsuartifact}{}{\ndsu@artifactbegin}{\ndsu@artifactend}
\NewDocumentCommand{\ndsuartifactcontent}{ m }{\ndsu@artifactbegin#1\ndsu@artifactend}

% Source-level placeholder for legacy/manual figure descriptions.
% TODO: Remove or replace this no-op if a future tagging workflow can safely
% attach descriptions entered separately from the image-inclusion command.
\NewDocumentCommand{\ndsufigurealt}{ m }{}

% Keep longtable body text single spaced, matching ordinary tables.
% Make longtables use landscape pages by default.
\newif\ifndsu@landscapelongtables
\ndsu@landscapelongtablestrue
\newif\ifndsu@longtableopenedlandscape

\newcommand{\uselandscapelongtables}{\ndsu@landscapelongtablestrue}
\newcommand{\useportraitlongtables}{\ndsu@landscapelongtablesfalse}

\newcommand{\ndsu@landscapelongtablesetup}{%
  \setstretch{1}\selectfont
  \small
  \setlength{\tabcolsep}{3pt}%
  \renewcommand{\arraystretch}{0.9}%
  \setlength{\LTleft}{0pt}%
  \setlength{\LTright}{0pt}%
  \setlength{\LTcapwidth}{\linewidth}%
}

\BeforeBeginEnvironment{longtable}{%
  \ifndsu@landscapelongtables
    \ifndsu@landscapepage
      \global\ndsu@longtableopenedlandscapefalse
      \begingroup
    \else
      \global\ndsu@longtableopenedlandscapetrue
      \begin{landscapepage}%
      \begingroup
    \fi
    \ndsu@landscapelongtablesetup
  \fi
}

\AfterEndEnvironment{longtable}{%
  \ifndsu@landscapelongtables
    \endgroup
    \ifndsu@longtableopenedlandscape
      \end{landscapepage}%
      \global\ndsu@longtableopenedlandscapefalse
    \fi
  \fi
}

% --- Table helpers ---
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}p{#1}}
\newcommand{\ndsu@tagpdfsetup}[1]{%
  \@ifundefined{tagpdfsetup}{%
    \ClassWarning{ndsudisq}{LaTeX tagpdf setup is unavailable; table accessibility hint `#1' was ignored}%
  }{\tagpdfsetup{#1}}%
}

\newcommand{\ndsutableheaders}[1]{\ndsu@tagpdfsetup{table/header-rows={#1}}}
\newcommand{\ndsutablepresentation}{\ndsu@tagpdfsetup{table/tagging=presentation}}
\ExplSyntaxOn
\keys_define:nn { ndsu / datatable }
  {
    headers .code:n = { \ndsutableheaders{#1} },
    presentation .code:n = { \ndsutablepresentation },
    presentation .default:n = true
  }
\NewDocumentEnvironment{ndsudatatable}{ O{} }
  {%
    \par\vspace{-0.75\baselineskip}%
    \begingroup
    \keys_set:nn { ndsu / datatable } { #1 }%
    \singlespacing\selectfont
  }
  {%
    \endgroup
  }
\ExplSyntaxOff

% --- Schema helpers ---
\floatstyle{plain}
\newfloat{schema}{htbp}{los}
\floatname{schema}{Schema}
\captionsetup[schema]{justification=raggedright,singlelinecheck=false,skip=\ndsuSchemaCaptionSkip}
\AtBeginDocument{\captionsetup[schema]{justification=raggedright,singlelinecheck=false,skip=\ndsuSchemaCaptionSkip}}
\newcommand{\listschemaname}{LIST OF SCHEMAS}

% --- Math and equation-list helpers ---
\ExplSyntaxOn
\tl_new:N \g_ndsu_math_alt_pending_tl
\tl_new:N \g_ndsu_math_alt_saved_template_tl
\bool_new:N \g_ndsu_math_alt_pending_bool
\bool_new:N \g_ndsu_math_alt_active_bool
\bool_new:N \g_ndsu_math_alt_saved_use_bool
\bool_new:N \g_ndsu_math_alt_warned_bool
\msg_new:nnn { ndsudisq } { math-alt-unavailable }
  {
    Formula~alternative~text~was~stored~in~the~source~but~could~not~be~embedded~in~the~PDF.\MessageBreak
    Use~a~current~LaTeX/LuaLaTeX~tagged-PDF~build~with~math~tagging~enabled.
  }
\msg_new:nnn { ndsudisq } { math-alt-unused }
  {
    \string\mathalt\space was~used,~but~no~supported~display~math~environment~followed~it.
  }
\cs_new_protected:Npn \ndsu_math_alt_warn_unavailable:
  {
    \bool_if:NF \g_ndsu_math_alt_warned_bool
      {
        \msg_warning:nn { ndsudisq } { math-alt-unavailable }
        \bool_gset_true:N \g_ndsu_math_alt_warned_bool
      }
  }
\NewDocumentCommand{\mathalt}{ m }
  {
    \tl_gset:Nn \g_ndsu_math_alt_pending_tl {#1}
    \bool_gset_true:N \g_ndsu_math_alt_pending_bool
  }
\cs_new_protected:Npn \ndsu_math_alt_begin:
  {
    \bool_if:NT \g_ndsu_math_alt_pending_bool
      {
        \cs_if_exist:NTF \l__tag_math_alt_bool
          {
            \tl_if_exist:NTF \l__math_content_template_tl
              {
                \bool_if:NTF \l__tag_math_alt_bool
                  { \bool_gset_true:N \g_ndsu_math_alt_saved_use_bool }
                  { \bool_gset_false:N \g_ndsu_math_alt_saved_use_bool }
                \tl_gset_eq:NN \g_ndsu_math_alt_saved_template_tl \l__math_content_template_tl
                \bool_set_true:N \l__tag_math_alt_bool
                \tl_set_eq:NN \l__math_content_template_tl \g_ndsu_math_alt_pending_tl
                \bool_gset_true:N \g_ndsu_math_alt_active_bool
              }
              { \ndsu_math_alt_warn_unavailable: }
          }
          { \ndsu_math_alt_warn_unavailable: }
        \bool_gset_false:N \g_ndsu_math_alt_pending_bool
        \tl_gclear:N \g_ndsu_math_alt_pending_tl
      }
  }
\cs_new_protected:Npn \ndsu_math_alt_end:
  {
    \bool_if:NT \g_ndsu_math_alt_active_bool
      {
        \cs_if_exist:NT \l__tag_math_alt_bool
          { \bool_set_eq:NN \l__tag_math_alt_bool \g_ndsu_math_alt_saved_use_bool }
        \tl_if_exist:NT \l__math_content_template_tl
          { \tl_set_eq:NN \l__math_content_template_tl \g_ndsu_math_alt_saved_template_tl }
        \bool_gset_false:N \g_ndsu_math_alt_active_bool
      }
  }
\cs_new_protected:Npn \ndsu_math_alt_install_env:n #1
  {
    \BeforeBeginEnvironment{#1}{\ndsu_math_alt_begin:}
    \AfterEndEnvironment{#1}{\ndsu_math_alt_end:}
  }
\clist_map_inline:nn
  { equation,equation*,align,align*,alignat,alignat*,gather,gather*,multline,multline*,flalign,flalign*,displaymath }
  { \ndsu_math_alt_install_env:n {#1} }
\AtEndDocument
  {
    \bool_if:NT \g_ndsu_math_alt_pending_bool
      { \msg_warning:nn { ndsudisq } { math-alt-unused } }
  }
\ExplSyntaxOff
\newif\ifndsu@equationbychapter \ndsu@equationbychaptertrue
\newcommand{\equationnumberingbychapter}{\ndsu@equationbychaptertrue\numberwithin{equation}{chapter}}
\newcommand{\equationnumberingcontinuous}{\ndsu@equationbychapterfalse\counterwithout{equation}{chapter}\renewcommand{\theequation}{\arabic{equation}}}
\newcommand{\ndsu@pendingequationlistentry}{}
\newcommand{\equationlistentry}[1]{\gdef\ndsu@pendingequationlistentry{#1}}
\newcommand{\ndsu@addequationtolist}{%
  \begingroup
    \ifstrempty{\ndsu@pendingequationlistentry}
      {\def\ndsu@equationlisttext{Equation}}
      {\let\ndsu@equationlisttext\ndsu@pendingequationlistentry}%
    \addcontentsline{loe}{equation}{\protect\numberline{\theequation}\ndsu@equationlisttext}%
  \endgroup
  \global\let\ndsu@pendingequationlistentry\@empty
}


% --- TOC/list rendering ---
\renewcommand{\contentsname}{TABLE OF CONTENTS}
\renewcommand{\listtablename}{LIST OF TABLES}
\renewcommand{\listfigurename}{LIST OF FIGURES}
\newcommand{\listequationname}{LIST OF EQUATIONS}
\AtBeginDocument{%
  \renewcommand{\contentsname}{TABLE OF CONTENTS}%
  \renewcommand{\listtablename}{LIST OF TABLES}%
  \renewcommand{\listfigurename}{LIST OF FIGURES}%
}
\DeclareRobustCommand{\ndsu@tocuppercase}[1]{\MakeUppercase{#1}}

\ExplSyntaxOn
\cs_new_protected:Npn \ndsu_toc_chapter_number_format:n #1
  {
    \regex_match:nnTF { \A [0-9]+ \Z } {#1}
      {
        \ifndsu@nonumbered
          CHAPTER~#1:\c_space_token
        \else
          #1.\c_space_token
        \fi
      }
      {
        \ndsu@iflastsingleappendix
          { APPENDIX.\c_space_token }
          { APPENDIX~#1.\c_space_token }
      }
  }

\NewDocumentCommand{\ndsu@tocchapternumberline}{m}
  { \ndsu_toc_chapter_number_format:n {#1} }
\ExplSyntaxOff

\newcommand{\ndsu@tocnumberline}[1]{#1.\ }
\newcommand{\ndsu@floatlistnumberline}[1]{\hb@xt@\@tempdima{\normalfont #1.\hfil}}

\newlength{\ndsu@tocpagenumgap}
\setlength{\ndsu@tocpagenumgap}{0.25em}
\newlength{\ndsu@tocpagenumreserve}
\setlength{\ndsu@tocpagenumreserve}{0.5em}
\newlength{\ndsu@tocwrapreserve}
\setlength{\ndsu@tocwrapreserve}{0.5in}
\newlength{\ndsu@tocrightmargin}
\newcommand{\ndsu@settoclinewidths}[1]{%
  \settowidth{\@tempdimb}{\normalfont #1}%
  \advance\@tempdimb by \ndsu@tocpagenumgap%
  \edef\@pnumwidth{\the\@tempdimb}%
  \setlength{\ndsu@tocrightmargin}{\ndsu@tocwrapreserve}%
  \advance\@tempdimb by \ndsu@tocpagenumreserve%
  \ifdim\ndsu@tocrightmargin<\@tempdimb
    \setlength{\ndsu@tocrightmargin}{\@tempdimb}%
  \fi
  \edef\@tocrmarg{\the\ndsu@tocrightmargin}%
}
\newcommand{\ndsu@dottedfloatline}[2]{\@dottedtocline{1}{0pt}{2.5em}{\normalfont #1}{\normalfont #2}}
\newcommand{\ndsu@dottedtableline}[2]{\@dottedtocline{1}{0pt}{2.5em}{\normalfont #1}{\normalfont #2}}
\newcommand{\ndsu@dottedequationline}[2]{\@dottedtocline{1}{0pt}{2.5em}{\normalfont #1}{\normalfont #2}}
\newcommand{\ndsu@dottedschemaline}[2]{\@dottedtocline{1}{0pt}{2.5em}{\normalfont #1}{\normalfont #2}}

\newcommand{\ndsu@tocchapterentry}[1]{%
  \ndsu@tocchapterentry@start#1\ndsu@toc@end
}

\def\ndsu@tocchapterentry@start{%
  \@ifnextchar\numberline
    {\ndsu@tocchapterentry@numbered}
    {\ndsu@tocchapterentry@unnumbered}%
}

\def\ndsu@tocchapterentry@numbered\numberline#1#2\ndsu@toc@end{%
  \numberline{#1}\ndsu@tocuppercase{#2}%
}

\def\ndsu@tocchapterentry@unnumbered#1\ndsu@toc@end{%
  \ndsu@tocuppercase{#1}%
}

\ExplSyntaxOn
\tl_new:N \l_ndsu_chapter_toc_title_tl
\tl_new:N \l_ndsu_chapter_pdf_title_tl
\tl_new:N \l_ndsu_chapter_toc_entry_tl
\cs_new_protected:Npn \ndsu_add_chapter_toc_bookmark_uppercase_title:n #1
  {
    \tl_set:Nx \l_ndsu_chapter_toc_title_tl
      { \text_uppercase:n {#1} }
    \tl_set:Nx \l_ndsu_chapter_pdf_title_tl
      { \text_purify:n { \text_uppercase:n {#1} } }
    \ifndsu@appendices
      \tl_set:Nx \l_ndsu_chapter_toc_entry_tl
        {
          \exp_not:N \protect
          \exp_not:N \numberline
            {
              \exp_not:N \protect
              \exp_not:N \ndsu@appendixtocbookmarknumber
                { \ndsu@saved@thechapter }
            }
          \exp_not:N \texorpdfstring
            { \exp_not:V \l_ndsu_chapter_toc_title_tl }
            { \exp_not:V \l_ndsu_chapter_pdf_title_tl }
        }
    \else
      \tl_set:Nx \l_ndsu_chapter_toc_entry_tl
        {
          \exp_not:N \protect
          \exp_not:N \numberline { \thechapter }
          \exp_not:N \texorpdfstring
            { \exp_not:V \l_ndsu_chapter_toc_title_tl }
            { \exp_not:V \l_ndsu_chapter_pdf_title_tl }
        }
    \fi
    \exp_args:NnnV \addcontentsline
      { toc }
      { chapter }
      \l_ndsu_chapter_toc_entry_tl
  }
\cs_new_eq:NN \NDSUAddChapterTocBookmarkUppercaseTitle
  \ndsu_add_chapter_toc_bookmark_uppercase_title:n
\cs_new_eq:NN \NDSUAddNumberedChapterTocBookmark
  \ndsu_add_chapter_toc_bookmark_uppercase_title:n
\ExplSyntaxOff
\ifcsname NR@chapter\endcsname
  \patchcmd{\NR@chapter}
    {\addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}}%
    {\NDSUAddChapterTocBookmarkUppercaseTitle{#1}}%
    {\ndsu@bookmarktrace{patch NR@chapter addcontentsline SUCCEEDED}}%
    {\ClassWarningNoLine{ndsudisq}{NDSU TRACE patch NR@chapter addcontentsline FAILED}}%
\else
  \ClassWarningNoLine{ndsudisq}{NDSU TRACE NR@chapter is undefined; chapter bookmark capitalization patch was not applied}%
\fi

\newlength{\ndsuGeneratedListEntrySkip}
\setlength{\ndsuGeneratedListEntrySkip}{0.5\baselineskip plus 1pt minus 1pt}
\newcommand{\ndsu@tocentryspace}{\ndsuGeneratedListEntrySkip}
\newcommand{\ndsu@rendertocentry}[4]{%
  \begingroup
    \setstretch{1}\selectfont
    \let\numberline#2%
    \ndsu@settoclinewidths{#4}%
    #1{#3}{#4}%
    \addvspace{\ndsu@tocentryspace}%
  \endgroup
}

\let\ndsu@standard@l@chapter\l@chapter
\let\ndsu@standard@l@figure\l@figure
\let\ndsu@standard@l@table\l@table

\providecommand{\@contentsline@destination}{}
\newcommand{\ndsu@contentslinehook}[4]{%
  \ifx\UseHookWithArguments\@undefined
  \else
    \UseHookWithArguments{#1}{4}{#2}{#3}{#4}{\@contentsline@destination}%
  \fi
}
\newcommand{\ndsu@contentslinetextbefore}[3]{\ndsu@contentslinehook{contentsline/text/before}{#1}{#2}{#3}}
\newcommand{\ndsu@contentslinetextafter}[3]{\ndsu@contentslinehook{contentsline/text/after}{#1}{#2}{#3}}
\newcommand{\ndsu@contentslinepagebefore}[3]{\ndsu@contentslinehook{contentsline/page/before}{#1}{#2}{#3}}
\newcommand{\ndsu@contentslinepageafter}[3]{\ndsu@contentslinehook{contentsline/page/after}{#1}{#2}{#3}}
\newcommand{\ndsu@dottedtoclineflushwrap}[5]{%
  \ifnum #1>\c@tocdepth \else
    \vskip \z@ \@plus.2\p@
    {\leftskip #2\relax
     \rightskip \@tocrmarg
     \parfillskip -\rightskip
     \parindent \z@
     \interlinepenalty\@M
     \leavevmode
     \@tempdima #3\relax
     \normalfont\normalcolor
     \ndsu@contentslinetextbefore{#1}{#4}{#5}%
     #4%
     \ndsu@contentslinetextafter{#1}{#4}{#5}%
     \nobreak
     \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hfill
     \nobreak
     \hb@xt@\@pnumwidth{\hfil\normalfont\normalcolor
       \ndsu@contentslinepagebefore{#1}{#4}{#5}%
       #5%
       \ndsu@contentslinepageafter{#1}{#4}{#5}}%
     \par}%
  \fi}

\newlength{\ndsuchaptocnumwidth}
\setlength{\ndsuchaptocnumwidth}{1.5em}
\newlength{\ndsu@currentchaptocnumwidth}
\newcommand{\ndsu@setcurrentchaptocnumwidth}[1]{%
  \settowidth{\@tempdima}{\normalfont\ndsu@tocchapternumberline{#1}}%
  \setlength{\ndsu@currentchaptocnumwidth}{\ndsuchaptocnumwidth}%
  \ifdim\ndsu@currentchaptocnumwidth<\@tempdima\relax
    \setlength{\ndsu@currentchaptocnumwidth}{\@tempdima}%
  \fi
}
\newcommand{\ndsu@setcurrentchaptocnumwidthglobal}[1]{%
  \settowidth{\@tempdima}{\normalfont\ndsu@tocchapternumberline{#1}}%
  \global\ndsu@currentchaptocnumwidth=\ndsuchaptocnumwidth\relax
  \ifdim\ndsu@currentchaptocnumwidth<\@tempdima\relax
    \global\ndsu@currentchaptocnumwidth=\@tempdima\relax
  \fi
}
\newcommand{\ndsu@measurechaptertocentry}[1]{%
  \setlength{\ndsu@currentchaptocnumwidth}{0pt}%
  \begingroup
    \let\hyper@linkstart\@gobbletwo
    \let\hyper@linkend\@empty
    \def\Hy@toclinkstart##1{}%
    \let\Hy@toclinkend\@empty
    \def\numberline##1{\ndsu@setcurrentchaptocnumwidthglobal{##1}}%
    \setbox\z@\hbox{#1}%
  \endgroup
}
\newcommand{\ndsu@chaptertocnumberline}[1]{%
  \hb@xt@\ndsu@currentchaptocnumwidth{\ndsu@tocchapternumberline{#1}\hfil}%
}
\newcommand{\ndsu@dottedtoclinehangwrap}[5]{%
  \ifnum #1>\c@tocdepth \else
    \vskip \z@ \@plus.2\p@
    {\leftskip #2\relax
     \rightskip \@tocrmarg
     \parfillskip -\rightskip
     \parindent #2\relax
     \interlinepenalty\@M
     \leavevmode
     \@tempdima #3\relax
     \advance\leftskip \@tempdima\relax
     \null\nobreak\hskip -\leftskip
     \normalfont\normalcolor
     \ndsu@contentslinetextbefore{#1}{#4}{#5}%
     #4%
     \ndsu@contentslinetextafter{#1}{#4}{#5}%
     \nobreak
     \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hfill
     \nobreak
     \hb@xt@\@pnumwidth{\hfil\normalfont\normalcolor
       \ndsu@contentslinepagebefore{#1}{#4}{#5}%
       #5%
       \ndsu@contentslinepageafter{#1}{#4}{#5}}%
     \par}%
  \fi}
\newcommand{\ndsu@dottedchapterline}[2]{\ndsu@dottedtoclineflushwrap{0}{0pt}{\ndsu@currentchaptocnumwidth}{#1}{#2}}
\newcommand{\ndsu@dottedsectionline}[2]{\ndsu@dottedtoclineflushwrap{1}{1.5em}{2.3em}{#1}{#2}}
\newcommand{\ndsu@dottedsubsectionline}[2]{\ndsu@dottedtoclineflushwrap{2}{3.8em}{3.2em}{#1}{#2}}

\newcommand{\ndsu@renderchaptertocentry}[2]{%
  \begingroup
    \setstretch{1}\selectfont
    \ndsu@measurechaptertocentry{#1}%
    \let\numberline\ndsu@chaptertocnumberline
    \ndsu@settoclinewidths{#2}%
    \ndsu@dottedchapterline{#1}{#2}%
    \addvspace{\ndsu@tocentryspace}%
  \endgroup
}

\newcommand{\ndsu@installtocformatting}{%
  \renewcommand*{\l@chapter}[2]{%
    \ndsu@renderchaptertocentry{##1}{##2}%
  }%
  \renewcommand*{\l@section}[2]{%
    \ndsu@rendertocentry
      {\ndsu@dottedsectionline}%
      {\ndsu@tocnumberline}%
      {##1}%
      {##2}%
  }%
  \renewcommand*{\l@subsection}[2]{%
    \ndsu@rendertocentry
      {\ndsu@dottedsubsectionline}%
      {\ndsu@tocnumberline}%
      {##1}%
      {##2}%
  }%
  \renewcommand*{\l@figure}[2]{%
    \ndsu@rendertocentry
      {\ndsu@dottedfloatline}%
      {\ndsu@floatlistnumberline}%
      {##1}%
      {##2}%
  }%
  \renewcommand*{\l@table}[2]{%
    \ndsu@rendertocentry
      {\ndsu@dottedtableline}%
      {\ndsu@floatlistnumberline}%
      {##1}%
      {##2}%
  }%
  \def\l@equation##1##2{%
    \ndsu@rendertocentry
      {\ndsu@dottedequationline}%
      {\ndsu@floatlistnumberline}%
      {##1}%
      {##2}%
  }%
  \def\l@schema##1##2{%
    \ndsu@rendertocentry
      {\ndsu@dottedschemaline}%
      {\ndsu@floatlistnumberline}%
      {##1}%
      {##2}%
  }%
  \let\l@frontmatter\l@chapter
  \let\l@prefatory\l@chapter
  \let\l@appendix\l@chapter
  \let\l@references\l@chapter
  \let\l@bibliography\l@chapter
}
\AtBeginDocument{\ndsu@installtocformatting}
\renewcommand{\tableofcontents}{%
  \chapter*{TABLE OF CONTENTS}%
  \phantomsection
  \pdfbookmark[0]{TABLE OF CONTENTS}{toc}%
  \vspace{0.5\baselineskip}%
  \@starttoc{toc}%
}

% --- Cover page and approval page ---
\newcommand{\ndsu@centerheader}[1]{\begin{center}\bfseries #1\end{center}}
\newlength{\ndsu@titleblocksep}
\setlength{\ndsu@titleblocksep}{0.34in}
\newlength{\ndsu@titlefirstsep}
\setlength{\ndsu@titlefirstsep}{0.92in}
\newlength{\ndsu@titlebottomsep}
\setlength{\ndsu@titlebottomsep}{0.12in}
\newlength{\ndsu@approvalblockwidth}
\setlength{\ndsu@approvalblockwidth}{0.855\textwidth}
\newlength{\ndsu@approvalcommitteeskip}
\setlength{\ndsu@approvalcommitteeskip}{0.90in}
\newlength{\ndsu@approvalapprovedskip}
\setlength{\ndsu@approvalapprovedskip}{0.20in}
\newlength{\ndsu@approvallowerheight}
\setlength{\ndsu@approvallowerheight}{5.98in}
\newcommand{\makecoverpage}{%
  \thispagestyle{empty}%
  \begingroup
  \singlespacing
  \centering
  \phantomsection
  \NDSUAddTitlePdfBookmark
  \tagstructbegin{tag=H1}%
  \tagmcbegin{tag=H1}%
  {\begin{doublespace}\MakeUppercase{\ndsutitle}\par\end{doublespace}}%
  \tagpdfsuppressmarks{\tagmcend}\tagstructend%
  \vspace{\ndsu@titlefirstsep}
  A \ndsudocumenttype\par
  Submitted to the Graduate Faculty\par
  of the\par
  North Dakota State University\par
  of Agriculture and Applied Science\par
  \vspace{0.668in}
  \begin{doublespace}
   By\par
  \ndsuauthor\par\end{doublespace}

  \vspace{\ndsu@titleblocksep}
  \vspace{.668in}
  In Partial Fulfillment of the Requirements\par
  for the Degree of\par
  \MakeUppercase{\ndsudegree}\par
  \vspace{0.668in}
  \vspace{\ndsu@titleblocksep}
  \ndsumajorlabel:\par
  \ndsuprogram\par
  \ifstrempty{\ndsudegreeoption}{}{\ndsudegreeoption\par}%
  \vfill
  \ndsufinaldefense\par
  \vspace{0.668in}
  Fargo, North Dakota\par
  \vspace{\ndsu@titlebottomsep}
  \endgroup
  \clearpage
}

\newcommand{\ndsu@signatureline}[2]{%
  \vspace{0.02in}%
  #1\\[-0.08in]
  \ndsuartifactcontent{\rule{0.55\textwidth}{0.4pt}}\\[-0.02in]
  {\fontsize{8pt}{10pt}\selectfont #2}%
}
\newcommand{\ndsu@signatureentry}[2]{%
  \noindent
  \begin{minipage}[t]{0.58\linewidth}
    #1\par%
    \vspace{-1.5ex}
    \ndsuartifactcontent{\rule{\linewidth}{0.4pt}}\par
    \vspace{0.15\baselineskip}
    {\fontsize{8pt}{10pt}\selectfont\hspace{0.18em} #2\par}%
  \end{minipage}%
}

\newcommand{\ndsu@committeeentry}[1]{%
  \par\vspace{0.12in}%
  \ndsu@signatureentry{#1}{}%
}

\newcommand{\ndsu@approvalfield}[2]{%
  \begin{minipage}[t]{0.42\linewidth}
    \centering
    #1\par%
    \vspace{-1.5ex}
    \ndsuartifactcontent{\rule{0.85\linewidth}{0.4pt}}\par
    \vspace{0.10\baselineskip}
        {\fontsize{8pt}{10pt}\selectfont #2\par}%
  \end{minipage}%
}
\newcommand{\ndsu@approvaldatefield}[2]{%
  \begin{minipage}[t]{0.42\linewidth}
    \noindent\makebox[0.85\linewidth][c]{#1}\par
    \vspace{-1.5ex}
    \ndsuartifactcontent{\rule{0.85\linewidth}{0.4pt}}\par
    \vspace{0.10\baselineskip}
        {\fontsize{8pt}{10pt}\selectfont\makebox[0.85\linewidth][c]{#2}\par}%
  \end{minipage}%
}

\newcommand{\makeapprovalpage}{%
  \thispagestyle{empty}%
  \begingroup
  \singlespacing
  \begin{ndsu@nohyphenation}
  \setlength{\parindent}{0pt}%
  \hyphenpenalty=10000
  \exhyphenpenalty=10000
  \noindent\begin{minipage}[t][\dimexpr\textheight-\topskip\relax][t]{\textwidth}
  \vspace*{0pt}%
  
  \begin{center}
    {\fontsize{18pt}{22pt}\selectfont
    North Dakota State University\par}
    \vspace{0.02in}
    {\fontsize{14pt}{18pt}\selectfont
    Graduate School\par}
  \end{center}

  \vspace{-1.5\baselineskip}
  \noindent\ndsuartifactcontent{\rule{\textwidth}{1.6pt}}
  \vspace{0.15\baselineskip}

  \begin{center}
    {\fontsize{10pt}{12pt}\selectfont\textbf{Title}\par}
    \vspace{0.08in}

    \begin{minipage}{\ndsu@approvalblockwidth}
      \centering
      \ndsutitle\par
      \vspace{-1.5ex}
      \ndsuartifactcontent{\rule{\linewidth}{0.4pt}}
    \end{minipage}

    \vspace{0.12in}

    {\fontsize{10pt}{12pt}\selectfont\textbf{By}\par}
    \vspace{0.08in}

    \begin{minipage}{\ndsu@approvalblockwidth}
      \centering
      \ndsuauthor\par
      \vspace{-1.5ex}
      \ndsuartifactcontent{\rule{\linewidth}{0.4pt}}
    \end{minipage}
  \end{center}

  \vspace{0.12in}

  \noindent\makebox[\textwidth][c]{%
     \begin{minipage}[t][\ndsu@approvallowerheight][s]{\ndsu@approvalblockwidth}
      {\fontsize{10pt}{12pt}\selectfont
      \doublespacing
      The Supervisory Committee certifies that this \textbf{\textit{disquisition}} complies with
      North Dakota State University's regulations and meets the accepted standards
      for the degree of\par}

    \vspace{0.20in}

     {\centering
    {\fontsize{10pt}{12pt}\selectfont\bfseries\MakeUppercase{\ndsudegree}\par}}


    \vspace{\ndsu@approvalcommitteeskip}

    {\fontsize{10pt}{12pt}\selectfont SUPERVISORY COMMITTEE:\par}

    \vspace{0.20in}

    \ndsu@signatureentry{\ndsucommitteechair}{Chair}%
      \ifdefempty{\ndsucommitteecochair}{}{%
      \par\vspace{0.20in}%
      \ndsu@signatureentry{\ndsucommitteecochair}{Co-Chair}%
    }%
    \ifdefempty{\ndsucommitteeone}{}{%
      \par\vspace{0.20in}%
      \ndsu@signatureentry{\ndsucommitteeone}{}%
    }%
    \ifdefempty{\ndsucommitteetwo}{}{%
      \par\vspace{0.12in}%
      \ndsu@signatureentry{\ndsucommitteetwo}{}%
    }%
    \ifdefempty{\ndsucommitteethree}{}{%
      \par\vspace{0.12in}%
      \ndsu@signatureentry{\ndsucommitteethree}{}%
    }%
    \forlistloop{\ndsu@committeeentry}{\ndsu@additionalcommittee}%

    \vspace{\ndsu@approvalapprovedskip}\vfill

    {\fontsize{10pt}{12pt}\selectfont Approved:\par}

    \vspace{0.10in}

    \noindent
    \ndsu@approvaldatefield{\ndsuapprovaldate}{Date}%
    \hfill
      \ndsu@approvalfield{\ndsudeptchair}{Department Chair}%
    \end{minipage}%
  }%

\end{minipage}%
  \end{ndsu@nohyphenation}
  \endgroup
  \clearpage
}

% --- Front matter/main matter/references ---
\newcommand{\ndsuprefatoryheading}[1]{\chapter*{\MakeUppercase{#1}}\phantomsection\addcontentsline{toc}{frontmatter}{\texorpdfstring{\MakeUppercase{#1}}{\MakeUppercase{#1}}}}
\newcommand{\frontmattersetup}{\pagenumbering{roman}\ndsu@nohyphenationmode}
\newcommand{\ndsu@inputrequiredfrontmatter}[1]{%
  \InputIfFileExists{#1}{}{%
    \ClassError{ndsudisq}{Required front-matter file `#1' not found}{%
      The front-matter file `#1' is required by \string\makefrontmatter.\MessageBreak
      Create the file or revise \string\makefrontmatter\space if your document intentionally omits this section.%
    }%
  }%
}
\newcommand{\ndsu@inputoptionalfrontmatter}[1]{%
  \InputIfFileExists{#1}{}{%
    \ClassWarning{ndsudisq}{Optional front-matter file `#1' not found.\MessageBreak
      The section was requested, but the file was not found}%
  }%
}

\newlength{\ndsu@loeafterheaderskip}
\setlength{\ndsu@loeafterheaderskip}{4pt}
\newcommand{\ndsu@listheaderlabel}[1]{\normalfont\underline{#1}}
\newcommand{\ndsu@listheader}[2]{%
  \noindent\ndsu@listheaderlabel{#1}\hfill\ndsu@listheaderlabel{#2}\par\vspace{0.2cm}%
}
\newcommand{\ndsu@equationlistheader}{%
  \ndsu@listheader{Equation}{Page}%
  \vspace{\ndsu@loeafterheaderskip}%
}
\newcommand{\makefrontmatter}{%
  \frontmattersetup
  \makecoverpage
  \makeapprovalpage
  \ndsu@inputrequiredfrontmatter{frontmatter/abstract.tex}%
  \ndsu@inputrequiredfrontmatter{frontmatter/acknowledgments.tex}%
  \ifndsu@includeDedication\ndsu@inputoptionalfrontmatter{frontmatter/dedication.tex}\fi
  \tableofcontents
  \clearpage
  \ifndsu@includeListOfTables
    \chapter*{LIST OF TABLES}%
    \phantomsection
    \addcontentsline{toc}{frontmatter}{LIST OF TABLES}%
    \ndsu@listheader{Table}{Page}%
    \@starttoc{lot}%
    \clearpage
  \fi
  \ifndsu@includeListOfFigures
    \chapter*{LIST OF FIGURES}%
    \phantomsection
    \addcontentsline{toc}{frontmatter}{LIST OF FIGURES}%
    \ndsu@listheader{Figure}{Page}%
    \@starttoc{lof}%
    \clearpage
  \fi
  \ifndsu@includeListOfEquations
    \chapter*{\listequationname}%
    \phantomsection
    \addcontentsline{toc}{frontmatter}{\listequationname}%
    \ndsu@equationlistheader%
    \@starttoc{loe}%
    \clearpage
  \fi
  \ifndsu@includeListOfSchemas
    \chapter*{\listschemaname}%
    \phantomsection
    \addcontentsline{toc}{frontmatter}{\listschemaname}%
    \ndsu@listheader{Schema}{Page}%
    \@starttoc{los}%
    \clearpage
  \fi
  \ifndsu@includeAbbreviations\ndsu@inputoptionalfrontmatter{frontmatter/abbreviations.tex}\fi
  \ifndsu@includeSymbols\ndsu@inputoptionalfrontmatter{frontmatter/symbols.tex}\fi
  \ifndsu@includePreface\ndsu@inputoptionalfrontmatter{frontmatter/preface.tex}\fi
}
\newcommand{\mainmattersetup}{\ndsu@normalhyphenationmode\clearpage\pagenumbering{arabic}\setcounter{page}{1}}

\newcommand{\ndsureferencesname}{REFERENCES}
\newcommand{\referencesheading}[1]{\renewcommand{\ndsureferencesname}{#1}}
\newcommand{\ndsu@referencesheading}[1]{%
  \chapter*{\MakeUppercase{#1}}%
  \phantomsection
  \addcontentsline{toc}{references}{\texorpdfstring{\MakeUppercase{#1}}{\MakeUppercase{#1}}}%
}
\AtBeginDocument{%
  \@ifpackageloaded{biblatex}{%
    \defbibheading{ndsureferences}[\ndsureferencesname]{\ndsu@referencesheading{##1}}%
    \setlength{\bibhang}{0.5in}%
  }{}%
}
\newcommand{\printreferences}{%
  \clearpage
  \ifcsname printbibliography\endcsname
    \ndsu@referencesheading{\ndsureferencesname}%
    \printbibliography[heading=none]%
  \else
    \ClassError{ndsudisq}{\string\printreferences\space requires biblatex}{Load biblatex in the preamble and add a bibliography resource, for example: \string\usepackage[backend=biber,style=authoryear]{biblatex} and \string\addbibresource{references.bib}.}%
  \fi
}
\newcommand{\printworkscited}{\referencesheading{WORKS CITED}\printreferences}
\newcommand{\printbibliographyheading}{\referencesheading{BIBLIOGRAPHY}\printreferences}

% --- Abbreviation/symbol lists and code listings ---
\newlength{\ndsuAbbrevLabelWidth}
\newlength{\ndsuAbbrevLabelSep}
\newlength{\ndsuAbbrevItemSep}
\setlength{\ndsuAbbrevLabelWidth}{1.45in}
\setlength{\ndsuAbbrevLabelSep}{0.05in}
\setlength{\ndsuAbbrevItemSep}{0pt plus 1pt}
\NewDocumentEnvironment{ndsuabbreviations}{ O{3.0in} }
  {%
    \par
    \begingroup
    \setlength{\ndsuAbbrevLabelWidth}{#1}%
    \setlength{\parindent}{0pt}%
    \setlength{\parskip}{0pt}%
    \setstretch{1.667}\selectfont
  }
  {%
    \par
    \endgroup
  }
\newcommand{\ndsuabbr}[2]{%
  \par\vspace{\ndsuAbbrevItemSep}%
  \begingroup
    \hangindent=\dimexpr\ndsuAbbrevLabelWidth+\ndsuAbbrevLabelSep\relax
    \hangafter=1
    \noindent\leavevmode
    \hbox to \ndsuAbbrevLabelWidth{%
      #1\ndsuartifactcontent{\leaders\hbox{.\kern0.35em}\hfill}%
    }%
    \nobreak\hspace{\ndsuAbbrevLabelSep}%
    \ignorespaces#2\par
  \endgroup
}
\NewDocumentEnvironment{ndsusymbols}{ O{3.0in} }{\begin{ndsuabbreviations}[#1]}{\end{ndsuabbreviations}}
\newcommand{\ndsusym}[2]{\ndsuabbr{#1}{#2}}

\newlength{\ndsu@codebeforeskip}
\setlength{\ndsu@codebeforeskip}{2pt}
\newlength{\ndsu@codeafterskip}
\setlength{\ndsu@codeafterskip}{6pt}
\newlength{\ndsuCodeCaptionSkip}
\setlength{\ndsuCodeCaptionSkip}{4pt}
\newlength{\ndsu@codetitleskip}
\setlength{\ndsu@codetitleskip}{0pt}
\newlength{\ndsu@codenumbersep}
\setlength{\ndsu@codenumbersep}{6pt}
\newlength{\ndsu@codelistingxleftmargin}
\setlength{\ndsu@codelistingxleftmargin}{1.75em}
\newlength{\ndsu@codelistingframexleftmargin}
\setlength{\ndsu@codelistingframexleftmargin}{1.75em}
\providecommand{\listlistingname}{LIST OF LISTINGS}
\@ifundefined{c@listing}{%
  \newfloat{listing}{htbp}{lol}%
  \floatname{listing}{Listing}%
}{}
\captionsetup[listing]{%
  justification=raggedright,%
  singlelinecheck=false,%
  margin=0pt,%
  indention=0pt,%
  parindent=0pt,%
  skip=0pt%
}
\crefname{listing}{Listing}{Listings}
\Crefname{listing}{Listing}{Listings}
\newcommand{\ndsu@codelistingcaption}[1]{%
  \captionsetup{type=listing}%
  \captionof{listing}{#1}%
   \par\nobreak\vspace{\ndsuCodeCaptionSkip}%
}
\newcommand{\ndsu@codeverbatimlistparameters}{%
  \setlength{\topsep}{0pt}%
  \setlength{\partopsep}{0pt}%
  \setlength{\parsep}{0pt}%
}
\NewDocumentEnvironment{ndsusimplecode}{ O{} }
  {%
    \VerbatimEnvironment
    \par\Needspace{4\baselineskip}%
    \addvspace{\ndsu@codebeforeskip}%
    \singlespacing
    \begin{Verbatim}[fontsize=\small,belowskip=0pt,listparameters={\ndsu@codeverbatimlistparameters},#1]%
  }
  {\end{Verbatim}\par\addvspace{\ndsu@codeafterskip}}
\newenvironment{ndsucodelisting}[1][]{%
  \VerbatimEnvironment
  \par
  
  \Needspace{6\baselineskip}%
  \addvspace{\ndsu@codebeforeskip}%
  \ndsu@codelistingcaption{#1}%
  \setstretch{1}%
  \begin{Verbatim}[fontsize=\small,numbers=left,numbersep=\ndsu@codenumbersep,xleftmargin=\ndsu@codelistingxleftmargin,frame=single,breaklines=true,breakanywhere=true,listparameters={\ndsu@codeverbatimlistparameters}]%
}{%
  \end{Verbatim}%
  \par
  
  \addvspace{\ndsu@codeafterskip}%
}

\newcommand{\ndsucodenote}[1]{\ndsunote{#1}}

% Apply the default chapter-based float/list counter policy after all counters
% have been defined. Preamble calls such as \usecontinuouscaptions can still
% override this default after \documentclass.
\AtEndOfClass{\usechaptercaptions}

% --- End-of-class cleanup ---
\makeatother
