FROM manimcommunity/manim:stable

# install Jupyter and MF‑Tools
USER root
RUN python3 -m pip install --no-cache-dir \
    notebook \
    jupyterlab \
    ipywidgets \
    MF-Tools

# copy local TeX packages into the image and add to TEXINPUTS
COPY tex /manim/tex
ENV TEXINPUTS=/manim/tex//:

# copy entire repository and fix ownership
COPY --chown=manimuser:manimuser . /manim

# switch to unprivileged user and set working directory
USER manimuser
WORKDIR /manim










