module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)

import Test.CalculatorTest as CalculatorTest

main :: Effect Unit
main = do
  log "🍝"
  CalculatorTest.main
