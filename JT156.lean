import Lean

/-!
The finite hypergraph in Jensen--Toft 15.6, encoded from the three rules in
the paper. This file checks the eleven-vertex witness. The external theorem
that every four-uniform non-two-colorable hypergraph has at least 23 edges is
not formalized here.
-/

namespace JT156

abbrev Edge := List Nat

def pairs : List Edge := [[0, 1], [2, 3], [4, 5], [6, 7]]
def uPairs : List Edge := [[8, 9], [8, 10], [9, 10]]

def familyI : List Edge :=
  pairs.flatMap (fun p => uPairs.map (fun s => p ++ s))

def familyII : List Edge :=
  (List.range 2).flatMap (fun i =>
    (List.range 2).flatMap (fun j =>
      (List.range 2).flatMap (fun k =>
        if (i + j + k) % 2 = 0 then
          [[i, 2 + j, 4 + k, 6], [i, 2 + j, 4 + k, 7]]
        else [])))

def familyIII : List Edge :=
  (List.range 2).flatMap (fun i =>
    (List.range 2).flatMap (fun j =>
      (List.range 2).flatMap (fun k =>
        if (i + j + k) % 2 = 1 then
          [[i, 2 + j, 4 + k, 6, 7]]
        else [])))

def edges : List Edge := familyI ++ familyII ++ familyIII

theorem familyI_count : familyI.length = 12 := by decide
theorem familyII_count : familyII.length = 8 := by decide
theorem familyIII_count : familyIII.length = 4 := by decide
theorem edge_count : edges.length = 24 := by decide
theorem edge_nodup : edges.Nodup := by decide
theorem vertex_bounds :
    edges.all (fun e => e.all (fun v => decide (v < 11))) = true := by decide
theorem four_edge_count : (edges.filter (fun e => e.length == 4)).length = 20 := by decide
theorem five_edge_count : (edges.filter (fun e => e.length == 5)).length = 4 := by decide

def colorAt (colors : List Nat) (v : Nat) : Nat :=
  (colors[v]?).getD 0

def monochromatic (colors : List Nat) : Edge → Bool
  | [] => false
  | v :: rest => rest.all (fun w => colorAt colors w == colorAt colors v)

def hasMonochromaticEdge (colors : List Nat) : Bool :=
  edges.any (monochromatic colors)

-- This universal statement covers every one of the 2^11 red--blue assignments.
theorem no_two_coloring :
    ∀ a0 a1 b0 b1 c0 c1 d0 d1 u0 u1 u2 : Bool,
      hasMonochromaticEdge
        [(a0.toNat), (a1.toNat), (b0.toNat), (b1.toNat),
         (c0.toNat), (c1.toNat), (d0.toNat), (d1.toNat),
         (u0.toNat), (u1.toNat), (u2.toNat)] = true := by
  native_decide

def threeColoring : List Nat := [0, 0, 1, 1, 0, 0, 0, 0, 2, 2, 2]

theorem three_coloring_proper :
    hasMonochromaticEdge threeColoring = false := by decide

-- In units of 1/32, a four-edge contributes 2 and a five-edge contributes 1.
theorem witness_weight_numerator :
    2 * (edges.filter (fun e => e.length == 4)).length +
      (edges.filter (fun e => e.length == 5)).length = 44 := by decide

theorem weight_below_23_four_edges : 44 < 2 * 23 := by decide

-- This comparison is conditional on an externally supplied lower bound.
theorem comparison_given_m4 (m4 : Nat) (h : 23 ≤ m4) : 44 < 2 * m4 := by
  omega

#print axioms no_two_coloring
#print axioms three_coloring_proper

end JT156
