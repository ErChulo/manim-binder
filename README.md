# Manim CE en Binder
---
## Launch JupyterLab:
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/ErChulo/manim-binder/HEAD?urlpath=lab)

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
```python
class Demo_TransformByGlyphMap2(Scene):
    def construct(self):
        exp1 = MathTex("ax^2 + bx + c = 0").scale(2)
        exp2 = MathTex("x^2 + \\frac{b}{a}x + \\frac{c}{a} = 0").scale(2)
        self.add(exp1)
        self.wait()
        self.play(TransformByGlyphMap(exp1, exp2,
            ([0], [5], {"path_arc":2/3*PI}),
            ([0], [10], {"path_arc":1/2*PI}),
            ([], [4,9]),
            run_time=2
        ))
        self.wait()
```
```python
class Demo_TransformByGlyphMap3(Scene):
    def construct(self):
        exp1 = MathTex("\\frac{x^2y^3}{w^4z^{-8}}").scale(2)
        exp2 = MathTex("\\frac{x^2y^3z^8}{w^4}").scale(2)
        self.add(exp1)
        self.wait()
        self.play(TransformByGlyphMap(exp1, exp2,
            ([7,9], [4,5]),
            ([8], [], {"shift":UP}),
        ))
        self.wait()
```
```python
class Demo_TransformByGlyphMap4(Scene):
    def construct(self):
        exp1 = MathTex("{ { 3x+2y \\over 2x+y } + 12z").scale(1.8)
        exp2 = MathTex("\\left( { 2x+y \\over 3x+2y } \\right) ^ {-1} + 12z").scale(1.8)
        self.add(exp1)
        self.wait()
        self.play(TransformByGlyphMap(exp1, exp2,
            ([0,1,2,3,4], [6,7,8,9,10], {"path_arc": PI}),
            ([6,7,8,9], [1,2,3,4], {"path_arc": PI}),
            ([], [0], {"delay":0.5}),
            ([], [11], {"delay":0.5}),
            ([], [12,13], {"delay":0.5}),
            default_introducer=Write
        ))
        self.wait()
```
```python
class Demo_TransformByGlyphMap5(Scene):
    def construct(self):
        exp1 = MathTex("1 \\over 3r+\\theta").scale(2)
        exp2 = MathTex("\\left( 3r+\\theta \\right) ^ {-1}").scale(2)
        self.add(exp1)
        self.wait()
        self.play(TransformByGlyphMap(exp1, exp2,
            ([2,3,4,5], [1,2,3,4], {"path_arc": -2/3*PI}),
            ([0,1], FadeOut, {"run_time": 0.5}),
            (GrowFromCenter, [0,5,6,7], {"delay":0.25}),
            introduce_individually=True,
        ))
        self.wait()
```

```python
class Demo_TransformByGlyphMap6(Scene):
    def construct(self):
        exp1 = MathTex("4x^2 - x^2 + 5x + 3x - 7")
        exp2 = MathTex("3x^2 + 8x - 7")
        VGroup(exp1, exp2).arrange(DOWN, buff=1).scale(2)
        self.add(exp1)
        self.wait()
        self.play(TransformByGlyphMap(exp1, exp2,
            ([0,3], [0]),
            ([1,2], [1,2]),
            ([4,5], [1,2]),
            ([7,8,9,10,11], [4,5]),
            from_copy=True
        ))
        self.wait()
```
```python
class Demo_TransformByGlyphMap7(Scene):
    def construct(self):
        exp1 = MathTex("1 \\over x").scale(1.8)
        exp2 = MathTex("{ { 1 \\over x } - { 1 \\over x } } + 10").scale(1.8)
        self.add(exp1)
        self.wait()
        self.play(TransformByGlyphMap(exp1, exp2,
            ([0,1,2], [0,1,2]),
            ([0,1,2], [4,5,6]),
            default_introducer=Write,
            auto_fade=True
        ))
        self.wait()
```
```python
def construct(self):
    square = Square()
    side_length = MathTex("1.8").next_to(square, RIGHT)
    square.add(side_length)
    self.add(square)
    self.keep_orientation(side_length)
    self.play(Write(side_length))
    self.play(Rotate(square, 3*PI/2, about_point=ORIGIN, run_time=2))
    self.wait()
```
```python
class Demo_Arc3d(ThreeDScene):
    def construct(self):
        cs = ThreeDAxes().set_color(GRAY)
        self.add(cs)
        C = Dot3D([1,3,1])
        self.add(C)
        self.move_camera(phi=75 * DEGREES, theta=25 * DEGREES)
        self.begin_ambient_camera_rotation(rate=0.2)
        A = Dot3D([2,0,3]).set_color(RED)
        B = Dot3D([-2,-2,-2]).set_color(BLUE)
        CA = Line(C.get_center(), A.get_center())
        CB = Line(C.get_center(), B.get_center())      
        self.add(A,B)
        self.play(Create(CA), Create(CB))
        self.play(Create(Arc3d(A=A.get_center(), B=B.get_center(), center=C.get_center(), radius=1.5, segments=30)))
        self.wait(6)
```
```python
class Demo_indexx_labels(Scene):
    def construct(self):
        M1 = MathTex("a^2+b^2=c^2")
        M2 = MathTex("\\sin \\left(", "{a^2+b^2}", "\\over", "{3n+1}", "\\right)")
        self.add(VGroup(M1, M2.scale(2)).arrange(DOWN, buff=1))
        self.add(indexx_labels(M1), indexx_labels(M2))
```

## Para usar `actuarialsymbol`

```python
%%manim -qh -v WARNING ActuarialSymbolExplainer

from manim import *

from manim import *

# 1. Define the custom TeX Template to include the actuarialsymbol package
actuarial_template = TexTemplate(
    preamble=r"""
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{actuarialsymbol}
"""
)

class ActuarialSymbolExplainer(Scene):
    def construct(self):
        # We create the correctly formatted, full symbol as a single object.
        full_symbol = MathTex(r"\qx[t]{x}", tex_template=actuarial_template).scale(3)

        # Show the full formula first
        self.play(Write(full_symbol))
        self.wait(1)
        # Move the formula up to make space for the explanation combo.
        self.play(full_symbol.animate.shift(UP * 1.5))
        self.wait(0.5)

        # --- Explain each component one by one with a clear, sequential flow ---
        
        # 2. Explain 'q'
        q_part = Tex(r"q", color=YELLOW, tex_template=actuarial_template).next_to(full_symbol, DOWN, buff=1.2).scale(1.5)
        q_explanation = Tex(r"\textbf{q}: probability of death", color=YELLOW).next_to(q_part, DOWN)
        
        self.play(Write(q_part), Write(q_explanation))
        self.wait(2.5)
        self.play(FadeOut(q_part), FadeOut(q_explanation))

        # 3. Explain 'x'
        x_part = Tex(r"x", color=BLUE, tex_template=actuarial_template).next_to(full_symbol, DOWN, buff=1.2).scale(1.5)
        x_explanation = Tex(r"\textbf{x}: attained age at the start", color=BLUE).next_to(x_part, DOWN)

        self.play(Write(x_part), Write(x_explanation))
        self.wait(2.5)
        self.play(FadeOut(x_part), FadeOut(x_explanation))
        
        # 4. Explain 't'
        t_part = Tex(r"t", color=GREEN, tex_template=actuarial_template).next_to(full_symbol, DOWN, buff=1.2).scale(1.5)
        t_explanation = Tex(r"\textbf{t}: time period that has passed", color=GREEN).next_to(t_part, DOWN)
        
        self.play(Write(t_part), Write(t_explanation))
        self.wait(2.5)
        self.play(FadeOut(t_part), FadeOut(t_explanation))

        # --- Show the final, combined meaning ---
        final_text = VGroup(
            Tex("The probability that a person aged ($x$)"),
            Tex("will die within ($t$) years.")
        ).arrange(DOWN, aligned_edge=LEFT).scale(0.9).next_to(full_symbol, DOWN, buff=0.7)

        # Highlight the symbols in the final text
        final_text[0].set_color_by_tex('($x$)', BLUE)
        final_text[1].set_color_by_tex('($t$)', GREEN)

        self.play(Write(final_text))
        self.wait(5)
        self.play(FadeOut(final_text, full_symbol))

        # --- Add the identity: p + q = 1 ---
        identity = MathTex(
            r"\px[t]{x} + \qx[t]{x} = 1",
            tex_template=actuarial_template
        ).scale(2.5)

        self.play(Write(identity))
        self.wait(5)
```

### Recursos

- [Documentación oficial de Manim](https://docs.manim.community/)
- [Galería de ejemplos](https://docs.manim.community/en/stable/examples.html)
- [Tutorial de Manim](https://docs.manim.community/en/stable/tutorials.html)
