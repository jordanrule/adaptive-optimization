{-# LANGUAGE GADTs #-}

-- | Main: Modernizing Hoopl with Deep Learning Techniques
--
-- This demonstrates how compiler optimization can benefit from
-- adaptive techniques popularized in deep learning over the past 15 years.

module Main where

import AdaptiveDataflow
import ShapeIndexedGraph
import qualified Examples

main :: IO ()
main = do
  putStrLn "╔════════════════════════════════════════════════════════════╗"
  putStrLn "║  Adaptive Compiler Optimization                           ║"
  putStrLn "║  Modernizing Hoopl with Deep Learning Techniques          ║"
  putStrLn "╚════════════════════════════════════════════════════════════╝"
  putStrLn ""
  
  putStrLn "Original Hoopl Concepts:"
  putStrLn "  • Dataflow lattices with fixpoint iteration"
  putStrLn "  • Shape-indexed control flow graphs (O/C types)"
  putStrLn "  • Interleaved analysis and rewriting"
  putStrLn "  • Fuel-based optimization control"
  putStrLn ""
  
  putStrLn "Modern Enhancements:"
  putStrLn "  • Adaptive fixpoint iteration (Adam-style momentum)"
  putStrLn "  • Dynamic fuel scheduling (learning rate decay)"
  putStrLn "  • Confidence-based rewrite selection (RL policy)"
  putStrLn "  • Gradient clipping for stability"
  putStrLn ""
  
  AdaptiveDataflow.demo
  putStrLn ""
  ShapeIndexedGraph.demo
  putStrLn ""
  Examples.demo
  
  putStrLn ""
  putStrLn "Key Insights:"
  putStrLn "  1. Momentum accelerates convergence in cyclic dataflow"
  putStrLn "  2. Adaptive fuel prevents over-optimization"
  putStrLn "  3. Learned rewrite policies improve phase ordering"
  putStrLn "  4. Stability techniques reduce oscillation"
  putStrLn ""
  putStrLn "See TECHNICAL.md for mathematical foundations"
  putStrLn "See README.md for conceptual overview"
