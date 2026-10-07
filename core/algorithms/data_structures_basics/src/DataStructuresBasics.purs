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

derive instance Eq Node

data LinkedList = LinkedList Node Node Int

data Stack = Stack Node Int

data Queue = Queue Node Node Int

initNode :: Int -> Node
initNode value = Node value Empty

getValue :: Node -> Int
getValue (Node value _) = value
getValue Empty = -1

getNext :: Node -> Node
getNext (Node _ next) = next
getNext Empty = Empty

setNext :: Node -> Node -> Node
setNext (Node value _) newNext = Node value newNext
setNext Empty _ = Empty

initLinkedList :: LinkedList
initLinkedList = LinkedList Empty Empty 0

getHead :: LinkedList -> Int
getHead (LinkedList head _ _) = getValue head

insertHead :: Int -> LinkedList -> LinkedList
insertHead value (LinkedList head tail count) =
  let newHead = Node value head
      newTail = if tail == Empty then newHead else tail
  in LinkedList newHead newTail (count + 1)

insertTail :: Int -> LinkedList -> LinkedList
insertTail value (LinkedList head tail count) =
  let newNode = Node value Empty
      newHead = if head == Empty then newNode else head
      newTail = if tail == Empty then newNode else setNext tail newNode
  in LinkedList newHead newTail (count + 1)

delete :: Int -> LinkedList -> Tuple LinkedList Boolean
delete value (LinkedList head tail count) =
  let deleteNode Empty = Empty
      deleteNode (Node v next) =
        if v == value then next else Node v (deleteNode next)
      newHead = deleteNode head
      newTail = if newHead == Empty then Empty else tail
      newCount = if newHead == head then count else count - 1
  in Tuple (LinkedList newHead newTail newCount) (newHead /= head)

isLinkedListEmpty :: LinkedList -> Boolean
isLinkedListEmpty (LinkedList _ _ count) = count == 0

linkedListSize :: LinkedList -> Int
linkedListSize (LinkedList _ _ count) = count

initStack :: Stack
initStack = Stack Empty 0

push :: Int -> Stack -> Stack
push value (Stack head count) =
  let newHead = Node value head
      newCount = count + 1
  in Stack newHead newCount

pop :: Stack -> Tuple Int Stack
pop (Stack head count) =
  case head of
    Empty -> Tuple (-1) (Stack head count)
    Node value next -> Tuple value (Stack next (count - 1))

peekStack :: Stack -> Int
peekStack (Stack head _) =
  case head of
    Empty -> -1
    Node value _ -> value

isStackEmpty :: Stack -> Boolean
isStackEmpty (Stack _ count) = count == 0

stackSize :: Stack -> Int
stackSize (Stack _ count) = count

initQueue :: Queue
initQueue = Queue Empty Empty 0

enqueue :: Int -> Queue -> Queue
enqueue value (Queue head tail count) =
  let newNode = Node value Empty
      newHead = if head == Empty then newNode else head
      newTail = if tail == Empty then newNode else setNext tail newNode
      newCount = count + 1
  in Queue newHead newTail newCount

dequeue :: Queue -> Tuple Int Queue
dequeue (Queue head tail count) =
  case head of
    Empty -> Tuple (-1) (Queue head tail count)
    Node value next ->
      let newHead = next
          newTail = if newHead == Empty then Empty else tail
          newCount = count - 1
      in Tuple value (Queue newHead newTail newCount)

peekQueue :: Queue -> Int
peekQueue (Queue head _ _) =
  case head of
    Empty -> -1
    Node value _ -> value

isQueueEmpty :: Queue -> Boolean
isQueueEmpty (Queue _ _ count) = count == 0

queueSize :: Queue -> Int
queueSize (Queue _ _ count) = count
