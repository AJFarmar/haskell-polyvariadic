{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FunctionalDependencies #-}

newtype Result a = Result {getResult :: a}
  deriving (Show, Read, Eq, Ord)

class MonoidReturn m r | r -> m where
  fromMonoid :: m -> r

instance MonoidReturn m (Result m) where
  fromMonoid = Result

instance (Monoid m, MonoidReturn m r) => MonoidReturn m (m -> r) where
  fromMonoid a b = fromMonoid (a `mappend` b)
  

appends :: (Monoid m, MonoidReturn m r) => r
appends = fromMonoid mempty

--  Examples:
--> getResult $ appends [1,2,3] [4,5] [6,7,8] [] [9,10] :: [Int]
--> (getResult $ appends reverse id) [1,2,3,4,5] :: [Int]
--> getResult $ appends (EQ, [1,2]) (GT, []) (GT, [1,2,3]) :: (Ordering, [Int])
