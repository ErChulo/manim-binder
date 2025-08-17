FROM manimcommunity/manim:stable

# Binder needs Jupyter to be available inside the image
RUN python3 -m pip install --no-cache-dir notebook jupyterlab jupyterhub ipywidgets

# Create a non-root user (Binder expects uid=1000)
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER=${NB_USER} NB_UID=${NB_UID} HOME=/home/${NB_USER}
RUN adduser --disabled-password --gecos "Default user" --uid ${NB_UID} ${NB_USER}

# Copy repo and set permissions (Binder mounts repo at runtime; this keeps local runs sane)
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID}:${NB_UID} ${HOME}
USER ${NB_USER}

WORKDIR ${HOME}
# Do NOT set ENTRYPOINT/CMD; Binder injects its own command to start Jupyter
