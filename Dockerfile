# Usa una imagen base de Ubuntu
FROM ubuntu:22.04

# 1. Instala las dependencias del sistema para Manim
# Esto incluye las bibliotecas de desarrollo para Cairo y Pango
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
    libxrender-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Instala Node.js y npm
# Usamos el script oficial de NodeSource para obtener la última versión LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. Configura el entorno de usuario y el directorio de trabajo
# Esto asegura que los paquetes de npm se instalen correctamente para el usuario 'manim'
RUN useradd -ms /bin/bash manim
USER manim
WORKDIR /home/manim

# 4. Copia los archivos de requerimientos
COPY --chown=manim:manim requirements.txt .

# 5. Instala las dependencias de Python
RUN python3 -m pip install --no-cache-dir -r requirements.txt
