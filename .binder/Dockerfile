# Use the official Manim CE base image
FROM manimcommunity/manim:stable

# Install a full TeX Live distribution (includes actuarialsymbol, amsmath, tikz, etc.) and dvipng
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-full \
    dvipng && \
    rm -rf /var/lib/apt/lists/*

# Install Jupyter, widgets, and the MF‑Tools Python package
RUN python3 -m pip install --no-cache-dir \
    notebook \
    jupyterlab \
    ipywidgets \
    MF-Tools

# Copy your repository into the image and set correct ownership
COPY --chown=manimuser:manimuser . /manim

# Switch to the unprivileged user and set the working directory
USER manimuser
WORKDIR /manim

# Note: Do not set CMD or ENTRYPOINT; Binder will inject its own startup command








