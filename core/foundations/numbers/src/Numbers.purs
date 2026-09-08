module Numbers
  ( sumOfFirstNRec
  , factorialRec
  , fibonacciRec
  , greatestCommonDivisorRec
  , leastCommonMultipleRec
  , sumOfFirstNAcc
  , factorialAcc
  , fibonacciAcc
  , greatestCommonDivisorAcc
  , leastCommonMultipleAcc
  , sumOfFirstNIte
  , factorialIte
  , fibonacciIte
  , greatestCommonDivisorIte
  , leastCommonMultipleIte
  ) where

import Prelude

import Data.Array (range)
import Data.Foldable (foldl)
import Data.Tuple (Tuple(..), snd)

-- Direct recursion (_rec)

sumOfFirstNRec :: Int -> Int
sumOfFirstNRec n = case n <= 0 of
  true -> 0
  false -> n + sumOfFirstNRec (n - 1)

factorialRec :: Int -> Int
factorialRec n = case n <= 0 of
  true -> 1
  false -> n * factorialRec (n - 1)

fibonacciRec :: Int -> Int
fibonacciRec n = case n <= 1 of
  true -> n
  false -> fibonacciRec (n - 1) + fibonacciRec (n - 2)

greatestCommonDivisorRec :: Int -> Int -> Int
greatestCommonDivisorRec a b = case b == 0 of
  true -> a
  false -> greatestCommonDivisorRec b (a `mod` b)

leastCommonMultipleRec :: Int -> Int -> Int
leastCommonMultipleRec a b = (a * b) / greatestCommonDivisorRec a b

-- Accumulator recursion (_acc): educational bridge, no TCO guarantee

sumOfFirstNAcc :: Int -> Int
sumOfFirstNAcc n = sumOfFirstNAccHelp n 0

sumOfFirstNAccHelp :: Int -> Int -> Int
sumOfFirstNAccHelp n acc = case n <= 0 of
  true -> acc
  false -> sumOfFirstNAccHelp (n - 1) (n + acc)

factorialAcc :: Int -> Int
factorialAcc n = factorialAccHelp n 1

factorialAccHelp :: Int -> Int -> Int
factorialAccHelp n acc = case n <= 1 of
  true -> acc
  false -> factorialAccHelp (n - 1) (n * acc)

fibonacciAcc :: Int -> Int
fibonacciAcc n = fibonacciAccHelp n 0 1

fibonacciAccHelp :: Int -> Int -> Int -> Int
fibonacciAccHelp n acc2 acc1 = case n <= 0 of
  true -> acc2
  false -> case n <= 2 of
    true -> acc1 + acc2
    false -> fibonacciAccHelp (n - 1) acc1 (acc1 + acc2)

greatestCommonDivisorAcc :: Int -> Int -> Int
greatestCommonDivisorAcc a b = greatestCommonDivisorAccHelp a b

greatestCommonDivisorAccHelp :: Int -> Int -> Int
greatestCommonDivisorAccHelp a b = case b == 0 of
  true -> a
  false -> greatestCommonDivisorAccHelp b (a `mod` b)

leastCommonMultipleAcc :: Int -> Int -> Int
leastCommonMultipleAcc a b = (a * b) / greatestCommonDivisorAcc a b

-- Iterative (_ite): fold combinators + tail-recursive loop idiom

sumOfFirstNIte :: Int -> Int
sumOfFirstNIte n = case n <= 0 of
  true -> 0
  false -> foldl (\acc i -> acc + i) 0 (range 1 n)

factorialIte :: Int -> Int
factorialIte n = case n <= 1 of
  true -> 1
  false -> foldl (\acc i -> acc * i) 1 (range 2 n)

fibonacciIte :: Int -> Int
fibonacciIte n = case n <= 1 of
  true -> n
  false -> snd (foldl fibStep (Tuple 0 1) (range 2 n))
  where
  fibStep (Tuple acc2 acc1) _ = Tuple acc1 (acc1 + acc2)

greatestCommonDivisorIte :: Int -> Int -> Int
greatestCommonDivisorIte a b = greatestCommonDivisorIteHelp a b

greatestCommonDivisorIteHelp :: Int -> Int -> Int
greatestCommonDivisorIteHelp a b = case b == 0 of
  true -> a
  false -> greatestCommonDivisorIteHelp b (a `mod` b)

leastCommonMultipleIte :: Int -> Int -> Int
leastCommonMultipleIte a b = (a * b) / greatestCommonDivisorIte a b
