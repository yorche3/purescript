module Test.NaiveSortTests where

import Prelude

import Data.Foldable (for_)
import Data.List (List(..), (:))
import Effect (Effect)
import Effect.Aff (Aff)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import NaiveSort (bubbleSort, insertionSort, selectionSort)

-- Casos de prueba de la especificación 05_Naive_Sort.md
--
-- Caso nulo omitido: las listas de PureScript no admiten `null` ni una entrada
-- inválida, así que el caso no es representable y se conservan los 7 casos de la
-- especificación. Al ser las listas inmutables, cada caso puede usar la
-- constante compartida sin riesgo de contaminar los siguientes.

type TestCase =
  { description :: String
  , input :: List Int
  , expected :: List Int
  }

standardInput :: List Int
standardInput = 5 : 2 : 9 : 1 : 5 : 6 : Nil

standardOutput :: List Int
standardOutput = 1 : 2 : 5 : 5 : 6 : 9 : Nil

sortedInput :: List Int
sortedInput = 1 : 2 : 3 : 4 : 5 : Nil

sortedOutput :: List Int
sortedOutput = 1 : 2 : 3 : 4 : 5 : Nil

reverseInput :: List Int
reverseInput = 5 : 4 : 3 : 2 : 1 : Nil

reverseOutput :: List Int
reverseOutput = 1 : 2 : 3 : 4 : 5 : Nil

identicalInput :: List Int
identicalInput = 7 : 7 : 7 : 7 : Nil

identicalOutput :: List Int
identicalOutput = 7 : 7 : 7 : 7 : Nil

negativeInput :: List Int
negativeInput = 3 : (-1) : 4 : (-5) : 0 : Nil

negativeOutput :: List Int
negativeOutput = (-5) : (-1) : 0 : 3 : 4 : Nil

singleInput :: List Int
singleInput = 42 : Nil

singleOutput :: List Int
singleOutput = 42 : Nil

emptyInput :: List Int
emptyInput = Nil

emptyOutput :: List Int
emptyOutput = Nil

cases :: List TestCase
cases =
  { description: "an unsorted array", input: standardInput, expected: standardOutput }
    : { description: "an already sorted array", input: sortedInput, expected: sortedOutput }
    : { description: "a reverse ordered array", input: reverseInput, expected: reverseOutput }
    : { description: "an array of identical elements", input: identicalInput, expected: identicalOutput }
    : { description: "an array with negative numbers", input: negativeInput, expected: negativeOutput }
    : { description: "a single element array", input: singleInput, expected: singleOutput }
    : { description: "an empty array", input: emptyInput, expected: emptyOutput }
    : Nil

-- Helper compartido: recibe la función a probar y el nombre del algoritmo, y
-- ejecuta todos los casos con un mensaje descriptivo cada uno.
assertAllCases :: (List Int -> List Int) -> String -> Aff Unit
assertAllCases sort algorithm =
  for_ cases \testCase -> do
    let
      actual = sort testCase.input
    Assert.assert
      ( algorithm <> " should sort " <> testCase.description
          <> ": expected "
          <> show testCase.expected
          <> " but got "
          <> show actual
      )
      (testCase.expected == actual)

main :: Effect Unit
main = runTest do
  suite "naive_sort" do
    test "selection_sort" do
      assertAllCases selectionSort "selection_sort"
    test "bubble_sort" do
      assertAllCases bubbleSort "bubble_sort"
    test "insertion_sort" do
      assertAllCases insertionSort "insertion_sort"
