{-# LANGUAGE GADTs, DataKinds, KindSignatures #-}

-- | Shape-Indexed Graphs with Adaptive Rewriting
--
-- Extends Hoopl's shape-indexed control flow graphs with adaptive
-- rewriting strategies inspired by neural architecture search and
-- reinforcement learning.

module ShapeIndexedGraph where

-- | Open/Closed shape indices (from Hoopl)
data O  -- Open: single entry/exit point
data C  -- Closed: multiple labeled entry/exit points

-- | Simple instruction nodes
data Insn (e :: *) (x :: *) where
  Label  :: String -> Insn C O
  Assign :: String -> Int -> Insn O O
  Branch :: String -> Insn O C

-- | Block structure preserving shape invariants
data Block (e :: *) (x :: *) where
  BFirst  :: Insn C O -> Block C O
  BMiddle :: Insn O O -> Block O O
  BLast   :: Insn O C -> Block O C
  BCat    :: Block O O -> Block O O -> Block O O
  BClosed :: Block C O -> Block O C -> Block C C

-- | Rewrite strategy with confidence scores (RL-inspired)
data RewriteStrategy = RewriteStrategy
  { strategyName :: String
  , confidence   :: Double  -- learned confidence in [0,1]
  , priority     :: Int     -- exploration priority
  }

-- | Adaptive rewrite: select strategy based on learned policy
data AdaptiveRewrite = AdaptiveRewrite
  { strategies :: [RewriteStrategy]
  , temperature :: Double  -- softmax temperature for exploration
  }

-- | Select rewrite strategy using softmax (exploration vs exploitation)
selectStrategy :: AdaptiveRewrite -> IO RewriteStrategy
selectStrategy (AdaptiveRewrite strats temp) =
  let scores = map (\s -> confidence s / temp) strats
      total = sum $ map exp scores
      probs = map (\s -> exp s / total) scores
  in return $ strats !! 0  -- simplified: would sample from distribution

-- | Example: constant folding with learned confidence
constantFoldStrategy :: RewriteStrategy
constantFoldStrategy = RewriteStrategy "ConstFold" 0.95 1

-- | Example: dead code elimination with learned confidence
deadCodeStrategy :: RewriteStrategy
deadCodeStrategy = RewriteStrategy "DeadCode" 0.87 2

-- | Adaptive rewriter combining multiple strategies
adaptiveRewriter :: AdaptiveRewrite
adaptiveRewriter = AdaptiveRewrite
  [constantFoldStrategy, deadCodeStrategy]
  1.0  -- temperature

-- | Demonstration
demo :: IO ()
demo = do
  putStrLn "=== Shape-Indexed Adaptive Rewriting ==="
  strategy <- selectStrategy adaptiveRewriter
  putStrLn $ "Selected strategy: " ++ strategyName strategy
  putStrLn $ "Confidence: " ++ show (confidence strategy)
