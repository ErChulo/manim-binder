# Use Ubuntu 22.04 as base
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NB_USER=jovyan
ENV NB_UID=1000
ENV HOME=/home/${NB_USER}

# Install system dependencies (MUCH lighter LaTeX setup)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3-pip \
    python3-dev \
    ffmpeg \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-lang-spanish \
    libcairo2-dev \
    librsvg2-dev \
    libpango1.0-dev \
    libgirepository1.0-dev \
    pkg-config \
    build-essential \
    libgl1-mesa-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    curl \
    pandoc \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (for JupyterLab extensions)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create user (following Binder conventions)
RUN useradd -m -s /bin/bash -N -u ${NB_UID} ${NB_USER}

# Switch to user and set working directory
USER ${NB_USER}
WORKDIR ${HOME}

# Copy requirements
COPY --chown=${NB_USER}:${NB_USER} requirements.txt ./

# Install Python packages
RUN python3 -m pip install --no-cache-dir --user \
    jupyterhub==4.0.* \
    jupyterlab==4.0.* \
    notebook==7.0.* \
    manim==0.18.* \
    jupyterlab_latex

# Set up Jupyter configuration
RUN mkdir -p ${HOME}/.jupyter
RUN echo "c.ServerApp.ip = '0.0.0.0'" >> ${HOME}/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.open_browser = False" >> ${HOME}/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.token = ''" >> ${HOME}/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.password = ''" >> ${HOME}/.jupyter/jupyter_lab_config.py

# Verify manim installation
RUN python3 -c "import manim; print('Manim version:', manim.__version__)"

# Set PATH for user pip installs
ENV PATH="${HOME}/.local/bin:${PATH}"

# Default command
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
