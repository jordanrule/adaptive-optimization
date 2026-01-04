#!/bin/bash

# Simple build script for the adaptive optimization demo

echo "Building Adaptive Compiler Optimization..."
echo ""

# Check if GHC is installed
if ! command -v ghc &> /dev/null; then
    echo "Error: GHC (Glasgow Haskell Compiler) not found."
    echo "Please install GHC via:"
    echo "  - macOS: brew install ghc"
    echo "  - Linux: apt-get install ghc or yum install ghc"
    echo "  - Or install Haskell Platform: https://www.haskell.org/platform/"
    exit 1
fi

echo "GHC found: $(ghc --version)"
echo ""

# Compile
echo "Compiling..."
ghc -O2 Main.hs -o optimize

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Build successful!"
    echo ""
    echo "Run with: ./optimize"
    echo ""
else
    echo ""
    echo "✗ Build failed. Please check error messages above."
    exit 1
fi
