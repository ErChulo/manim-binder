# Usa una imagen base de Ubuntu 22.04
FROM ubuntu:22.04

# 1. Instala las dependencias del sistema necesarias
# Esto incluye las bibliotecas de desarrollo para Cairo y Pango, ffmpeg,
# y curl para poder descargar el script de NodeSource.
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
# Ahora curl está disponible para este paso.
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. Configura el entorno de usuario
# Crea un usuario 'manim' y establece el directorio de trabajo.
RUN useradd -ms /bin/bash manim
USER manim
WORKDIR /home/manim

# 4. Copia los archivos de requerimientos de Python
# Asegúrate de tener un archivo 'requirements.txt' en la misma carpeta que el Dockerfile.
COPY --chown=manim:manim requirements.txt .

# 5. Instala las dependencias de Python desde el archivo
RUN python3 -m pip install --no-cache-dir -r requirements.txt
