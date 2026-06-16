# Manim CE Project Starter Instructions

These instructions accompany `manim-project-starter.sh`, a Bash starter script for creating a new Manim Community Edition project managed with `uv`.

## Purpose

Use this workflow when starting a new Manim CE project from an empty directory opened in Visual Studio Code.

The script will:

1. Check for basic prerequisites.
2. Install or verify `uv`.
3. Install Manim CE into a project-local `uv` environment.
4. Install common numerical and graphics packages.
5. Install Manim voiceover packages.
6. Install or check system dependencies such as FFmpeg, LaTeX, and SoX where possible.
7. Create a basic project scaffold.
8. Run `uv run manim checkhealth`.
9. Create a starter `main.py` scene.

---

## Pre-installation notes

### General

Run the script from the empty project directory that is already open in VS Code.

Example:

```bash
cd ~/OneDrive/Documents/manim/my-new-project
./manim-project-starter.sh
```

The script assumes you want a `uv`-managed project.

You do **not** need to manually activate the virtual environment if you use `uv run`.

---

## Windows notes

On Windows, run the script from **Git Bash**.

The script will use Windows commands such as `winget` through Git Bash where needed.

You should have access to:

```text
winget
PowerShell
Git Bash
Visual Studio Code
```

The script tries to install or verify:

```text
Python
uv
FFmpeg
SoX
MiKTeX
Manim CE
Manim Voiceover
```

If Windows cannot find SoX, FFmpeg, or LaTeX immediately after installation, close all Git Bash and VS Code terminals, reopen VS Code, and rerun:

```bash
uv run manim checkhealth
```

To check whether Python can see SoX:

```bash
uv run python -c "import shutil; print(shutil.which('sox'))"
```

---

## macOS notes

The script assumes **Homebrew** is already installed.

If Homebrew is not installed, install it first:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The script uses Homebrew to install system dependencies such as:

```text
ffmpeg
cairo
pango
pkg-config
sox
portaudio
gettext
```

For LaTeX, it attempts to install `mactex-no-gui` if `pdflatex` is not visible.

---

## Linux notes

On Linux, the script supports common package managers:

```text
apt-get
dnf
pacman
```

You need `sudo` privileges for system package installation.

The script tries to install:

```text
curl
Python
FFmpeg
SoX
Cairo/Pango development libraries
LaTeX / TeX Live
TikZ / PGF
actuarialsymbol
portaudio
gettext
```

---

## Running the starter script

Place `manim-project-starter.sh` in the empty project directory.

Then run:

```bash
chmod +x manim-project-starter.sh
./manim-project-starter.sh
```

---

## What the script creates

The script creates or updates the following files and folders:

```text
.venv/
.vscode/settings.json
.vscode/extensions.json
.gitignore
pyproject.toml
uv.lock
main.py
```

The starter scene is created in:

```text
main.py
```

The starter scene class is:

```python
StarterScene
```

---

## Running the health check

The script runs this automatically at the end:

```bash
uv run manim checkhealth
```

You can rerun it manually at any time:

```bash
uv run manim checkhealth
```

---

## Rendering the starter scene

Use this command:

```bash
uv run manim -p -r 1080,1920 main.py StarterScene --disable_caching
```

This renders a vertical 9:16 TikTok-style scene.

---

## Optional virtual environment activation

Manual activation is optional when using `uv run`.

### Windows Git Bash

```bash
source .venv/Scripts/activate
```

### macOS / Linux

```bash
source .venv/bin/activate
```

---

## Recommended workflow

Use this workflow for most Manim projects:

```bash
uv run manim checkhealth
uv run manim -p -r 1080,1920 main.py StarterScene --disable_caching
```

For quick non-portrait test renders, you may use Manim quality flags, for example:

```bash
uv run manim -pql main.py StarterScene
```

For TikTok portrait output, prefer explicit resolution:

```bash
uv run manim -p -r 1080,1920 main.py StarterScene --disable_caching
```

---

## Voiceover notes

The starter installs common Manim Voiceover packages, including support for:

```text
gTTS
Azure
pyttsx3
recorder
OpenAI
ElevenLabs
```

For gTTS voiceover projects, internet access is required.

For Azure voiceover projects, create a `.env` file with:

```text
AZURE_SUBSCRIPTION_KEY="your_key_here"
AZURE_SERVICE_REGION="your_region_here"
```

SoX must be visible to Python for some voiceover audio processing.

Check it with:

```bash
uv run python -c "import shutil; print(shutil.which('sox'))"
```

If this prints `None`, SoX is either not installed or not on the PATH visible to Python.

---

## LaTeX notes

Manim `MathTex` requires LaTeX.

The script attempts to support:

```text
TikZ / PGF
actuarialsymbol
standard LaTeX packages needed by Manim
```

On Windows, MiKTeX may install missing packages automatically if configured. If LaTeX package installation fails, open MiKTeX Console and update both:

```text
User MiKTeX
Admin MiKTeX, if installed
```

Then rerun:

```bash
uv run manim checkhealth
```

---

## Common commands

Check tool locations:

```bash
uv run python -c "import shutil; print('ffmpeg:', shutil.which('ffmpeg')); print('sox:', shutil.which('sox')); print('pdflatex:', shutil.which('pdflatex'))"
```

Render TikTok portrait:

```bash
uv run manim -p -r 1080,1920 main.py StarterScene --disable_caching
```

Render low quality preview:

```bash
uv run manim -pql main.py StarterScene
```

Add a package:

```bash
uv add package-name
```

Remove a package:

```bash
uv remove package-name
```

Sync the environment:

```bash
uv sync
```

---

## Troubleshooting

### `manim` is not recognized

Use:

```bash
uv run manim ...
```

instead of:

```bash
manim ...
```

### SoX is not recognized on Windows

Close every Git Bash and VS Code terminal, reopen VS Code, then run:

```bash
uv run python -c "import shutil; print(shutil.which('sox'))"
```

If it still prints `None`, add the SoX directory to your Windows User PATH.

### LaTeX packages are missing

Open MiKTeX Console and update packages.

Then run:

```bash
uv run manim checkhealth
```

### MiKTeX says updates are out of sync

Update both the user-level MiKTeX and the administrator-level MiKTeX installation, if both exist.

---

## Files to keep

Keep these under version control:

```text
main.py
pyproject.toml
uv.lock
.vscode/settings.json
.vscode/extensions.json
.gitignore
```

Do not commit:

```text
.venv/
media/
__pycache__/
```
## Note

`MF_Tools` appears to be the package you mean. PyPI lists it as **MF-Tools**, and its own install recommendation is `pip install MF_Tools`. It is a Manim utility package with tools such as `TransformByGlyphMap`. ([PyPI][1])

To add it manually inside the `uv` project, run this from the project folder:

```bash
uv add MF_Tools
```

Then verify:

```bash
uv run python -c "import MF_Tools; print('MF_Tools installed')"
```

If the import name is different, inspect it with:

```bash
uv run python -c "import pkgutil; print([m.name for m in pkgutil.iter_modules() if 'mf' in m.name.lower()])"
```

No, I did **not** create a `requirements.txt` file. The starter scripts use the modern `uv` project files:

```text
pyproject.toml
uv.lock
```

That is the correct native `uv` setup.

If you still want a `requirements.txt`, generate it manually with:

```bash
uv export --format requirements.txt --output-file requirements.txt
```

The official `uv export` docs say it can export a project lockfile to `requirements.txt`, and `--output-file` writes it to a file. ([docs.astral.sh][2])

[1]: https://pypi.org/project/MF-Tools/?utm_source=chatgpt.com "MF-Tools"
[2]: https://docs.astral.sh/uv/concepts/projects/export/?utm_source=chatgpt.com "Exporting a lockfile | uv"
