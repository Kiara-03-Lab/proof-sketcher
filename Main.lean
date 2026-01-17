/-
# Proof Sketcher - Main Entry Point

This executable can be used to run proof sketcher commands
or display version information.
-/

import ProofSketcher

def main : IO Unit := do
  IO.println "Proof Sketcher v0.1.0"
  IO.println "A Lean 4 library for top-down proof development"
  IO.println ""
  IO.println "Usage: Import ProofSketcher in your Lean files"
  IO.println ""
  IO.println "Available tactics:"
  IO.println "  sketch \"desc\" : P       - Assert P (deferred proof)"
  IO.println "  milestone \"desc\" : P := by tac  - Assert and prove P"
  IO.println "  outline \"desc\"          - Document proof structure"
  IO.println "  progress                 - Show completion stats"
  IO.println "  qed                      - Finalize with report"
