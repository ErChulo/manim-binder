FROM manimcommunity/manim:stable

USER root
ENV PATH="/manim/.local/bin:${PATH}"
RUN python3 -m pip install --no-cache-dir notebook jupyterlab ipywidgets

# ensure Binder mounts the repo here and it appears in the file browser
RUN mkdir -p /home/jovyan
WORKDIR /home/jovyan

# leave the default command for Binder to start Jupyter



