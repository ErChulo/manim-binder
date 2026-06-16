# Manim CE PowerShell Project Starter Instructions

These instructions accompany `manim-project-starter.ps1`, the native Windows PowerShell version of the Manim CE starter script.

Use this file when starting a new Manim Community Edition project from an empty directory in Visual Studio Code on Windows.

---

## Purpose

The PowerShell script sets up a complete `uv`-managed Manim CE project on Windows.

It will:

1. Check for basic Windows prerequisites.
2. Install or verify `uv`.
3. Install or verify FFmpeg, SoX, and MiKTeX using `winget`.
4. Add common FFmpeg, SoX, and MiKTeX locations to the Windows User PATH.
5. Create a `uv` project.
6. Install Manim CE and common mathematical/scientific Python packages.
7. Install Manim Voiceover packages.
8. Try to verify LaTeX packages such as TikZ/PGF and `actuarialsymbol`.
9. Create VS Code project settings.
10. Create a starter `main.py` file.
11. Run `uv run manim checkhealth`.

---

## Intended platform

This script is for:

```text
Windows + PowerShell + Visual Studio Code
```

It is **not** the Git Bash script. For Git Bash, use:

```text
manim-project-starter.sh
```

For native PowerShell, use:

```text
manim-project-starter.ps1
```

---

## Pre-installation notes

Before running the script, open an empty project directory in VS Code.

Example project folder:

```text
C:\Users\heric\OneDrive\Documents\manim\my-new-project
```

You should have:

```text
Windows PowerShell
Visual Studio Code
winget
Internet access
```

The script uses `winget` to install Windows system dependencies where possible.

If `winget` is not available, install dependencies manually before rerunning the script.

---

## How to run the script

Open PowerShell in the empty project directory.

You can do this in VS Code using:

```text
Terminal > New Terminal > PowerShell
```

Then run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\manim-project-starter.ps1
```

The execution-policy command applies only to the current PowerShell process.

---

## What the script installs or checks

### Core tools

```text
Python 3.11
uv
FFmpeg
SoX
MiKTeX
```

### Python packages

```text
manim
numpy
scipy
matplotlib
pandas
sympy
ipykernel
jupyterlab
```

### Manim voiceover packages

The script attempts to install:

```text
manim-voiceover[gtts, azure, pyttsx3, recorder, openai, elevenlabs]
gTTS
pyttsx3
```

The script intentionally does **not** install Coqui voiceover by default because it can be heavy and platform-sensitive.

To try installing Coqui too, run PowerShell with:

```powershell
$env:INSTALL_COQUI = "1"
.\manim-project-starter.ps1
```

---

## What files the script creates

The script creates or updates:

```text
.venv/
.vscode/settings.json
.vscode/extensions.json
.gitignore
pyproject.toml
uv.lock
main.py
```

The starter scene is:

```text
main.py
```

The starter scene class is:

```python
StarterScene
```

---

## Project structure after setup

Expected folder structure:

```text
my-new-project/
├── .venv/
├── .vscode/
│   ├── settings.json
│   └── extensions.json
├── .gitignore
├── main.py
├── pyproject.toml
└── uv.lock
```

---

## Running the health check

The script runs this automatically:

```powershell
uv run manim checkhealth
```

You can rerun it manually:

```powershell
uv run manim checkhealth
```

---

## Rendering the starter scene

Use this command:

```powershell
uv run manim -p -r 1080,1920 main.py StarterScene --disable_caching
```

This renders a vertical 9:16 scene suitable for TikTok-style output.

---

## Optional virtual environment activation

Manual activation is optional if you use `uv run`.

To activate manually in PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

If activation is blocked by execution policy, use:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\.venv\Scripts\Activate.ps1
```

Again, activation is not required when using:

```powershell
uv run manim ...
```

---

## Recommended workflow

Use this workflow for most Manim projects:

```powershell
uv run manim checkhealth
uv run manim -p -r 1080,1920 main.py StarterScene --disable_caching
```

For quick low-quality previews:

```powershell
uv run manim -pql main.py StarterScene
```

For vertical TikTok output, prefer explicit resolution:

```powershell
uv run manim -p -r 1080,1920 main.py StarterScene --disable_caching
```

---

## Voiceover notes

The script installs common Manim Voiceover options.

### gTTS

Works with internet access.

Typical Python setup:

```python
from manim_voiceover import VoiceoverScene
from manim_voiceover.services.gtts import GTTSService

class MyScene(VoiceoverScene):
    def construct(self):
        self.set_speech_service(GTTSService(lang="en"))
```

### Azure

Requires an Azure Speech key and region.

Create a `.env` file in the project directory:

```text
AZURE_SUBSCRIPTION_KEY="your_key_here"
AZURE_SERVICE_REGION="your_region_here"
```

Typical Python setup:

```python
from manim_voiceover import VoiceoverScene
from manim_voiceover.services.azure import AzureService

class MyScene(VoiceoverScene):
    def construct(self):
        self.set_speech_service(
            AzureService(
                voice="en-US-GuyNeural",
                style="newscast",
            )
        )
```

### SoX check

Voiceover projects may need SoX to be visible to Python.

Check it with:

```powershell
uv run python -c "import shutil; print(shutil.which('sox'))"
```

If this prints `None`, close every VS Code and PowerShell terminal, reopen VS Code, and check again.

---

## LaTeX notes

Manim `MathTex` requires LaTeX.

The script attempts to install or verify:

```text
MiKTeX
TikZ / PGF
actuarialsymbol
```

The script also tries to configure MiKTeX automatic package installation.

If LaTeX still fails, open MiKTeX Console and update packages.

If you have both user-level and administrator-level MiKTeX installations, update both.

Then rerun:

```powershell
uv run manim checkhealth
```

---

## Common diagnostics

Check whether Python can see external tools:

```powershell
uv run python -c "import shutil; print('ffmpeg:', shutil.which('ffmpeg')); print('sox:', shutil.which('sox')); print('pdflatex:', shutil.which('pdflatex'))"
```

Check uv:

```powershell
uv --version
```

Check Python inside uv:

```powershell
uv run python --version
```

Check Manim:

```powershell
uv run manim --version
```

Check Manim health:

```powershell
uv run manim checkhealth
```

---

## Common failures

### `uv` is not recognized

Close and reopen VS Code or PowerShell.

Then run:

```powershell
uv --version
```

If it still fails, rerun the script.

---

### `manim` is not recognized

Use:

```powershell
uv run manim ...
```

Do not rely on:

```powershell
manim ...
```

unless the virtual environment is activated.

---

### SoX is not recognized

Run:

```powershell
uv run python -c "import shutil; print(shutil.which('sox'))"
```

If it prints `None`, close and reopen VS Code.

If it still prints `None`, verify SoX exists under a WinGet path similar to:

```text
C:\Users\<you>\AppData\Local\Microsoft\WinGet\Packages\ChrisBagwell.SoX_Microsoft.Winget.Source_8wekyb3d8bbwe\sox-14.4.2
```

Then add that folder to your Windows User PATH.

---

### MiKTeX says updates are out of sync

Open MiKTeX Console twice if necessary:

```text
User mode
Administrator mode
```

Update both installations.

Then rerun:

```powershell
uv run manim checkhealth
```

---

## Files to keep under version control

Keep:

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
