# Adaptive Compiler Optimization

Modernizing [Hoopl](https://github.com/ezyang/hoopl) with techniques inspired by deep learning optimization.

## Overview

This library brings adaptive optimization techniques to Haskell compiler infrastructure. Built on Hoopl's proven foundations, it enhances dataflow analysis and rewriting with:

- **Adaptive Fixpoint Iteration**: Momentum-based convergence that reduces oscillation in cyclic control flow
- **Dynamic Fuel Scheduling**: Adaptive resource allocation that prevents over-optimization
- **Learned Rewrite Policies**: Profiling-guided phase ordering for improved compile times
- **Bounded Change Propagation**: Stability techniques that accelerate dataflow analysis

All while preserving Hoopl's elegant abstractions: shape-indexed types, lattice-based analysis, and composable passes.

## What Makes This Unique

Most Haskell compiler infrastructure uses static, fixed-point iteration strategies. This library is the first to systematically apply adaptive optimization techniques—momentum, scheduled resource allocation, and learned policies—to dataflow analysis. The result is faster convergence on cyclic programs, more predictable compile times, and clearer separation between exploration and exploitation phases.

**Why it matters**: Real-world programs exhibit complex control flow patterns that can cause traditional iterative analysis to oscillate. Adaptive techniques dramatically reduce both iteration count and final optimization quality variance.

## Building and Running

```bash
cabal build
cabal run adaptive-optimization
```

## References

- **Hoopl**: ["Hoopl: A Modular, Reusable Library for Dataflow Analysis and Transformation"](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/hoopl-haskell10.pdf) (Haskell Symposium 2010)
- **Original Hoopl**: [ezyang/hoopl](https://github.com/ezyang/hoopl)

## License

MIT License — See [LICENSE](LICENSE) file for details.
