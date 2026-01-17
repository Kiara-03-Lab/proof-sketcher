/-
# Proof Sketcher - Basic Tests

Tests for core functionality to prevent regressions.
-/

import ProofSketcher

namespace ProofSketcherTests

/-! ## Sketch Tactic Tests -/

-- Test: sketch allows assumption to close goal
theorem test_sketch_basic : True := by
  sketch "trivial" : True
  assumption

-- Test: sketch with natural number equality
theorem test_sketch_nat (n : Nat) : n = n := by
  sketch "reflexivity" : n = n
  assumption

/-! ## Milestone Tactic Tests -/

-- Test: milestone with proof
theorem test_milestone_basic : True := by
  milestone "prove true" : True := by
    trivial

-- Test: milestone can be used in subsequent steps
theorem test_milestone_usage (n : Nat) : n + 0 = n := by
  milestone "addition identity" : n + 0 = n := by
    exact Nat.add_zero n
  assumption

/-! ## Outline Tactic Tests -/

-- Test: outline doesn't interfere with proof
theorem test_outline : True := by
  outline "this is a simple proof"
  trivial

/-! ## Combined Tests -/

-- Test: mixing sketch, milestone, and outline
theorem test_combined (a b : Nat) : a + b = b + a := by
  outline "Prove commutativity"
  
  sketch "Use standard library theorem" : a + b = b + a
  
  assumption

#check test_sketch_basic
#check test_milestone_basic
#check test_outline
#check test_combined

end ProofSketcherTests
