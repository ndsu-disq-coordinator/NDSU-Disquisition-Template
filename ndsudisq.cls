% ndsudisq.cls
% NDSU disquisition class.
% This file controls document structure and formatting.
% Most users should edit main.tex and the content files rather than this class file.
% LAST PATCH 2026/10/14: restore approval appearance and body-list marker alignment

% --- Class identity and version ---
\NeedsTeXFormat{LaTeX2e}[2026-06-01]
\newcommand{\ndsudisqversion}{v0.6.8-chapter-references-review}
\newcommand{\ndsudisqdate}{2026/10/22}
\newcommand{\ndsudisqdesc}{NDSU disquisition class}
\ProvidesClass{ndsudisq}[\ndsudisqdate\space \ndsudisqdesc\space (\ndsudisqversion)]


% --- Options and base class ---
\newif\ifndsu@nonumbered
\ndsu@nonumberedfalse
\newif\ifndsu@debugbookmarks
\ndsu@debugbookmarksfalse
\newif\ifndsu@xitsfonts
\ndsu@xitsfontsfalse
\newif\ifndsu@draft
\newif\ifndsu@guideLinks
\newif\ifndsu@allowFontSubstitute
\DeclareOption{draft}{\ndsu@drafttrue}
\DeclareOption{final}{\ndsu@draftfalse}
\DeclareOption{guidelinks}{\ndsu@guideLinkstrue}
\DeclareOption{allowfontsubstitute}{\ndsu@allowFontSubstitutetrue}
\DeclareOption{nonumbered}{\ndsu@nonumberedtrue}
\DeclareOption{debugbookmarks}{\ndsu@debugbookmarkstrue}
\DeclareOption{equationchapter}{\AtEndOfClass{\equationnumberingbychapter}}
\DeclareOption{equationcontinuous}{\AtEndOfClass{\equationnumberingcontinuous}}
\DeclareOption{xitsfonts}{\ndsu@xitsfontstrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
% These are metadata validation modes, not package-level draft rendering modes.
\@removeelement{draft}\@classoptionslist\@classoptionslist
\@removeelement{final}\@classoptionslist\@classoptionslist
\@removeelement{draft}\@raw@classoptionslist\@raw@classoptionslist
\@removeelement{final}\@raw@classoptionslist\@raw@classoptionslist
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
  \ifndsu@allowFontSubstitute\else
    \ClassError{ndsudisq}{XITS paragraph-font approval has not been established}{The xitsfonts experiment also requires allowfontsubstitute after institutional approval. XITS Math equation approval alone is not paragraph approval.}%
  \fi
  \ClassWarningNoLine{ndsudisq}{Explicit XITS paragraph-font experiment; institutional approval remains the author's responsibility}
\else
  \IfFontExistsTF{Times New Roman}
    {\setmainfont{Times New Roman}}
    {%
      \ifndsu@allowFontSubstitute
        \setmainfont{TeX Gyre Termes}%
      \else
        \ClassError{ndsudisq}{Times New Roman is required for the default paragraph scheme}{Install an appropriately licensed Times New Roman family. For an explicitly approved alternative only, select allowfontsubstitute and confirm its institutional acceptance.}%
      \fi
      \ClassWarningNoLine{ndsudisq}{Times New Roman was not found; using TeX Gyre Termes fallback. Confirm institutional acceptance of this substitute font before submission}%
    }
\fi
\RequirePackage{polyglossia}
\RequirePackage{xparse}

% --- Package loading by feature area ---
\RequirePackage[margin=1in]{geometry}
\RequirePackage{setspace}
\RequirePackage{ragged2e}
\RequirePackage{microtype}
\RequirePackage{lua-widow-control}
    \lwcsetup{draft=false,
      balanced,
      disablecmds={
        \@sect,
        \@ssect,
        \M@sect,
        \@mem@old@ssect,
        \ttl@straight@ii,
        \ttl@top@ii,
        \ttl@part@ii,
        \@chapter,
        \@schapter,
        \ParseLaTeXeHeading
      }
    }
\RequirePackage{indentfirst}
\RequirePackage{pdflscape}
\RequirePackage{eso-pic}
\RequirePackage{graphicx}
\setkeys{Gin}{draft=false}
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
% Native LaTeX heading templates preserve H1-H6 tagging; do not load titlesec.
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
\RequirePackage{csquotes}
\RequirePackage{listings}
\RequirePackage{needspace}
\RequirePackage[bottom]{footmisc}

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
\setcounter{tocdepth}{2}

% ------------------------------------------------------------
% Before-list baseline alignment
% ------------------------------------------------------------
\newdimen\ndsu@listBeginSkip

\newcommand{\ndsu@computelistbeginskip}{%
     \ndsu@listBeginSkip=0pt
     \ifhmode
          \par
     \fi
     \ifdim\prevdepth>-1000pt
          \ndsu@listBeginSkip=\baselineskip
          \advance\ndsu@listBeginSkip by -\prevdepth
          \advance\ndsu@listBeginSkip by -\ht\strutbox
          \ifdim\ndsu@listBeginSkip<0pt
               \ndsu@listBeginSkip=0pt
          \fi
     \fi
}

% ------------------------------------------------------------
% List spacing configuration
% Right-aligned labels reproduce the original PDF positions; retain the
% original label widths, label separation and hanging text indentation.
% ------------------------------------------------------------
\newlength{\ndsuListTopSep}
\setlength{\ndsuListTopSep}{0pt}

\newlength{\ndsuListItemSep}
\setlength{\ndsuListItemSep}{0pt}

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
    align=right,%
    topsep=\ndsuListTopSep,%
    partopsep=\ndsuListPartopSep,%
    itemsep=\ndsuListItemSep,%
    parsep=\ndsuListParseSep,%
    % parskip is controlled by para-vspace and list wrappers.
  }%
  \let\ndsu@original@itemize\itemize
  \let\ndsu@original@enditemize\enditemize

% ------------------------------------------------------------
% Itemize environment definitions
% ------------------------------------------------------------
\renewenvironment{itemize}[1][]{%
     \ifnum\@itemdepth=0
          \@ifpackageloaded{latex-lab-enumitem}{}{\ndsu@computelistbeginskip}
          \ndsu@original@itemize[
               leftmargin=\ndsuItemizeLeftMargin,
               topsep=0pt,
               partopsep=0pt,
               ##1
          ]%
          \@ifpackageloaded{latex-lab-enumitem}{}{\vspace{\ndsu@listBeginSkip}}%
          \setlength{\labelwidth}{\ndsuItemizeLabelWidth}%
          \setlength{\labelsep}{\ndsuItemizeLabelSep}%
          \setlength{\itemindent}{0pt}%
          \setlength{\itemsep}{\ndsuListItemSep}%
          \setlength{\parsep}{\ndsuListParseSep}%
     \else
          \ndsu@original@itemize[##1]%
     \fi
     \setlength{\parskip}{0pt}%
}{%
     \ndsu@original@enditemize
}%

    \@ifpackageloaded{latex-lab-enumitem}{%
        \setlist[enumerate,1]{%
        label-width=\ndsuEnumerateLabelWidth,%
        label-sep=\ndsuEnumerateLabelSep,%
        left-margin=\ndsuEnumerateLeftMargin,%
        item-indent=0pt,%
        label-align=right,%
        begin-vspace=\ndsuListTopSep,%
        begin-extra-vspace=\ndsuListPartopSep,%
        end-vspace=0pt,%
        end-extra-vspace=0pt,%
        item-vspace=\ndsuListItemSep,%
        para-vspace=\ndsuListParseSep%
    }%
}{%
  \setlist[enumerate,1]{%
    labelwidth=\ndsuEnumerateLabelWidth,%
    labelsep=\ndsuEnumerateLabelSep,%
    leftmargin=\ndsuEnumerateLeftMargin,%
    itemindent=0pt,%
    align=right,%
    topsep=\ndsuListTopSep,%
    partopsep=\ndsuListPartopSep,%
    itemsep=\ndsuListItemSep,%
    parsep=\ndsuListParseSep,%
    % parskip is controlled by para-vspace and list wrappers.
  }%
}%
  \let\ndsu@original@enumerate\enumerate
  \let\ndsu@original@endenumerate\endenumerate

% ------------------------------------------------------------
% Enumerate environment definitions
% ------------------------------------------------------------
\renewenvironment{enumerate}[1][]{%
     \ifnum\@enumdepth=0
          \@ifpackageloaded{latex-lab-enumitem}{}{\ndsu@computelistbeginskip}
          \ndsu@original@enumerate[
               leftmargin=\ndsuEnumerateLeftMargin,
               topsep=0pt,
               partopsep=0pt,
               ##1
          ]%
          \@ifpackageloaded{latex-lab-enumitem}{}{\vspace{\ndsu@listBeginSkip}}%
          \setlength{\labelwidth}{\ndsuEnumerateLabelWidth}%
          \setlength{\labelsep}{\ndsuEnumerateLabelSep}%
          \setlength{\itemindent}{0pt}%
          \setlength{\itemsep}{\ndsuListItemSep}%
          \setlength{\parsep}{\ndsuListParseSep}%
     \else
          \ndsu@original@enumerate[##1]%
     \fi
     \setlength{\parskip}{0pt}%
}{%
     \ndsu@original@endenumerate
}%

  \setlist[description,1]{%
    leftmargin=\ndsuListLeftMargin,%
    topsep=\ndsuListTopSep,%
    partopsep=\ndsuListPartopSep,%
    itemsep=\ndsuListItemSep,%
    parsep=\ndsuListParseSep,%
    % parskip is controlled by para-vspace and list wrappers.
  }%
  \setlist[itemize,2]{%
    topsep=\ndsuListTopSep,%
    partopsep=0pt,%
    itemsep=\ndsuListItemSep,%
    parsep=0pt,%
    % parskip is controlled by para-vspace and list wrappers.
  }%
  \setlist[enumerate,2]{%
    topsep=\ndsuListTopSep,%
    partopsep=0pt,%
    itemsep=\ndsuListItemSep,%
    parsep=0pt,%
    % parskip is controlled by para-vspace and list wrappers.
  }%
  \setlist[description,2]{%
    topsep=\ndsuListTopSep,%
    partopsep=0pt,%
    itemsep=\ndsuListItemSep,%
    parsep=0pt,%
    % parskip is controlled by para-vspace and list wrappers.
  }%
}
% Native tagged lists already preserve baseline glue. Their topsep alias
% sets only begin-vspace, so explicitly clear the independent exit spacing.
% Ordinary enumitem retains its existing symmetric topsep behavior.
\newcommand{\ndsu@installlistboundaryspacing}{%
  \@ifpackageloaded{latex-lab-enumitem}{%
    \setlist*[itemize,1]{end-vspace=0pt,end-extra-vspace=0pt}%
    \setlist*[itemize,2]{end-vspace=0pt,end-extra-vspace=0pt}%
    \setlist*[enumerate,1]{end-vspace=0pt,end-extra-vspace=0pt}%
    \setlist*[enumerate,2]{end-vspace=0pt,end-extra-vspace=0pt}%
  }{}%
}
\AtBeginDocument{\ndsu@installlistformatting\ndsu@installlistboundaryspacing}

% Maintainable non-text spacing controls.
% Maintainers should tune these named lengths instead of adding manual \vspace
% around individual figures/tables in chapter files.
\newlength{\ndsuFloatTextSkip}
\setlength{\ndsuFloatTextSkip}{10pt plus 2pt minus 2pt}
\newlength{\ndsuFloatFloatSkip}
\AtBeginDocument{%
  \setlength{\ndsuFloatFloatSkip}{\baselineskip}%
  \setlength{\floatsep}{\ndsuFloatFloatSkip}%
  \setlength{\@fpsep}{\ndsuFloatFloatSkip}%
}
\setlength{\ndsuFloatFloatSkip}{0pt}
\newlength{\ndsuFigureCaptionSkip}
\setlength{\ndsuFigureCaptionSkip}{0pt}
\newlength{\ndsuFigureBottomReserve}
\setlength{\ndsuFigureBottomReserve}{0pt}
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
\setlength{\ndsuNoteAfterSkip}{0pt}
\newlength{\ndsuSchemaCaptionSkip}
\setlength{\ndsuSchemaCaptionSkip}{6pt plus 1pt minus 1pt}
\setlength{\LTpre}{\ndsuLongtablePreSkip}
\setlength{\LTpost}{\ndsuLongtablePostSkip}
\setlength{\floatsep}{\ndsuFloatFloatSkip}
\setlength{\textfloatsep}{\ndsuFloatTextSkip}
\setlength{\intextsep}{\ndsuFloatTextSkip}
% Deferred floats meet a column boundary rather than an ordinary body baseline.
% Restore the body-leading allowance missing from that boundary calculation.
\AtBeginDocument{%
  \setlength{\textfloatsep}{\ndsuFloatTextSkip}%
  \addtolength{\textfloatsep}{\baselineskip}%
  \addtolength{\textfloatsep}{-\topskip}%
  \setlength{\dbltextfloatsep}{\textfloatsep}%
}


% Separate upper spacing for in-text figures.
\newskip\ndsuFigureAboveTextSkip
\AtBeginDocument{%
  \ndsuFigureAboveTextSkip=\baselineskip
}

\newskip\ndsu@currentFloatAboveSkip
\newskip\ndsu@currentFloatBelowSkip

\newskip\ndsu@currentFloatAboveSkip
\newskip\ndsu@currentFloatBelowSkip
\newif\ifndsu@previousTableSource
\newif\ifndsu@thisTableConsecutive
\ndsu@previousTableSourcefalse
\ndsu@thisTableConsecutivefalse
\newcommand{\ndsu@begintablespacingstate}{%
  \ifndsu@previousTableSource
    \global\ndsu@thisTableConsecutivetrue
  \else
    \global\ndsu@thisTableConsecutivefalse
  \fi
  \global\ndsu@previousTableSourcefalse
}
\newcommand{\ndsu@endtablespacingstate}{%
  \global\ndsu@previousTableSourcetrue
  \global\ndsu@thisTableConsecutivefalse
}
\newcommand{\ndsu@setcurrentfloatskips}{%
    \ndsu@currentFloatAboveSkip=\intextsep
    \ndsu@currentFloatBelowSkip=\intextsep
    \ifnum\@currtype=\@xxxii
        \ndsu@currentFloatAboveSkip=\ndsuFigureAboveTextSkip
        % The figure box itself supplies the 10pt post-caption space.  Keeping the
        % insertion skip at zero avoids doubling it for figures placed in text.
        \ndsu@currentFloatBelowSkip=\intextsep
    \fi
  \ifnum\@currtype=64
    \ifndsu@thisTableConsecutive
      % The preceding table already supplied the one required inter-table gap.
      \ndsu@currentFloatAboveSkip=0pt
    \fi
  \fi
}
\patchcmd{\@addtocurcol}
  {\advance \@reqcolroom \intextsep}
  {\ndsu@setcurrentfloatskips\advance \@reqcolroom \ndsu@currentFloatAboveSkip}
  {}{\ClassWarningNoLine{ndsudisq}{Could not install the figure above-spacing fit check}}
\patchcmd{\@addtocurcol}
  {\global \advance \@textfloatsheight 2\intextsep}
  {\ndsu@setcurrentfloatskips
   \global\advance\@textfloatsheight\ndsu@currentFloatAboveSkip
   \global\advance\@textfloatsheight\ndsu@currentFloatBelowSkip}
  {}{\ClassWarningNoLine{ndsudisq}{Could not install the figure spacing height adjustment}}
\patchcmd{\@addtocurcol}
  {\vskip \intextsep \box\@currbox \penalty\interlinepenalty \vskip\intextsep}
  {\ndsu@setcurrentfloatskips
   \vskip\ndsu@currentFloatAboveSkip \box\@currbox
   \penalty\interlinepenalty \vskip\ndsu@currentFloatBelowSkip}
  {}{\ClassWarningNoLine{ndsudisq}{Could not install asymmetric in-text figure spacing}}

% The float package handles [H] floats separately from \@addtocurcol.
% Increase only the leading space for [H] figures.
\patchcmd{\float@endH}
    {\@endfloatbox\UseTaggingSocket{float/H/end}\vskip\intextsep}
    {\@endfloatbox\UseTaggingSocket{float/H/end}%
    \ifdefstring{\@captype}{figure}
        {\vskip\ndsuFigureAboveTextSkip}
        {\vskip\intextsep}
        }
    {}
    {\ClassWarningNoLine{ndsudisq}
        {Could not install [H] figure leading-spacing adjustment}
    }

\AtEndEnvironment{figure}{\par\vspace{\ndsuFigureBottomReserve}}
\AtEndEnvironment{figure*}{\par\vspace{\ndsuFigureBottomReserve}}
\AtBeginEnvironment{table}{\ndsu@begintablespacingstate}
\AfterEndEnvironment{table}{\ndsu@endtablespacingstate}
% Any real intervening paragraph means that the tables are not consecutive.
\AddToHook{para/begin}{\global\ndsu@previousTableSourcefalse}
% Keep figures/tables horizontally centered but top-aligned on float-only pages.
\setlength{\@fptop}{0pt}
\setlength{\@fpsep}{\ndsuFloatFloatSkip}
\setlength{\@fpbot}{0pt plus 1fil}

% Remove the residual leading baseline from tables placed on float-only pages.
% This correction applies only when the first float on the page is a table.
\newskip\ndsuTableFloatPageTopCorrection

\AtBeginDocument{%
    \begingroup
        \singlespacing
        \global\ndsuTableFloatPageTopCorrection=.75\baselineskip
    \endgroup
}

\newif\ifndsu@floatpagefirst

% Mark the first float while LaTeX assembles a float-only page.
\patchcmd{\@vtryfc}
    {\global\setbox\@outputbox\vbox{}}
    {\global\setbox\@outputbox\vbox{}%
        \global\ndsu@floatpagefirsttrue}
    {}
  {\ClassWarningNoLine{ndsudisq}
    {Could not install float-page first-float tracker}}

% Pull the first float upward only when that float is a table.
\patchcmd{\@wtryfc}
    {\unvbox\@outputbox\vskip\@fpsep\box #1}
    {\unvbox\@outputbox
    \ifndsu@floatpagefirst
        \global\ndsu@floatpagefirstfalse
        \@tempcnta\count#1\relax
        \divide\@tempcnta\@xxxii
        \multiply\@tempcnta\@xxxii
        \ifnum\@tempcnta=64\relax
            \vskip-\ndsuTableFloatPageTopCorrection
        \fi
    \fi
    \vskip\@fpsep
    \box #1}
    {}
    {\ClassWarningNoLine{ndsudisq}
        {Could not install table float-page top correction}}

% Displayed math: one 12-point blank line above and below every display.
\newlength{\ndsuEquationPadding}
\setlength{\ndsuEquationPadding}{10pt}

\AtBeginDocument{%
  % Append these assignments after setspace's display-math adjustments.
  \everydisplay\expandafter{%
    \the\everydisplay
    \abovedisplayskip=\ndsuEquationPadding\relax
    \belowdisplayskip=\ndsuEquationPadding\relax
    \abovedisplayshortskip=\ndsuEquationPadding\relax
    \belowdisplayshortskip=\ndsuEquationPadding\relax
  }%
}

% Allow blank source lines before display equations without adding an extra vertical interval to the rendered document.
\newcommand{\ndsu@normalizedisplaystart}{%
  \ifvmode
    \noindent
  \fi
}

\BeforeBeginEnvironment{equation}{\ndsu@normalizedisplaystart}
\BeforeBeginEnvironment{equation*}{\ndsu@normalizedisplaystart}
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
\RequirePackage[final]{hyperref}
\hypersetup{final,%
  unicode=true,%
  bookmarks=true,%
  bookmarksopen=true,%
  bookmarksnumbered=true,%
  linktoc=all,%
  pdfdisplaydoctitle=true,%
  hidelinks%
}

\RequirePackage{xcolor}
\RequirePackage[normalem]{ulem}
\let\ndsuOriginalHref\href
\ifndsu@guideLinks
  \renewcommand{\href}[2]{\ndsuOriginalHref{#1}{\textcolor{blue}{\uline{#2}}}}%
\fi

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
  \def\LaTeX{LATEX}\def\TeX{TEX}%
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
    \pdfbookmark[0]{\MakeUppercase{\ndsutitle}}{ndsu-disquisition-title}
  }
\cs_new_eq:NN \NDSUAddTitlePdfBookmark \ndsu_add_title_pdf_bookmark:
\ExplSyntaxOff
\AtBeginDocument{%
  \hypersetup{final,%
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
\newcommand{\ndsufinaldefense}{Month Year}
\newcommand{\ndsuapprovaldate}{Month Day, Year}
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
\newcommand{\majorlabel}[1]{\renewcommand{\ndsumajorlabel}{#1}}
\newcommand{\major}[1]{\renewcommand{\ndsuprogram}{#1}}
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

% Draft retains clearly marked sample fields; final reports missing/invalid inputs.
\newcommand{\ndsu@inputproblem}[1]{\ifndsu@draft
 \ClassWarningNoLine{ndsudisq}{Draft input: #1}%
 \else\ClassError{ndsudisq}{#1}{Replace the sample or invalid field. Use the explicit draft class option only for instructional or unfinished documents.}\fi}
\ExplSyntaxOn
\cs_generate_variant:Nn\clist_if_in:nnF{ne,nV}
\cs_generate_variant:Nn\regex_match:nnT{nV}
\cs_new_protected:Npn\ndsu_validate_metadata:{
 \clist_map_inline:nn {ndsucommitteecochair,ndsucommitteeone,ndsucommitteetwo,ndsucommitteethree}{
  \tl_set:Nx\l_tmpa_tl{\use:c{##1}}
  \regex_match:nVT {Committee\s|Your\s}\l_tmpa_tl{\ndsu@inputproblem{Unfilled~optional~committee~field~##1}}
 }
 \clist_if_in:neF {Dissertation,Thesis,Paper}{\ndsudocumenttype}
  {\ndsu@inputproblem{Invalid~document~type;~use~Dissertation,~Thesis~or~Paper}}
 \tl_set:Nx\l_tmpa_tl{\text_uppercase:n{\ndsudegree}}
 \clist_if_in:nVF {MASTER~OF~ARTS,MASTER~OF~SCIENCE,DOCTOR~OF~PHILOSOPHY,DOCTOR~OF~MUSICAL~ARTS,DOCTOR~OF~NURSING~PRACTICE}\l_tmpa_tl
  {\ndsu@inputproblem{Unsupported~or~placeholder~degree}}
 \clist_map_inline:nn {ndsutitle,ndsuauthor,ndsuprogram,ndsufinaldefense,ndsuapprovaldate,ndsucommitteechair,ndsudeptchair}{
  \tl_set:Nx\l_tmpa_tl{\use:c{##1}}
  \regex_match:nVT {\A\s*\Z|Your\s|SAMPLE|Month\s|Student\sName|Chair\sName|Department\sChair|Program\sName}\l_tmpa_tl
   {\ndsu@inputproblem{Unfilled~required~field~##1}}
 }
}
\AtBeginDocument{\ndsu_validate_metadata:}
\ExplSyntaxOff

% --- Front-matter inclusion switches ---
\newif\ifndsu@includeAcknowledgments
\newcommand{\includeacknowledgments}{\ndsu@includeAcknowledgmentstrue}
\newif\ifndsu@includeListOfListings
\newif\ifndsu@includeAppendixListings
\newcommand{\includelistoflistings}{\ndsu@includeListOfListingstrue}
\newcommand{\includeappendixlistings}{\ndsu@includeAppendixListingstrue}
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
\newcommand{\includeappendixtables}{\ndsu@includeAppendixTablestrue}
\newcommand{\includeappendixfigures}{\ndsu@includeAppendixFigurestrue}
\newcommand{\includepreface}{\ndsu@includePrefacetrue}

% --- Native tagged headings and stable appendix numbering ---
\setcounter{secnumdepth}{3}
\ifndsu@nonumbered\setcounter{secnumdepth}{0}\fi
\renewcommand{\thechapter}{\arabic{chapter}}
\renewcommand{\thesection}{\thechapter.\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\newcommand{\ndsu@subheadingneedspace}{\par\Needspace{4\baselineskip}}
\let\cleardoublepage\clearpage
\newif\ifndsu@appendices
\newcounter{ndsu@appendixchapters}
\newcommand{\ndsu@lastappendixchapters}{0}
\newcommand{\ndsu@setappendixchapters}[1]{\gdef\ndsu@lastappendixchapters{#1}}
\newcommand{\ndsu@iflastsingleappendix}[2]{\ifnum\ndsu@lastappendixchapters=1\relax#1\else#2\fi}
\newcommand{\ndsu@appendixchapterlabel}{\ndsu@iflastsingleappendix{APPENDIX.\space}{APPENDIX~\thechapter.\space}}
\newcommand{\ndsu@appendixbookmarkchapterlabel}{\ndsu@iflastsingleappendix{APPENDIX}{APPENDIX~\ndsu@saved@thechapter}}
\newcommand{\ndsu@appendixtocbookmarknumber}[1]{#1}
\newcommand{\ndsu@chapterlabel}{%
  \ifndsu@appendices\ndsu@appendixchapterlabel
  \else\ifndsu@nonumbered CHAPTER~\thechapter:\space\else\thechapter.\space\fi\fi}
\ExplSyntaxOn
\IfInstanceExistsTF {heading}{chapter} {} {
  \ClassError{ndsudisq}{Native tagged heading templates are unavailable}{Use LuaLaTeX with LaTeX 2026-06-01 or newer and DocumentMetadata tagging=on.}
}
\DeclareInstance{headformat}{ndsu-chapter}{hang}{heading-indent=0pt,number-title-sep=0pt,title-format=\MakeUppercase{#1}}
\DeclareInstance{heading}{chapter}{display}{name=chapter,level=0,placement=top,
 after-penalty-vspace=0pt,after-vspace=0pt,para-indent=true,
 number-format=\ndsu@chapterlabel,heading-decls=\normalfont\normalsize\bfseries\centering,
 headformat-instance=ndsu-chapter,mark-cmd=\chaptermark{#1}}
\DeclareInstance{headformat}{ndsu-subheading}{hang}{heading-indent=0pt,number-title-sep=0pt}
\cs_new_protected:Npn \ndsu_subheading:nnnn #1#2#3#4 {
 \DeclareInstance{heading}{#1}{display}{name=#1,level=#2,parent-name=#3,
  before-vspace=0pt,after-vspace=0pt,after-penalty-vspace=0pt,para-indent=true,
  number-format=\theheading.\space,heading-decls=\normalfont\normalsize #4,
  headformat-instance=ndsu-subheading}
}
\ndsu_subheading:nnnn {section}{1}{chapter}{\bfseries\centering}
\ndsu_subheading:nnnn {subsection}{2}{section}{\bfseries\raggedright}
\ndsu_subheading:nnnn {subsubsection}{3}{subsection}{\bfseries\itshape\raggedright}
\ndsu_subheading:nnnn {paragraph}{4}{subsubsection}{\itshape\raggedright}
% H6 is supported as upright left-aligned display text; differs from italic H5.
\ndsu_subheading:nnnn {subparagraph}{5}{paragraph}{\upshape\raggedright}
\RenewDocumentCommand\section{s o m}{\ndsu@subheadingneedspace\ParseLaTeXeHeading{section}{#1}{#2}{#3}}
\RenewDocumentCommand\subsection{s o m}{\ndsu@subheadingneedspace\ParseLaTeXeHeading{subsection}{#1}{#2}{#3}}
\RenewDocumentCommand\subsubsection{s o m}{\ndsu@subheadingneedspace\ParseLaTeXeHeading{subsubsection}{#1}{#2}{#3}}
\RenewDocumentCommand\paragraph{s o m}{\ndsu@subheadingneedspace\ParseLaTeXeHeading{paragraph}{#1}{#2}{#3}}
\RenewDocumentCommand\subparagraph{s o m}{\ndsu@subheadingneedspace\ParseLaTeXeHeading{subparagraph}{#1}{#2}{#3}}
\RenewDocumentCommand\chapter{s o m}{
 \IfBooleanF{#1}{
   \ndsu@startchapterreferences
   \ifndsu@appendices
    \stepcounter{ndsu@appendixchapters}
    \let\ndsu@saved@thechapter\thechapter
    \renewcommand{\thechapter}{\texorpdfstring{\ndsu@saved@thechapter}{\ndsu@appendixbookmarkchapterlabel}}
   \fi
 }
 \IfNoValueTF{#2}{\tl_set:Nn\l_tmpa_tl{#3}}{\tl_set:Nn\l_tmpa_tl{#2}}
 \tl_set:Nx\l_tmpb_tl{toc={\exp_not:N\MakeUppercase{\exp_not:V\l_tmpa_tl}},bookmark={\exp_not:N\MakeUppercase{\exp_not:V\l_tmpa_tl}}}
 \IfBooleanT{#1}{\tl_set:Nn\l_tmpb_tl{toc={},bookmark={}}}
 \exp_args:NnnV\ParseLaTeXeHeading{chapter}{#1}\l_tmpb_tl{#3}
 \IfBooleanF{#1}{\ifndsu@appendices
  \let\thechapter\ndsu@saved@thechapter
  \protected@edef\@currentlabel{\csname p@chapter\endcsname\thechapter}
 \fi}
}
\ExplSyntaxOff
\let\ndsu@standard@appendix\appendix
\newcommand{\appendicesmatter}{%
 \ifndsu@appendices\else
  \clearpage\ndsu@appendicestrue\setcounter{ndsu@appendixchapters}{0}%
  \ndsu@standard@appendix
  % Body numbering is a choice; appendix identifiers always include a letter.
  \ndsu@counterwithinchapter{table}\ndsu@counterwithinchapter{figure}%
  \ndsu@counterwithinchapter{schema}\ndsu@counterwithinchapter{listing}%
  \equationnumberingbychapter%
 \fi}
\renewcommand{\appendix}{\appendicesmatter}
\AtEndDocument{%
 \if@filesw\immediate\write\@auxout{\string\ndsu@setappendixchapters{\arabic{ndsu@appendixchapters}}}\fi
 \ifndsu@appendices\ifnum\value{ndsu@appendixchapters}=\ndsu@lastappendixchapters\relax\else
  \ClassWarningNoLine{ndsudisq}{Appendix count changed; rerun LuaLaTeX until headings, TOC and bookmarks settle}%
 \fi\fi}

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
 \UseHookWithArguments{cmd/@makecaption/before}{2}{#1}{#2}%
 \begingroup
  \singlespacing\normalfont\normalsize\upshape\raggedright
  \setlength{\parindent}{0pt}\setlength{\parskip}{0pt}%
  \UseTaggingSocket{caption/begin}{\@current@float@struct}%
  \ifcaption@star\else\UseTaggingSocket{recordtarget}\fi%
  \UseTaggingSocket{caption/label/begin}%
  {\bfseries #1.}\space
  \UseTaggingSocket{caption/label/end}%
  \UseTaggingSocket{para/begin}#2\par
  \UseTaggingSocket{caption/end}%
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
  \tagpdfsetup{float/here=true,float/new=schema,float/new=listing}%
  \AssignStructureRole{float/figure}{Div}%
  \AssignStructureRole{float/table}{Div}%
  \AssignStructureRole{float/schema}{Div}%
  \AssignStructureRole{float/listing}{Div}%
  \AssignStructureRole{float/generic}{Div}%
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
\NewDocumentCommand{\ndsufigurealt}{ m }{%
 \ClassWarning{ndsudisq}{Legacy ndsufigurealt cannot attach text to an image. Use ndsuincludegraphics[options]{meaningful alt text}{file}; this description was NOT embedded}%
}

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
\floatevery{schema}{\let\caption@@make\ndsu@makeleftcaption}
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
\newcommand{\listappendixtablename}{LIST OF APPENDIX TABLES}
\newcommand{\listappendixfigurename}{LIST OF APPENDIX FIGURES}
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
\newcommand{\ndsu@dottedfloatline}[2]{\@dottedtocline{1}{0pt}{0.5in}{\normalfont #1}{\normalfont #2}}
\newcommand{\ndsu@dottedtableline}[2]{\@dottedtocline{1}{0pt}{0.5in}{\normalfont #1}{\normalfont #2}}
\newcommand{\ndsu@dottedequationline}[2]{\@dottedtocline{1}{0pt}{0.5in}{\normalfont #1}{\normalfont #2}}
\newcommand{\ndsu@dottedschemaline}[2]{\@dottedtocline{1}{0pt}{0.5in}{\normalfont #1}{\normalfont #2}}


\providecommand{\ndsu@tocfile}{}
\newcommand{\ndsu@installappendixfloatlistredirects}{%
  \let\ndsu@standard@addcontentsline\addcontentsline
  \let\ndsu@standard@addtocontents\addtocontents
  \renewcommand{\addtocontents}[2]{%
    \edef\ndsu@tocfile{##1}%
    \ifndsu@appendices
      \ifdefstring{\ndsu@tocfile}{lot}{%
        \ndsu@standard@addtocontents{lat}{##2}%
      }{%
        \ifdefstring{\ndsu@tocfile}{lof}{%
          \ndsu@standard@addtocontents{laf}{##2}%
        }{%
          \ndsu@standard@addtocontents{##1}{##2}%
        }%
      }%
    \else
      \ndsu@standard@addtocontents{##1}{##2}%
    \fi
  }%
  \renewcommand{\addcontentsline}[3]{%
    \edef\ndsu@tocfile{##1}%
    \ifndsu@appendices
      \ifdefstring{\ndsu@tocfile}{lot}{%
        \ifstrequal{##2}{table}{%
          \ndsu@standard@addcontentsline{lat}{table}{##3}%
        }{%
          \ndsu@standard@addcontentsline{##1}{##2}{##3}%
        }%
      }{%
        \ifdefstring{\ndsu@tocfile}{lof}{%
          \ifstrequal{##2}{figure}{%
            \ndsu@standard@addcontentsline{laf}{figure}{##3}%
          }{%
            \ndsu@standard@addcontentsline{##1}{##2}{##3}%
          }%
        }{%
          \ndsu@standard@addcontentsline{##1}{##2}{##3}%
        }%
      }%
    \else
      \ndsu@standard@addcontentsline{##1}{##2}{##3}%
    \fi
  }%
}
\AtBeginDocument{\ndsu@installappendixfloatlistredirects}
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
% Native chapter templates own TOC/bookmark construction.
\newlength{\ndsuGeneratedListEntrySkip}
\setlength{\ndsuGeneratedListEntrySkip}{0.4\baselineskip plus 1pt minus 1pt}
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
    \rightskip=\@tocrmarg plus 1fil\relax
    \parfillskip=\z@
    \hyphenpenalty=\@M
    \exhyphenpenalty=\@M
    \microtypesetup{protrusion=false,expansion=false}%
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
    \rlap{%
      \hb@xt@\@tocrmarg{%
        \leaders\hbox{$\m@th
          \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
          mu$}\hfill
        \kern\ndsu@tocpagenumgap
        \normalfont\normalcolor
        \ndsu@contentslinepagebefore{#1}{#4}{#5}%
        #5%
        \ndsu@contentslinepageafter{#1}{#4}{#5}%
      }%
    }%
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
    \SuspendTagging{ndsu-toc-measure}%
    \setbox\z@\hbox{#1}%
    \ResumeTagging{ndsu-toc-measure}%
  \endgroup
}
\newcommand{\ndsu@chaptertocnumberline}[1]{%
  \hb@xt@\ndsu@currentchaptocnumwidth{\ndsu@tocchapternumberline{#1}\hfil}%
}
\newcommand{\ndsu@dottedtoclinehangwrap}[5]{%
  \ifnum #1>\c@tocdepth \else
    \vskip \z@ \@plus.2\p@
    {\leftskip #2\relax
    \rightskip=\@tocrmarg plus 1fil\relax
    \parfillskip=\z@
    \hyphenpenalty=\@M
    \exhyphenpenalty=\@M
    \microtypesetup{protrusion=false,expansion=false}%
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
    \rlap{%
        \hb@xt@\@tocrmarg{%
        \leaders\hbox{$\m@th
            \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
            mu$}\hfill
        \kern\ndsu@tocpagenumgap
        \normalfont\normalcolor
        \ndsu@contentslinepagebefore{#1}{#4}{#5}%
        #5%
        \ndsu@contentslinepageafter{#1}{#4}{#5}%
      }%
    }%
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
% Dimensions below use bp for physical spacing (72 bp = 1 inch).
% Each page is built once: measuring must not typeset a second copy of tagged
% content or bookmarks. Only the title's six major gaps may shrink, by at most
% 4 bp each; this exceptional fit is always reported for visual review.
\newcommand{\ndsu@centerheader}[1]{\begin{center}\bfseries #1\end{center}}
\newlength{\ndsu@titleblocksep}
\setlength{\ndsu@titleblocksep}{48bp minus 4bp}
\newlength{\ndsu@approvalblockwidth}
\newlength{\ndsu@approvalinsetwidth}
\newlength{\ndsu@paragraphsize}
\newlength{\ndsu@singleleading}
\newlength{\ndsu@specialpageheight}
\newlength{\ndsu@specialpageexcess}
\newlength{\ndsu@approvalfieldwidth}
\newlength{\ndsu@approvalfieldheight}
\newbox\ndsu@specialpagebox
\newbox\ndsu@approvaldatebox
\newbox\ndsu@approvalchairbox

\newcommand{\ndsu@specialpagesetup}{%
  \normalfont\normalsize
  \setstretch{1}% unlike \singlespacing, this adds no entry correction glue
  \setlength{\ndsu@paragraphsize}{\f@size pt}%
  \setlength{\ndsu@singleleading}{\baselineskip}%
  \setlength{\parindent}{0pt}%
  \setlength{\parskip}{0pt}%
  \setlength{\leftskip}{0pt}%
  \setlength{\rightskip}{0pt}%
  \setlength{\parfillskip}{0pt plus 1fil}%
  \microtypesetup{protrusion=false}% do not protrude beyond measured insets
  \ndsu@nohyphenationmode
}

\newcommand{\ndsu@finishspecialpage}[2]{%
  % Normalize depth to zero so a fitted box's total height is textheight,
  % including the last line's descenders, rather than textheight + depth.
  \setbox\ndsu@specialpagebox=\vbox{\unvbox\ndsu@specialpagebox\kern0pt}%
  \setlength{\ndsu@specialpageheight}{%
    \dimexpr\ht\ndsu@specialpagebox+\dp\ndsu@specialpagebox\relax}%
  \setlength{\ndsu@specialpageexcess}{%
    \dimexpr\ndsu@specialpageheight-\textheight\relax}%
  \ifdim\ndsu@specialpageexcess>0pt
    \ifdim\ndsu@specialpageexcess>#2\relax
      \ClassError{ndsudisq}{#1 does not fit within one page}{%
        The page exceeds the text area by \the\ndsu@specialpageexcess.
        \MessageBreak Fonts and margins have not been reduced.
        \MessageBreak Check the title, names, program option and committee entries;
        \MessageBreak remove accidental line breaks or obtain an approved layout
        \MessageBreak for content that cannot fit. Do not accept this output.}%
    \else
      \ClassWarning{ndsudisq}{#1 needs \the\ndsu@specialpageexcess\space
        of gap compression. The six title gaps remain at least 44bp;
        review the rendered page before acceptance}%
      \setbox\ndsu@specialpagebox=\vbox to \textheight{%
        \unvbox\ndsu@specialpagebox}%
    \fi
  \fi
  \par\nointerlineskip\box\ndsu@specialpagebox
}

\newcommand{\makecoverpage}{%
  \clearpage\thispagestyle{empty}%
  \begingroup
  \ndsu@specialpagesetup
  \setbox\ndsu@specialpagebox=\vbox{%
    \hsize=\textwidth\linewidth=\hsize
    \centering
    \phantomsection
    \NDSUAddTitlePdfBookmark
    \tagpdfparaOff\tagstructbegin{tag=H1}%
    \tagmcbegin{tag=H1}%
    {\doublespacing\MakeUppercase{\ndsutitle}\par}%
    \tagpdfsuppressmarks{\tagmcend}\tagstructend\tagpdfparaOn%
    \vskip\ndsu@titleblocksep
    A \ndsudocumenttype\par
    Submitted to the Graduate Faculty\par
    of the\par
    North Dakota State University\par
    of Agriculture and Applied Science\par
    \vskip\ndsu@titleblocksep
    By\par
    \vskip\ndsu@singleleading
    \ndsuauthor\par
    \vskip\ndsu@titleblocksep
    In Partial Fulfillment of the Requirements\par
    for the Degree of\par
    \MakeUppercase{\ndsudegree}\par
    \vskip\ndsu@titleblocksep
    \ndsumajorlabel:\par
    \ndsuprogram\par
    \ifdefempty{\ndsudegreeoption}{}{\ndsudegreeoption\par}%
    \vskip\ndsu@titleblocksep
    \ndsufinaldefense\par
    \vskip\ndsu@titleblocksep
    Fargo, North Dakota\par
  }%
  \ndsu@finishspecialpage{Title page}{24bp}%
  \endgroup
  \clearpage
}

% The following blocks begin/end at their measured box edges: there is no
% center-environment topsep, negative ex spacing, or hidden vfill between them.
\newcommand{\ndsu@approvalblock}[3]{%
  \par\nointerlineskip
  \hbox to \textwidth{\hfil
    \vbox{\hsize=#1\relax\linewidth=\hsize #2#3\par}%
    \hfil}%
}
\newcommand{\ndsu@approvalcenter}[2]{%
  \ndsu@approvalblock{#1}{\centering}{#2}%
}
\newcommand{\ndsu@approvalrule}[2]{%
  \par\nointerlineskip
  \hbox to \linewidth{\hfil\ndsuartifactcontent{\rule{#1}{#2}}\hfil}%
}
\newcommand{\ndsu@approvalsmallfont}{%
  \fontsize{\dimexpr\ndsu@paragraphsize-2pt\relax}{\ndsu@paragraphsize}\selectfont
}
\newcommand{\ndsu@approvalnamefont}{%
  \fontsize{\ndsu@paragraphsize}{\ndsu@singleleading}\selectfont
}
% Restored approval-page appearance, requested 2026-10-14.
% Preserve repaired co-chair labels, aligned final fields and overflow checks.
\newlength{\ndsu@approvalcommitteeskip}
\setlength{\ndsu@approvalcommitteeskip}{0.90in}
\newlength{\ndsu@approvalapprovedskip}
\setlength{\ndsu@approvalapprovedskip}{0.20in}
\newlength{\ndsu@approvallowerheight}
\setlength{\ndsu@approvallowerheight}{5.98in}
\newbox\ndsu@approvallowerbox
\newbox\ndsu@approvalheaderbox
\setlength{\ndsu@approvalblockwidth}{0.855\textwidth}
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

\newcommand{\ndsu@approvalfields}{%
  \setlength{\ndsu@approvalfieldwidth}{0.357\linewidth}%
  \setbox\ndsu@approvaldatebox=\vbox{%
    \hsize=\ndsu@approvalfieldwidth\linewidth=\hsize
    \ndsu@approvalnamefont\centering\strut\ndsuapprovaldate\par}%
  \setbox\ndsu@approvalchairbox=\vbox{%
    \hsize=\ndsu@approvalfieldwidth\linewidth=\hsize
    \ndsu@approvalnamefont\centering\strut\ndsudeptchair\par}%
  \setlength{\ndsu@approvalfieldheight}{%
    \dimexpr\ht\ndsu@approvaldatebox+\dp\ndsu@approvaldatebox\relax}%
  \ifdim\dimexpr\ht\ndsu@approvalchairbox+\dp\ndsu@approvalchairbox\relax
      >\ndsu@approvalfieldheight
    \setlength{\ndsu@approvalfieldheight}{%
      \dimexpr\ht\ndsu@approvalchairbox+\dp\ndsu@approvalchairbox\relax}%
  \fi
  \par\nointerlineskip
  \hbox to 0.9685\linewidth{%
    \vtop{\hsize=\ndsu@approvalfieldwidth\linewidth=\hsize
      \vbox to \ndsu@approvalfieldheight{\unvbox\ndsu@approvaldatebox\vfil}%
      \vskip 2bp
      \ndsu@approvalrule{\linewidth}{0.5bp}%
      \vskip 5.7bp\nointerlineskip
      {\fontsize{8pt}{10pt}\selectfont\centering Date\par}}%
    \hfil
    \vtop{\hsize=\ndsu@approvalfieldwidth\linewidth=\hsize
      \vbox to \ndsu@approvalfieldheight{\unvbox\ndsu@approvalchairbox\vfil}%
      \vskip 2bp
      \ndsu@approvalrule{\linewidth}{0.5bp}%
      \vskip 5.7bp\nointerlineskip
      {\fontsize{8pt}{10pt}\selectfont\centering Department Chair\par}}%
  }%
}

\newcommand{\makeapprovalpage}{%
  \clearpage\thispagestyle{empty}%
  \begingroup
  \ndsu@specialpagesetup
  \singlespacing
  \begin{ndsu@nohyphenation}
  \setlength{\parindent}{0pt}%
  \hyphenpenalty=10000
  \exhyphenpenalty=10000
  % Measure the actual content; fixed outer heights must not hide overflow.
  \setbox\ndsu@approvalheaderbox=\vbox{%
  \kern\topskip
  \noindent\begin{minipage}[t]{\textwidth}
  \vspace*{0pt}%
  
  \begin{center}
    {\fontsize{18pt}{22pt}\selectfont
    North Dakota State University\par}
    \vspace{\dimexpr0.02in+5pt\relax}
    {\fontsize{14pt}{18pt}\selectfont
    Graduate School\par}
  \end{center}

  \vspace{-1.5\baselineskip}
  \noindent\ndsuartifactcontent{\rule{\textwidth}{1.6pt}}
  \vspace{0.15\baselineskip}

  \begin{center}
    {\fontsize{10pt}{12pt}\selectfont\textbf{Title}\par}
    \vspace{\dimexpr0.08in+5pt\relax}

    \begin{minipage}{\ndsu@approvalblockwidth}
      \centering
      \ndsutitle\par
      \vspace{-1.5ex}
      \ndsuartifactcontent{\rule{\linewidth}{0.4pt}}
    \end{minipage}

    \vspace{\dimexpr0.12in+5pt\relax}

    {\fontsize{10pt}{12pt}\selectfont\textbf{By}\par}
    \vspace{\dimexpr0.08in+5pt\relax}

    \begin{minipage}{\ndsu@approvalblockwidth}
      \centering
      \ndsuauthor\par
      \vspace{-1.5ex}
      \ndsuartifactcontent{\rule{\linewidth}{0.4pt}}
    \end{minipage}
  \end{center}

  \vspace{0.12in}

  \end{minipage}\par\kern0pt
  }%
  % Keep final fields at the bottom while allowing wrapped headings above.
  \setlength{\ndsu@approvallowerheight}{%
    \dimexpr\textheight-\ht\ndsu@approvalheaderbox-\dp\ndsu@approvalheaderbox\relax}%
  % Typeset the lower block once, then stretch only its existing vfill.
  \setbox\ndsu@approvallowerbox=\vbox{%
    \hsize=\ndsu@approvalblockwidth\linewidth=\hsize
    \@parboxrestore
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

    \ifdefempty{\ndsucommitteecochair}{%
      \ndsu@signatureentry{\ndsucommitteechair}{Chair}%
    }{%
      \ndsu@signatureentry{\ndsucommitteechair}{Co-chair}%
      \par\vspace{0.20in}%
      \ndsu@signatureentry{\ndsucommitteecochair}{Co-chair}%
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

    \ndsu@approvalfields
    \par\kern0pt
  }%
  \ifdim\dimexpr\ht\ndsu@approvallowerbox+\dp\ndsu@approvallowerbox\relax
      >\ndsu@approvallowerheight
    \ClassError{ndsudisq}{Approval page does not fit within one page}{%
      The committee and approval fields exceed the restored layout.
      \MessageBreak Fonts and margins have not been reduced.
      \MessageBreak Obtain an approved layout for the longer content.}%
  \fi
  \setbox\ndsu@specialpagebox=\vbox{%
    \unvbox\ndsu@approvalheaderbox
    \nointerlineskip
    \hbox to \textwidth{\hfil
      \vbox to \ndsu@approvallowerheight{\unvbox\ndsu@approvallowerbox}%
      \hfil}%
  }%
  \ndsu@finishspecialpage{Approval page}{0pt}%
  \end{ndsu@nohyphenation}
  \endgroup
  \clearpage
}

% --- Front matter/main matter/references ---
\newcommand{\ndsuprefatoryheading}[1]{\chapter*{\MakeUppercase{#1}}\addcontentsline{toc}{frontmatter}{\texorpdfstring{\MakeUppercase{#1}}{\MakeUppercase{#1}}}}
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
% Empty list suppression uses settled previous-pass counts. Rerun when counts change.
\newcommand{\ndsu@setlistcount}[2]{\expandafter\gdef\csname ndsu@previous@#1\endcsname{#2}}
\newcommand{\ndsu@itemlist}[3]{%
 \ifnum\csname ndsu@previous@#1\endcsname>0\relax
  \chapter*{#2}\addcontentsline{toc}{frontmatter}{#2}%
  \ndsu@listheader{#3}{Page}\@starttoc{#1}\clearpage
 \else
  \begingroup\let\contentsline\@gobblefour\@starttoc{#1}\endgroup
 \fi}
\newcommand{\ndsu@initlistcount}[1]{%
 \expandafter\gdef\csname ndsu@previous@#1\endcsname{0}%
 \expandafter\newcount\csname ndsu@current@#1\endcsname}
\forcsvlist{\ndsu@initlistcount}{lot,lof,loe,los,lol,lat,laf,lal}
\AtBeginDocument{%
 \let\ndsu@countedaddcontentsline\addcontentsline
 \renewcommand{\addcontentsline}[3]{%
  \edef\ndsu@destination{#1}%
  \ifndsu@appendices
   \ifdefstring{\ndsu@destination}{lot}{\def\ndsu@destination{lat}}{}%
   \ifdefstring{\ndsu@destination}{lof}{\def\ndsu@destination{laf}}{}%
   \ifdefstring{\ndsu@destination}{lol}{\def\ndsu@destination{lal}}{}%
  \fi
  \ifcsname ndsu@current@\ndsu@destination\endcsname
   \global\advance\csname ndsu@current@\ndsu@destination\endcsname by1\relax
  \fi
  \ifdefstring{\ndsu@destination}{lal}{%
   \ifndsu@appendices\ndsu@countedaddcontentsline{lal}{#2}{#3}%
   \else\ndsu@countedaddcontentsline{#1}{#2}{#3}\fi
  }{\ndsu@countedaddcontentsline{#1}{#2}{#3}}%
 }}
\newcommand{\ndsu@writelistcount}[1]{%
 \ifnum\csname ndsu@previous@#1\endcsname=\csname ndsu@current@#1\endcsname\else
  \ClassWarningNoLine{ndsudisq}{List #1 changed; rerun LuaLaTeX until front matter settles}%
 \fi
 \if@filesw\immediate\write\@auxout{\string\ndsu@setlistcount{#1}{\the\csname ndsu@current@#1\endcsname}}\fi}
\AtEndDocument{\forcsvlist{\ndsu@writelistcount}{lot,lof,loe,los,lol,lat,laf,lal}}
\providecommand{\l@listing}[2]{\ndsu@rendertocentry{\ndsu@dottedfloatline}{\ndsu@floatlistnumberline}{#1}{#2}}

\newcommand{\makefrontmatter}{%
  \frontmattersetup
  \makecoverpage
  \makeapprovalpage
  \ndsu@inputrequiredfrontmatter{frontmatter/abstract.tex}%
  \ifndsu@includeAcknowledgments\ndsu@inputoptionalfrontmatter{frontmatter/acknowledgments.tex}\fi
  \ifndsu@includeDedication\ndsu@inputoptionalfrontmatter{frontmatter/dedication.tex}\fi
  
  \ifndsu@includePreface\ndsu@inputoptionalfrontmatter{frontmatter/preface.tex}\fi
  
  \tableofcontents
  \clearpage
  \ifndsu@includeListOfTables\ndsu@itemlist{lot}{LIST OF TABLES}{Table}\fi
  \ifndsu@includeListOfFigures\ndsu@itemlist{lof}{LIST OF FIGURES}{Figure}\fi
  \ifndsu@includeListOfEquations\ndsu@itemlist{loe}{\listequationname}{Equation}\fi
  \ifndsu@includeListOfSchemas\ndsu@itemlist{los}{\listschemaname}{Schema}\fi
  \ifndsu@includeListOfListings\ndsu@itemlist{lol}{LIST OF LISTINGS}{Listing}\fi
  \ifndsu@includeAbbreviations\ndsu@inputoptionalfrontmatter{frontmatter/abbreviations.tex}\fi

\ifndsu@includeSymbols\ndsu@inputoptionalfrontmatter{frontmatter/symbols.tex}\fi

    \ifndsu@includeAppendixTables\ndsu@itemlist{lat}{\listappendixtablename}{Table}\fi
  \ifndsu@includeAppendixFigures\ndsu@itemlist{laf}{\listappendixfigurename}{Figure}\fi
  \ifndsu@includeAppendixListings\ndsu@itemlist{lal}{LIST OF APPENDIX LISTINGS}{Listing}\fi
}
\newcommand{\mainmattersetup}{\ndsu@normalhyphenationmode\clearpage\pagenumbering{arabic}\setcounter{page}{1}}

% Track chapter citations as segments within one shared bibliography section.
% Native tagged chapter headings bypass biblatex's legacy chapter-head hooks.
\newcommand{\ndsu@startchapterreferences}{%
  \@ifpackageloaded{biblatex}{\endrefsegment\refsegment}{}%
}
\NewDocumentCommand{\printchapterreferences}{ O{References} }{%
  \@ifpackageloaded{biblatex}{%
    \ifnum\value{refsegment}>0\relax
      \printbibliography[heading=ndsuchapterreferences,segment=\therefsegment,title={#1}]%
    \else
      \ClassError{ndsudisq}{No current chapter bibliography segment}{Place \string\printchapterreferences\space at the end of a numbered chapter, before the next chapter.}%
    \fi
  }{\ClassError{ndsudisq}{\string\printchapterreferences\space requires biblatex}{Load biblatex and add a bibliography resource in the preamble.}}%
}
\newcommand{\ndsureferencesname}{REFERENCES}
\newcommand{\referencesheading}[1]{\renewcommand{\ndsureferencesname}{#1}}
\newcommand{\ndsu@referencesheading}[1]{%
  \chapter*{\MakeUppercase{#1}}%
  \phantomsection
  \addcontentsline{toc}{references}{\texorpdfstring{\MakeUppercase{#1}}{\MakeUppercase{#1}}}%
}
\AtBeginDocument{%
  \@ifpackageloaded{biblatex}{%
    \defbibheading{ndsureferences}[\ndsureferencesname]{\ndsu@referencesheading{#1}}%
    \defbibheading{ndsuchapterreferences}[References]{%
      \subsection*{#1}%
      \addcontentsline{toc}{subsection}{#1}%
    }%
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
\setlength{\ndsuAbbrevItemSep}{\ndsuGeneratedListEntrySkip}
\NewDocumentEnvironment{ndsuabbreviations}{ O{3.0in} }
  {%
    \par
    \begingroup
    \setlength{\ndsuAbbrevLabelWidth}{#1}%
    \setlength{\parindent}{0pt}%
    \setlength{\parskip}{0pt}%
    \setstretch{1}\selectfont
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
\newlength{\ndsu@codeafterskip}

\AtBeginDocument{%
  \setlength{\ndsu@codebeforeskip}{0.33\baselineskip}%
  \setlength{\ndsu@codeafterskip}{0.5\baselineskip}%
}

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

% Line-number formatting for numbered code listings
\renewcommand{\theFancyVerbLine}{%
  \normalfont
  \fontsize{8pt}{12pt}\selectfont
  \arabic{FancyVerbLine}%
}

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
  % A boxed listing caption needs single leading, not a transition blank line.
  \let\ndsu@savedSingleSpacing\singlespacing
  \def\singlespacing{\setstretch{\setspace@singlespace}}%
  \captionof{listing}{#1}%
  \let\singlespacing\ndsu@savedSingleSpacing
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
% Typeset once: preserve caption counters and tagged content while measuring.
\newbox\ndsu@codebox
\newcommand{\ndsu@placecodebox}{%
  \ifdim\dimexpr\ht\ndsu@codebox+\dp\ndsu@codebox\relax>\textheight
    \Needspace{6\baselineskip}% Truly long listings may span pages.
    \addvspace{\ndsu@codebeforeskip}%
    \unvbox\ndsu@codebox
    \par\addvspace{\ndsu@codeafterskip}%
  \else
    \begin{listing}[htbp]% Allow subsequent prose to fill the current page.
      \box\ndsu@codebox
    \end{listing}
  \fi
}
% Supply a note before the listing so its height participates in pagination.
\newcommand{\ndsu@listingnote}{}
\newcommand{\nextcodelistingnote}[1]{\gdef\ndsu@listingnote{#1}}
\newenvironment{ndsucodelisting}[1][]{%
  \VerbatimEnvironment
  \par
  \setbox\ndsu@codebox=\vbox\bgroup
  \hsize=\linewidth
  \ndsu@codelistingcaption{#1}%
  \setstretch{1}%
  \begin{Verbatim}[fontsize=\small,numbers=left,numbersep=\ndsu@codenumbersep,xleftmargin=\ndsu@codelistingxleftmargin,frame=single,breaklines=true,breakanywhere=true,breaksymbolleft={},breakanywheresymbolpre={},breakanywheresymbolpost={},listparameters={\ndsu@codeverbatimlistparameters}]%
}{%
  \end{Verbatim}%
  \par
  \ifx\ndsu@listingnote\@empty\else
    \ndsucodenote{\ndsu@listingnote}%
  \fi
  \egroup
  \ndsu@placecodebox
  \global\let\ndsu@listingnote\@empty
  \par
}

% fvextra wraps source lines in implementation parboxes. Keep those boxes
% inside one explicitly tagged source-code line, without prose subparagraphs.
\let\ndsu@fvextra@breakline\FV@ListProcessLine@Break
\def\FV@ListProcessLine@Break#1{%
  \hbox to \hsize{%
    \tagpdfparaOff
    \AssignTaggingSocketPlug{parbox/before}{noop}%
    \AssignTaggingSocketPlug{parbox/after}{noop}%
    \AssignTaggingSocketPlug{para/restore}{noop}%
    \UseTaggingSocket{struct-mc}{tag=\UseStructureName{block/verbatim/codeline}}{%
      \ndsu@fvextra@breakline{#1}%
    }%
  }\FV@bgcoloroverlap\baselineskip\z@\lineskip\z@
}

\newcommand{\ndsucodenote}[1]{\ndsunote{#1}}

% Apply the default chapter-based float/list counter policy after all counters
% have been defined. Preamble calls such as \usecontinuouscaptions can still
% override this default after \documentclass.
\AtEndOfClass{\usechaptercaptions}

% --- End-of-class cleanup ---
% Longtable builds captions in spanning cells rather than through @makecaption.
% The primary caption belongs to the Table. Repeated continuation captions
% are artifacts, as the table already has its complete accessible caption.
% Keep the caption outside the row-indexed native longtable finalizer,
% then restore it before the first retained row.

\ExplSyntaxOn
\tl_new:N\g_ndsu_lt_caption_table_tl
\tl_new:N\g_ndsu_lt_caption_kid_tl
\tl_new:N\g_ndsu_lt_caption_row_tl
\cs_new_protected:Npn\ndsu@saveLTCaption{
  \tl_gset_eq:NN\g_ndsu_lt_caption_table_tl\g__tbl_struct_table_tl
  \seq_gpop_right:cN{g__tag_struct_kids_\g__tbl_struct_table_tl _seq}\g_ndsu_lt_caption_kid_tl
  \tl_gset:Ne\g_ndsu_lt_caption_row_tl{
    \pdf_object_ref_indexed:nn{__tag/struct}{\seq_item:Nn\g__tbl_struct_rows_seq{-1}}
  }
}
\cs_generate_variant:Nn\seq_gremove_all:Nn{cV}
\cs_new_protected:Npn\ndsu@restoreLTCaption{
  \tl_if_empty:NF\g_ndsu_lt_caption_kid_tl{
    \seq_gremove_all:cV{g__tag_struct_kids_\g_ndsu_lt_caption_table_tl _seq}\g_ndsu_lt_caption_row_tl
    \seq_gput_left:cV{g__tag_struct_kids_\g_ndsu_lt_caption_table_tl _seq}\g_ndsu_lt_caption_kid_tl
    \tl_gclear:N\g_ndsu_lt_caption_kid_tl
  }
}
\ExplSyntaxOff
\AfterEndEnvironment{longtable}{\ndsu@restoreLTCaption}

\newif\ifndsu@ltcaptionseen
\BeforeBeginEnvironment{longtable}{\global\ndsu@ltcaptionseenfalse}
\long\def\ndsu@LTmakecaption#1#2#3{%
  \LT@mcol\LT@cols{@{}l@{}}{%
    \AssignTaggingSocketPlug{parbox/before}{noop}%
    \AssignTaggingSocketPlug{parbox/after}{noop}%
    \hbox to\z@{\parbox[t]\LTcapwidth{%
      \setstretch{1}\normalfont\normalsize\raggedright
      \setlength{\parindent}{0pt}\setlength{\parskip}{0pt}%
      \def\@captype{table}%
      \ifndsu@ltcaptionseen
        \tagpdfparaOff\tagmcbegin{artifact}%
        #1{\textbf{#2.}\space}#3\par\tagmcend
      \else
        \global\ndsu@ltcaptionseentrue
        \UseTaggingSocket{caption/begin}{\csname g__tbl_struct_table_tl\endcsname}%
        #1{\UseTaggingSocket{caption/label/begin}%
          \textbf{#2.}\space\UseTaggingSocket{caption/label/end}}%
        \UseTaggingSocket{para/begin}#3\par
        \UseTaggingSocket{caption/end}%
        \ndsu@saveLTCaption%
      \fi
      \vskip\baselineskip
    }\hss}%
  }%
}

\AtBeginDocument{\let\LT@makecaption\ndsu@LTmakecaption}

\makeatother
