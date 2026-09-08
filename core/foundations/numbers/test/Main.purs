module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

import Test.RecursiveTests as RecursiveTests
import Test.IterativeTests as IterativeTests

main :: Effect Unit
main = do
  log "🍝"
  RecursiveTests.main
  IterativeTests.main
