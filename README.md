# Manim Binder

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/erchulo/manim-binder/HEAD)

Un entorno de **Manim Community Edition** para usar en MyBinder.org.

## Lanzar el entorno

Haz clic en el botón de Binder arriba para lanzar el entorno interactivo.

## ¿Qué incluye?

- **Manim CE** - La biblioteca de animación matemática
- **JupyterLab** - Interfaz de notebooks
- **FFmpeg** - Para procesamiento de video
- **Python 3.10** - Entorno optimizado

## Uso básico

```python
%%manim -qm -v WARNING MiAnimacion

class MiAnimacion(Scene):
    def construct(self):
        texto = Text("¡Hola, Manim!")
        self.play(Write(texto))
        self.wait(2)
```

## Recursos

- [Documentación oficial de Manim](https://docs.manim.community/)
- [Galería de ejemplos](https://docs.manim.community/en/stable/examples.html)
- [Tutorial de Manim](https://docs.manim.community/en/stable/tutorials.html)
