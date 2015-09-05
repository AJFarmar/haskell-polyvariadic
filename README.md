# Haskell-polyvariadic
Examples of polyvariadic functions in Haskell.

## What are polyvariadic functions?
Polyvariadic functions are functions which can take variable numbers of arguments. In most programming languages this is trivial. Take this example in Python:

```python
def sum_args(*all):
    total = 0
    for i in all:
        total = total + i
    return total
```

In this case, all of these function calls are legal:

```python
>>> sum_args(4,3,1)
8
>>> sum_args(1,2,3,4,5)
15
>>> sum_args()
0
```

However, in Haskell, this becomes trickier due to types: since every Haskell function's type only takes one argument, functions with many arguments return a new function with a different argument type, and does so until reaching a final type.

However, we can't have a *variable* number of arguments in that way: the number of arguments is already decided. You might think of making the type return an `Either` type so as to describe the option of two return types, but that would lead to nasty syntax.

## How can we describe polyvariadic functions in Haskell?

We can't quite create functions that are polyvariadic at runtime, but at compile-time it's certainly possible, via typeclasses.

For instance, if we were to make a function, `str`, that chained `Char`s together into a string, we would begin by making a typeclass:

```Haskell
{-# LANGUAGE FlexibleInstances #-}

class StrReturnType r where
  retString :: String -> r
```

Then, we'd add instances for the possible return types, as so:

```Haskell
instance StrReturnType String where
  retString = id

instance (StrReturnType r) => StrReturnType (Char -> r) where
  retString s c = retString (s ++ [c])
```

Then it's easy to make a function `str`:

```Haskell
str :: (StrReturnType r) => r
str = retString ""
```

And that's all! We need to write the type signature so as to constrain the type in GHCi:

```Haskell
λ> str 'a' 'b' 'c' 'd' :: String
"abcd"
λ> str 'H' 'a' 's' 'k' 'e' 'l' 'l' :: String
"Haskell"
λ> str :: String
""
```
