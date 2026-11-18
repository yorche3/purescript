-- DataStructuresAdvanced — árbol binario de búsqueda y grafo dirigido sobre
-- términos inmutables.
--
-- Especificación: 07_Data_Structures_Advanced
--
-- Contrato: `TreeNode` (valor y dos enlaces), `BinaryTree` (ABB sin límite de
-- capacidad contractual), `GraphNode` (interno: etiqueta, adyacencia ordenada y
-- enlace al siguiente vértice del registro) y `Graph` (registro canónico
-- enlazado y contadores propios).
--
-- Adaptaciones:
--   - Los valores son inmutables: cada operación devuelve el valor nuevo. Las
--     dos actualizaciones de enlace son `withLeft` y `withRight` (la forma
--     `with_next` de la convención V2) y `addEdge` devuelve `Maybe Graph`: el
--     grafo resultante cuando la arista se añade o ya estaba y `Nothing`
--     cuando falta un extremo, de modo que el fallo nunca crea vértices.
--   - La ausencia es `Nothing`, el opcional nativo declarado para PureScript en
--     `docs/ruleset/data/canonical_names.tsv` (`absent = Nothing`,
--     `present = Just x`, familia `func-option`). Por eso los enlaces son
--     `Maybe TreeNode`, `addEdge` devuelve `Maybe Graph` y `getNeighbors`
--     devuelve `Maybe (Array Int)`: `Nothing` si el vértice no está
--     registrado y `Just []` si está aislado, que es lo que exige la
--     especificación.
--   - Los contadores devuelven `Int` y la estructura vacía informa 0.
--
-- Implementación completa: inserción ordenada sin duplicados, registro
-- canónico enlazado y contadores propios.

module DataStructuresAdvanced
  ( TreeNode(..)
  , newTreeNode
  , getValue
  , getLeft
  , getRight
  , withLeft
  , withRight
  , BinaryTree
  , newBinaryTree
  , insert
  , contains
  , isTreeEmpty
  , treeSize
  , Graph
  , newGraph
  , addVertex
  , addEdge
  , hasEdge
  , getNeighbors
  , isGraphEmpty
  , vertexCount
  , edgeCount
  ) where

import Prelude

import Data.Array (index, insertAt, length)
import Data.Maybe (Maybe(..), fromMaybe)

data TreeNode = TreeNode
  { value :: Int
  , left :: Maybe TreeNode
  , right :: Maybe TreeNode
  }

derive instance eqTreeNode :: Eq TreeNode

-- Vértice del registro canónico: etiqueta, adyacencia ordenada y enlace al
-- siguiente vértice. Interno a `Graph`.
newtype GraphNode = GraphNode
  { label :: Int
  , neighbors :: Array Int
  , nextVertex :: Maybe GraphNode
  }

newtype BinaryTree = BinaryTree
  { root :: Maybe TreeNode
  , count :: Int
  }

newtype Graph = Graph
  { vertices :: Maybe GraphNode
  , vertexCount :: Int
  , edgeCount :: Int
  }

-- Nodo con el valor indicado y ambos enlaces ausentes (`init`).
newTreeNode :: Int -> TreeNode
newTreeNode value = TreeNode { value, left: Nothing, right: Nothing }

getValue :: TreeNode -> Int
getValue (TreeNode node) = node.value

getLeft :: TreeNode -> Maybe TreeNode
getLeft (TreeNode node) = node.left

getRight :: TreeNode -> Maybe TreeNode
getRight (TreeNode node) = node.right

-- Copia del nodo con el enlace izquierdo indicado (`set_left`).
withLeft :: TreeNode -> Maybe TreeNode -> TreeNode
withLeft (TreeNode node) link = TreeNode node { left = link }

-- Copia del nodo con el enlace derecho indicado (`set_right`).
withRight :: TreeNode -> Maybe TreeNode -> TreeNode
withRight (TreeNode node) link = TreeNode node { right = link }

-- Árbol vacío utilizable: sin raíz y contador a cero (`init`).
newBinaryTree :: BinaryTree
newBinaryTree = BinaryTree { root: Nothing, count: 0 }

type InsertResult = { node :: Maybe TreeNode, inserted :: Boolean }

insertNode :: Int -> Maybe TreeNode -> InsertResult
insertNode value Nothing = { node: Just (newTreeNode value), inserted: true }
insertNode value (Just node@(TreeNode current))
  | value == current.value = { node: Just node, inserted: false }
  | value < current.value =
      let result = insertNode value current.left
      in { node: Just (withLeft node result.node), inserted: result.inserted }
  | otherwise =
      let result = insertNode value current.right
      in { node: Just (withRight node result.node), inserted: result.inserted }

-- Inserta el valor; un duplicado también es éxito y no crece el tamaño.
insert :: Int -> BinaryTree -> BinaryTree
insert value (BinaryTree tree) =
  let result = insertNode value tree.root
  in BinaryTree
    { root: result.node
    , count: if result.inserted then tree.count + 1 else tree.count
    }

-- Pertenencia según la invariante del ABB.
contains :: Int -> BinaryTree -> Boolean
contains value (BinaryTree tree) = go tree.root
  where
  go Nothing = false
  go (Just (TreeNode current))
    | value == current.value = true
    | value < current.value = go current.left
    | otherwise = go current.right

isTreeEmpty :: BinaryTree -> Boolean
isTreeEmpty (BinaryTree tree) = tree.count == 0

treeSize :: BinaryTree -> Int
treeSize (BinaryTree tree) = tree.count

-- Grafo vacío utilizable: sin vértices y contadores a cero (`init`).
newGraph :: Graph
newGraph = Graph { vertices: Nothing, vertexCount: 0, edgeCount: 0 }

findVertex :: Int -> Maybe GraphNode -> Maybe GraphNode
findVertex _ Nothing = Nothing
findVertex label (Just node@(GraphNode gn)) =
  if gn.label == label then Just node
  else findVertex label gn.nextVertex

-- Registra el vértice; un duplicado también es éxito y conserva la adyacencia.
addVertex :: Int -> Graph -> Graph
addVertex label (Graph g) =
  case findVertex label g.vertices of
    Just _ -> Graph g
    Nothing ->
      let
        newVertex = GraphNode
          { label: label, neighbors: [], nextVertex: g.vertices }
      in Graph g { vertices = Just newVertex, vertexCount = g.vertexCount + 1 }

-- Posición del primer vecino mayor que el valor nuevo; el final si no hay.
positionFor :: Int -> Array Int -> Int
positionFor value neighbors = go 0
  where
  go i
    | i >= length neighbors = i
    | otherwise = case index neighbors i of
        Just current -> if current < value then go (i + 1) else i
        Nothing -> i

insertNeighbor :: Int -> Array Int -> Array Int
insertNeighbor value neighbors =
  fromMaybe neighbors (insertAt (positionFor value neighbors) value neighbors)

hasNeighbor :: Int -> Array Int -> Boolean
hasNeighbor value neighbors = go 0
  where
  go i
    | i >= length neighbors = false
    | otherwise = case index neighbors i of
        Just current -> if current == value then true else go (i + 1)
        Nothing -> false

replaceNeighbors :: Int -> Array Int -> Maybe GraphNode -> Maybe GraphNode
replaceNeighbors _ _ Nothing = Nothing
replaceNeighbors label neighbors (Just (GraphNode gn)) =
  if gn.label == label then
    Just (GraphNode gn { neighbors = neighbors })
  else
    Just
      (GraphNode gn
        { nextVertex = replaceNeighbors label neighbors gn.nextVertex })

-- Arista dirigida `from -> to`: el grafo resultante cuando se añade o ya
-- estaba, y `Nothing` cuando falta un extremo.
addEdge :: Int -> Int -> Graph -> Maybe Graph
addEdge from to (Graph g) =
  case findVertex from g.vertices, findVertex to g.vertices of
    Just (GraphNode source), Just _
      | hasNeighbor to source.neighbors -> Just (Graph g)
      | otherwise ->
          let
            updated = replaceNeighbors from
              (insertNeighbor to source.neighbors)
              g.vertices
          in Just (Graph g { vertices = updated, edgeCount = g.edgeCount + 1 })
    _, _ -> Nothing

-- Verdadero si existe la arista dirigida `from -> to`.
hasEdge :: Int -> Int -> Graph -> Boolean
hasEdge from to (Graph g) =
  case findVertex from g.vertices of
    Nothing -> false
    Just (GraphNode source) -> hasNeighbor to source.neighbors

-- Vecinos ordenados: `Nothing` si no está registrado,
-- `Just []` si está aislado.
getNeighbors :: Int -> Graph -> Maybe (Array Int)
getNeighbors label (Graph g) =
  case findVertex label g.vertices of
    Nothing -> Nothing
    Just (GraphNode node) -> Just node.neighbors

isGraphEmpty :: Graph -> Boolean
isGraphEmpty (Graph g) = g.vertexCount == 0

-- Número de vértices registrados.
vertexCount :: Graph -> Int
vertexCount (Graph g) = g.vertexCount

-- Número de aristas registradas.
edgeCount :: Graph -> Int
edgeCount (Graph g) = g.edgeCount
