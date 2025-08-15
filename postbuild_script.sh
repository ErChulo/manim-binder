#!/bin/bash
set -euo pipefail

# Enable JupyterLab extensions
jupyter labextension list

# Verify manim installation
python -c "import manim; print('Manim version:', manim.__version__)"

# Set up manim config directory
mkdir -p ~/.config/manim
echo "Creating manim config..."