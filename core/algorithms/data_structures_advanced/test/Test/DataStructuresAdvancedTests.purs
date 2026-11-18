module Test.DataStructuresAdvancedTests where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe, isJust, isNothing)
import Effect (Effect)
import Effect.Aff (Aff)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

import DataStructuresAdvanced
  ( BinaryTree
  , Graph
  , addEdge
  , addVertex
  , contains
  , edgeCount
  , getLeft
  , getNeighbors
  , getRight
  , getValue
  , hasEdge
  , insert
  , isGraphEmpty
  , isTreeEmpty
  , newBinaryTree
  , newGraph
  , newTreeNode
  , treeSize
  , vertexCount
  , withLeft
  , withRight
  )

-- Casos de prueba de la especificación 07_Data_Structures_Advanced.md
-- (23 filas: 6 TreeNode, 7 BinaryTree, 10 Graph; un test por fila).
--
-- Los valores son inmutables: cada paso encadena el término devuelto por el
-- anterior y cada test parte de una instancia recién inicializada.
--
-- Adaptaciones:
--   - La ausencia es `Nothing`; el fallo de `contains`/`hasEdge` es `false`.
--   - `insert` y `addVertex` no pueden fallar con el contrato actual: su éxito
--     se observa en pertenencia y contadores. `addEdge` devuelve `Maybe Graph`
--     y `Just` es éxito; encadenar con `>>=` propaga el primer fallo.
--   - La fila «Adaptación inmutable» aplica: los valores son inmutables.

check :: String -> Boolean -> Aff Unit
check label condition = Assert.assert label condition

checkInt :: String -> Int -> Int -> Aff Unit
checkInt label expected actual =
  check (label <> " expected " <> show expected <> " but got " <> show actual)
    (actual == expected)

checkNeighbors :: String -> Maybe (Array Int) -> Int -> Graph -> Aff Unit
checkNeighbors label expected vertex graph =
  check
    ( label <> ": getNeighbors(" <> show vertex <> ") expected " <> show expected
        <> " but got "
        <> show (getNeighbors vertex graph)
    )
    (getNeighbors vertex graph == expected)

checkTree :: String -> Int -> BinaryTree -> Aff Unit
checkTree label size tree = do
  checkInt (label <> ": treeSize") size (treeSize tree)
  check (label <> ": isTreeEmpty should be " <> show (size == 0))
    (isTreeEmpty tree == (size == 0))

checkCounts :: String -> Int -> Int -> Graph -> Aff Unit
checkCounts label vertices edges graph = do
  checkInt (label <> ": vertexCount") vertices (vertexCount graph)
  checkInt (label <> ": edgeCount") edges (edgeCount graph)

graphOf :: Maybe Graph -> Graph
graphOf = fromMaybe newGraph

edge :: Int -> Int -> Maybe Graph -> Maybe Graph
edge from to = (=<<) (addEdge from to)

main :: Effect Unit
main = runTest do
  suite "data_structures_advanced" do
    suite "TreeNode" do
      test "create a tree node" do
        check "treeNode: getValue should be 10" (getValue (newTreeNode 10) == 10)

      test "absent initial links" do
        let node = newTreeNode 10
        check "treeNode: getLeft should be absent" (isNothing (getLeft node))
        check "treeNode: getRight should be absent" (isNothing (getRight node))

      test "link two children" do
        let parent = withRight (withLeft (newTreeNode 10) (Just (newTreeNode 20))) (Just (newTreeNode 30))
        check "treeNode: left child value should be 20" (map getValue (getLeft parent) == Just 20)
        check "treeNode: right child value should be 30" (map getValue (getRight parent) == Just 30)

      test "traverse each link" do
        let
          parent = withRight (withLeft (newTreeNode 10) (Just (newTreeNode 20))) (Just (newTreeNode 30))
          leftChild = getLeft parent
          rightChild = getRight parent
        check "treeNode: following getLeft should reach 20" (map getValue leftChild == Just 20)
        check "treeNode: following getRight should reach 30" (map getValue rightChild == Just 30)
        check "treeNode: left child links should be absent"
          (isNothing (leftChild >>= getLeft) && isNothing (leftChild >>= getRight))
        check "treeNode: right child links should be absent"
          (isNothing (rightChild >>= getLeft) && isNothing (rightChild >>= getRight))

      test "unlink children" do
        let
          linked = withRight (withLeft (newTreeNode 10) (Just (newTreeNode 20))) (Just (newTreeNode 30))
          noLeft = withLeft linked Nothing
          noChildren = withRight noLeft Nothing
        check "treeNode: clearing left should keep value 10" (getValue noLeft == 10)
        check "treeNode: clearing left should make left absent" (isNothing (getLeft noLeft))
        check "treeNode: clearing left should keep right child 30"
          (map getValue (getRight noLeft) == Just 30)
        check "treeNode: clearing right should keep value 10" (getValue noChildren == 10)
        check "treeNode: clearing right should make both links absent"
          (isNothing (getLeft noChildren) && isNothing (getRight noChildren))

      test "immutable adaptation" do
        let
          original = newTreeNode 10
          updated = withLeft original (Just (newTreeNode 20))
        check "treeNode: updated copy should carry the link" (map getValue (getLeft updated) == Just 20)
        check "treeNode: original should stay unchanged" (isNothing (getLeft original))

    suite "BinaryTree" do
      test "create empty" do
        checkTree "tree" 0 newBinaryTree
        check "tree: contains(50) should fail on the empty tree" (not (contains 50 newBinaryTree))

      test "insert the root" do
        let tree = insert 50 newBinaryTree
        checkTree "tree" 1 tree
        check "tree: contains(50) should succeed" (contains 50 tree)

      test "insert lower and higher" do
        let tree = newBinaryTree # insert 50 # insert 30 # insert 70
        checkTree "tree" 3 tree
        check "tree: contains(50) should succeed" (contains 50 tree)
        check "tree: contains(30) should succeed" (contains 30 tree)
        check "tree: contains(70) should succeed" (contains 70 tree)

      test "multilevel branches" do
        let tree = newBinaryTree # insert 50 # insert 30 # insert 70 # insert 20 # insert 40
        checkTree "tree" 5 tree
        check "tree: contains(50) should succeed" (contains 50 tree)
        check "tree: contains(30) should succeed" (contains 30 tree)
        check "tree: contains(70) should succeed" (contains 70 tree)
        check "tree: contains(20) should succeed" (contains 20 tree)
        check "tree: contains(40) should succeed" (contains 40 tree)

      test "missing value in nonempty tree" do
        let tree = insert 50 newBinaryTree
        check "tree: contains(99) should fail" (not (contains 99 tree))
        checkTree "tree" 1 tree
        check "tree: contains(50) should still succeed" (contains 50 tree)

      test "idempotent duplicate" do
        let tree = newBinaryTree # insert 50 # insert 30 # insert 70 # insert 30
        checkTree "tree" 3 tree
        check "tree: contains(50) should succeed" (contains 50 tree)
        check "tree: contains(30) should succeed" (contains 30 tree)
        check "tree: contains(70) should succeed" (contains 70 tree)

      test "ordered insertions" do
        let tree = newBinaryTree # insert 20 # insert 30 # insert 40 # insert 50 # insert 70
        checkTree "tree" 5 tree
        check "tree: contains(20) should succeed" (contains 20 tree)
        check "tree: contains(30) should succeed" (contains 30 tree)
        check "tree: contains(40) should succeed" (contains 40 tree)
        check "tree: contains(50) should succeed" (contains 50 tree)
        check "tree: contains(70) should succeed" (contains 70 tree)
        check "tree: contains(99) should fail" (not (contains 99 tree))

    suite "Graph" do
      test "create empty" do
        check "graph: isGraphEmpty should be true" (isGraphEmpty newGraph)
        checkCounts "graph" 0 0 newGraph
        check "graph: hasEdge(10,30) should fail" (not (hasEdge 10 30 newGraph))
        checkNeighbors "graph" Nothing 10 newGraph

      test "isolated vertex" do
        let graph = addVertex 10 newGraph
        check "graph: isGraphEmpty should be false" (not (isGraphEmpty graph))
        checkCounts "graph" 1 0 graph
        checkNeighbors "graph" (Just []) 10 graph

      test "nonconsecutive labels and directed edge" do
        let result = Just (newGraph # addVertex 10 # addVertex 70) # edge 10 70
        check "graph: addEdge(10,70) should succeed" (isJust result)
        let graph = graphOf result
        check "graph: hasEdge(10,70) should succeed" (hasEdge 10 70 graph)
        check "graph: hasEdge(70,10) should fail" (not (hasEdge 70 10 graph))
        checkCounts "graph" 2 1 graph

      test "duplicate vertex preserves adjacency" do
        let result = Just (newGraph # addVertex 10 # addVertex 30) # edge 10 30
        check "graph: addEdge(10,30) should succeed" (isJust result)
        let graph = addVertex 10 (graphOf result)
        checkCounts "graph" 2 1 graph
        checkNeighbors "graph" (Just [ 30 ]) 10 graph

      test "duplicate edge" do
        let
          base = Just (newGraph # addVertex 10 # addVertex 30)
          first = edge 10 30 base
          second = edge 10 30 first
        check "graph: first addEdge(10,30) should succeed" (isJust first)
        check "graph: second addEdge(10,30) should succeed" (isJust second)
        let graph = graphOf second
        checkCounts "graph" 2 1 graph
        checkNeighbors "graph" (Just [ 30 ]) 10 graph

      test "missing endpoint without mutation" do
        let
          graph = graphOf (edge 10 30 (Just (newGraph # addVertex 10 # addVertex 30)))
        check "graph: setup addEdge(10,30) should succeed" (hasEdge 10 30 graph)
        check "graph: addEdge(10,99) should fail" (isNothing (addEdge 10 99 graph))
        check "graph: addEdge(99,10) should fail" (isNothing (addEdge 99 10 graph))
        check "graph: addEdge(98,99) should fail" (isNothing (addEdge 98 99 graph))
        check "graph: addEdge(99,99) should fail" (isNothing (addEdge 99 99 graph))
        checkCounts "graph" 2 1 graph
        checkNeighbors "graph" (Just [ 30 ]) 10 graph
        checkNeighbors "graph" (Just []) 30 graph
        check "graph: hasEdge(10,99) should fail" (not (hasEdge 10 99 graph))
        check "graph: hasEdge(99,10) should fail" (not (hasEdge 99 10 graph))
        check "graph: hasEdge(98,99) should fail" (not (hasEdge 98 99 graph))
        check "graph: hasEdge(99,99) should fail" (not (hasEdge 99 99 graph))
        checkNeighbors "graph" Nothing 98 graph
        checkNeighbors "graph" Nothing 99 graph

      test "sorted neighbours and counts" do
        let
          result =
            Just (newGraph # addVertex 10 # addVertex 30 # addVertex 50 # addVertex 70)
              # edge 10 70
              # edge 10 30
              # edge 10 50
              # edge 30 50
        check "graph: all four addEdge calls should succeed" (isJust result)
        let graph = graphOf result
        checkNeighbors "graph" (Just [ 30, 50, 70 ]) 10 graph
        checkNeighbors "graph" (Just [ 50 ]) 30 graph
        checkNeighbors "graph" (Just []) 50 graph
        checkNeighbors "graph" (Just []) 70 graph
        checkCounts "graph" 4 4 graph

      test "missing-edge query" do
        let graph = newGraph # addVertex 10 # addVertex 30
        check "graph: hasEdge(10,30) should fail" (not (hasEdge 10 30 graph))
        checkCounts "graph" 2 0 graph
        check "graph: isGraphEmpty should be false" (not (isGraphEmpty graph))

      test "neighbours of missing vertex" do
        let graph = addVertex 10 newGraph
        checkNeighbors "graph" Nothing 99 graph
        checkNeighbors "graph" (Just []) 10 graph
        checkCounts "graph" 1 0 graph

      test "self-loop and duplicate" do
        let
          base = Just (addVertex 10 newGraph)
          first = edge 10 10 base
          second = edge 10 10 first
        check "graph: first addEdge(10,10) should succeed" (isJust first)
        check "graph: second addEdge(10,10) should succeed" (isJust second)
        let graph = graphOf second
        check "graph: hasEdge(10,10) should succeed" (hasEdge 10 10 graph)
        checkNeighbors "graph" (Just [ 10 ]) 10 graph
        checkCounts "graph" 1 1 graph
