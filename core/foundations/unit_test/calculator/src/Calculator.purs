module Calculator where

import Prelude

addition :: Int -> Int -> Int
addition a b = a + b

subtraction :: Int -> Int -> Int
subtraction a b = a - b

multiplication :: Int -> Int -> Int
multiplication a b = go b 0
  where
  go n acc = case n of
    0 -> acc
    _ -> go (n - 1) (addition acc a)

division :: Int -> Int -> Int
division a b = go a 0
  where
  go n q = case n < b of
    true -> q
    false -> go (subtraction n b) (addition q 1)

modulus :: Int -> Int -> Int
modulus a b = subtraction a (multiplication (division a b) b)
