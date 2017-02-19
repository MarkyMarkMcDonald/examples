# How to hack together a chrome extension that uses elm in a weekend

I recently built a chrome extension to help me learn the names of my new coworkers faster. When I go to my company's employee directory, there's a conspicuous "Play the Name Game" button my extension adds. Clicking it scrapes the page of all the people's names and faces, then takes over the DOM with a name-to-face matching game. 

Here's an example outside of the chrome extension:

![](http://i.imgur.com/FE8Y3TW.gif)

You can find the [full source](https://github.com/markymarkmcdonald/name-face-game) on github.

## 1. Start with elm

A chrome extension is a delivery mechanism, not your architecture. Start in a playground outside of the context of a chrome extension. Prototype for a bit, play around with ideas, and settle on which features of your project will be worthwhile. 

Starting by setting up a chrome extension involves configuring boilerplate, managing permissions, and reading documentation. It also promotes coupling your app to chrome's internal apis instead of the apis you wish you had (for better or worse).

Instead of setting up a full chrome extension, clone [some elm examples](https://github.com/evancz/elm-architecture-tutorial), add your own elm file next to the examples, and run `$ elm reactor` from the project root to get started in less than 10 seconds.

## 2. Start simple

Start coding the simplist feature of your app. Even better, start with static markup based on a hardcoded initial state. Once you have something on the page you can start thinking about the actions and possible states needed to support your first features.

## 2.5 Add a stylesheet
Sooner or later you'll want to stop dealing with inline style rules in your elm view code and switch to ids/classes and stylesheets.

Elm-reactor doesn't have any hooks right now to load custom stylesheets, but it can serve up html files in addition to elm files.

We can copy the contents of one of the examples from the browser into our own html file. This lets us control loading other assets besides our compiled code, such as [a link tag pointing to our own css file](https://github.com/MarkyMarkMcDonald/name-face-game/blob/1e39899a6f1d0086a228723b113acb467a48bb84/examples/name-face-game.html#L6). (Thanks @DenisKolodin for this suggestion in [your post](https://github.com/elm-lang/elm-reactor/issues/138#issuecomment-240940888) on an elm-reactor issue)

## 3. Code towards "worth it"

Wait until you think to yourself "I'm at the point where this would be fun to try with real data". For me, this was tracking when users successfully finished matching all the names with faces. Make up sample (but available) data as needed up until this point so that you don't get hung up writing code for an integration yet.

## 4. Set boundaries

It's time to make our elm code embedded in our delivery mechanism. I looked at two main ways of [interopting between elm and javascript](https://guide.elm-lang.org/interop/javascript.html):

- Taking "[flags](https://guide.elm-lang.org/interop/javascript.html#flags)" when starting the elm program
- Subscribing/Publishing to events in our elm program via "[ports](https://guide.elm-lang.org/interop/javascript.html#ports)"

Taking flags on startup seems to fit our use case because we don't need to do anything outside of elm once we start. I'd use ports if we needed to pass messages for handling chrome-extension specific functionality like tab management.

After going down the "flags" route we'll need to change how we start our program, so let's make sure we're passing people from outside the elm program [`like this`](https://github.com/MarkyMarkMcDonald/name-face-game/blob/1e39899a6f1d0086a228723b113acb467a48bb84/examples/name-face-game.html#L25).

In my specific case I wanted to take over the employee directory page, so I used `Elm.Main.fullscreen`. If you want to start your elm program within an existing dom node, you can use `Elm.Main.embed`.

## 5. Setup the chrome extension

I use [http://extensionizr.com/](http://extensionizr.com/) to generate the boilerplate for a chrome extension quickly (thank you, thank you, thank you, [@altryne](https://twitter.com/altryne) for helping make my weekend ambitions a reality).

Once we've downloaded our skeleton, we need to [inject three scripts](https://github.com/MarkyMarkMcDonald/name-face-game/blob/96d9a26/chrome-extension/manifest.json#L16) on the employee directory page:

1. Jquery (not required by the elm program)
2. The transpiled elm program
3. The click handler that scrapes the data and starts the elm program

The transpiled elm program is created via `elm-make`: `$ elm-make elm/src/main.elm --output chrome-extension/src/inject/elm-game.js`. Using this command we can also create a [build script](https://github.com/MarkyMarkMcDonald/name-face-game/blob/96d9a26a0555e18a4a16d0b43b7db64bca307c2c/scripts/build) for creating a shareable chrome-extension as a final deliverable artifact.

Development from this point on is the same as any other chrome extension development.

## 6. Tweak the boundaries

Did we really perfectly envision how we would interopt with our elm component on the first try? Of course not. We started from a layer below our delivery mechanism, so we had to change a few things around later in order to support a new feature.

Originally when you clicked "show me new faces", I cleared the dom and started the elm program again with random people. I wanted to track the combo count across different sets of names and faces, so I moved handling new rounds to inside the elm app instead of creating the elm component over and over again.

## 7. Share the fun

Pair with someone else and show them how awesome elm is. In my case, I convinced [@mattrothenberg](https://twitter.com/mattrothenberg) to create an awesome transition upon reaching a high combo.

![](http://i.imgur.com/aHGBEx4.gif)