-- DataStructuresBasics — Node, LinkedList, Stack y Queue manuales sobre el
-- mismo tipo de nodo enlazado.
--
-- Especificación: 06_Data_Structures_Basics
--
-- Contrato: un único tipo `Node` (valor + enlace) compartido por las tres
-- estructuras, que gestionan sus propios punteros y no delegan operaciones entre
-- sí (`Stack` y `Queue` no envuelven `LinkedList`). Cada estructura se crea con
-- su `init` antes de cualquier otra operación.
--
-- Adaptaciones:
--   - Los valores de PureScript son inmutables: cada operación que actualizaría
--     la estructura devuelve una nueva, así que las tres que producen una
--     estructura actualizada lo hacen en una tupla —
--     `delete :: Int -> LinkedList -> Tuple LinkedList Boolean`,
--     `pop :: Stack -> Tuple Int Stack` y
--     `dequeue :: Queue -> Tuple Int Queue`— y el resto devuelve solo el valor.
--   - La ausencia de enlace es el constructor `Empty` del tipo `Node`, única
--     representación de ausencia; no se usa `Maybe` en esta fase.
--   - Las lecturas que pueden fallar devuelven el indicador `-1` (`getHead`,
--     `pop`, `dequeue`, `peekStack`, `peekQueue`), `delete` devuelve el
--     booleano de éxito o fallo en su tupla, y el tamaño sin nodos es `0`.
--   - Los valores de prueba son enteros positivos.
--   - Los identificadores van en inglés y los comentarios en español.
--
-- Implementación pendiente: la escribe el autor. Esta delegación solo genera el
-- contrato y el esqueleto de todas sus operaciones.

module DataStructuresBasics
  ( Node(..)
  , initNode
  , getValue
  , getNext
  , setNext
  , LinkedList(..)
  , initLinkedList
  , getHead
  , insertHead
  , insertTail
  , delete
  , isLinkedListEmpty
  , linkedListSize
  , Stack(..)
  , initStack
  , push
  , pop
  , peekStack
  , isStackEmpty
  , stackSize
  , Queue(..)
  , initQueue
  , enqueue
  , dequeue
  , peekQueue
  , isQueueEmpty
  , queueSize
  ) where

import Prelude

import Data.Tuple (Tuple(..))

data Node
  = Empty
  | Node Int Node

data LinkedList = LinkedList Node Node Int

data Stack = Stack Node Int

data Queue = Queue Node Node Int

initNode :: Int -> Node
initNode value = Node value Empty

getValue :: Node -> Int
getValue _ = -1

getNext :: Node -> Node
getNext _ = Empty

setNext :: Node -> Node -> Node
setNext _ _ = Empty

initLinkedList :: LinkedList
initLinkedList = LinkedList Empty Empty 0

getHead :: LinkedList -> Int
getHead _ = -1

insertHead :: Int -> LinkedList -> LinkedList
insertHead _ list = list

insertTail :: Int -> LinkedList -> LinkedList
insertTail _ list = list

delete :: Int -> LinkedList -> Tuple LinkedList Boolean
delete _ list = Tuple list false

isLinkedListEmpty :: LinkedList -> Boolean
isLinkedListEmpty _ = false

linkedListSize :: LinkedList -> Int
linkedListSize _ = 0

initStack :: Stack
initStack = Stack Empty 0

push :: Int -> Stack -> Stack
push _ stack = stack

pop :: Stack -> Tuple Int Stack
pop stack = Tuple (-1) stack

peekStack :: Stack -> Int
peekStack _ = -1

isStackEmpty :: Stack -> Boolean
isStackEmpty _ = false

stackSize :: Stack -> Int
stackSize _ = 0

initQueue :: Queue
initQueue = Queue Empty Empty 0

enqueue :: Int -> Queue -> Queue
enqueue _ queue = queue

dequeue :: Queue -> Tuple Int Queue
dequeue queue = Tuple (-1) queue

peekQueue :: Queue -> Int
peekQueue _ = -1

isQueueEmpty :: Queue -> Boolean
isQueueEmpty _ = false

queueSize :: Queue -> Int
queueSize _ = 0
