$ErrorActionPreference = "Stop"
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $RepoRoot

$LibPath = "dsg/ext/lib.scad.clamps"
$LibUrl  = "https://github.com/brainboxemb/lib.scad.clamps.git"

if (Test-Path (Join-Path $LibPath ".git")) {
    Write-Host "Library already initialized: $LibPath"
    exit 0
}

if (Test-Path $LibPath) {
    $items = Get-ChildItem $LibPath -Force -ErrorAction SilentlyContinue
    if ($items.Count -gt 0) { throw "$LibPath already contains files." }
    Remove-Item $LibPath -Force
}

git submodule add $LibUrl $LibPath
git submodule update --init --recursive
Write-Host "Library initialized. Commit .gitmodules and the submodule entry."
