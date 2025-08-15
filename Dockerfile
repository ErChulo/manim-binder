# Usa una imagen base de Ubuntu 22.04
FROM ubuntu:22.04

# 1. Instala las dependencias del sistema necesarias
# Incluye las bibliotecas de desarrollo, ffmpeg, y curl.
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3-pip \
    ffmpeg \
    texlive-full \
    texlive-lang-spanish \
    xdg-utils \
    build-essential \
    libcairo2-dev \
    libpango1.0-dev \
    libsdl2-dev \
    libgl1-mesa-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Instala Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. Configura el entorno de usuario
RUN useradd -ms /bin/bash manim
USER manim
WORKDIR /home/manim

# 4. Copia los archivos de requerimientos de Python
COPY --chown=manim:manim requirements.txt .

# 5. Instala las dependencias de compilación con Python
# Ahora instalamos Meson con pip para asegurar la versión correcta.
RUN python3 -m pip install --no-cache-dir meson

# 6. Instala las dependencias de Python desde el archivo
# Este paso ahora tendrá la versión correcta de Meson disponible.
RUN python3 -m pip install --no-cache-dir -r requirements.txt
