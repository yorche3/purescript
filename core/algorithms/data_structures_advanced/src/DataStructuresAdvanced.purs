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
-- Cuerpos centinela: la implementación llega en el paso siguiente; hasta
-- entonces las operaciones devuelven el valor neutro de su tipo y la suite debe
-- fallar.

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

import Data.Maybe (Maybe(..))

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
withLeft node _ = node

-- Copia del nodo con el enlace derecho indicado (`set_right`).
withRight :: TreeNode -> Maybe TreeNode -> TreeNode
withRight node _ = node

-- Árbol vacío utilizable: sin raíz y contador a cero (`init`).
newBinaryTree :: BinaryTree
newBinaryTree = BinaryTree { root: Nothing, count: 0 }

-- Inserta el valor; un duplicado también es éxito y no crece el tamaño.
insert :: Int -> BinaryTree -> BinaryTree
insert _ tree = tree

-- Pertenencia según la invariante del ABB.
contains :: Int -> BinaryTree -> Boolean
contains _ _ = false

isTreeEmpty :: BinaryTree -> Boolean
isTreeEmpty _ = false

treeSize :: BinaryTree -> Int
treeSize _ = 0

-- Grafo vacío utilizable: sin vértices y contadores a cero (`init`).
newGraph :: Graph
newGraph = Graph { vertices: Nothing, vertexCount: 0, edgeCount: 0 }

-- Registra el vértice; un duplicado también es éxito y conserva la adyacencia.
addVertex :: Int -> Graph -> Graph
addVertex _ graph = graph

-- Arista dirigida `from -> to`: el grafo resultante cuando se añade o ya
-- estaba, y `Nothing` cuando falta un extremo.
addEdge :: Int -> Int -> Graph -> Maybe Graph
addEdge _ _ _ = Nothing

-- Verdadero si existe la arista dirigida `from -> to`.
hasEdge :: Int -> Int -> Graph -> Boolean
hasEdge _ _ _ = false

-- Vecinos ordenados: `Nothing` si no está registrado,
-- `Just []` si está aislado.
getNeighbors :: Int -> Graph -> Maybe (Array Int)
getNeighbors _ _ = Nothing

isGraphEmpty :: Graph -> Boolean
isGraphEmpty _ = false

-- Número de vértices registrados.
vertexCount :: Graph -> Int
vertexCount _ = 0

-- Número de aristas registradas.
edgeCount :: Graph -> Int
edgeCount _ = 0
