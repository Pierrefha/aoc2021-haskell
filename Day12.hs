{-|
Example data:
-}
import Data.List (foldl')
import Data.List.Split

import Data.Map (Map)
import qualified Data.Map as M

import Data.Char

main
  -- input <- lines <$> readFile "inputDay11"
 = do
  input <- lines <$> readFile "testInput"
  print $ ex1 input
  -- print $ ex2 input
  return ()

type Node = [Char]

type Path = [Node]

type EdgeMap = Map Node [Node]

ex1 :: [[Char]] -> [Path]
ex1 input = walk "start" [[]] $ mkEdgeMap input
  where
    mkEdgeMap :: [[Char]] -> EdgeMap
    mkEdgeMap input
          -- parses input which looks like ["x-y",..] to "["x","y"],..] where x and
          -- y will be an edge with x being the start and y the end node.
     =
      let edges = map (splitOn "-") input
            -- creates Map of edges consisting of the individual nodes as keys and
            -- all the nodes their are connected with as values.
       in M.fromListWith (++) $ [(head edge, tail edge) | edge <- edges]

endNode = "end"

startNode = "start"

emptyPath :: Path
emptyPath = []

walk :: Node -> Path -> Map Node [Node] -> [Path]
walk node visited edgeMap =
  if node == endNode
    then [visited]
    else case useNode node visited of
           True ->
             case M.lookup node edgeMap of
               Just stepableNodes ->
                 concatMap
                   (\nextNode -> walk nextNode (node : visited) edgeMap)
                   stepableNodes
               Nothing -> [emptyPath]
           otherwise -> [emptyPath]

-- Determines whether we can use this node for walking towards the goal.
useNode :: Node -> Path -> Bool
useNode node path
  | all isLower node && node `elem` path = False
  | otherwise = True

-- edgeMap :: [[Char]] -> Map [Char] [[Char]]
-- edgeMap input = foldl' (\edgeMap (start,end) -> ) M.empty
-- addEdge :: Map [Char] [[Char]] -> [Char]
ex2 :: [[Char]] -> Int
ex2 input = 2