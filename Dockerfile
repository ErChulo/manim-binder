# Usa una imagen base de Ubuntu 22.04
FROM ubuntu:22.04

# 1. Instala las dependencias del sistema necesarias
# Esto incluye las bibliotecas de desarrollo, ffmpeg, curl, pandoc, y ahora python3-cairo.
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3-pip \
    ffmpeg \
    texlive-full \
    texlive-lang-spanish \
    xdg-utils \
    build-essential \
    libpango1.0-dev \
    libsdl2-dev \
    libgl1-mesa-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    curl \
    pandoc \
    python3-cairo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Instala Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. Instala las dependencias de compilación de Python a nivel del sistema
# Se usa 'pip' con el usuario root para instalar 'meson' y 'ninja' globalmente.
RUN python3 -m pip install --no-cache-dir meson ninja

# 4. Configura el entorno de usuario
RUN useradd -ms /bin/bash manim
USER manim
WORKDIR /home/manim

# 5. Copia los archivos de requerimientos de Python
COPY --chown=manim:manim requirements.txt .

# 6. Instala las dependencias de Python para el usuario 'manim'
RUN python3 -m pip install --no-cache-dir -r requirements.txt
