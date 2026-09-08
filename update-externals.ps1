$ErrorActionPreference = "Stop"

function Get-ExternalSubmodules {
    $rows = @()
    $lines = git config -f .gitmodules --get-regexp '^submodule\..*\.path$'

    foreach ($line in $lines) {
        if ($line -match '^submodule\.(.+)\.path\s+(.+)$') {
            $name = $Matches[1]
            $path = $Matches[2]

            # Tooling is pinned separately. This command intentionally updates
            # only CAD/library externals below the project's external tree.
            if ($path -notlike "dsg/*/ext/*") {
                continue
            }

            $rows += [PSCustomObject]@{
                Name = $name
                Path = $path
            }
        }
    }

    return $rows
}

function Assert-Clean {
    param([string]$Path)

    $status = git -C $Path status --porcelain
    if ($status) {
        throw "External '$Path' has local changes. Commit, stash or discard them first."
    }
}

if (-not (Test-Path ".gitmodules")) {
    throw ".gitmodules not found."
}

git submodule sync --recursive
git submodule update --init --recursive

$externals = @(Get-ExternalSubmodules)
if ($externals.Count -eq 0) {
    Write-Host "No CAD/library externals found below dsg/*/ext/."
    exit 0
}

$updates = @()

foreach ($external in $externals) {
    $path = $external.Path
    Assert-Clean -Path $path

    $oldCommit = (git -C $path rev-parse HEAD).Trim()

    git -C $path fetch --prune --tags origin

    $remoteHead = git -C $path symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>$null
    if (-not $remoteHead) {
        throw "Cannot determine origin default branch for '$path'."
    }

    $branch = $remoteHead -replace '^origin/', ''

    git -C $path show-ref --verify --quiet "refs/heads/$branch"
    if ($LASTEXITCODE -eq 0) {
        git -C $path checkout $branch
    }
    else {
        git -C $path checkout -b $branch --track "origin/$branch"
    }

    git -C $path pull --ff-only origin $branch

    $newCommit = (git -C $path rev-parse HEAD).Trim()

    $updates += [PSCustomObject]@{
        Name    = $external.Name
        Path    = $path
        Branch  = $branch
        Old     = $oldCommit
        New     = $newCommit
        Changed = ($oldCommit -ne $newCommit)
    }
}

Write-Host ""
Write-Host "External update summary"
Write-Host "======================="

foreach ($update in $updates) {
    Write-Host ""
    if ($update.Changed) {
        Write-Host $update.Name
        Write-Host "  path   : $($update.Path)"
        Write-Host "  branch : $($update.Branch)"
        Write-Host "  old    : $($update.Old)"
        Write-Host "  new    : $($update.New)"
    }
    else {
        Write-Host "$($update.Name) - unchanged ($($update.New))"
    }
}

Write-Host ""
Write-Host "Parent repository status:"
git status --short
Write-Host ""
Write-Host "Review the changed external gitlinks before committing them."
Write-Host "Tooling under tools/ is intentionally not updated by this script."
