module Test.RecursiveTests where

import Prelude

import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert as Assert
import Numbers
  ( sumOfFirstNRec
  , factorialRec
  , fibonacciRec
  , greatestCommonDivisorRec
  , leastCommonMultipleRec
  )

main :: Effect Unit
main = runTest do
  suite "Numbers recursive" do
    test "sumOfFirstNRec" do
      Assert.equal 0 (sumOfFirstNRec 0)
      Assert.equal 6 (sumOfFirstNRec 3)
    test "factorialRec" do
      Assert.equal 1 (factorialRec 0)
      Assert.equal 24 (factorialRec 4)
    test "fibonacciRec" do
      Assert.equal 0 (fibonacciRec 0)
      Assert.equal 1 (fibonacciRec 1)
      Assert.equal 8 (fibonacciRec 6)
    test "greatestCommonDivisorRec" do
      Assert.equal 4 (greatestCommonDivisorRec 12 8)
      Assert.equal 1 (greatestCommonDivisorRec 7 5)
    test "leastCommonMultipleRec" do
      Assert.equal 12 (leastCommonMultipleRec 4 6)
      Assert.equal 24 (leastCommonMultipleRec 6 8)
