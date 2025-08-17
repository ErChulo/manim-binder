# Manim CE on Binder
#
# Launch JupyterLab:
# [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/ErChulo/manim-binder/HEAD?urlpath=lab)
#
# Launch classic Notebook:
# https://mybinder.org/v2/gh/<YOU>/<REPO>/HEAD?urlpath=tree
#
# Open notebooks/demo.ipynb and run all cells.

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
