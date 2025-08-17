# .binder/Dockerfile — Binder-compatible Manim CE image that shows your repo files

FROM manimcommunity/manim:stable

# 1) Become root and install Jupyter bits
USER root
RUN python3 -m pip install --no-cache-dir --upgrade pip \
 && python3 -m pip install --no-cache-dir notebook jupyterlab ipywidgets

# 2) Create Binder’s expected user and home, then set permissions
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV HOME=/home/${NB_USER}
RUN useradd -m -s /bin/bash -u ${NB_UID} ${NB_USER}

# 3) Make Binder’s working directory; Binder will mount your repo here
RUN mkdir -p ${HOME} /home/${NB_USER} \
 && chown -R ${NB_UID}:${NB_UID} ${HOME}

# 4) Environment for user-local pip scripts
ENV PATH="${HOME}/.local/bin:${PATH}"

# 5) Switch to the unprivileged user and set working directory
USER ${NB_USER}
WORKDIR ${HOME}

# 6) Do NOT set ENTRYPOINT or CMD; Binder injects its own

