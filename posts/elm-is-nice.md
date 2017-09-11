# Elm is Nice
> I like to code with it from time to time.

### What is an 'Elm'?

Elm is a [delightful language for reliable webapps](http://elm-lang.org). Like React or Vue, it's main goal is to make building complex (or simple) web applications easier! But unlike these Javascript frameworks, it is not trying to accomplish that goal by building on top of the Javascript language. Elm solves the problem by introducing functional programming in an approachable, easy-to-learn way.

I first got hooked when I a Medium article entitled [So You Want to be a Functional Programmer](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-1-1f15e387e536) caught my eye on the train. By the time I got home, I had read through the entire series. When I got home, I checked out Evan Czaplicki's [Let's be Mainstream](https://youtu.be/oYk8CKH7OhE) talk.

Evan's message really resonated with me. Elm was designed to bring functional programming to Javascript developers. Although the language didn't match the Java/C++ mindset I had from high school and college, it's syntax was oddly intuitive. After the talk I decided to give it a shot!


### Hello World!

```elm
import Html exposing (text)

main =
    text "Hello World!"
```

If we take a look at the line `text "Hello World!"`, we'll see that it is a function.
