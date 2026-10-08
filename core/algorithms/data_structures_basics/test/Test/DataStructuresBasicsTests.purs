module Test.DataStructuresBasicsTests where

import Prelude

import Data.Tuple (Tuple(..), fst)
import Effect (Effect)
import Effect.Aff (Aff)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

import DataStructuresBasics
  ( LinkedList(..)
  , Node(..)
  , delete
  , dequeue
  , enqueue
  , getHead
  , getNext
  , getValue
  , initLinkedList
  , initNode
  , initQueue
  , initStack
  , insertHead
  , insertTail
  , isLinkedListEmpty
  , isQueueEmpty
  , isStackEmpty
  , linkedListSize
  , peekQueue
  , peekStack
  , pop
  , push
  , queueSize
  , setNext
  , stackSize
  )

-- Casos de prueba de la especificación 06_Data_Structures_Basics.md
--
-- Los casos de cada estructura son pasos sucesivos sobre el mismo estado lógico:
-- como los valores son inmutables, cada paso encadena el término que devuelve el
-- anterior, así que cada test recorre su estructura de una vez y sin reiniciar
-- el escenario. Las aserciones observan solo operaciones del contrato.
--
-- Adaptaciones: los valores de prueba son enteros positivos; `Empty` es la
-- ausencia de enlace y las lecturas que pueden fallar devuelven `-1`.

-- Valores de la cadena enlazada, siguiendo el enlace de cada `Node`.
nodeValues :: Node -> Array Int
nodeValues Empty = []
nodeValues (Node value next) = [ value ] <> nodeValues next

-- Valores de la lista, desde su cabeza.
listValues :: LinkedList -> Array Int
listValues (LinkedList head _ _) = nodeValues head

-- Aserción con el contrato delante: es el mensaje que imprime Test.Unit al
-- fallar.
check :: String -> Boolean -> Aff Unit
check label condition = Assert.assert label condition

main :: Effect Unit
main = runTest do
  suite "data_structures_basics" do
    test "node: initialize and observe value/link" do
      let a = initNode 10
      check ("node: getValue expected 10 but got " <> show (getValue a)) (getValue a == 10)
      check ("node: getNext(a) expected Empty") (getNext a == Empty)

    test "node: initialize another node, link and traverse" do
      let
        a = initNode 10
        b = initNode 20
        linked = setNext a b
      check ("node: getValue(getNext(a)) expected 20 but got " <> show (getValue (getNext linked)))
        (getValue (getNext linked) == 20)
      check ("node: getNext(b) expected Empty") (getNext b == Empty)

    test "linked_list: successive steps on the same list" do
      let empty = initLinkedList
      -- Estado vacío.
      check ("linked_list empty: isLinkedListEmpty expected true") (isLinkedListEmpty empty)
      check ("linked_list empty: linkedListSize expected 0 but got " <> show (linkedListSize empty))
        (linkedListSize empty == 0)
      check ("linked_list empty: getHead expected -1 but got " <> show (getHead empty)) (getHead empty == -1)

      -- Insertar por ambos extremos.
      let four = insertTail 10 (insertTail 20 (insertHead 5 (insertTail 10 empty)))
      check ("linked_list four insertions: linkedListSize expected 4 but got " <> show (linkedListSize four))
        (linkedListSize four == 4)
      check ("linked_list four insertions: traversal expected [5,10,20,10] but got " <> show (listValues four))
        (listValues four == [ 5, 10, 20, 10 ])

      -- Eliminar la primera aparición.
      let Tuple afterDelete deleted = delete 10 four
      check ("linked_list delete(10): expected true but got " <> show deleted) deleted
      check ("linked_list delete(10): traversal expected [5,20,10] but got " <> show (listValues afterDelete))
        (listValues afterDelete == [ 5, 20, 10 ])
      check ("linked_list delete(10): linkedListSize expected 3 but got " <> show (linkedListSize afterDelete))
        (linkedListSize afterDelete == 3)

      -- Valor ausente.
      let Tuple afterAbsent absent = delete 99 afterDelete
      check ("linked_list delete(99): expected false but got " <> show absent) (not absent)
      check ("linked_list delete(99): traversal must not change")
        (listValues afterAbsent == listValues afterDelete)
      check ("linked_list delete(99): size must not change")
        (linkedListSize afterAbsent == linkedListSize afterDelete)

      -- Vaciar.
      let Tuple after5 ok5 = delete 5 afterAbsent
      let Tuple after20 ok20 = delete 20 after5
      let Tuple emptied ok10 = delete 10 after20
      check ("linked_list delete(5): expected true but got " <> show ok5) ok5
      check ("linked_list delete(20): expected true but got " <> show ok20) ok20
      check ("linked_list delete(10): expected true but got " <> show ok10) ok10
      check ("linked_list emptied: isLinkedListEmpty expected true") (isLinkedListEmpty emptied)
      check ("linked_list emptied: linkedListSize expected 0 but got " <> show (linkedListSize emptied))
        (linkedListSize emptied == 0)
      check ("linked_list emptied: getHead expected -1 but got " <> show (getHead emptied))
        (getHead emptied == -1)

    test "stack: successive steps on the same stack" do
      let empty = initStack
      -- Estado vacío y extracción fallida.
      check ("stack empty: isStackEmpty expected true") (isStackEmpty empty)
      check ("stack empty: stackSize expected 0 but got " <> show (stackSize empty)) (stackSize empty == 0)
      check ("stack empty: peekStack expected -1 but got " <> show (peekStack empty)) (peekStack empty == -1)
      check ("stack empty: pop expected -1 but got " <> show (fst (pop empty))) (fst (pop empty) == -1)

      -- LIFO y peek no mutante.
      let three = push 30 (push 20 (push 10 empty))
      check ("stack three pushes: peekStack expected 30 but got " <> show (peekStack three)) (peekStack three == 30)
      check ("stack three pushes: stackSize expected 3 but got " <> show (stackSize three)) (stackSize three == 3)

      -- Extracción y reutilización.
      let Tuple v1 afterPop1 = pop three
      check ("stack pop: expected 30 but got " <> show v1) (v1 == 30)
      let afterPush = push 40 afterPop1
      let Tuple v2 afterPop2 = pop afterPush
      let Tuple v3 afterPop3 = pop afterPop2
      let Tuple v4 afterPop4 = pop afterPop3
      check ("stack pop after push(40): expected 40 but got " <> show v2) (v2 == 40)
      check ("stack third pop: expected 20 but got " <> show v3) (v3 == 20)
      check ("stack fourth pop: expected 10 but got " <> show v4) (v4 == 10)
      check ("stack emptied: isStackEmpty expected true") (isStackEmpty afterPop4)
      check ("stack emptied: stackSize expected 0 but got " <> show (stackSize afterPop4))
        (stackSize afterPop4 == 0)

      -- Vacío tras extracción.
      check ("stack pop on empty: expected -1 but got " <> show (fst (pop afterPop4))) (fst (pop afterPop4) == -1)
      check ("stack pop on empty: isStackEmpty still true") (isStackEmpty afterPop4)

    test "queue: successive steps on the same queue" do
      let empty = initQueue
      -- Estado vacío y extracción fallida.
      check ("queue empty: isQueueEmpty expected true") (isQueueEmpty empty)
      check ("queue empty: queueSize expected 0 but got " <> show (queueSize empty)) (queueSize empty == 0)
      check ("queue empty: peekQueue expected -1 but got " <> show (peekQueue empty)) (peekQueue empty == -1)
      check ("queue empty: dequeue expected -1 but got " <> show (fst (dequeue empty))) (fst (dequeue empty) == -1)

      -- FIFO y peek no mutante.
      let three = enqueue 30 (enqueue 20 (enqueue 10 empty))
      check ("queue three enqueues: peekQueue expected 10 but got " <> show (peekQueue three)) (peekQueue three == 10)
      check ("queue three enqueues: queueSize expected 3 but got " <> show (queueSize three)) (queueSize three == 3)

      -- Extracción y reutilización.
      let Tuple v1 afterDequeue1 = dequeue three
      check ("queue dequeue: expected 10 but got " <> show v1) (v1 == 10)
      let afterEnqueue = enqueue 40 afterDequeue1
      let Tuple v2 afterDequeue2 = dequeue afterEnqueue
      let Tuple v3 afterDequeue3 = dequeue afterDequeue2
      let Tuple v4 afterDequeue4 = dequeue afterDequeue3
      check ("queue second dequeue: expected 20 but got " <> show v2) (v2 == 20)
      check ("queue third dequeue: expected 30 but got " <> show v3) (v3 == 30)
      check ("queue fourth dequeue: expected 40 but got " <> show v4) (v4 == 40)
      check ("queue emptied: isQueueEmpty expected true") (isQueueEmpty afterDequeue4)
      check ("queue emptied: queueSize expected 0 but got " <> show (queueSize afterDequeue4))
        (queueSize afterDequeue4 == 0)

      -- Vacío tras extracción.
      check ("queue dequeue on empty: expected -1 but got " <> show (fst (dequeue afterDequeue4)))
        (fst (dequeue afterDequeue4) == -1)
      check ("queue dequeue on empty: isQueueEmpty still true") (isQueueEmpty afterDequeue4)
