<#
.SYNOPSIS
    Native Windows / PowerShell Manim CE project starter using uv.

.DESCRIPTION
    Run this from an empty project directory opened in Visual Studio Code.
    It installs/checks Windows dependencies with winget, installs uv, creates a uv-managed
    Manim CE project, adds common Manim/voiceover packages, configures VS Code, and runs
    uv run manim checkhealth.

.USAGE
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    .\manim-project-starter.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ============================================================
# Configuration
# ============================================================

$PythonVersion = if ($env:PYTHON_VERSION) { $env:PYTHON_VERSION } else { "3.11" }
$ProjectSceneFile = if ($env:PROJECT_SCENE_FILE) { $env:PROJECT_SCENE_FILE } else { "main.py" }
$ProjectSceneClass = if ($env:PROJECT_SCENE_CLASS) { $env:PROJECT_SCENE_CLASS } else { "StarterScene" }

# Voiceover extras: intentionally omits Coqui by default because it is heavy and often
# creates platform-specific PyTorch/version friction. Set INSTALL_COQUI=1 to try it.
$VoiceoverExtras = "azure,gtts,pyttsx3,recorder,openai,elevenlabs"
$InstallCoqui = if ($env:INSTALL_COQUI) { $env:INSTALL_COQUI } else { "0" }

# ============================================================
# Logging helpers
# ============================================================

function Write-Info($Message) { Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Ok($Message) { Write-Host "[OK] $Message" -ForegroundColor Green }
function Write-Warn($Message) { Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Err($Message) { Write-Host "[ERROR] $Message" -ForegroundColor Red }
function Write-Section($Message) {
    Write-Host ""
    Write-Host $Message -ForegroundColor White -BackgroundColor DarkBlue
}

function Test-Command($Name) {
    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Add-UserPath($PathToAdd) {
    if ([string]::IsNullOrWhiteSpace($PathToAdd)) { return }
    if (-not (Test-Path $PathToAdd)) { return }

    $currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ([string]::IsNullOrWhiteSpace($currentUserPath)) {
        $currentUserPath = ""
    }

    $pathParts = $currentUserPath -split ";" | Where-Object { $_ -ne "" }
    if ($pathParts -notcontains $PathToAdd) {
        [Environment]::SetEnvironmentVariable("Path", "$currentUserPath;$PathToAdd", "User")
        Write-Ok "Added to Windows User PATH: $PathToAdd"
    }

    $envParts = $env:Path -split ";" | Where-Object { $_ -ne "" }
    if ($envParts -notcontains $PathToAdd) {
        $env:Path = "$env:Path;$PathToAdd"
    }
}

function Install-WingetPackageIfMissing($PackageId, $CommandName, $Label) {
    if (Test-Command $CommandName) {
        Write-Ok "$Label already available."
        return
    }

    if (-not (Test-Command "winget")) {
        Write-Warn "winget not found. Install $Label manually: $PackageId"
        return
    }

    Write-Info "Installing $Label with winget: $PackageId"
    try {
        winget install -e --id $PackageId --accept-package-agreements --accept-source-agreements
    }
    catch {
        Write-Warn "winget could not install $Label. You may need to run PowerShell as Administrator or install it manually."
    }
}

function Get-UvExecutable {
    $uvCmd = Get-Command "uv" -ErrorAction SilentlyContinue
    if ($uvCmd) { return $uvCmd.Source }

    $candidatePaths = @(
        Join-Path $env:USERPROFILE ".local\bin\uv.exe",
        Join-Path $env:USERPROFILE ".cargo\bin\uv.exe"
    )

    foreach ($candidate in $candidatePaths) {
        if (Test-Path $candidate) { return $candidate }
    }

    return $null
}

function Invoke-Uv($Arguments) {
    $uvExe = Get-UvExecutable
    if (-not $uvExe) {
        throw "uv executable not found."
    }
    & $uvExe @Arguments
}

# ============================================================
# Start
# ============================================================

Write-Section "Manim CE PowerShell project starter"
Write-Info "Current directory: $(Get-Location)"
Write-Info "This script will set up this directory as a uv-managed Manim CE project."

# ============================================================
# Basic prerequisite checks
# ============================================================

Write-Section "Checking basic prerequisites"

if (Test-Command "curl.exe") {
    Write-Ok "curl.exe available."
}
else {
    Write-Warn "curl.exe is missing. Modern Windows usually includes it. Install Git for Windows or curl manually if uv installation fails."
}

if (Test-Command "python") {
    Write-Ok "Python available: $((python --version) 2>&1)"
}
elseif (Test-Command "py") {
    Write-Ok "Python launcher available: $((py --version) 2>&1)"
}
else {
    Install-WingetPackageIfMissing "Python.Python.3.11" "python" "Python $PythonVersion"
}

# ============================================================
# Windows system dependencies
# ============================================================

Write-Section "Checking/installing Windows system dependencies"

Install-WingetPackageIfMissing "Gyan.FFmpeg" "ffmpeg" "FFmpeg"
Install-WingetPackageIfMissing "ChrisBagwell.SoX" "sox" "SoX"
Install-WingetPackageIfMissing "MiKTeX.MiKTeX" "pdflatex" "MiKTeX / LaTeX"

# Add common WinGet and program paths to User PATH and current process PATH.
Write-Info "Adding common FFmpeg / SoX / MiKTeX directories to PATH when present."

$wingetRoot = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages"
if (Test-Path $wingetRoot) {
    $soxExe = Get-ChildItem -Path $wingetRoot -Recurse -Filter "sox.exe" -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($soxExe) { Add-UserPath $soxExe.DirectoryName }

    $ffmpegExe = Get-ChildItem -Path $wingetRoot -Recurse -Filter "ffmpeg.exe" -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($ffmpegExe) { Add-UserPath $ffmpegExe.DirectoryName }
}

$miktexCandidatePaths = @(
    "C:\Program Files\MiKTeX\miktex\bin\x64",
    (Join-Path $env:LOCALAPPDATA "Programs\MiKTeX\miktex\bin\x64")
)

foreach ($p in $miktexCandidatePaths) { Add-UserPath $p }

# ============================================================
# Install uv first
# ============================================================

Write-Section "Installing/checking uv"

$uvExe = Get-UvExecutable
if ($uvExe) {
    Write-Ok "uv already available: $(& $uvExe --version)"
}
else {
    Write-Info "Installing uv using the official Astral PowerShell installer."
    Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression

    Add-UserPath (Join-Path $env:USERPROFILE ".local\bin")
    Add-UserPath (Join-Path $env:USERPROFILE ".cargo\bin")

    $uvExe = Get-UvExecutable
    if (-not $uvExe) {
        Write-Err "uv installed but is not visible. Close/reopen VS Code or PowerShell, then rerun this script."
        exit 1
    }
}

Write-Ok "uv available: $(& $uvExe --version)"

# ============================================================
# Initialize uv project
# ============================================================

Write-Section "Initializing uv project"

if (-not (Test-Path "pyproject.toml")) {
    Write-Info "Creating pyproject.toml."
    try {
        Invoke-Uv @("init", "--bare")
    }
    catch {
        Invoke-Uv @("init")
    }
}
else {
    Write-Ok "pyproject.toml already exists."
}

Write-Info "Installing/pinning Python $PythonVersion for this project."
try { Invoke-Uv @("python", "install", $PythonVersion) } catch { Write-Warn "uv python install $PythonVersion failed or was unnecessary." }
try { Invoke-Uv @("python", "pin", $PythonVersion) } catch { Write-Warn "uv python pin $PythonVersion failed or was unnecessary." }

# ============================================================
# Python dependencies
# ============================================================

Write-Section "Installing Python dependencies"

Write-Info "Adding Manim CE and common math/graphics packages."
Invoke-Uv @("add", "manim", "numpy", "scipy", "matplotlib", "pandas", "sympy", "ipykernel", "jupyterlab")

Write-Info "Adding Manim Voiceover packages."
try {
    Invoke-Uv @("add", "manim-voiceover[$VoiceoverExtras]", "gTTS", "pyttsx3")
}
catch {
    Write-Warn "Full voiceover extras failed. Trying smaller voiceover install."
    try { Invoke-Uv @("add", "manim-voiceover[gtts,azure,pyttsx3]", "gTTS", "pyttsx3") } catch { Write-Warn "Fallback voiceover install also failed." }
}

if ($InstallCoqui -eq "1") {
    Write-Warn "Trying Coqui voiceover extra. This may be slow or fail on Windows."
    try { Invoke-Uv @("add", "manim-voiceover[coqui]") } catch { Write-Warn "Coqui install failed." }
}

Invoke-Uv @("sync")

# ============================================================
# LaTeX package probes / best-effort package installation
# ============================================================

Write-Section "Checking LaTeX"

if (Test-Command "pdflatex") {
    Write-Ok "pdflatex available: $((pdflatex --version | Select-Object -First 1) -join '')"
}
else {
    Write-Warn "pdflatex is not visible. Manim MathTex will fail until MiKTeX is installed and on PATH."
}

if (Test-Command "initexmf") {
    Write-Info "Configuring MiKTeX best-effort automatic package installation."
    try { initexmf --set-config-value "[MPM]AutoInstall=1" | Out-Null } catch { Write-Warn "Could not set MiKTeX AutoInstall." }
}

if (Test-Command "mpm") {
    Write-Info "Trying to install/check MiKTeX packages: pgf, actuarialsymbol."
    try { mpm --install=pgf | Out-Null } catch { Write-Warn "Could not install/check pgf via mpm." }
    try { mpm --install=actuarialsymbol | Out-Null } catch { Write-Warn "Could not install/check actuarialsymbol via mpm." }
}

@'
\documentclass{standalone}
\usepackage{tikz}
\usepackage{actuarialsymbol}
\begin{document}
\begin{tikzpicture}\draw (0,0)--(1,1);\end{tikzpicture}
\end{document}
'@ | Set-Content -Encoding UTF8 ".latex_probe.tex"

if (Test-Command "pdflatex") {
    try {
        pdflatex -interaction=nonstopmode .latex_probe.tex | Out-Null
        Write-Ok "LaTeX probe passed: tikz and actuarialsymbol loaded."
    }
    catch {
        Write-Warn "LaTeX probe failed. Open MiKTeX Console and install/repair tikz/pgf and actuarialsymbol."
    }
}

Remove-Item .latex_probe.* -Force -ErrorAction SilentlyContinue
Remove-Item texput.log -Force -ErrorAction SilentlyContinue

# ============================================================
# VS Code project scaffolding
# ============================================================

Write-Section "Creating VS Code project files"

New-Item -ItemType Directory -Force ".vscode" | Out-Null

@'
{
  "python.defaultInterpreterPath": ".venv\\Scripts\\python.exe",
  "python.analysis.typeCheckingMode": "basic"
}
'@ | Set-Content -Encoding UTF8 ".vscode\settings.json"

@'
{
  "recommendations": [
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-toolsai.jupyter"
  ]
}
'@ | Set-Content -Encoding UTF8 ".vscode\extensions.json"

if (-not (Test-Path ".gitignore")) {
@'
.venv/
__pycache__/
.pytest_cache/
.ipynb_checkpoints/
media/
*.log
*.aux
*.fls
*.fdb_latexmk
*.synctex.gz
'@ | Set-Content -Encoding UTF8 ".gitignore"
}

if (-not (Test-Path $ProjectSceneFile)) {
@'
from manim import *

config.pixel_width = 1080
config.pixel_height = 1920
config.frame_width = 9
config.frame_height = 16
config.background_color = "#0f111a"


class StarterScene(Scene):
    def construct(self):
        title = Text("Manim CE is ready", font_size=48)
        subtitle = Text("Edit main.py and render your scene", font_size=28, color=GRAY_B)
        group = VGroup(title, subtitle).arrange(DOWN, buff=0.35)
        self.play(Write(title), FadeIn(subtitle), run_time=2)
        self.wait(1)
'@ | Set-Content -Encoding UTF8 $ProjectSceneFile
}

# ============================================================
# Health checks
# ============================================================

Write-Section "Running health checks"

Invoke-Uv @("run", "python", "-c", "import shutil; print('Python executable OK'); print('ffmpeg:', shutil.which('ffmpeg')); print('sox:', shutil.which('sox')); print('pdflatex:', shutil.which('pdflatex'))")

Write-Info "Running Manim health check. This may render a small test scene."
try {
    Invoke-Uv @("run", "manim", "checkhealth")
    Write-Ok "Manim checkhealth completed."
}
catch {
    Write-Warn "Manim checkhealth reported an issue. Read the output above; common causes are LaTeX PATH, FFmpeg PATH, SoX PATH, or MiKTeX package sync."
}

# ============================================================
# Final instructions
# ============================================================

Write-Section "Setup complete"

Write-Host ""
Write-Host "Project files created in:" -ForegroundColor White
Write-Host "  $(Get-Location)"
Write-Host ""
Write-Host "Usual workflow with uv, no manual activation required:" -ForegroundColor White
Write-Host "  uv run manim -p -r 1080,1920 $ProjectSceneFile $ProjectSceneClass --disable_caching"
Write-Host ""
Write-Host "Optional virtual environment activation:" -ForegroundColor White
Write-Host "  .\.venv\Scripts\Activate.ps1"
Write-Host ""
Write-Host "Recommended first commands:" -ForegroundColor White
Write-Host "  uv run manim checkhealth"
Write-Host "  uv run manim -p -r 1080,1920 $ProjectSceneFile $ProjectSceneClass --disable_caching"
Write-Host ""
Write-Host "Voiceover diagnostic:" -ForegroundColor White
Write-Host "  uv run python -c \"import shutil; print(shutil.which('sox'))\""
Write-Host ""
Write-Host "If Windows still cannot find SoX/FFmpeg/LaTeX after installation:" -ForegroundColor White
Write-Host "  1. Close every VS Code and PowerShell terminal."
Write-Host "  2. Reopen VS Code."
Write-Host "  3. Run: uv run manim checkhealth"
Write-Host ""
