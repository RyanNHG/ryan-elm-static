# arrow functions are life
> when ES6 enables you to do neat stuff.


### "teach me arrow functions in 60 seconds!"

Let me show you some old-school, ES5 javascript:

```javascript
function add (a, b) {
  return a + b
}
```

Cool. Let's make another valid ES5 function, by assigning our function to a `var` (instead of a naming it):

```javascript
var add = function (a, b) {
  return a + b
}
```

They both can be used the same way!

Now let's convert this to an ES6 arrow function:

```javascript
var add = (a, b) => {
  return a + b
}
```

Wow! We remove `function` before the parameters, and add an `=>` after instead. We did it!


### let's do it some more!

```javascript
var add = (a, b) => {
  return a + b
}

var subtract = (a, b) => {
  return a - b
}

var getLength = (str) => {
  return str.length
}
```

Notice all these functions just return stuff directly? With ES6 arrow functions, we can get rid of the `{ ... }` and `return` keyword if we're returning a value in one line:

```javascript
var add = (a, b) =>
  a + b

var subtract = (a, b) =>
  a - b

var getLength = (str) =>
  str.length
```

Holy moly, you're now an arrow function pro! 


### let's check some types!

Now let's roll our own type checker for javascript values! Here are the functions we need to implement:

```javascript
var isString = (thing) => { /* true if 'thing' is a string */ }
var isBoolean = (thing) => { /* true if 'thing' is a boolean */ }
var isNumber = (thing) => { /* true if 'thing' is a number */ }
```

Let's implement this in a repetitive way, and refactor as we go:

```javascript
var isString = (thing) =>
  typeof thing === 'string'

var isBoolean = (thing) =>
  typeof thing === 'boolean'

var isNumber = (thing) =>
  typeof thing === 'number'
```

We can see the first three functions are pretty gosh darn similar. Let's try and reuse some logic!

```javascript
var isType = (thing, type) =>
  typeof thing === type

var isString = (thing) =>
  isType(thing, 'string')

var isBoolean = (thing) =>
  isType(thing, 'boolean')

var isNumber = (thing) =>
  isType(thing, 'number')
```

Welp. We successfully added more lines of code. However, fewer lines of code do not always mean better code! Still, let's try to make up for this by using arrow functions to do something called "partial composition" or more commonly "currying"


### currying used to look really ugly

Here is our ES5 add function from earlier:

```javascript
var add = function (a, b) {
  return a + b
}

add(5, 4) // => 9
```

Pretty simple, right? Let's do something bizarre:

```javascript
var add = function (a) {
  return function (b) {
    return a + b
  }
}

add(5)(4) // => 9
```

What the heck am I doing? The `add` function is a __function that returns a function__. This means `add(5)` returns a function __expecting the second number__. And _that_ means I can do stuff like this:

```javascript
var addFifty = add(50)

addFifty(1)  // => 51
addFifty(25) // => 75
```

__Partial composition__ allows me to create functions from other functions, where some of the parameters are available. It's neat in theory, but let's code the new `add` function with arrow functions to make it prettier:

```javascript
const add = (a) => (b) =>
  a + b

add(5)(4) // => 9
```

Because of the implicit `return` keyword, we can easily construct an ES6 equivalent that doesn't significantly add visual overhead.


### putting it all together.

Let's apply what we learned to the original parsing library!

```javascript
const isType = (type) => (thing) =>
  typeof thing === type

const isString = isType('string')
const isBoolean = isType('boolean')
const isNumber = isType('number')
```

Hooray! `isString` uses `isType('string')`, which returns a function! When we call `isString`, it will be expecting one parameter: `thing`. From there, we can reuse the same logic across all three functions.
