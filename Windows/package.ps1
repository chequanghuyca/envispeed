# Package an existing Release build. The architecture and version come from the EXE.
param(
    [string]$Exe = "$PSScriptRoot/build/App/Envispeed.exe",
    [string]$Iscc
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot/..").Path
$binary = Get-Item -LiteralPath $Exe
if ($binary.Name -ne 'Envispeed.exe') { throw 'Expected Envispeed.exe.' }

$reader = [IO.BinaryReader]::new($binary.OpenRead())
try {
    if ($reader.ReadUInt16() -ne 0x5a4d) { throw 'Invalid executable header.' }
    $reader.BaseStream.Position = 0x3c
    $reader.BaseStream.Position = $reader.ReadInt32()
    if ($reader.ReadUInt32() -ne 0x4550) { throw 'Invalid PE signature.' }
    $arch = switch ($reader.ReadUInt16()) {
        0x8664 { 'x64' }
        0xaa64 { 'arm64' }
        default { throw 'The installer supports only x64 and ARM64 builds.' }
    }
}
finally {
    $reader.Dispose()
}

$version = $binary.VersionInfo.ProductVersion
if ($binary.VersionInfo.ProductName -ne 'Envispeed' -or $version -notmatch '^\d+\.\d+\.\d+$') {
    throw 'Envispeed version metadata is missing. Rebuild the Release target.'
}

if (-not $Iscc) {
    $Iscc = (Get-Command ISCC.exe -CommandType Application -ErrorAction SilentlyContinue).Source
}
if (-not $Iscc) {
    $Iscc = @(
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe"
        "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
        "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
    ) | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
}
if (-not $Iscc) { throw 'Inno Setup 6.3+ is required. Pass -Iscc with the path to ISCC.exe.' }

$dist = Join-Path $root 'dist/windows'
$staging = Join-Path $dist ".package-$([guid]::NewGuid())"
$installer = "Envispeed-$version-$arch-Setup.exe"
$portable = "Envispeed-$version-$arch-portable.zip"
New-Item -ItemType Directory -Path $staging -Force | Out-Null
try {
    & $Iscc "/DVersion=$version" "/DArch=$arch" "/DSrc=$($binary.DirectoryName)" "/O$staging" "$PSScriptRoot/installer/Envispeed.iss"
    if ($LASTEXITCODE -ne 0) { throw 'Inno Setup compilation failed.' }
    if (-not (Test-Path -LiteralPath "$staging/$installer" -PathType Leaf)) { throw "Installer output missing: $installer" }

    Compress-Archive -LiteralPath @($binary.FullName, "$root/LICENSE", "$root/ACKNOWLEDGEMENTS.md") -DestinationPath "$staging/$portable"
    Move-Item -LiteralPath @("$staging/$installer", "$staging/$portable") -Destination $dist -Force
    Write-Host "Installer: $dist/$installer"
    Write-Host "Portable: $dist/$portable"
}
finally {
    Remove-Item -LiteralPath $staging -Recurse -Force
}
