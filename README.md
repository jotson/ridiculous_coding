# Ridiculous Coding Addon for Godot 4.X Cuppixx Version

Original version written by John Watson.

New, improved and **extended** version by Cuppixx.

## What does it do?

It makes your coding experience in Godot 1000x more ridiculous.

![Ridiculous](readme-example.gif)

The original addon was inspired by [Textreme2 by Ash K](https://ash-k.itch.io/textreme-2). Consider checking it out!

### Changes, Bugfixes and More

As this is a fork of the original addon by John Watson, the general idea and structure remain the same.
Should you encounter any problems (I hope you won't) while using my version of the addon please do not bother the original author as it is most likely an issue caused by me.

#### What I fixed:
- **Saving works now properly over new / multiple sessions**
- Characters / Keys now animate even with the boom and / or blip settings toggled off
- Fixed some node errors (most likely caused by porting to godot 4)
- Experience is now counted properly after a reload / restart
- More stable in my testing

#### What I changed:
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

#### TODO / What I want to do:
- Settings to configure VFX color schemes
- Settings to adjust VFX positions
- Implement an optional custom background feature

Besides the obvious fix and some new features my version of the addon aims to be overall less 'in your face'. **This is my personal taste**. Feel free to revert any changes back to a more 'in your face' type of style.

**A huge thanks** to John Watson for creating such an amazing addon / plugin :D !!!!!!!

## Installation

### AssetLib

1. Open your Godot Engine 4.X
2. Open the AssetLib
3. Search for 'Ridiculous' (that should bring up the addon)
4. Download and Install either my addon or the original
6. From the `res://` directory delete or move the addons LICENSE.md to a designated folder
7. Enable the plugin in `Project Settings | Plugins`

### Manual

1. Download the addon as a zip file
2. Create an `addons` directory in your Godot project
3. Create an `ridiculous_coding` directory inside `addons`
4. Copy all of the files from the zip (`addons/ridiculous_coding`) there
5. Enable the plugin in `Project Settings | Plugins`

**IMPORTANT:** You might need to close and open your editor to start seeing anything working. I don't know why!

Your Godot directory structure should look like this:

```
res://
	addons
		ridiculous_coding
			...all the ridiculous coding files...
```

![Enable plugin](readme-enable.png)

## About me

### John Watson

Hey, I'm John and I'm making a game in Godot called [Gravity Ace](https://gravityace.com).

Come follow me on [Twitter](https://twitter.com/yafd) and [wishlist the game on Steam](https://store.steampowered.com/app/1003860/Gravity_Ace/) and [itch.io](https://jotson.itch.io/gravity)!

### Cuppixx

Hey, my name is Cuppixx (not really) and I like to do game dev stuff. This is my first serious project and I'm excited that so many people have already checked out this repo.

Currently I have no (active) social media!

## All the links

### Cuppixx

[RidiculousCoding](https://github.com/Cuppixx/RidiculousCodingCuppixxVersion/tree/develop)

### John Watson

[Twitter](https://twitter.com/yafd) 

[Gravity Ace](https://gravityace.com)

[Gravity Ace on Steam](https://store.steampowered.com/app/1003860/Gravity_Ace/)

[Gravity Ace on itch.io](https://jotson.itch.io/gravity)!

### Resources and Inspiration 

[Textreme2 by Ash K](https://ash-k.itch.io/textreme-2)

[RidiculousCoding by Jotson](https://github.com/jotson/ridiculous_coding/tree/godot4)

[EditorImagePlugin2 by newjoker6](https://github.com/newjoker6/Editor-Image-Plugin-2)

[EditorBackground by Nukiloco](https://github.com/Nukiloco/editor_background)
