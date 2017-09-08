# ryan-elm
> A static personal website made in elm.

### Local Setup

1. __`npm i -g static-server elm`__
1. __`elm make src/Main.elm --output app.js`__
1. __`static-server`__

__To watch for file changes__

1. __`npm i -g chokidar-cli`__
1. __`chokidar 'src/**/*.elm' -c 'elm make src/Main.elm --output app.js'`__
