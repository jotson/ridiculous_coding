# ridiculous_coding for Godot

Written by John Watson and edited by Cuppixx.

## A word by CuppiXD [aka Cuppixx]

As this is a fork of the original addon by John Watson, the general idea and structure remain the same.
Should you encounter any bugs (I hope you won't) while using my version of the addon please do not bother the original author as it is most likely an issue caused by me.

What I fixed:
- **Saving works properly over new / multiple sessions now**
- Characters / Keys now animate even with the boom and / or blip settings toggled off
- Fixed some node errors (most likely caused by porting to godot 4)
- More stable in my testing

What I changed:
- **Added an extensive settings window**
- The progress bar now includes different "ranks" to climb
- You can choose between the original beeping sound and my typewriter sound
- Smaller char / blip / newline effects
- Fireworks are now purple-ish instead of rainbow colored
- Chars emited upon destruction are now red / yellow instead of rainbow colored
- Less overhead in code
- Saving now utilizes godots resources instead of .ini files
- Code is more alligned with (godot) writing conventions
- Code is more static
- Prob some more stuff I don't remember as of writing this LOL

What I want to do:
- Make the implementation of some scenes more modular
- Settings to configure VFX color schemes
- Other settings
- Maybe some more sounds to pick from
- Implement an optional custom background feature

Besides the obvious fix and some new features my version of the addon aims to be overall less 'in your face'. **This is my personal taste**. Feel free to revert any changes back to a more 'in your face' type of style.

**A huge thanks** to John Watson for creating such an amazing addon / plugin :D !!!!!!!

# Below is the addons original README:

## What does it do?

It makes your coding experience in Godot 1000x more ridiculous.

![Ridiculous](readme-example.gif)

This addon was inspired by [Textreme2 by Ash K](https://ash-k.itch.io/textreme-2). Go buy it!

## Installation

1. Create an `addons` directory in your Godot project
2. Create a `ridiculous_coding` directory inside `addons`
3. Copy all of the files there
4. Enable the plugin in `Project Settings | Plugins`
5. **IMPORTANT:** Choose a *monospaced* Code Font in `Editor Settings` on the `Interface | Editor` tab otherwise the addon won't be able to calculate your cursor position correctly

You might need to close and open your editor or open a new script file to start seeing anything working. I don't know why. Pull requests welcome.

Your Godot directory structure should look like this:

```
res://
	addons
		ridiculous_coding
			...all the ridiculous coding files...
```

![Choose a code font](readme-font.png)

![Enable plugin](readme-enable.png)

## About me

Hey, I'm John and I'm making a game in Godot called [Gravity Ace](https://gravityace.com).

Come follow me on [Twitter](https://twitter.com/yafd) and [wishlist the game on Steam](https://store.steampowered.com/app/1003860/Gravity_Ace/) and [itch.io](https://jotson.itch.io/gravity)!
