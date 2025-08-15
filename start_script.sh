#!/bin/bash

# Set environment variables for better performance
export JUPYTER_ENABLE_LAB=yes
export MANIM_DISABLE_CAIRO_LOGS=1

# Start JupyterLab with optimized settings
exec jupyter lab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --allow-root \
  --ServerApp.token='' \
  --ServerApp.password='' \
  --ServerApp.allow_origin='*' \
  --ServerApp.base_url=${JUPYTERHUB_SERVICE_PREFIX:-/}