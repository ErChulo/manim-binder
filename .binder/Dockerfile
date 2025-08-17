FROM manimcommunity/manim:stable

# install system dependencies as root
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-pictures \
    texlive-xetex \
    dvipng && \
    rm -rf /var/lib/apt/lists/*

# install Jupyter, widgets, and MF-Tools plugin
RUN python3 -m pip install --no-cache-dir \
    notebook \
    jupyterlab \
    ipywidgets \
    MF-Tools

# copy repo and set ownership
COPY --chown=manimuser:manimuser . /manim

USER manimuser
WORKDIR /manim





