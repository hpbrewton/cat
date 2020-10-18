---
title: Motivation for Monads
---

Suppose you're trying to make a program that automatically builds a house.
The programs you can use are ones that dig a foundation, build a skeleton, and do the finishing work.
The foundation takes no input, but to build the skeleton you have to pass the exact shape created by digging,
and to do the finishing work you need to take in the exact skeleton of the house.
Each of these programs can raise an issue to its user:
a storm made the ground too wet to excavate, 
the carpenters do not have all their materials,
the interior dectorators went on strike.
We can represent these problems with the following type signatures:

- `dig: Possibly Foundation`
- `build: Foundation -> Possibly Skeleton`
- `finish: Skeleton -> Possibly House`

Here, `Possibly X` means that we either have an `error` or we have a value `X`.
We can get values out of a `Possibly X` with `getValue(Possibly X)-> X`, 
but if we apply `getValue` to an error, our program will break and we'll have a disaster.
There is no value to get after all.
We can also take any value and convert it to a `Possibly X` with `possibly(v: X)-> Possibly X`.
All this is to say that we need to check before getting a value.
We could imagine writing our program `housePlease`:
```
housePlease-> Possibly House {
	pfoundation = dig
	if pfoundation is an error {
		return an error
	}
	foundation = getValue(pfoundation)

	pskeleton = build foundation
	if pskeleton is an error {
		return an error
	}
	skeleton = getValue(pskeleton)

	return (finish skeleton)
}
```

So we have a program, good.
But what if had a few more errors?
Eventually all of this messing arround with `is an error` and if statements will get annyoing.
Is there a better way to do this?

We can define another function `fMap` (ask later about the name)
which wraps up this `if` business.
The type signature is `fMap(m: A-> B, v: Possibly A) -> Possibly B`,
and it takes a function and a value that is either an error or an `A` and uses that function to define something that is possibly `B`.
This is defined the way you'd think: 
if `v` is an error, then just return an error,
but otherwise extract the value with `getValue`,
and then apply `m` and return that value wth `Possibly(B)`.
With this we can now simplify our `housePlease` function.

```
housePlease-> Possibly(Possibly(Possibly House)) {
	return fMap(finish, fMap(build, dig))
}
```

We are almost read to rewrite our `housePlease` function.
But we have a problem, the type of this function is not right. 
It should just give us `Possibly House`,
but instead gives us a `Possibly(Possibly(Possibly(House)))`.
We need some function that compresses this down.
Well, one way is to create a function that does this for us.
We shall call this, somewhat leadingly, `joinPossibly`.
This takes something that is either an error or either an error or a value,
and convert it something that is just either an error or a value.

```
joinPossibly(ppx: Possibly (Possibly v))-> Possibly v {
	if ppx is an error {
		return an error 
	}
	return getValue(ppx)
}
```

So, now we can actually define `housePlease`:
```
housePlease-> Possibly(House) {
	return join(fMap(finish, join(fMap(build, dig))))
}
```

Okay, we can still do a little more cleaning up.
We can define a function bind `bind(m : A-> Possibly B, v: Possibly A) -> Possibly B`.
This defined simply: `bind(m, v) {join(fmap(m, v))}`.

And, we can now simplify `housePlease` to:
```
housePlease-> Possibly(House) {
	return bind(finish, bind(build, dig))
}
```

This pattern is very common in programming.
That is, defining `join(F(F(v)))-> F(v)` and and defining `fMap(m: A -> B, v: F(A)) -> F(B)`, and using `bind`.
We call this pattern a Monad.
The name monad comes from category theory. 
Where any `F` thing that has `fMap` defined is called a functor (that's the `f` in `fMap`),
oh, you have to be able to convert an `A` to a `F`, this was the `Possibly` function seen earlier.
And if `join` is defined it is a special functor called a monad.

Here are some additional interesting monads you might want to take a look at:

- The parser monad
- The writer monad
- The state monad
- The infamous IO monad
- The list monad 

They all do a similar thing of making repeated pieces of code easier to understand.

I might write about these in the future.
