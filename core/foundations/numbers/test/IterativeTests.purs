module Test.IterativeTests where

import Prelude

import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert as Assert
import Numbers
  ( sumOfFirstNIte
  , factorialIte
  , fibonacciIte
  , greatestCommonDivisorIte
  , leastCommonMultipleIte
  )

main :: Effect Unit
main = runTest do
  suite "Numbers iterative" do
    test "sumOfFirstNIte" do
      Assert.equal 0 (sumOfFirstNIte 0)
      Assert.equal 6 (sumOfFirstNIte 3)
    test "factorialIte" do
      Assert.equal 1 (factorialIte 0)
      Assert.equal 24 (factorialIte 4)
    test "fibonacciIte" do
      Assert.equal 0 (fibonacciIte 0)
      Assert.equal 1 (fibonacciIte 1)
      Assert.equal 8 (fibonacciIte 6)
    test "greatestCommonDivisorIte" do
      Assert.equal 4 (greatestCommonDivisorIte 12 8)
      Assert.equal 1 (greatestCommonDivisorIte 7 5)
    test "leastCommonMultipleIte" do
      Assert.equal 12 (leastCommonMultipleIte 4 6)
      Assert.equal 24 (leastCommonMultipleIte 6 8)
