# Jensen--Toft 15.6: uniform attainment

This folder contains the eleven-vertex hypergraph used in the accompanying
paper. Vertex numbers 0--1, 2--3, 4--5, and 6--7 form the pairs A, B, C, and
D; 8--10 form U. The three edge rules in `paper/jt156_uniform_attainment.tex`
generate 20 four-edges and four five-edges.

## Files

- `JT156.lean` checks the finite edge counts, absence of a red--blue coloring,
  an explicit three-coloring, and the numerical weight comparison.
- `lean-toolchain` pins Lean 4.35.0. There is no mathlib dependency.
- `verify.py` independently rebuilds the edges and tests all 2,048 binary
  colorings with standard Python.
- `edges.json` is the literal vertex and edge data.
- `paper/jt156_uniform_attainment.tex` and `.pdf` are the revised paper.

Verification was run successfully on macOS with Lean 4.35.0:

    lean JT156.lean
    python3 verify.py

Lean accepts the finite witness. The axiom audit reports `propext` and a
generated native-computation axiom for `no_two_coloring`, which uses
`native_decide`; `three_coloring_proper` uses only `propext`. Neither
reported theorem depends on `sorryAx`.

The Python verifier independently checks all 2,048 binary colorings.

The published lower bound `m(4) = 23` is not formalized here.
Consequently this repository does not provide an unconditional Lean
formalization of the paper's full conclusion.

The companion repository is planned at
<https://github.com/alexgocardinal/jt156-uniform-attainment>. Its link becomes
active after the repository is created and pushed.
