"""Independent finite audit of the hypergraph in the paper.

Vertices 0,1 form A; 2,3 form B; 4,5 form C; 6,7 form D;
8,9,10 form U. No external Python packages are needed.
"""

from collections import Counter
from fractions import Fraction
from itertools import combinations, product


PAIRS = ((0, 1), (2, 3), (4, 5), (6, 7))
U = (8, 9, 10)


def make_edges():
    family_i = [tuple(sorted((*pair, *two)))
                for pair in PAIRS for two in combinations(U, 2)]
    family_ii = [tuple(sorted((i, 2 + j, 4 + k, 6 + delta)))
                 for i, j, k in product(range(2), repeat=3)
                 if (i + j + k) % 2 == 0 for delta in range(2)]
    family_iii = [tuple(sorted((i, 2 + j, 4 + k, 6, 7)))
                  for i, j, k in product(range(2), repeat=3)
                  if (i + j + k) % 2 == 1]
    edges = family_i + family_ii + family_iii
    assert len(family_i) == 12 and len(family_ii) == 8 and len(family_iii) == 4
    assert len(edges) == len(set(edges)) == 24
    return tuple(sorted(edges))


def proper(edges, coloring):
    return all(len({coloring[v] for v in edge}) > 1 for edge in edges)


def main():
    edges = make_edges()
    assert Counter(map(len, edges)) == {4: 20, 5: 4}
    checked = 0
    for coloring in product(range(2), repeat=11):
        assert not proper(edges, coloring), f"unexpected two-coloring: {coloring}"
        checked += 1
    three_colors = (0, 0, 1, 1, 0, 0, 0, 0, 2, 2, 2)
    assert proper(edges, three_colors)
    weight = sum((Fraction(1, 2 ** len(edge)) for edge in edges), Fraction())
    assert weight == Fraction(11, 8) < Fraction(23, 16)
    print(f"vertices: 11; edges: {len(edges)} (20 of size 4, 4 of size 5)")
    print(f"two-colorings checked: {checked}; proper two-colorings: 0")
    print("proper three-coloring:", three_colors)
    print(f"weight: {weight}; four-uniform benchmark: 23/16")
    print("PASS: finite witness. The benchmark m(4) = 23 is an external theorem.")


if __name__ == "__main__":
    main()
