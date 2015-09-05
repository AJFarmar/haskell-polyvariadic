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
