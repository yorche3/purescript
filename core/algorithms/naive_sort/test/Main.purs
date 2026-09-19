module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

import Test.NaiveSortTests as NaiveSortTests

main :: Effect Unit
main = do
  log "🍝"
  NaiveSortTests.main
