# STEP 1 — Replace .binder/Dockerfile with this EXACT content

FROM manimcommunity/manim:stable

USER root
ENV PATH="/manim/.local/bin:${PATH}"
RUN python3 -m pip install --no-cache-dir notebook jupyterlab ipywidgets

# Binder mounts your repo at /home/jovyan; ensure it exists and is owned by the runtime user
RUN mkdir -p /home/jovyan && chown -R manim:manim /home/jovyan

# Make the repo mount the working directory so files show up in the file browser
WORKDIR /home/jovyan

# Run as the image’s default user
USER manim

# Do NOT set ENTRYPOINT/CMD
