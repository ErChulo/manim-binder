FROM manimcommunity/manim:stable

USER root
ENV PATH="/manim/.local/bin:${PATH}"
RUN python3 -m pip install --no-cache-dir notebook jupyterlab ipywidgets

# leave user creation to repo2docker/binder


