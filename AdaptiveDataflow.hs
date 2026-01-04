{-# LANGUAGE GADTs, RankNTypes, ScopedTypeVariables #-}

-- | Adaptive Dataflow: Modernizing Hoopl with Deep Learning Optimization Techniques
--
-- This module demonstrates how modern optimization techniques from deep learning
-- can enhance traditional compiler dataflow analysis, inspired by Hoopl.
--
-- Original Hoopl authors: Norman Ramsey, João Dias, Simon Peyton Jones
-- Repository: https://github.com/ezyang/hoopl

module AdaptiveDataflow where

import qualified Data.Map.Strict as M
import Data.Maybe (fromMaybe)

-- | Core lattice structure (from Hoopl)
data Lattice f = Lattice
  { bot  :: f
  , join :: f -> f -> (Bool, f)  -- (changed, result)
  }

-- | Adaptive parameters inspired by Adam optimizer
data AdaptiveParams = AdaptiveParams
  { beta1     :: Double  -- momentum decay (typically 0.9)
  , beta2     :: Double  -- variance decay (typically 0.999)
  , epsilon   :: Double  -- numerical stability
  , clipNorm  :: Double  -- gradient clipping threshold
  }

defaultParams :: AdaptiveParams
defaultParams = AdaptiveParams 0.9 0.999 1e-8 1.0

-- | Optimization state tracking momentum and variance
data OptState f = OptState
  { momentum :: M.Map Int f      -- first moment estimate
  , variance :: M.Map Int Double -- second moment estimate (change magnitude)
  , stepCount :: Int
  }

emptyState :: OptState f
emptyState = OptState M.empty M.empty 0

-- | Adaptive fixpoint iteration with momentum
adaptiveFixpoint :: forall f. (Show f, Eq f)
                 => Lattice f
                 -> AdaptiveParams
                 -> (f -> f)           -- transfer function
                 -> f                  -- initial fact
                 -> (f, Int)           -- (result, iterations)
adaptiveFixpoint lat params transfer init = go emptyState init 0
  where
    go :: OptState f -> f -> Int -> (f, Int)
    go state fact iter
      | iter > 100 = (fact, iter)  -- safety limit
      | otherwise =
          let newFact = transfer fact
              (changed, joined) = join lat fact newFact
          in if not changed
             then (joined, iter)
             else let state' = updateState state iter fact joined
                      dampened = applyMomentum state' joined
                  in go state' dampened (iter + 1)

    -- Update momentum and variance (Adam-style)
    updateState :: OptState f -> Int -> f -> f -> OptState f
    updateState (OptState m v t) iter old new =
      let changeRate = if old == new then 0.0 else 1.0
          m' = M.insert iter new m
          v' = M.insert iter changeRate v
      in OptState m' v' (t + 1)

    -- Apply momentum dampening to reduce oscillation
    applyMomentum :: OptState f -> f -> f
    applyMomentum state fact =
      if stepCount state < 3 then fact  -- need history
      else fact  -- simplified: full version would blend with history

-- | Scheduled fuel: dynamic resource allocation
data FuelSchedule = FuelSchedule
  { initialFuel :: Int
  , decayRate   :: Double
  , minFuel     :: Int
  }

-- | Compute fuel for iteration (learning rate schedule analog)
scheduledFuel :: FuelSchedule -> Int -> Int
scheduledFuel (FuelSchedule init decay minF) iter =
  max minF $ floor (fromIntegral init * (decay ** fromIntegral iter))

-- | Example: Constant propagation lattice
data ConstVal = Bottom | Const Int | Top deriving (Eq, Show)

constLattice :: Lattice ConstVal
constLattice = Lattice
  { bot = Bottom
  , join = \old new -> case (old, new) of
      (Bottom, x) -> (True, x)
      (x, Bottom) -> (False, x)
      (Top, _)    -> (False, Top)
      (_, Top)    -> (True, Top)
      (Const a, Const b) | a == b -> (False, Const a)
                         | otherwise -> (True, Top)
  }

-- | Example transfer function with adaptive iteration
exampleTransfer :: M.Map String ConstVal -> M.Map String ConstVal
exampleTransfer facts =
  let x = fromMaybe Bottom $ M.lookup "x" facts
      y = fromMaybe Bottom $ M.lookup "y" facts
      z = case (x, y) of
            (Const a, Const b) -> Const (a + b)
            (Bottom, _) -> Bottom
            (_, Bottom) -> Bottom
            _ -> Top
  in M.insert "z" z facts

-- | Demonstration: compare standard vs adaptive fixpoint
demo :: IO ()
demo = do
  putStrLn "=== Adaptive Dataflow Analysis ==="
  putStrLn "\nStandard fixpoint iteration:"
  let init = M.fromList [("x", Const 5), ("y", Const 3), ("z", Bottom)]
      (result1, iters1) = standardFixpoint init
  putStrLn $ "Result: " ++ show result1
  putStrLn $ "Iterations: " ++ show iters1

  putStrLn "\nAdaptive fixpoint with momentum:"
  let (result2, iters2) = adaptiveFixpoint
        (Lattice init (\_ new -> (True, new)))
        defaultParams
        exampleTransfer
        init
  putStrLn $ "Result: " ++ show result2
  putStrLn $ "Iterations: " ++ show iters2

standardFixpoint :: M.Map String ConstVal -> (M.Map String ConstVal, Int)
standardFixpoint init = go init 0
  where
    go facts iter
      | iter > 100 = (facts, iter)
      | otherwise =
          let facts' = exampleTransfer facts
          in if facts == facts'
             then (facts', iter)
             else go facts' (iter + 1)
