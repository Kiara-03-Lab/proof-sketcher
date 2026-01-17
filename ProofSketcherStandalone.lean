/-
# Proof Sketcher - Standalone Version

This is a minimal version that works without Mathlib dependency.
Use this for quick testing or if you don't need Mathlib tactics.

To use: copy this file into any Lean 4 project.
-/

import Lean

namespace ProofSketcher

open Lean Elab Tactic Meta

-- Counters for tracking progress
initialize sketchCounter : IO.Ref Nat ← IO.mkRef 0
initialize formalizedCounter : IO.Ref Nat ← IO.mkRef 0

/-- Reset counters -/
def resetCounters : IO Unit := do
  sketchCounter.set 0
  formalizedCounter.set 0

/-! ## Sketch Tactic -/

syntax (name := sketch) "sketch " str " : " term : tactic

@[tactic sketch]
def evalSketch : Tactic := fun stx => do
  let descStx := stx[1]
  let propStx := stx[3]

  let description := match descStx.isStrLit? with
    | some s => s
    | none => "unnamed step"

  sketchCounter.modify (· + 1)
  let count ← sketchCounter.get

  logInfo m!"🔶 Sketch #{count}: {description}"
  evalTactic (← `(tactic| have : $propStx := by sorry))

/-! ## Milestone Tactic -/

syntax (name := milestone) "milestone " str " : " term " := by " tacticSeq : tactic

@[tactic milestone]
def evalMilestone : Tactic := fun stx => do
  let descStx := stx[1]
  let propStx := stx[3]
  let tacStx := stx[6]

  let description := match descStx.isStrLit? with
    | some s => s
    | none => "unnamed milestone"

  formalizedCounter.modify (· + 1)
  let count ← formalizedCounter.get

  logInfo m!"✅ Milestone #{count}: {description}"
  evalTactic (← `(tactic| have : $propStx := by $tacStx))

/-! ## Outline Tactic -/

syntax (name := outline) "outline " str : tactic

@[tactic outline]
def evalOutline : Tactic := fun stx => do
  let descStx := stx[1]
  let description := match descStx.isStrLit? with
    | some s => s
    | none => "proof outline"

  logInfo m!"📋 Proof Outline: {description}"
  pure ()

/-! ## Progress Tactic -/

syntax (name := progress) "progress" : tactic

@[tactic progress]
def evalProgress : Tactic := fun _ => do
  let sketched ← sketchCounter.get
  let formalized ← formalizedCounter.get
  let total := sketched + formalized

  if total == 0 then
    logInfo m!"📊 No steps recorded yet"
  else
    let pct := (formalized * 100) / total
    logInfo m!"📊 Progress: {formalized}/{total} steps formalized ({pct}%)"
    if sketched > 0 then
      logInfo m!"   ⚠️  {sketched} steps still use 'sorry'"
  pure ()

/-! ## QED Tactic -/

syntax (name := qed) "qed" : tactic

@[tactic qed]
def evalQed : Tactic := fun _ => do
  let sketched ← sketchCounter.get
  let formalized ← formalizedCounter.get

  if sketched > 0 then
    logWarning m!"⚠️  Proof complete but {sketched} steps are still sketched"
  else if formalized > 0 then
    logInfo m!"🎉 Proof complete! All {formalized} milestones verified."
  else
    logInfo m!"✓ Proof complete."

  evalTactic (← `(tactic| done <|> assumption <|> trivial))

end ProofSketcher

/-! ## Quick Tests -/

-- Test 1: Basic sketch
theorem test_sketch (n : Nat) : n = n := by
  sketch "reflexivity" : n = n
  assumption

-- Test 2: Milestone
theorem test_milestone (a b : Nat) : a + b = a + b := by
  milestone "reflexivity of addition" : a + b = a + b := by rfl
  assumption

-- Test 3: Combined workflow
theorem test_combined (P : Prop) (h : P) : P := by
  outline "Trivial proof from hypothesis"
  milestone "use hypothesis directly" : P := by exact h
  progress
  qed

-- Test 4: Multiple sketches
theorem test_multi (a b c : Nat) : a + (b + c) = a + (b + c) := by
  sketch "associativity doesn't matter here" : a + (b + c) = a + (b + c)
  progress  -- Should show 1 sketch
  assumption

#check test_sketch
#check test_milestone
#check test_combined
#check test_multi
