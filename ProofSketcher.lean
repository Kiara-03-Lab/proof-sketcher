/-
# Proof Sketcher Library

A Lean 4 library for top-down proof development.

## Quick Start

```lean
import ProofSketcher

theorem my_theorem : 1 + 1 = 2 := by
  sketch "arithmetic" : 1 + 1 = 2
  assumption
```

## Tactics Provided

- `sketch "desc" : P` - Assert P without proof (uses sorry)
- `milestone "desc" : P := by tac` - Assert and prove P
- `outline "desc"` - Document proof structure
- `progress` - Show completion statistics
- `qed` - Finalize proof with report
-/

import ProofSketcher.Basic

-- Re-export everything
namespace ProofSketcher
  export ProofSketcher (
    evalSketch
    evalMilestone
    evalOutline
    evalProgress
    evalQed
    getSketchStats
    resetCounters
  )
end ProofSketcher
