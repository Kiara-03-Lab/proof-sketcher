/-
# Proof Sketcher Examples

This file demonstrates how to use Proof Sketcher for
top-down proof development.

## Philosophy

Traditional proof development is "bottom-up":
  Start with axioms → Build lemmas → Reach theorem

Top-down development inverts this:
  State theorem → Outline key steps → Fill in details

This mirrors how mathematicians actually think about proofs.
-/

import ProofSketcher

namespace Examples

/-! ## Example 1: Simple Arithmetic

Let's prove a basic fact about natural numbers.
We'll first sketch, then formalize.
-/

-- Version 1: Pure sketch (all steps deferred)
theorem add_comm_sketch (a b : Nat) : a + b = b + a := by
  outline "Prove commutativity of addition"

  sketch "Use the built-in commutativity" : a + b = b + a

  -- The sketch gives us our goal as a hypothesis
  assumption

-- Version 2: Fully formalized
theorem add_comm_formal (a b : Nat) : a + b = b + a := by
  outline "Prove commutativity of addition"

  milestone "Apply Nat.add_comm" : a + b = b + a := by
    exact Nat.add_comm a b

  progress
  qed

/-! ## Example 2: Logical Reasoning

Prove a simple logical equivalence.
-/

-- Sketch version
theorem and_comm_sketch (P Q : Prop) : P ∧ Q → Q ∧ P := by
  outline "Prove commutativity of conjunction"

  intro hpq

  sketch "Extract P from hypothesis" : P
  sketch "Extract Q from hypothesis" : Q
  sketch "Recombine as Q ∧ P" : Q ∧ P

  assumption

-- Formalized version
theorem and_comm_formal (P Q : Prop) : P ∧ Q → Q ∧ P := by
  outline "Prove commutativity of conjunction"

  intro hpq

  milestone "Extract P from hypothesis" : P := by
    exact hpq.left

  milestone "Extract Q from hypothesis" : Q := by
    exact hpq.right

  milestone "Recombine as Q ∧ P" : Q ∧ P := by
    exact ⟨‹Q›, ‹P›⟩

  progress
  qed

/-! ## Example 3: Proof by Induction (Outline)

When proving by induction, sketching helps organize:
1. Base case
2. Inductive hypothesis
3. Inductive step
-/

-- Sketch the structure of a proof that 0 + n = n
theorem zero_add_sketch (n : Nat) : 0 + n = n := by
  outline "Prove 0 + n = n by induction on n"

  -- For this simple case, we can use the built-in
  sketch "By definition of addition" : 0 + n = n

  assumption

-- A more complex example: sum of first n naturals
-- This demonstrates outlining before diving into details

theorem sum_formula_sketch (n : Nat) : 2 * (List.range n).sum = n * (n - 1) := by
  outline "Prove 2 * Σᵢ₌₀ⁿ⁻¹ i = n(n-1)"

  -- Sketch the key steps
  sketch "Base case n = 0 is trivial" : n = 0 → 2 * (List.range 0).sum = 0 * (0 - 1)

  sketch "For inductive case, use sum(range(n+1)) = sum(range(n)) + n" :
    ∀ k, (List.range (k + 1)).sum = (List.range k).sum + k

  sketch "Final algebraic manipulation" : 2 * (List.range n).sum = n * (n - 1)

  assumption

/-! ## Example 4: Mixed Sketching and Proving

In practice, you'll have some steps you can prove immediately
and others you want to defer. Mix `sketch` and `milestone` freely.
-/

theorem mixed_example (x y : Nat) (h : x < y) : x + 1 ≤ y := by
  outline "From x < y, derive x + 1 ≤ y"

  -- This step we can prove
  milestone "x < y means Nat.succ x ≤ y" : Nat.succ x ≤ y := by
    exact h

  -- This reformulation we sketch
  sketch "Nat.succ x = x + 1" : Nat.succ x = x + 1

  -- Use our hypothesis
  milestone "Conclude x + 1 ≤ y" : x + 1 ≤ y := by
    simp only [Nat.succ_eq_add_one] at *
    assumption

  progress
  qed

/-! ## Example 5: A "Real" Mathematical Proof Outline

Let's outline the classic proof that √2 is irrational.
This won't compile (we're not importing the real numbers)
but shows the intended workflow.
-/

-- This is pseudo-code showing the intended usage pattern
/-
theorem sqrt2_irrational : ¬∃ (p q : ℤ), q ≠ 0 ∧ p^2 = 2 * q^2 := by
  outline "Prove √2 is irrational by infinite descent"

  intro ⟨p, q, hq, heq⟩

  sketch "WLOG assume gcd(p,q) = 1" :
    ∃ p' q', gcd p' q' = 1 ∧ p'^2 = 2 * q'^2

  sketch "From p² = 2q², conclude p is even" :
    ∃ k, p = 2 * k

  sketch "Substitute p = 2k, get 2k² = q²" :
    ∃ k, q^2 = 2 * k^2

  sketch "Thus q is also even" :
    ∃ m, q = 2 * m

  sketch "Contradiction: gcd(p,q) ≥ 2" :
    False

  assumption
-/

end Examples
