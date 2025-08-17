FROM manimcommunity/manim:stable

# Become root to install Jupyter pieces
USER root

# Ensure user-local scripts are on PATH (pip installs to /manim/.local/bin in this image)
ENV PATH="/manim/.local/bin:${PATH}"

# Minimal Jupyter stack for Binder
RUN python3 -m pip install --no-cache-dir notebook jupyterlab ipywidgets

# Switch back to the default image user ("manim") and set a sane workdir
USER manim
WORKDIR /manim
