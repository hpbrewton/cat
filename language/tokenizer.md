---
title: Tokenizers
---

Tokenizers split your source into a list of tokens.

Tokens are the words of your program.
They are at their core groups of symbols that form comments, strings, variables, dots between variables, operators, number literals, import directives, open parenthes and close parenthes.
They are represent by some structure as some string with a `kind`.
Where some string has a kind is one of the things mentioned above: comments, strings, variables, data between variables, operators, number lit.
Often, to make error handling easier to do, they include things like row number and column number, which allow you to refer to their position in the source.

```go
type Token struct {
	row int
	col int
	text string
	kind kind
}
```

Let's look at a simple example: suppose we want to write a tokenizer for calculator expressions. 
Here are some example expressions:

```
(2+3)+(6+4)*2
7.55*32+85*1
```

What are the tokens here? Well, for the first line we have:
	- OpenParen
	- 2
	- PlusSign 
	- 3
	- CloseParen
	- OpenParen
	- 6
	- PlusSign 
	- 4
	- CloseParen
	- Asterix
	- 2
