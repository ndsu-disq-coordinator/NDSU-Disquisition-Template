# Run from PowerShell after installing LuaLaTeX, Biber, dependencies and Times New Roman.
$ErrorActionPreference = 'Stop'
Push-Location -LiteralPath $PSScriptRoot
try {
    $taskLua = (Get-Command lualatex -ErrorAction Stop).Source
    $taskBiber = (Get-Command biber -ErrorAction Stop).Source
    & $taskLua -no-shell-escape -interaction=nonstopmode -halt-on-error -file-line-error -recorder main.tex
    if ($LASTEXITCODE -ne 0) { throw 'First LuaLaTeX pass failed; inspect main.log.' }
    & $taskBiber main
    if ($LASTEXITCODE -ne 0) { throw 'Biber failed; inspect main.blg.' }
    # Settle bibliography, front-matter lists, appendix counts and links.
    for ($taskPass = 1; $taskPass -le 3; $taskPass++) {
        & $taskLua -no-shell-escape -interaction=nonstopmode -halt-on-error -file-line-error -recorder main.tex
        if ($LASTEXITCODE -ne 0) { throw 'LuaLaTeX failed; inspect main.log.' }
    }
    Write-Output 'Built main.pdf. Review diagnostics and the PDF before submission.'
}
finally { Pop-Location }
