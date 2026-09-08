module Test.CalculatorTest where

import Prelude

import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Assert as Assert
import Calculator (addition, subtraction, multiplication, division, modulus)

main :: Effect Unit
main = runTest do
  suite "Calculator" do
    test "addition" do
      Assert.equal 5 (addition 2 3)
    test "subtraction" do
      Assert.equal 3 (subtraction 5 2)
    test "multiplication" do
      Assert.equal 12 (multiplication 3 4)
    test "division" do
      Assert.equal 3 (division 10 3)
    test "modulus" do
      Assert.equal 1 (modulus 10 3)
