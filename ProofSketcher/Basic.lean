/-
# Proof Sketcher - Core Tactics

This module provides tactics for "top-down" proof development in Lean 4.
The key insight: mathematicians often know the *structure* of a proof
before they know all the *details*. This library lets you:

1. Outline logical milestones with `sketch`
2. Formalize them incrementally with `milestone`
3. Track progress visually in the Infoview

## Mathematical Foundation

A proof sketch is essentially a sequence of claims:
  P₀ → P₁ → P₂ → ... → Pₙ

Where:
- P₀ is the hypothesis
- Pₙ is the goal
- Each Pᵢ → Pᵢ₊₁ is a "step" we claim is provable

The `sketch` tactic lets us assert Pᵢ and defer its proof via `sorry`,
while still being able to use Pᵢ in subsequent reasoning.
-/

import Lean

namespace ProofSketcher

open Lean Elab Tactic Meta

/-! ## Sketch Counter State

We maintain a global counter to track how many sketched (unproven) steps
remain. This enables progress tracking features.
-/

initialize sketchCounter : IO.Ref Nat ← IO.mkRef 0
initialize formalizedCounter : IO.Ref Nat ← IO.mkRef 0

/-- Get current sketch statistics -/
def getSketchStats : IO (Nat × Nat) := do
  let sketched ← sketchCounter.get
  let formalized ← formalizedCounter.get
  return (sketched, formalized)

/-- Reset counters (useful for testing) -/
def resetCounters : IO Unit := do
  sketchCounter.set 0
  formalizedCounter.set 0

/-! ## Core Tactics -/

/--
The `sketch` tactic: declare a logical step without proving it.

**Syntax:** `sketch "description" : Proposition`

**Effect:**
1. Logs the description to the Infoview
2. Adds `Proposition` as a hypothesis (via `sorry`)
3. Increments the sketch counter

**Example:**
```lean
theorem example_thm (n : Nat) : n + 0 = n := by
  sketch "addition identity" : n + 0 = n
  assumption
```
-/
syntax (name := sketch) "sketch " str " : " term : tactic

@[tactic sketch]
def evalSketch : Tactic := fun stx => do
  -- Parse the syntax tree
  -- stx[0] = "sketch"
  -- stx[1] = string literal (description)
  -- stx[2] = ":"
  -- stx[3] = term (proposition)
  let descStx := stx[1]
  let propStx := stx[3]

  -- Extract description string
  let description := match descStx.isStrLit? with
    | some s => s
    | none => "unnamed step"

  -- Increment sketch counter
  sketchCounter.modify (· + 1)
  let count ← sketchCounter.get

  -- Log to Infoview with emoji for visibility
  logInfo m!"🔶 Sketch #{count}: {description}"

  -- Inject: have : Prop := by sorry
  -- This adds the proposition to the local context
  evalTactic (← `(tactic| have : $propStx := by sorry))

/--
The `milestone` tactic: declare AND prove a logical step.

**Syntax:** `milestone "description" : Proposition := by tactic`

**Effect:**
1. Logs the description to the Infoview
2. Proves `Proposition` using the provided tactic
3. Adds the result as a hypothesis
4. Increments the formalized counter

**Example:**
```lean
theorem example_thm (n : Nat) : n + 0 = n := by
  milestone "n + 0 = n by definition" : n + 0 = n := by rfl
  assumption
```
-/
syntax (name := milestone) "milestone " str " : " term " := by " tacticSeq : tactic

@[tactic milestone]
def evalMilestone : Tactic := fun stx => do
  -- Parse syntax:
  -- stx[0] = "milestone"
  -- stx[1] = string literal
  -- stx[2] = ":"
  -- stx[3] = term
  -- stx[4] = ":="
  -- stx[5] = "by"
  -- stx[6] = tacticSeq
  let descStx := stx[1]
  let propStx := stx[3]
  let tacStx := stx[6]

  let description := match descStx.isStrLit? with
    | some s => s
    | none => "unnamed milestone"

  -- Increment formalized counter
  formalizedCounter.modify (· + 1)
  let count ← formalizedCounter.get

  -- Log success
  logInfo m!"✅ Milestone #{count}: {description}"

  -- Execute: have : Prop := by tacticSeq
  evalTactic (← `(tactic| have : $propStx := by $tacStx))

/--
The `outline` tactic: declare the overall proof structure.

**Syntax:** `outline "theorem description"`

This is purely for documentation - it logs to the Infoview
but doesn't affect the proof state.
-/
syntax (name := outline) "outline " str : tactic

@[tactic outline]
def evalOutline : Tactic := fun stx => do
  let descStx := stx[1]
  let description := match descStx.isStrLit? with
    | some s => s
    | none => "proof outline"

  logInfo m!"📋 Proof Outline: {description}"

  -- No-op tactic (doesn't change goal state)
  pure ()

/--
The `progress` tactic: show current sketch/milestone statistics.

**Syntax:** `progress`

Displays how many steps are sketched vs formalized.
-/
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

/--
The `qed` tactic: finalize a proof and report statistics.

**Syntax:** `qed`

Attempts to close the goal and reports final statistics.
Should be used at the end of a proof.
-/
syntax (name := qed) "qed" : tactic

@[tactic qed]
def evalQed : Tactic := fun _ => do
  let sketched ← sketchCounter.get
  let formalized ← formalizedCounter.get

  if sketched > 0 then
    logWarning m!"⚠️  Proof complete but {sketched} steps are still sketched (use 'sorry')"
  else if formalized > 0 then
    logInfo m!"🎉 Proof complete! All {formalized} milestones verified."
  else
    logInfo m!"✓ Proof complete."

  -- Try to close the goal
  evalTactic (← `(tactic| done <|> assumption <|> trivial))

end ProofSketcher
