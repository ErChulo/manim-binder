FROM manimcommunity/manim:stable

# Run as root to install extra pieces
USER root

# Ensure pip-installed scripts are on PATH
ENV PATH="/manim/.local/bin:${PATH}"

# Minimal Jupyter stack for Binder
RUN python3 -m pip install --no-cache-dir notebook jupyterlab ipywidgets

# Switch back to the default user from the base image
USER manim

# Workdir left as provided by Binder (do NOT override with /home/jovyan)
WORKDIR /manim

# Do NOT set ENTRYPOINT or CMD; Binder injects its own commands

