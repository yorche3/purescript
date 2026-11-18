module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

import Test.DataStructuresAdvancedTests as DataStructuresAdvancedTests

main :: Effect Unit
main = do
  log "🍝"
  DataStructuresAdvancedTests.main

