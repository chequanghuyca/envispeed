# From a Visual Studio Developer PowerShell, or reuse matching CI binaries with -SkipBuild.
param([string]$BuildDir = "$PSScriptRoot/build", [switch]$SkipBuild)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath "$PSScriptRoot/..").Path
$tools = Join-Path $root 'Tools/autoswitch'
$build = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($BuildDir)

if (-not $SkipBuild) {
    cmake -S "$root/Windows" -B $build -G Ninja -DCMAKE_BUILD_TYPE=Release
    if ($LASTEXITCODE -ne 0) { throw 'CMake configure failed.' }
    cmake --build $build --config Release
    if ($LASTEXITCODE -ne 0) { throw 'Build failed.' }
}
foreach ($tool in 'harness', 'sim', 'undo_test', 'drvlazy', 'bench') {
    if (-not (Test-Path -LiteralPath "$build/tools/$tool.exe" -PathType Leaf)) {
        throw "Missing test binary: $build/tools/$tool.exe. Build first or download the matching CI test tools."
    }
}

$temp = Join-Path ([IO.Path]::GetTempPath()) "envispeed-check-$([guid]::NewGuid())"
New-Item -ItemType Directory -Path $temp | Out-Null
$vars = @{
    PYTHONUTF8 = '1'
    PYTHONIOENCODING = 'utf-8'
    TMPDIR = $temp
    ENVISPEED_HARNESS = "$build/tools/harness.exe"
    ENVISPEED_SIM = "$build/tools/sim.exe"
    ENVISPEED_TELEX_STYLE = $null
    DRV_OUT = "$temp/driver.txt"
}
$saved = @{}
foreach ($key in $vars.Keys) {
    $saved[$key] = [Environment]::GetEnvironmentVariable($key)
    [Environment]::SetEnvironmentVariable($key, $vars[$key])
}

try {
    python "$tools/rules/run_rules.py"
    if ($LASTEXITCODE -ne 0) { throw 'Default Telex rules failed.' }
    foreach ($style in 1, 2) {
        $env:ENVISPEED_TELEX_STYLE = [string]$style
        python "$tools/rules/run_rules.py" "telex_simple$style.tsv"
        if ($LASTEXITCODE -ne 0) { throw "Simple Telex $style rules failed." }
    }
    Remove-Item Env:ENVISPEED_TELEX_STYLE
    python "$tools/rules/run_reported.py"
    if ($LASTEXITCODE -ne 0) { throw 'Reported regressions failed.' }
    python "$tools/rules/golden.py" check
    if ($LASTEXITCODE -ne 0) { throw 'Golden snapshots failed.' }
    & "$build/tools/undo_test.exe"
    if ($LASTEXITCODE -ne 0) { throw 'Undo tests failed.' }

    $units = "$temp/chat.units"
    $prep = @'
import subprocess, sys
prep, corpus, output = sys.argv[1:]
with open(output, 'wb') as f:
    subprocess.run([sys.executable, prep, corpus], stdout=f, check=True)
'@
    python -c $prep "$tools/sim/prep.py" "$tools/sim/corpus/chat_messages.txt" $units
    if ($LASTEXITCODE -ne 0) { throw 'Preparing the test corpus failed.' }

    $dump = "$temp/sim.txt"
    & "$build/tools/drvlazy.exe" $units --start vi
    if ($LASTEXITCODE -ne 0) { throw 'Driver simulation failed.' }
    & $env:ENVISPEED_SIM $units --start vi --lazy --dump $dump | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'Engine simulation failed.' }

    $compare = @'
import pathlib, re, sys
driver = pathlib.Path(sys.argv[1]).read_text(encoding='utf-8')
rows = pathlib.Path(sys.argv[2]).read_text(encoding='utf-8').splitlines()
sim = ''.join(row.split(chr(9), 1)[0] for row in rows)
letters = lambda s: re.sub(r'[\W\d_]+', '', s)
ok = bool(letters(driver)) and letters(driver) == letters(sim)
print('driver == simulator:', 'ok' if ok else 'FAIL')
sys.exit(0 if ok else 1)
'@
    python -c $compare $env:DRV_OUT $dump
    if ($LASTEXITCODE -ne 0) { throw 'Driver and simulator output differ.' }

    foreach ($attempt in 1..3) {
        & "$build/tools/bench.exe" $units 1000 20000
        if ($LASTEXITCODE -eq 0) { break }
    }
    if ($LASTEXITCODE -ne 0) { throw 'Performance budget exceeded.' }
    Write-Host 'ALL CHECKS PASSED'
}
finally {
    foreach ($key in $saved.Keys) {
        [Environment]::SetEnvironmentVariable($key, $saved[$key])
    }
    Remove-Item -LiteralPath $temp -Recurse -Force
}
