#!/usr/bin/env bash
# manim-project-starter.sh
# General Manim Community Edition project bootstrapper using uv.
# Intended use: run this from an empty VS Code project directory.

set -Eeuo pipefail

# ============================================================
# Configuration
# ============================================================

PYTHON_VERSION="${PYTHON_VERSION:-3.11}"
PROJECT_SCENE_FILE="${PROJECT_SCENE_FILE:-main.py}"
PROJECT_SCENE_CLASS="${PROJECT_SCENE_CLASS:-StarterScene}"

# Voiceover extras: intentionally omits Coqui by default because it is heavy and often
# creates platform-specific PyTorch/version friction. Set INSTALL_COQUI=1 to try it.
VOICEOVER_EXTRAS="azure,gtts,pyttsx3,recorder,openai,elevenlabs"
INSTALL_COQUI="${INSTALL_COQUI:-0}"

# ============================================================
# Logging helpers
# ============================================================

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
info() { printf '\033[34m[INFO]\033[0m %s\n' "$*"; }
ok() { printf '\033[32m[OK]\033[0m %s\n' "$*"; }
warn() { printf '\033[33m[WARN]\033[0m %s\n' "$*"; }
err() { printf '\033[31m[ERROR]\033[0m %s\n' "$*" >&2; }

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================
# OS detection
# ============================================================

UNAME_S="$(uname -s || true)"
case "$UNAME_S" in
    MINGW*|MSYS*|CYGWIN*) OS_TYPE="windows-git-bash" ;;
    Darwin*) OS_TYPE="macos" ;;
    Linux*) OS_TYPE="linux" ;;
    *) OS_TYPE="unknown" ;;
esac

info "Detected OS: $OS_TYPE"

# ============================================================
# Package-manager helpers
# ============================================================

run_powershell() {
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$1"
}

windows_has_winget() {
    command_exists winget || cmd.exe /c "where winget" >/dev/null 2>&1
}

winget_install_if_missing() {
    local package_id="$1"
    local check_cmd="$2"
    local label="$3"

    if bash -lc "$check_cmd" >/dev/null 2>&1 || cmd.exe /c "where ${check_cmd%% *}" >/dev/null 2>&1; then
        ok "$label already available."
        return 0
    fi

    if ! windows_has_winget; then
        warn "winget not found. Install $label manually: $package_id"
        return 1
    fi

    info "Installing $label with winget: $package_id"
    cmd.exe /c "winget install -e --id $package_id --accept-package-agreements --accept-source-agreements" || {
        warn "winget could not install $label. You may need to run the script from an elevated terminal or install it manually."
        return 1
    }
}

linux_install_packages() {
    if command_exists apt-get; then
        info "Installing system dependencies with apt-get."
        sudo apt-get update
        sudo apt-get install -y \
            curl ca-certificates \
            python3 python3-venv python3-dev \
            build-essential pkg-config \
            ffmpeg sox libsox-fmt-all \
            libcairo2-dev libpango1.0-dev \
            texlive texlive-latex-extra texlive-fonts-extra texlive-pictures texlive-science texlive-humanities \
            latexmk dvisvgm \
            portaudio19-dev gettext
    elif command_exists dnf; then
        info "Installing system dependencies with dnf."
        sudo dnf install -y \
            curl python3 python3-devel gcc gcc-c++ pkgconf-pkg-config \
            ffmpeg sox cairo-devel pango-devel \
            texlive-scheme-medium texlive-standalone texlive-preview texlive-dvisvgm texlive-pgf texlive-actuarialsymbol \
            portaudio-devel gettext
    elif command_exists pacman; then
        info "Installing system dependencies with pacman."
        sudo pacman -Sy --needed --noconfirm \
            curl python python-pip base-devel pkgconf \
            ffmpeg sox cairo pango \
            texlive-bin texlive-latexextra texlive-pictures texlive-science \
            portaudio gettext
    else
        warn "No supported Linux package manager found. Install manually: curl, Python, ffmpeg, cairo, pango, pkg-config, LaTeX, dvisvgm, SoX."
    fi
}

macos_install_packages() {
    if ! command_exists brew; then
        err "Homebrew is required for this macOS automation. Install Homebrew first: https://brew.sh"
        exit 1
    fi

    info "Installing system dependencies with Homebrew."
    brew install curl python ffmpeg cairo pango pkg-config sox portaudio gettext || true

    if ! command_exists pdflatex && [ ! -x "/Library/TeX/texbin/pdflatex" ]; then
        info "Installing MacTeX no-GUI. This is large and can take time."
        brew install --cask mactex-no-gui || true
    fi

    export PATH="/Library/TeX/texbin:$PATH"
}

windows_install_packages() {
    info "Checking Windows system dependencies."

    if ! command_exists curl && ! cmd.exe /c "where curl" >/dev/null 2>&1; then
        warn "curl is missing. Modern Windows usually includes curl. Install Git for Windows or curl manually, then rerun."
    else
        ok "curl available."
    fi

    if ! command_exists python && ! command_exists python3 && ! cmd.exe /c "where python" >/dev/null 2>&1; then
        winget_install_if_missing "Python.Python.3.11" "python --version" "Python $PYTHON_VERSION" || true
    else
        ok "Python available."
    fi

    winget_install_if_missing "Gyan.FFmpeg" "ffmpeg -version" "FFmpeg" || true
    winget_install_if_missing "ChrisBagwell.SoX" "sox --version" "SoX" || true
    winget_install_if_missing "MiKTeX.MiKTeX" "pdflatex --version" "MiKTeX / LaTeX" || true

    # Add common WinGet package directories to the Windows User PATH so Windows Python subprocesses can find them.
    info "Adding likely FFmpeg/SoX/MiKTeX paths to Windows User PATH when present."
    run_powershell '
$paths = @()
$paths += Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages\ChrisBagwell.SoX_Microsoft.Winget.Source_8wekyb3d8bbwe\sox-14.4.2"
$paths += Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-*\bin"
$paths += "C:\Program Files\MiKTeX\miktex\bin\x64"
$paths += Join-Path $env:LOCALAPPDATA "Programs\MiKTeX\miktex\bin\x64"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
foreach ($p in $paths) {
    $matches = Get-ChildItem -Path $p -ErrorAction SilentlyContinue
    foreach ($m in $matches) {
        $full = $m.FullName
        if ($userPath -notlike "*$full*") {
            $userPath = "$userPath;$full"
        }
    }
}
[Environment]::SetEnvironmentVariable("Path", $userPath, "User")
' || warn "Could not update Windows User PATH automatically."

    # Also update current Git Bash PATH for this run.
    export PATH="$PATH:/c/Program Files/MiKTeX/miktex/bin/x64"
    export PATH="$PATH:$HOME/AppData/Local/Programs/MiKTeX/miktex/bin/x64"
    if [ -d "$HOME/AppData/Local/Microsoft/WinGet/Packages" ]; then
        while IFS= read -r -d '' d; do export PATH="$PATH:$d"; done < <(find "$HOME/AppData/Local/Microsoft/WinGet/Packages" -type d \( -name "sox-*" -o -path "*/ffmpeg-*/bin" \) -print0 2>/dev/null || true)
    fi
}

# ============================================================
# Pre-flight checks and system dependencies
# ============================================================

bold "Manim CE project starter"
info "This script will set up the current directory as a uv-managed ManimCE project."

case "$OS_TYPE" in
    linux) linux_install_packages ;;
    macos) macos_install_packages ;;
    windows-git-bash) windows_install_packages ;;
    *) warn "Unknown OS. Continuing with Python/uv setup only." ;;
esac

if ! command_exists curl; then
    err "curl is still not available. Install curl and rerun."
    exit 1
fi

if ! command_exists python && ! command_exists python3 && ! cmd.exe /c "where python" >/dev/null 2>&1 2>/dev/null; then
    err "Python is still not available. Install Python $PYTHON_VERSION and rerun."
    exit 1
fi

# ============================================================
# Install uv first
# ============================================================

if command_exists uv; then
    ok "uv already installed: $(uv --version)"
else
    info "Installing uv."
    if [ "$OS_TYPE" = "windows-git-bash" ]; then
        run_powershell "irm https://astral.sh/uv/install.ps1 | iex"
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
fi

# Make uv available in the current shell.
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
if [ -n "${USERPROFILE:-}" ]; then
    export PATH="$USERPROFILE/.local/bin:$USERPROFILE/.cargo/bin:$PATH"
fi

if ! command_exists uv; then
    err "uv was installed but is not visible in this shell. Close/reopen the terminal, then rerun this script."
    exit 1
fi

ok "uv available: $(uv --version)"

# ============================================================
# Initialize uv project
# ============================================================

if [ ! -f "pyproject.toml" ]; then
    info "Initializing uv project in current directory."
    if ! uv init --bare >/dev/null 2>&1; then
        uv init
    fi
else
    ok "pyproject.toml already exists."
fi

info "Installing/pinning Python $PYTHON_VERSION for this project."
uv python install "$PYTHON_VERSION" || true
uv python pin "$PYTHON_VERSION" || true

# ============================================================
# Python dependencies
# ============================================================

info "Adding ManimCE and common numerical/graphics packages."
uv add manim numpy scipy matplotlib pandas sympy ipykernel jupyterlab || {
    err "uv add failed for core dependencies."
    exit 1
}

info "Adding Manim voiceover packages."
uv add "manim-voiceover[$VOICEOVER_EXTRAS]" gTTS pyttsx3 || {
    warn "Some voiceover extras failed. Trying a smaller voiceover installation."
    uv add "manim-voiceover[gtts,azure,pyttsx3]" gTTS pyttsx3 || true
}

if [ "$INSTALL_COQUI" = "1" ]; then
    warn "Trying Coqui voiceover extra. This may be slow or fail on some platforms."
    uv add "manim-voiceover[coqui]" || true
fi

uv sync

# ============================================================
# LaTeX package probes / best-effort package installation
# ============================================================

info "Checking LaTeX availability."
if command_exists pdflatex; then
    ok "pdflatex available: $(pdflatex --version | head -n 1)"
else
    warn "pdflatex is not visible. Manim MathTex will fail until LaTeX is installed and on PATH."
fi

# On MiKTeX, enable missing package installer as a best-effort user-level setting.
if command_exists initexmf; then
    info "Configuring MiKTeX best-effort automatic package installation."
    initexmf --set-config-value "[MPM]AutoInstall=1" >/dev/null 2>&1 || true
fi

# Best-effort package installs. pgf provides TikZ. actuarialsymbol is actuarial notation.
if command_exists mpm; then
    info "Trying to install/check MiKTeX packages: pgf, actuarialsymbol."
    mpm --install=pgf >/dev/null 2>&1 || true
    mpm --install=actuarialsymbol >/dev/null 2>&1 || true
fi

# Create a tiny LaTeX probe. Do not fail the whole script if this fails.
cat > .latex_probe.tex <<'LATEX'
\documentclass{standalone}
\usepackage{tikz}
\usepackage{actuarialsymbol}
\begin{document}
\begin{tikzpicture}\draw (0,0)--(1,1);\end{tikzpicture}
\end{document}
LATEX

if command_exists pdflatex; then
    pdflatex -interaction=nonstopmode .latex_probe.tex >/dev/null 2>&1 && ok "LaTeX probe passed: tikz and actuarialsymbol loaded." || warn "LaTeX probe failed. Open MiKTeX Console or TeX Live package manager and install/repair tikz/pgf and actuarialsymbol."
fi
rm -f .latex_probe.* texput.log >/dev/null 2>&1 || true

# ============================================================
# VS Code project scaffolding
# ============================================================

info "Creating starter project files."
mkdir -p .vscode

if [ "$OS_TYPE" = "windows-git-bash" ]; then
    PY_INTERPRETER=".venv\\Scripts\\python.exe"
else
    PY_INTERPRETER=".venv/bin/python"
fi

cat > .vscode/settings.json <<EOFSETTINGS
{
  "python.defaultInterpreterPath": "$PY_INTERPRETER",
  "python.analysis.typeCheckingMode": "basic",
  "terminal.integrated.defaultProfile.windows": "Git Bash"
}
EOFSETTINGS

cat > .vscode/extensions.json <<'EOFEXT'
{
  "recommendations": [
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-toolsai.jupyter"
  ]
}
EOFEXT

if [ ! -f ".gitignore" ]; then
    cat > .gitignore <<'EOFGITIGNORE'
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
EOFGITIGNORE
fi

if [ ! -f "$PROJECT_SCENE_FILE" ]; then
    cat > "$PROJECT_SCENE_FILE" <<'EOFPY'
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
EOFPY
fi

# ============================================================
# Health checks
# ============================================================

bold "Running health checks"

uv run python - <<'EOFPYCHECK'
import shutil
print("Python executable OK")
print("ffmpeg:", shutil.which("ffmpeg"))
print("sox:", shutil.which("sox"))
print("pdflatex:", shutil.which("pdflatex"))
EOFPYCHECK

info "Running Manim health check. This may render a small test scene."
if uv run manim checkhealth; then
    ok "Manim checkhealth completed."
else
    warn "Manim checkhealth reported an issue. Read the output above; common causes are LaTeX PATH, FFmpeg PATH, or MiKTeX package sync."
fi

# ============================================================
# Final instructions
# ============================================================

bold "Setup complete"

cat <<EOFEND

Project files created in:
  $(pwd)

Usual workflow with uv, no manual activation required:
  uv run manim -p -r 1080,1920 $PROJECT_SCENE_FILE $PROJECT_SCENE_CLASS --disable_caching

Optional virtual environment activation:
EOFEND

if [ "$OS_TYPE" = "windows-git-bash" ]; then
    cat <<'EOFEND'
  source .venv/Scripts/activate
EOFEND
else
    cat <<'EOFEND'
  source .venv/bin/activate
EOFEND
fi

cat <<EOFEND

Recommended first commands:
  uv run manim checkhealth
  uv run manim -p -r 1080,1920 $PROJECT_SCENE_FILE $PROJECT_SCENE_CLASS --disable_caching

Voiceover projects:
  - gTTS works with internet access.
  - Azure requires your Azure Speech key and region in .env.
  - SoX must be visible to Python for voiceover audio processing:
      uv run python -c "import shutil; print(shutil.which('sox'))"

If Windows still cannot find SoX/FFmpeg/LaTeX after installation:
  1. Close every Git Bash / VS Code terminal.
  2. Reopen VS Code.
  3. Run: uv run manim checkhealth

EOFEND
