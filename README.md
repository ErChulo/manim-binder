# Manim CE en Binder
---
## Launch JupyterLab:
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/ErChulo/manim-binder/HEAD?urlpath=lab)

## Launch classic Notebook:
# https://mybinder.org/v2/gh/<YOU>/<REPO>/HEAD?urlpath=tree

# Open notebooks/demo.ipynb and run all cells.

### Uso básico

```python
%%manim -qm -v WARNING MiAnimacion

class MiAnimacion(Scene):
    def construct(self):
        texto = Text("¡Hola, Manim!")
        self.play(Write(texto))
        self.wait(2)
```

```python
%%manim -qm -v WARNING ActuarialSymbolDemo
from manim import *

class ActuarialSymbolDemo(Scene):
    def construct(self):
        template = TexTemplate()
        template.add_to_preamble(r"\usepackage{graphicx}")
        template.add_to_preamble(r"\usepackage{actuarialsymbol}")

        exprs = [
            r"$\ax*{x:\angln}$",
            r"$\ax**{x:\angln}$",
            r"$\sx*{x:\angln}$",
            r"$\sx**{x:\angln}$",
        ]
        symbols = [Tex(expr, tex_template=template, font_size=96) for expr in exprs]
        group = VGroup(*symbols).arrange(DOWN, aligned_edge=LEFT)
        self.play(*[Write(sym) for sym in symbols], lag_ratio=0.3)
        self.play(group.animate.to_edge(LEFT))
        self.wait()
```

### Recursos

- [Documentación oficial de Manim](https://docs.manim.community/)
- [Galería de ejemplos](https://docs.manim.community/en/stable/examples.html)
- [Tutorial de Manim](https://docs.manim.community/en/stable/tutorials.html)
