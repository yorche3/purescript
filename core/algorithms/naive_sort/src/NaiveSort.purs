-- NaiveSort — ordenamientos elementales O(n²).
--
-- Especificación: 05_Naive_Sort
--
-- Contrato (array de entrada y array ordenado de menor a mayor). Los arrays de
-- PureScript son inmutables y el lenguaje no tiene bucles, así que cada función
-- devuelve un array nuevo y se apoya en recursión:
--   selectionSort(arr)
--   bubbleSort(arr)
--   insertionSort(arr)

module NaiveSort where

selectionSort :: Array Int -> Array Int
selectionSort [] = []
selectionSort [x] = [x]
selectionSort (x:xs) =
    let
      pickMin x (y:ys) =
        case (y:ys) of
          [] -> (x, [])
          (y:ys') ->
            if x <= y then (x, y:ys')
            else
              let (minVal, rest) = pickMin x ys'
              in (minVal, y:rest)
    (minVal, rest) = pickMin x xs
  in minVal : selectionSort rest

bubbleSort :: Array Int -> Array Int
bubbleSort [] = []
bubbleSort [x] = [x]
bubbleSort (x:xs) =
  let
    bubble [] = ([], False)
    bubble [y] = ([y], False)
    bubble (y:z:ys) =
      if y > z then
        let (rest, swapped) = bubble (y:ys)
        in (z:rest, True)
      else
        let (rest, swapped) = bubble (z:ys)
        in (y:rest, swapped)
    (bubbled, swapped) = bubble (x:xs)
  in if swapped then bubbleSort bubbled else bubbled

insertionSort :: Array Int -> Array Int
insertionSort [] = []
insertionSort [x] = [x]
insertionSort (x:xs) =
  let
    insert y [] = [y]
    insert y (z:zs) =
      if y <= z then y : z : zs
      else z : insert y zs
  in insert x (insertionSort xs)