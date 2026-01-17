import Lake
open Lake DSL

package «proof_sketcher» where
  version := v!"0.1.0"

lean_lib «ProofSketcher» where
  -- Library configuration

lean_lib «Examples» where
  -- Example proofs demonstrating Proof Sketcher usage

lean_lib «Tests» where
  -- Test suite

@[default_target]
lean_exe «proof_sketcher» where
  root := `Main

-- Mathlib dependency for standard tactics
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.14.0"
