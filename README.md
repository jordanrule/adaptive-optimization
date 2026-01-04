# Adaptive Compiler Optimization

**Modernizing Hoopl with Deep Learning Techniques**

This repository explores how modern optimization techniques from deep learning can enhance traditional compiler dataflow analysis, building on the foundational work of [Hoopl](https://github.com/ezyang/hoopl).

## Original Hoopl

Hoopl (Higher-Order OPtimization Library) was created by:
- **Norman Ramsey** ([@nrnrnr](https://github.com/nrnrnr))
- **João Dias**
- **Simon Peyton Jones** ([@simonpj](https://github.com/simonpj))

**Repository**: [ezyang/hoopl](https://github.com/ezyang/hoopl)

Hoopl introduced elegant abstractions for compiler optimization:

1. **Dataflow Lattices**: Monotone frameworks for program analysis
2. **Shape-Indexed Graphs**: Type-safe control flow using GADTs (O/C types)
3. **Interleaved Analysis & Rewriting**: Fixpoint iteration combining analysis and transformation
4. **Fuel-Based Control**: Resource limits preventing infinite optimization
5. **Higher-Order Combinators**: Composable optimization passes

## Modern Enhancements

Over the past 15 years, deep learning has popularized optimization techniques that can benefit compiler optimization:

### 1. **Adaptive Fixpoint Iteration** (Adam/RMSprop → Dataflow)

**Traditional Hoopl**: Fixed iteration until convergence
```haskell
fixpoint :: (f -> f) -> f -> f
fixpoint transfer init = 
  let new = transfer init
  in if new == init then init else fixpoint transfer new
```

**Modern Approach**: Momentum-based iteration
```haskell
adaptiveFixpoint :: Lattice f -> AdaptiveParams -> (f -> f) -> f -> f
-- Uses momentum (β₁) and variance (β₂) to accelerate convergence
-- Reduces oscillation in cyclic dataflow graphs
```

**Why it matters**: 
- Cyclic control flow can cause oscillating facts
- Momentum dampens oscillation, faster convergence
- Adaptive step sizes prevent overshooting

### 2. **Dynamic Fuel Scheduling** (Learning Rate Decay → Fuel)

**Traditional Hoopl**: Fixed fuel budget
```haskell
withFuel :: Int -> Optimization -> Optimization
```

**Modern Approach**: Scheduled fuel allocation
```haskell
scheduledFuel :: FuelSchedule -> Int -> Int
-- Starts with high fuel (exploration)
-- Decays over iterations (exploitation)
-- Prevents over-optimization in later phases
```

**Why it matters**:
- Early iterations benefit from aggressive optimization
- Later iterations need stability
- Mimics learning rate warmup/decay schedules

### 3. **Confidence-Based Rewrite Selection** (RL Policy → Phase Ordering)

**Traditional Hoopl**: Fixed rewrite ordering
```haskell
pass1 `thenFwdRw` pass2 `thenFwdRw` pass3
```

**Modern Approach**: Learned rewrite policies
```haskell
data RewriteStrategy = RewriteStrategy
  { confidence :: Double  -- learned from profiling
  , priority   :: Int
  }

selectStrategy :: AdaptiveRewrite -> IO RewriteStrategy
-- Softmax selection with temperature for exploration
```

**Why it matters**:
- Phase ordering is NP-hard
- Learn from compilation history
- Adapt to code patterns

### 4. **Gradient Clipping** (Stability → Fact Propagation)

**Traditional Hoopl**: Unbounded fact growth
```haskell
join :: f -> f -> f
```

**Modern Approach**: Bounded change magnitude
```haskell
join :: f -> f -> (Bool, f)
-- Clip change magnitude to prevent instability
-- Similar to gradient clipping in neural networks
```

**Why it matters**:
- Prevents explosive fact growth
- Ensures numerical stability
- Faster convergence

## Core Concepts Preserved

While modernizing, we preserve Hoopl's elegant foundations:

### Shape-Indexed Types
```haskell
data O  -- Open: single entry/exit
data C  -- Closed: labeled entry/exit

data Block e x where
  BFirst  :: Insn C O -> Block C O
  BMiddle :: Insn O O -> Block O O
  BLast   :: Insn O C -> Block O C
```

Type system prevents invalid control flow construction.

### Lattice-Based Analysis
```haskell
data Lattice f = Lattice
  { bot  :: f
  , join :: f -> f -> (Bool, f)
  }
```

Monotone frameworks ensure termination.

### Composable Passes
```haskell
pairFwd :: FwdPass m n f -> FwdPass m n f' -> FwdPass m n (f, f')
```

Combine analyses without rewriting infrastructure.

## Key Insights

1. **Momentum accelerates convergence**: Cyclic dataflow graphs benefit from history-aware iteration
2. **Adaptive fuel prevents over-optimization**: Dynamic resource allocation improves compile time
3. **Learned policies improve phase ordering**: Profiling-guided optimization selection
4. **Stability techniques reduce oscillation**: Bounded changes ensure predictable behavior

## Pedagogical Goals

This implementation is intentionally minimal to clarify:
- How deep learning optimization maps to compiler optimization
- Which techniques transfer directly vs. need adaptation
- Where the fundamental differences lie

## Building and Running

```bash
ghc -O2 Main.hs -o optimize
./optimize
```

## Further Reading

**Original Hoopl Paper**:
- "Hoopl: A Modular, Reusable Library for Dataflow Analysis and Transformation" (Haskell Symposium 2010)

**Deep Learning Optimization**:
- Adam: "A Method for Stochastic Optimization" (Kingma & Ba, 2014)
- Learning rate schedules: "Cyclical Learning Rates" (Smith, 2017)
- Gradient clipping: "On the difficulty of training RNNs" (Pascanu et al., 2013)

**Compiler Optimization**:
- "Engineering a Compiler" (Cooper & Torczon)
- "Modern Compiler Implementation" (Appel)

## License

This pedagogical implementation is provided for educational purposes. Original Hoopl is BSD-3 licensed.

## Acknowledgments

This work builds on the elegant foundations laid by Norman Ramsey, João Dias, and Simon Peyton Jones in Hoopl. Their insight that dataflow analysis could be abstracted into reusable, composable components revolutionized how we think about compiler optimization infrastructure.
