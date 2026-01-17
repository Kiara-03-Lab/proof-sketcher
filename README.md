# Proof Sketcher 📐

**Proof Sketcher** is a Lean 4 library for *top-down* proof development. It lets you outline the logical structure of a proof before filling in all the details.

## The Problem

Traditional proof development in theorem provers is **bottom-up**:

```
Axioms → Lemmas → More Lemmas → Theorem
```

But mathematicians think **top-down**:

```
Theorem → "The key insight is..." → "This follows because..." → Details
```

This cognitive mismatch makes formal verification harder than it needs to be.

## The Solution

Proof Sketcher provides tactics that let you:

1. **Outline** your proof strategy
2. **Sketch** logical milestones (deferred with `sorry`)
3. **Formalize** incrementally as you work out details
4. **Track progress** toward a complete proof

## Quick Start

```lean
import ProofSketcher

theorem my_theorem (P Q : Prop) (hp : P) (hq : Q) : Q ∧ P := by
  outline "Prove Q ∧ P from hypotheses"
  
  sketch "We have Q" : Q
  sketch "We have P" : P  
  sketch "Therefore Q ∧ P" : Q ∧ P
  
  assumption
```

As you formalize, replace `sketch` with `milestone`:

```lean
theorem my_theorem_v2 (P Q : Prop) (hp : P) (hq : Q) : Q ∧ P := by
  outline "Prove Q ∧ P from hypotheses"
  
  milestone "We have Q" : Q := by exact hq
  milestone "We have P" : P := by exact hp
  milestone "Therefore Q ∧ P" : Q ∧ P := by exact ⟨‹Q›, ‹P›⟩
  
  progress  -- Shows: 3/3 steps formalized (100%)
  qed
```

## Installation

Add to your `lakefile.lean`:

```lean
require proof_sketcher from git
  "https://github.com/YOUR_USERNAME/proof_sketcher.git"
```

Then run:

```bash
lake update
lake build
```

## Tactics Reference

| Tactic | Syntax | Effect |
|--------|--------|--------|
| `sketch` | `sketch "desc" : P` | Assert `P`, defer proof with `sorry` |
| `milestone` | `milestone "desc" : P := by tac` | Assert and prove `P` |
| `outline` | `outline "desc"` | Document proof structure (no-op) |
| `progress` | `progress` | Show formalization statistics |
| `qed` | `qed` | Finalize proof with summary |

## Mathematical Foundation

A proof sketch represents a proof as a sequence of claims:

$$P_0 \to P_1 \to P_2 \to \cdots \to P_n$$

Where:
- $P_0$ is your hypothesis
- $P_n$ is your goal
- Each $P_i \to P_{i+1}$ is a "step" you claim is provable

The `sketch` tactic lets you assert $P_i$ and use it immediately, while deferring the actual proof of how to derive $P_i$ from earlier facts.

## Workflow

### 1. Start with an outline

```lean
theorem sqrt2_irrational : Irrational (Real.sqrt 2) := by
  outline "Proof by infinite descent"
  
  sketch "Assume √2 = p/q with gcd(p,q) = 1" : ...
  sketch "Then p² = 2q², so p is even" : ...
  sketch "Write p = 2k, get q² = 2k², so q is even" : ...
  sketch "Contradiction: gcd(p,q) ≥ 2" : ...
  
  sorry
```

### 2. Formalize incrementally

Work on one `sketch` at a time, converting to `milestone` as you complete each step.

### 3. Track progress

Use `progress` to see how many steps remain:

```
📊 Progress: 2/4 steps formalized (50%)
   ⚠️  2 steps still use 'sorry'
```

### 4. Finish with `qed`

When all sketches are converted to milestones, `qed` confirms completion:

```
🎉 Proof complete! All 4 milestones verified.
```

## Examples

See `Examples.lean` for complete working examples including:

- Simple arithmetic proofs
- Logical reasoning (conjunction commutativity)
- Induction outlines
- Mixed sketch/milestone workflows

## Contributing

We welcome contributions! Great first issues:

1. Add sketches for classic theorems (infinitude of primes, Pythagorean theorem, etc.)
2. Improve Infoview integration
3. Add LaTeX export for proof outlines
4. Create a "hint" system that suggests tactics for sketched steps

## Philosophy

> "The first draft of anything is garbage." — Ernest Hemingway

This applies to proofs too. Proof Sketcher lets you write that first draft—the logical skeleton—without getting stuck on the details. Then you refine, just like editing prose.

## Future Roadmap

Proof Sketcher is evolving to become a **mathematician-first proof assistant** that bridges natural mathematical thinking with formal verification. Our roadmap focuses on:

### Near-Term (2026)
- 🔴 **Human-readable error messages** - No more type theory jargon
- 🔴 **Natural language connectors** - Write `using`, `because`, `from` instead of just `by`
- 🔴 **Browser playground** - Try Proof Sketcher with zero installation
- 🟡 **Theorem search integration** - Find theorems by description, not name
- 🟡 **LaTeX export** - Generate publication-ready proofs from sketches
- 🟡 **Auto-discharge trivial goals** - Stop proving `n + 0 = n` manually

### Long-Term Vision
- **Blueprint integration** - Separate human-readable proofs from machine code
- **Collaborative branching** - Try multiple proof approaches side-by-side
- **AI-assisted sketching** - Suggest next milestones based on your goal
- **Cross-prover export** - Generate Coq, Isabelle, or Metamath from sketches

**Full details:** See [ROADMAP.md](ROADMAP.md) for the complete development plan, timelines, and design principles.

**Get involved:** We're actively seeking feedback from mathematicians! Join us on [Lean Zulip #proof-sketcher](https://leanprover.zulipchat.com/) or open an issue with your frustrations and feature requests.

## License

MIT

---

*Created with rigor in Lean 4* 🦔
