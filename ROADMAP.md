# Proof Sketcher Future Roadmap

*Based on mathematician frustrations analysis and real-world feedback from Lean community*

---

## Vision Statement

Transform Proof Sketcher from a Lean-centric tool into a **mathematician-first proof assistant** that bridges the gap between natural mathematical thinking and formal verification. Following the "Blueprint model" philosophy: separate human-readable mathematics from machine-checkable code.

---

## Phase 1: Critical Usability Fixes (Q1 2026)

**Goal:** Make Proof Sketcher immediately usable for mathematicians without programming experience.

### 1.1 Human-Readable Error Messages
- **Current:** Type theory jargon (`type mismatch`, `?m.1234`, etc.)
- **Target:** Mathematical explanations
  - "To complete this step, you first need to prove that n + 0 = n"
  - "This uses commutativity, which requires importing Math.Algebra.Ring.Basic"
- **Implementation:** Custom elaborator wrapper that translates meta-variable errors to proof gap descriptions
- **Priority:** 🔴 Critical

### 1.2 Natural Language Connectors
- **Current:** Must use `by`, `:=`, tactic mode keywords
- **Target:** Accept mathematical English
  ```lean
  milestone "Triangle inequality" using h1, h2
  milestone "Conclusion" because previous_step
  milestone "Base case" from induction_hypothesis
  ```
- **Implementation:** Parser layer accepting multiple phrasings, converting to canonical syntax
- **Priority:** 🔴 Critical

### 1.3 Hide Implementation Details
- **Current:** Exposes `IO.Ref`, monads, elaboration
- **Target:** Zero mentions of programming concepts in user-facing API
- **Implementation:** 
  - Refactor counters to use internal state tracking
  - Abstract all meta-programming behind high-level commands
  - Documentation rewrite: mathematical terminology only
- **Priority:** 🔴 Critical

### 1.4 Simplified Progress Tracking
- **Current:** Global counter, unclear scope
- **Target:** Per-theorem dashboard showing:
  ```
  Theorem: Fermat's Little Theorem
  Status: 3 of 5 milestones complete
  ✓ Base case established
  ✓ Induction hypothesis assumed
  ⚠ Inductive step (has sorry)
  ⚠ Conclusion (incomplete)
  ○ Not started: Edge case
  ```
- **Implementation:** Theorem-scoped metadata tracking, visual progress indicators
- **Priority:** 🟡 High

---

## Phase 2: Intelligent Assistance (Q2 2026)

**Goal:** Proactively help mathematicians find theorems and resolve trivial goals.

### 2.1 Theorem Search & Suggestion
- **Current:** No guidance on available theorems
- **Target:** Integrated search and autocomplete
  ```lean
  sketch "FTC applies" : integral_deriv f a b = f b - f a
  -- Suggests: `ContinuousOn.integral_deriv_eq`
  -- From: Analysis.Calculus.FTC
  ```
- **Implementation:**
  - Integrate with Lean Finder/Moogle-style semantic search
  - Type-directed suggestions based on current goal
  - Natural language query interface
- **Priority:** 🔴 Critical

### 2.2 Auto-Discharge Trivial Goals
- **Current:** Requires explicit proof for `n + 0 = n`
- **Target:** Silent automation with explanation
  ```lean
  milestone "Simplify" : n + 0 = n
  -- Info: Automatically proved by arithmetic simplification
  ```
- **Implementation:** 
  - Try `simp`, `ring`, `linarith`, `omega` automatically
  - Show which tactic succeeded in info message
  - Manual override: `milestone "..." : P by manual`
- **Priority:** 🟡 High

### 2.3 Smart Rewrites & Unification
- **Current:** Fails on `n + 0 = n` vs `0 + n = n`
- **Target:** Suggest obvious fixes
  ```
  Goal: 0 + n = n
  You have: n + 0 = n
  Suggestion: Apply commutativity (Nat.add_comm)?
  ```
- **Implementation:** Pattern matching on common mismatches, tactic recommendation system
- **Priority:** 🟡 High

---

## Phase 3: Export & Collaboration (Q2-Q3 2026)

**Goal:** Enable mathematicians to share work with non-Lean users and integrate into papers.

### 3.1 LaTeX Export
- **Current:** Output only visible in Infoview
- **Target:** Generate publication-ready LaTeX
  ```bash
  lake exe proof_sketcher export my_theorem.lean --format latex
  ```
  Output:
  ```latex
  \begin{proof}[Proof of Theorem 2.1]
  We proceed by induction on $n$.
  
  \textbf{Base case:} For $n = 0$, we have...
  
  \textbf{Inductive step:} Assume the claim holds for $n$...
  \end{proof}
  ```
- **Implementation:** 
  - Template system for proof structure
  - Milestone descriptions become LaTeX text
  - Optional: include formal Lean code in appendix
- **Priority:** 🟡 High

### 3.2 Markdown/Blueprint Export
- **Current:** Lean files only
- **Target:** Generate Blueprint-style documentation
  ```markdown
  ## Theorem 2.1 (Triangle Inequality)
  
  **Statement:** For all x, y: |x + y| ≤ |x| + |y|
  
  **Proof sketch:**
  1. Case x ≥ 0, y ≥ 0: ... [Lean proof](theorems.lean#L45)
  2. Case x < 0, y < 0: ... [Lean proof](theorems.lean#L67)
  
  **Status:** ✓ Fully formalized
  ```
- **Implementation:** 
  - HTML generator for web viewing
  - Links between human text and formal code
  - Integration with existing Blueprint tools (leanblueprint)
- **Priority:** 🟡 High

### 3.3 Collaborative Branching
- **Current:** No support for trying multiple approaches
- **Target:** Named proof branches
  ```lean
  theorem main : P := by
    sketch_branch "direct_proof" : P := by
      milestone "Step 1" : Q
      ...
    
    sketch_branch "by_contradiction" : P := by
      milestone "Assume ¬P" : ¬P
      ...
  ```
- **Implementation:** 
  - Branch metadata tracking
  - Compare success/complexity across branches
  - Merge completed branch into main proof
- **Priority:** 🟢 Medium

---

## Phase 4: Accessibility & Onboarding (Q3 2026)

**Goal:** Remove installation barriers, support non-coders.

### 4.1 Browser Playground
- **Current:** Requires local Lean installation (5GB, 20+ min build)
- **Target:** Online editor with instant start
  - No installation required
  - Pre-built Mathlib cache
  - Share proofs via URL
  - Fork and modify examples
- **Implementation:**
  - Lean 4 web build (already exists for live.lean-lang.org)
  - Server-side compilation with caching
  - OAuth for save/load functionality
- **Priority:** 🔴 Critical

### 4.2 Minimal Standalone Version
- **Current:** Depends on full Mathlib
- **Target:** Lightweight version for teaching
  - Core tactics only (no Mathlib)
  - Basic arithmetic and logic
  - Starts in <1 minute
  - Perfect for workshops and courses
- **Implementation:**
  - Separate `ProofSketcherCore` package
  - Optional Mathlib import
  - Curated "essential theorems" subset
- **Priority:** 🟡 High

### 4.3 ASCII Input Support
- **Current:** Unicode symbols (`∀`, `∃`, `→`)
- **Target:** Accept ASCII, display Unicode
  ```lean
  -- Type: forall x, exists y, x -> y
  -- Display: ∀ x, ∃ y, x → y
  
  -- Type: /\ (and), \/ (or), -> (implies)
  -- Display: ∧, ∨, →
  ```
- **Implementation:**
  - Parser accepts both forms
  - Pretty-printer shows Unicode
  - Configuration option for ASCII-only mode
- **Priority:** 🟢 Medium

### 4.4 Interactive Tutorial System
- **Current:** README only
- **Target:** Guided walkthrough with immediate feedback
  - "Complete this proof sketch for n + 0 = n"
  - "Find the theorem for commutativity"
  - "Export your proof to LaTeX"
- **Implementation:**
  - In-editor tutorial mode
  - Progressive difficulty levels
  - Integration with error messages ("Try the tutorial on theorem search")
- **Priority:** 🟢 Medium

---

## Phase 5: Advanced Features (Q4 2026)

**Goal:** Support professional mathematicians doing research-level work.

### 5.1 Sorry Warnings & Tracking
- **Current:** `sorry` silently accepts anything
- **Target:** Prominent tracking of gaps
  ```lean
  theorem main : P := by
    milestone "Unproven lemma" : Q := by sorry
    -- ⚠ WARNING: This step is incomplete!
    -- This allows you to continue, but the theorem is not proven.
    
  -- At end of file:
  -- ⚠ SUMMARY: 1 theorem has unproven steps
  --   • main: 1 sorry at line 45
  ```
- **Implementation:**
  - Collect all sorry locations
  - Generate report at file end
  - CI integration: fail on sorry in main branch
- **Priority:** 🟡 High

### 5.2 Unified Mathematical Vocabulary
- **Current:** `have`, `let`, `show`, `suffices` with subtle differences
- **Target:** Consistent commands with clear semantics
  ```lean
  claim "name" : P       -- intermediate result (have)
  suppose "name" : P     -- assumption (assume/let)
  therefore : P          -- current goal (show)
  suffices_to_show : P   -- proof by sufficiency (suffices)
  ```
- **Implementation:**
  - Wrapper commands mapping to Lean primitives
  - Documentation explaining when to use each
  - Migration guide from standard Lean
- **Priority:** 🟢 Medium

### 5.3 Simplified Infoview
- **Current:** Shows all hypotheses, goals, messages simultaneously
- **Target:** Sketch-focused view
  ```
  Current Milestone: "Inductive step"
  Need to prove: P (n + 1)
  
  Available:
  - IH: P n
  - h: n > 0
  
  [Details] [Full context]
  ```
- **Implementation:**
  - Custom Infoview panel for sketch mode
  - Collapsible sections
  - Highlight relevant hypotheses only
- **Priority:** 🟢 Medium

### 5.4 Version Stability Guarantees
- **Current:** Mathlib updates break code
- **Target:** Stable API with migration path
  - Pin known-good Mathlib versions
  - Auto-migration tool for breaking changes
  - Clear changelog: "theorem X renamed to Y"
- **Implementation:**
  - Semantic versioning for Proof Sketcher
  - Compatibility layer for old sketches
  - Test suite across multiple Lean/Mathlib versions
- **Priority:** 🟢 Medium

---

## Phase 6: Ecosystem Integration (2027+)

**Goal:** Make Proof Sketcher a standard tool in mathematical workflow.

### 6.1 IDE Integrations
- VS Code extension (exists)
- Emacs lean4-mode integration
- Jupyter notebook support
- Overleaf integration (LaTeX + Lean side-by-side)

### 6.2 Cross-Prover Support
- Export to Coq, Isabelle, Metamath
- Import from informal proofs (ArXiv LaTeX)
- Integration with automated provers (Z3, E)

### 6.3 AI-Assisted Sketching
- GPT-powered sketch generation from natural language
- Suggest next milestones based on goal
- Auto-complete proof steps
- Learn from completed proofs in repository

### 6.4 Educational Platform
- Course creation tools for instructors
- Grading integration for homework
- Public gallery of formalized theorems
- Leaderboards and achievements for learning

---

## Success Metrics

### Usability (Phase 1-2)
- [ ] 90% of users complete tutorial without external help
- [ ] Median time to first successful proof sketch: <10 minutes
- [ ] Error messages rated "helpful" by 80% of users
- [ ] Zero mentions of `IO.Ref`, `Elab`, monads in user-facing docs

### Adoption (Phase 3-4)
- [ ] 100+ proofs exported to LaTeX for papers
- [ ] 1000+ users in browser playground
- [ ] 50+ educational institutions using Proof Sketcher
- [ ] Standalone version runs in <60 seconds from download

### Impact (Phase 5-6)
- [ ] 10+ research papers formally verified with Proof Sketcher
- [ ] Integration with major theorem repositories (Archive of Formal Proofs)
- [ ] Cited in 100+ academic works
- [ ] Contributed to discovery of new mathematical results

---

## Development Principles

1. **Mathematician-First Design:** Every feature must be usable by someone who's never programmed
2. **Gradual Formalization:** Start informal, add rigor incrementally
3. **Blueprint Philosophy:** Human-readable output is primary; Lean code is the proof certificate
4. **No Jargon:** Use mathematical vocabulary, not CS/type theory terms
5. **Fail Gracefully:** Errors should teach, not intimidate
6. **Progressive Disclosure:** Hide complexity until needed
7. **Collaboration Ready:** Single-player experience should scale to teams
8. **Open Science:** All exports should be shareable without Lean installed

---

## Community & Governance

### Feedback Channels
- Monthly office hours with mathematician users
- Zulip channel: #proof-sketcher
- Annual user survey on pain points
- GitHub issues triaged by mathematician volunteers

### Partnerships
- **Xena Project:** Educational use cases, teaching materials
- **Lean FRO:** Mathlib integration, stability
- **Blueprint Community:** Export format compatibility
- **ArXiv:** Exploration of formal/informal linking

### Open Source
- Apache 2.0 license
- Accept PRs from non-programmers (natural language feature requests)
- Quarterly releases with semantic versioning
- Backwards compatibility guaranteed for 2+ years

---

## Resources Needed

### Phase 1-2 (6 months)
- 2 FTE Lean developers
- 1 FTE UX researcher (mathematician background)
- User testing budget: $10k
- Server costs: $500/mo

### Phase 3-4 (6 months)
- +1 FTE web developer (browser playground)
- +1 FTE technical writer (docs, tutorials)
- +1 FTE community manager
- Server costs: $2k/mo (playground hosting)

### Phase 5-6 (ongoing)
- Maintenance: 3 FTE
- New features: 2 FTE
- Community growth: 1 FTE
- Infrastructure: $5k/mo

---

## Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Lean 4 API changes break core features | 🔴 High | Pin stable versions, contribute to Lean core stability |
| Mathematicians still find it too complex | 🔴 High | Continuous user testing, bi-weekly feedback sessions |
| Performance issues with large proofs | 🟡 Medium | Incremental compilation, proof caching |
| Browser playground becomes expensive | 🟡 Medium | Academic grants, usage quotas, cached compilation |
| Competition from other tools | 🟢 Low | Focus on unique value: mathematician-first design |
| Maintainer burnout | 🟡 Medium | Grow contributor base, clear governance, funding |

---

## Next Steps (Immediate - Jan 2026)

1. **This week:** 
   - [ ] Create GitHub project board for Phase 1 tasks
   - [ ] Recruit 3-5 mathematician beta testers
   - [ ] Draft error message rewrite specification

2. **This month:**
   - [ ] Implement human-readable error wrapper (1.1)
   - [ ] Design natural language parser for connectors (1.2)
   - [ ] Hide IO.Ref implementation (1.3)
   - [ ] Ship v0.2.0 with these improvements

3. **Q1 2026:**
   - [ ] Complete Phase 1 (all critical fixes)
   - [ ] Start Phase 2 (theorem search integration)
   - [ ] Launch closed beta for browser playground
   - [ ] Write and publish "Why Proof Sketcher?" blog post

---

## Long-Term Vision (5 years)

**By 2031, Proof Sketcher should be:**
- The default tool for teaching formal methods to mathematicians
- Used in 20% of papers submitted to formalization-friendly journals
- Cited as enabling new collaboration models between human and machine mathematics
- A key component in the "mathematician's toolchain" alongside LaTeX, SageMath, and pen-and-paper

**Moonshot goal:** A professional mathematician publishes a major result where Proof Sketcher:
1. Helped explore proof strategies through sketching
2. Found a gap in an informal argument via partial formalization  
3. Generated the formal verification accepted by journals
4. Produced the human-readable proof published in the paper

*All from the same source files, without the mathematician learning programming.*

---

**Questions? Feedback?** Open an issue or reach out on Lean Zulip #proof-sketcher
