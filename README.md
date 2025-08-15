# Manim Binder

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/erchulo/manim-binder/HEAD)

Un entorno completo de **Manim Community Edition** listo para usar en MyBinder.org.

## ¿Qué incluye?

- **Manim CE 0.18.0** - La biblioteca de animación matemática
- **JupyterLab** - Interfaz moderna de notebooks
- **LaTeX** - Para renderizado matemático
- **FFmpeg** - Para procesamiento de video
- **Dependencias del sistema** - Todas las bibliotecas necesarias

## Cómo usar

1. Haz clic en el badge de Binder arriba
2. Espera a que se construya el entorno (puede tomar unos minutos)
3. Abre `test_manim.ipynb` para ver ejemplos
4. ¡Empieza a crear animaciones!

## Ejemplos incluidos

- **Hello World** - Texto básico animado
- **Ecuaciones matemáticas** - Renderizado con LaTeX
- **Formas en movimiento** - Animaciones geométricas

## Uso básico

```python
%%manim -qm -v WARNING MiAnimacion

class MiAnimacion(Scene):
    def construct(self):
        texto = Text("¡Hola, Mundo!")
        self.play(Write(texto))
        self.wait(2)
```

## Calidades de video

- `-ql` - Baja calidad (rápido para pruebas)
- `-qm` - Calidad media (recomendado)
- `-qh` - Alta calidad (más lento)

## Recursos

- [Documentación oficial de Manim](https://docs.manim.community/)
- [Galería de ejemplos](https://docs.manim.community/en/stable/examples.html)
- [Tutorial de Manim](https://docs.manim.community/en/stable/tutorials.html)

## Notas técnicas

Este binder usa Ubuntu 22.04 con:
- Python 3.10
- Manim CE con todas las dependencias
- JupyterLab optimizado para animaciones matemáticas
