FROM manimcommunity/manim:stable

# Install TeX components (science and pictures) and other system deps
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-pictures \
    texlive-science \
    texlive-xetex \
    dvipng && \
    rm -rf /var/lib/apt/lists/*

# Install Jupyter components and MF‑Tools
RUN python3 -m pip install --no-cache-dir \
    notebook \
    jupyterlab \
    ipywidgets \
    MF-Tools

# Copy repository into image and fix ownership
COPY --chown=manimuser:manimuser . /manim

# Run as unprivileged user in Binder
USER manimuser
WORKDIR /manim






