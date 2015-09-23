{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FunctionalDependencies #-}

module Concats where

class ConcatReturn a r | r -> a where
  fromDifflist :: ([a] -> [a]) -> r

instance ConcatReturn a [a] where
  fromDifflist = ($ [])

instance (ConcatReturn a r) => ConcatReturn a ([a] -> r) where
  fromDifflist a xs = fromDifflist (a . (++) xs)

concats :: (ConcatReturn a r) => r
concats = fromDifflist id

-- Examples:
--> concats [1,2,3] [] [4,5] [6] :: [Int]
--> concats "Hello, " "world" "!"
--> fromDifflist reverse "!" "dlrow" " ,olleH"
