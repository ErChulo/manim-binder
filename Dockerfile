FROM ubuntu:22.04

# Instala las dependencias del sistema necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3-pip \
    ffmpeg \
    texlive-full \
    texlive-lang-spanish \
    xdg-utils \
    build-essential \
    libcairo2-dev \
    libsdl2-dev \
    libgl1-mesa-dev \
    libsm6 \
    libxext6 \
    libxrender-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Establece Python 3.10 como el predeterminado
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# Establece el directorio de trabajo
WORKDIR /home/manim

# Crea un usuario
RUN useradd -ms /bin/bash manim
USER manim

# Copia los archivos de requerimientos
COPY --chown=manim:manim requirements.txt .

# Instala las dependencias de Python
RUN python3 -m pip install --no-cache-dir -r requirements.txt
