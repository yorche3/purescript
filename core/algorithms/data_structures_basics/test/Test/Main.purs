module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

import Test.DataStructuresBasicsTests as DataStructuresBasicsTests

main :: Effect Unit
main = do
  log "🍝"
  DataStructuresBasicsTests.main

