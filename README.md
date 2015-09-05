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

## Notes

### Functional dependencies

We can make our classes much more powerful with multiparameter typeclasses and functional dependencies, for instance, making the class above polymorphic to any list, like so:

```Haskell
{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FunctionalDependencies #-}

class ListReturnType a r | r -> a where
  retList :: [a] -> r

instance ListReturnType a [a] where
  retList = id
  
instance (ListReturnType a r) => ListReturnType a (a -> r) where
  retList xs x = retList (xs ++ [x])

list :: (ListReturnType a r) => r
list = retList []
```

This can be applied to any datatype with a type variable. Notice the similarity to the original definition.

### Template Haskell method

It's worth mentioning that this can be done similarly with Template Haskell. However, this requires more effort on the users part, because the number of arguments must be explicitly described before the arguments are passed.
Here is an example of the use of a `printf` function written in Template Haskell:

```Haskell
$(printf "Hello %s! This is a number: %d") "World" 12
```

The number of arguments to the function is determined in the splice (The `$( ... )` bit) rather than outside. Where in our `str` or `list` function we can implicitly describe the number of arguments, with Template Haskell, we'd describe it explicitly, something like this:

```Haskell
$(list 5) 'H' 'e' 'l' 'l' 'o'
```

Even though we must define the number of arguments explictly, this does have the benefit of not needing explicit type signatures, which is an interesting payoff, but because Haskell supports type inference, I regard the original method as easier.

In these examples, we will not be using Template Haskell, though I encourage you to experiment with it.

More information about Template Haskell can be found [here](https://wiki.haskell.org/Template_Haskell).
