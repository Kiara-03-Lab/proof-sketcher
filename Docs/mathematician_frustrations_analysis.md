# Top 20 Frustrations a Mathematician (Non-Coder) Would Have with Proof Sketcher

Based on analysis of real mathematician feedback from Lean Zulip, Terence Tao's blog, academic papers on Lean UX, and the Xena project, here are the specific pain points a mathematician without coding skills would encounter with the current Proof Sketcher implementation.

---

## 1. **"What is `IO.Ref Nat`? I just want to count steps!"**
*Source: Lean Finder paper notes "Lean's syntax, grammar, and tactics incur a steep learning curve"*

The code exposes low-level Lean programming constructs:
```lean
initialize sketchCounter : IO.Ref Nat ← IO.mkRef 0
```
A mathematician sees: "What is IO? What is Ref? What is mkRef? I understand counting to 5."

**Fix needed:** Hide all implementation details. Mathematicians should never see monad types.

---

## 2. **"Why do I need to write `by` before everything?"**
*Source: Zulip teaching thread - "Students won't have to remember commas but they will fail because of whitespace sensitivity"*

The syntax `milestone "desc" : P := by tac` requires understanding that `by` enters "tactic mode."

A mathematician thinks: "In my paper I just write 'by [Theorem 3.2]'. Why do I need special keywords?"

**Fix needed:** Allow natural language connectors like `because`, `using`, `from`.

---

## 3. **"The error messages are incomprehensible"**
*Source: wolfgirl.dev - "errors are reported far away from where the 'wrong' thing actually happened"*

When a sketch fails, errors like:
```
type mismatch
  this
has type
  ?m.1234
but is expected to have type
  Prop
```

A mathematician: "I know what I meant! Why can't you figure it out?"

**Fix needed:** Human-readable error messages explaining mathematical gaps, not type theory violations.

---

## 4. **"How do I find the theorem I need?"**
*Source: Lean Finder paper - "locating the right theorem is frustrating: search tools are rudimentary, naming conventions are often inconsistent"*

The code provides no guidance on what theorems exist. `simp`, `ring`, `linarith` - where do these come from?

A mathematician: "I know the Fundamental Theorem of Calculus exists. How do I use it?"

**Fix needed:** Integrate theorem search/suggestion into the sketch workflow.

---

## 5. **"Why does `n + 0 = n` need a 'proof'?"**
*Source: Terence Tao's blog comment - "proofs not meant to be read are exactly what is exposed"*

The example:
```lean
have h1 : n + 0 = n := by simp
```

A mathematician: "This is definitionally true. Why am I proving the obvious?"

**Fix needed:** Auto-discharge trivial goals, explain when manual proof is actually needed.

---

## 6. **"I can't read my own proof anymore"**
*Source: Tao blog - "Lean proofs 'aren't meant to be read'... run-together roman letters... Couldn't Mathlib_hvDoneBetr?"*

After writing:
```lean
evalTactic (← `(tactic| have : $propStx := by sorry))
```

A mathematician: "This looks like noise. Where is the mathematics?"

**Fix needed:** Proof Sketcher should generate human-readable output, not just machine-checkable code.

---

## 7. **"What does 'elaboration' mean? What's a 'tactic'?"**
*Source: Learning Lean page - "Proof assistants are still difficult to use... different from how mathematicians think"*

The code uses terms like `evalTactic`, `Tactic`, `Elab` without explanation.

A mathematician: "I've written 50 papers and never used the word 'elaboration'."

**Fix needed:** Use mathematical vocabulary: "step", "claim", "deduce", "assume".

---

## 8. **"The progress counter resets randomly"**
*Source: Code analysis - counters use `IO.Ref` which persists across the process but not across files*

A mathematician working on multiple files: "I had 5 sketches, now it says 1?"

**Fix needed:** Progress should be scoped to individual theorems, not global state.

---

## 9. **"Why are there Greek letters and weird symbols I didn't type?"**
*Source: Zulip - "you can finally use characters like '≺' and '⋂'... but the 'words' formed... Oof"*

Lean's Unicode: `∀`, `∃`, `→`, `←`, `↔`, `λ`, `Π`

A mathematician: "I write 'for all x' not '∀ x'. Let me write natural language."

**Fix needed:** Accept ASCII alternatives, auto-convert to Unicode for display only.

---

## 10. **"Where is my proof? I want to export it to LaTeX"**
*Source: Tao blog - "I like the Blueprint model in which LaTeX is used to describe the human readable version"*

The sketch tactic logs to Infoview but doesn't generate exportable output.

A mathematician: "I need to put this in my paper. How do I get LaTeX?"

**Fix needed:** Add `export_latex` command that generates a .tex file from sketches.

---

## 11. **"Installing this requires 50 steps and a PhD in DevOps"**
*Source: Zulip - "it was really helpful that students didn't have to install Lean... There currently is no browser version"*

The lakefile requires:
- Installing elan
- Running `lake update`
- Downloading 5GB of Mathlib
- Waiting 20+ minutes to build

A mathematician: "I just want to try it. Can't I use it in browser?"

**Fix needed:** Provide online playground, pre-built Docker images, or minimal non-Mathlib version.

---

## 12. **"My proof worked yesterday, now it doesn't compile"**
*Source: Zulip - "lake: bouncing between versions"*

Lean/Mathlib version changes break code silently.

A mathematician: "Mathematics doesn't change! Why does my code?"

**Fix needed:** Pin stable versions, provide migration tools, explain breaking changes clearly.

---

## 13. **"I don't understand what `sorry` actually does"**
*Source: Xena project - "misformalization is a big issue"*

`sorry` accepts ANY proposition. A mathematician might write:
```lean
sketch "0 = 1" : (0 : Nat) = 1
```
...and the code accepts it!

A mathematician: "Wait, I just 'proved' a false statement? This is dangerous."

**Fix needed:** Warn clearly about sorry's nature, track unproven claims prominently.

---

## 14. **"The naming convention makes no sense"**
*Source: Lean Finder - "naming conventions are often inconsistent"*

Is it `add_comm` or `Nat.add_comm` or `Add.comm`? 

A mathematician: "I call it 'commutativity of addition'. Why do I need to know the namespace?"

**Fix needed:** Accept natural language descriptions, auto-resolve to formal names.

---

## 15. **"Whitespace breaks everything"**
*Source: Zulip teaching thread - "students... will fail because of whitespace sensitivity"*

```lean
theorem foo : P := by
  sketch "step" : Q   -- works
 sketch "step" : Q    -- ERROR: unexpected indentation
```

A mathematician: "I'm used to TeX where spaces don't matter!"

**Fix needed:** Provide more forgiving parsing or better indentation error messages.

---

## 16. **"What's the difference between `have`, `let`, `show`, `suffices`?"**
*Source: Zulip - "There is a lot of have, assume, suffices, show from. Are these implemented?"*

The sketch tactic only uses `have`. But Lean has many similar constructs.

A mathematician: "These all seem to mean 'assume this is true'. Why so many words?"

**Fix needed:** Unify under mathematical vocabulary: "claim", "suppose", "therefore".

---

## 17. **"I want to write math, not debug type errors"**
*Source: wolfgirl.dev - "returning the wrong type of Unit... very strange errors"*

When types don't unify:
```
application type mismatch
  h1
argument
  h1
has type
  n + 0 = n : Prop
but is expected to have type
  0 + n = n : Prop
```

A mathematician: "These are the same thing! Commutativity!"

**Fix needed:** Auto-apply obvious rewrites, suggest fixes instead of just failing.

---

## 18. **"The Infoview is overwhelming"**
*Source: Beginner's Companion blog - "One of the biggest pain points... was finding theorems to use"*

The VS Code Infoview shows:
- Current goal
- Local context (potentially dozens of hypotheses)
- Messages
- All at once

A mathematician: "I just want to see: what do I need to prove next?"

**Fix needed:** Simplified "sketch view" showing just: current milestone, remaining steps.

---

## 19. **"I can't collaborate with my co-author who doesn't use Lean"**
*Source: Tao on PFR - blueprint allowed distributed collaboration*

The code only exists in Lean. No way to share with non-Lean users.

A mathematician: "My collaborator uses Coq / pen and paper / nothing. How do we work together?"

**Fix needed:** Export to markdown/PDF with formal Lean code hidden, human text visible.

---

## 20. **"Where's the 'undo'? I want to try a different approach"**
*Source: Common programming frustration + proof assistant workflow*

Lean is not interactive like a scratchpad. You can't easily branch and explore.

A mathematician: "I want to try two approaches and see which works. How do I do that without copy-pasting files?"

**Fix needed:** Support named branches/alternatives within a proof: `alternative "try induction" : ...`

---

## Summary: What Proof Sketcher Should Become

| Current State | Mathematician Expectation |
|--------------|--------------------------|
| Programming syntax | Mathematical English |
| Type theory errors | "You need to prove X first" |
| `sorry` silently accepts | Clear warning: "UNPROVEN: ..." |
| Global state | Per-theorem tracking |
| Lean-only output | LaTeX/Markdown export |
| Complex installation | Browser playground |
| Namespace hunting | Natural language search |
| Whitespace sensitive | Forgiving parser |

The core insight from Terence Tao's experience: **The "Blueprint" model works because it separates human-readable mathematics from machine-checkable code.** Proof Sketcher should embrace this separation rather than forcing mathematicians to write Lean directly.
