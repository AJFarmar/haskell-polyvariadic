{-# LANGAUGE FlexibleInstances #-}

module Printf where

class PrintfType r where
  printf :: String -> r

instance PrintfType String where
  printf = id

instance PrintfType (IO ()) where
  printf = putStrLn

instance (PrintfType r) => PrintfType (String -> r) where
  printf f s = printf (replaceString f s)

instance (PrintfType r) => PrintfType (Int -> r) where
  printf f i = printf (replaceInt f i)

replaceString :: String -> String -> String
replaceString ('%':'%':xs) s = '%' : replaceString xs s
replaceString ('%':'s':xs) s = s ++ xs
replaceString (x:xs)       s = x : replaceString xs s
replaceString []           s = error "printf: No String placemarker."

replaceInt :: String -> Int -> String
replaceInt ('%':'%':xs) i = '%' : replaceInt xs i
replaceInt ('%':'i':xs) i = show i ++ xs
replaceInt (x:xs)       i = x : replaceInt xs i
replaceInt []           i = error "printf: No Int placemarker."

-- Examples:
--> printf "%i%% of the population are %s." (12 :: Int) "aliens" :: String
--> printf "Hello, %s!" "World" :: IO ()
--> printf "This will fail %i times!" "sixteen point five" :: IO ()
