{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FunctionalDependencies #-}

module List where

class ListReturn a r | r -> a where
  fromDifflist :: ([a] -> [a]) -> r

instance ListReturn a [a] where
  fromDifflist f = f []

instance (ListReturn a r) => ListReturn a (a -> r) where
  fromDifflist f x = fromDifflist (f . (:) x)

list :: (ListReturn a r) => r
list = fromDifflist id

--  Examples:
--> list 1 5 7 9 :: [Int]
--> list 'G' 'H' 'C' 'i' :: String
--> list [1,2,3] [] [4,5] :: [[Int]] 
