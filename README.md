# Elm

Elm is a programming language that compiles to JavaScript. The highlight features are great performance and no runtime exceptions. You can read more about all that on the [home page](http://elm-lang.org/). Elm also has its own virtual DOM implementation that is [very fast](http://elm-lang.org/blog/blazing-fast-html-round-two) compared to React, Angular, and Ember.

This repo contains a game to help learn names and elm examples to refer back to while developing.

## Run The Memory Game and Elm Examples

After you [install Elm](http://guide.elm-lang.org/get_started.html), run the following commands in your terminal to download this repo and start a server that compiles Elm for you:

```bash
git clone https://github.com/evancz/elm-architecture-tutorial.git
cd elm-architecture-tutorial
elm-reactor
```

Now go to [http://localhost:8000/](http://localhost:8000/) and start looking at the `examples/` directory. When you edit an Elm file, just refresh the corresponding page in your browser and it will recompile!

The memory game is at [http://localhost:8000/examples/name-face-game.html](http://localhost:8000/examples/name-face-game.html)
