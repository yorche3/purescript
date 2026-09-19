-- NaiveSort — ordenamientos elementales O(n²).
--
-- Especificación: 05_Naive_Sort
--
-- Contrato: List Int -> List Int (orden ascendente).
-- El parámetro conserva el nombre `arr` de la documentación.
--
-- PureScript no admite patrones cons sobre `Array`: `(:)` es un alias de la
-- función `cons`, así que el compilador lo rechaza con `InvalidOperatorInBinder`
-- (`Only aliases for data constructors may be used in patterns`), y `Data.Array`
-- solo permite obtener el primero y el resto por medio de `Maybe` (`uncons`,
-- `head`, `tail`), que es el equivalente a `Option` y no se usa en esta fase.
-- Por eso el módulo trabaja con `Data.List`, la secuencia recursiva estándar: es
-- inmutable, tiene constructor cons (`x : xs`, `Nil`) y se recorre por recursión
-- sin ningún tipo opcional, como en Haskell y Elm.

module NaiveSort
  ( selectionSort
  , bubbleSort
  , insertionSort
  ) where

import Prelude

import Data.List (List(..), (:))
import Data.Tuple (Tuple(..))

-- --- selectionSort: encuentra el mínimo del tramo no ordenado y lo ubica al
-- --- inicio, recursando sobre el resto.

selectionSort :: List Int -> List Int
selectionSort arr = case arr of
  Nil -> Nil
  x : Nil -> x : Nil
  x : xs ->
    let
      Tuple minVal rest = pickMin x xs
    in
      minVal : selectionSort rest

-- pickMin: encuentra el mínimo entre el candidato actual y el resto de la lista,
-- devolviendo el valor mínimo y los elementos restantes.
pickMin :: Int -> List Int -> Tuple Int (List Int)
pickMin minAcc arr = case arr of
  Nil -> Tuple minAcc Nil
  y : ys ->
    if y < minAcc then
      let
        Tuple actualMin remaining = pickMin y ys
      in
        Tuple actualMin (minAcc : remaining)
    else
      let
        Tuple actualMin remaining = pickMin minAcc ys
      in
        Tuple actualMin (y : remaining)

-- --- bubbleSort: compara e intercambia elementos adyacentes y repite mientras
-- --- la pasada haya cambiado algo.

bubbleSort :: List Int -> List Int
bubbleSort arr = case arr of
  Nil -> Nil
  x : Nil -> x : Nil
  _ ->
    let
      Tuple bubbled swapped = bubblePass arr
    in
      if swapped then bubbleSort bubbled else bubbled

-- bubblePass: una pasada que arrastra el mayor al final; devuelve además si la
-- pasada intercambió al menos un par, que es la bandera de salida temprana.
bubblePass :: List Int -> Tuple (List Int) Boolean
bubblePass arr = case arr of
  Nil -> Tuple Nil false
  x : Nil -> Tuple (x : Nil) false
  x : y : ys ->
    if x > y then
      let
        Tuple rest _ = bubblePass (x : ys)
      in
        Tuple (y : rest) true
    else
      let
        Tuple rest swapped = bubblePass (y : ys)
      in
        Tuple (x : rest) swapped

-- --- insertionSort: inserta cada elemento en su posición dentro de la sublista
-- --- ya ordenada.

insertionSort :: List Int -> List Int
insertionSort arr = case arr of
  Nil -> Nil
  x : xs -> insert x (insertionSort xs)

-- insert: inserta un elemento en una lista ya ordenada manteniendo el orden.
insert :: Int -> List Int -> List Int
insert x arr = case arr of
  Nil -> x : Nil
  y : ys ->
    if x <= y then
      x : arr
    else
      y : insert x ys
