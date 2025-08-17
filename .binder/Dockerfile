FROM manimcommunity/manim:stable

# Install the complete TeX Live distribution (contains all LaTeX packages, including actuarialsymbol)
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-full \
    dvipng && \
    rm -rf /var/lib/apt/lists/*

# Install Jupyter and the MF‑Tools Python package
RUN python3 -m pip install --no-cache-dir \
    notebook \
    jupyterlab \
    ipywidgets \
    MF-Tools

# Copy the contents of your repository into the image and set ownership
COPY --chown=manimuser:manimuser . /manim

# Run Binder as the unprivileged user in /manim
USER manimuser
WORKDIR /manim

# Do not define ENTRYPOINT or CMD; Binder injects its own









