{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}

module FirstJust where

class FirstReturn a r | r -> a where
  fromMaybe :: Maybe a -> r

instance FirstReturn a (Maybe a) where
  fromMaybe = id

instance (FirstReturn a r) => FirstReturn a (Maybe a -> r) where
  fromMaybe Nothing a = fromMaybe a
  fromMaybe a       _ = fromMaybe a

firstJust :: (FirstReturn a r) => r
firstJust = fromMaybe Nothing

--  Examples:
--> firstJust Nothing (Just 3) (Just 5) Nothing :: Maybe Int
--> firstJust :: Maybe String
--> firstJust (lookup a map) (lookup b map) (lookup c map) :: Maybe Something
