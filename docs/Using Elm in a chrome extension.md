# Using Elm in a chrome extension

I recently built a chrome extension to help me learn the names of my new coworkers faster. When I go to the page of my company's internal employee directory, there's a conspicuous "Play the Name Game" button. Clicking it scrapes the page of all the people and takes over the DOM with a name-face matching game. Here's an example outside of the chrome extension:

![](http://i.imgur.com/FE8Y3TW.gif)

## 1. Start with elm

A chrome extension is a delivery mechanism, not your architecture. Go build a something outside of the extension. Prototype, play, figure out which bits of your project are worthwhile. Setting up a chrome extension involves boilerplate, permissions, and no automated code reloading. Clone [some elm examples](https://github.com/evancz/elm-architecture-tutorial), add your own elm file next to the examples, and run `$ elm reactor` to get started in less than 10 seconds.

## 2. Add styles

Using tuples of style rules on a per element basis is unmaintainable right from the start. The elm reactor doesn't have any hooks to add custom stylesheets, but it can serve up html files in addition to elm files. We can go to one of the examples in the browser, open the dom inspector, and copy the contents to an html file we then control. Add a link tag pointing to a css file. [Here's an example](https://github.com/MarkyMarkMcDonald/name-face-game/blob/1e39899a6f1d0086a228723b113acb467a48bb84/examples/name-face-game.html#L6).

## 3. Arrive at "worth it"

Wait until you think to yourself "I'm at the point where this would be fun to try for real". For me, this was tracking when users successfully finished matching names with faces. Until you get to this point, make up sample (but available) data so you don't have to integrate with anything yet.

## 4. Set boundaries

It's time to make our elm code callable by the plain javascript of a chrome extension. I looked at two main ways of interopting between elm and javascript:

- Taking "[flags]()" when starting the elm program
- Subscribing/Publishing to events in our elm program via "[ports]()"

Taking flags on startup seems to fit our use case because we don't need to do anything outside of elm once we start. I'd use ports if we needed to pass messages for handling chrome-extension specific functionality like tab management.

After going down the "flags" route we'll need to change how we start our program, so let's edit where we call [`runElmProgram`](https://github.com/MarkyMarkMcDonald/name-face-game/blob/1e39899a6f1d0086a228723b113acb467a48bb84/examples/name-face-game.html#L25).

## 5. Setup the chrome extension

I use [http://extensionizr.com/](http://extensionizr.com/) to generate the boilerplate for a chrome extension quickly. 

For this project, I wanted to have a button show up in my company's internal person directory that would scrape the people on the page and run the command to start the elm program.

I choose to [inject three scripts](https://github.com/MarkyMarkMcDonald/name-face-game/blob/96d9a26/chrome-extension/manifest.json#L16) on the directory page:

1. Jquery (not required by the elm program)
2. The transpiled elm program
3. The click handler that scrapes the data and starts the elm program

How do we get the transpiled elm program? `elm-make` can generate a script file instead of the default html page. Here's the command I use: `elm-make elm/src/main.elm --output chrome-extension/src/inject/elm-game.js`. Using this we can create a [sample build script](https://github.com/MarkyMarkMcDonald/name-face-game/blob/96d9a26a0555e18a4a16d0b43b7db64bca307c2c/scripts/build) for creating a shareable chrome extension.

Development from this point is the same as any other chrome extension.

## 6. Tweak the boundaries

Did we really envision the perfect elm component from the Inside-Out on our first try? Of course not. Outside-In development makes sure we're making what top level consumers in our architecture need, but we skipped it this time in order to not start by setting up the actual chrome extension. 

Examples of changes at the boundary over time:

- Moving randomnization into the elm code
- Handling "show me new faces" inside the elm app instead of creating the elm component again in order to track the combo count.
- Passing all the people to the elm component at the start instead of one name-face set.

## 7. Share the fun

Get @mattrothenberg to help you make an awesome transition when you hit a high combo.

![](http://i.imgur.com/aHGBEx4.gif)