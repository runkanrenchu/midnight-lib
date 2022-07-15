# Midnight Lib

- Midnight is a helper Haxelib for my personal projects. It contains weird code and isn't meant to be used by anyone but me, BSOD, the most casual computer user in the world.

I made it so that I could stop copy-pasting old code into new projects and having to modify it every time. It provides out-of-the-box functionality for some things such as player movement and dialogue systems. It comes in VERY handy, specially with Haxejam 2022 around!


It is built ontop of Flixel (thus ontop of OpenFL and Lime) and it's an alternative to some of its methods. I will attempt to use raw openFL for it so that I can make it lighter and update its dependencies. But that's gonna take a long LONG time.

Taking advantage of Flixel's input system and event handlers, I made my own version of some of its utils, such as:

- **Button**: A simple button that calls a function when clicked. It uses Flixel's `FlxMouseEventManager`.

- **SelectionButton**: An extension of `Button` that contains utils for a specific type of button where the only possible options are "OK", "CANCEL", "DENY", "CONFIRM". (WIP)

- **Entity**: A basic entity based on FlxSprite with built-in movement and animations, for DIFFERENT types of entities, so far Enemies and Players. No more `Player.hx.` Ever. (WIP)

- **Dialogue**: A textbox which displays a character's name and a custom text, changes when you press enter. Different types of textboxes will be available in the future. **BIG thanks to ninjamuffin99 for the permission to use the dialogue skipping [sound](https://github.com/ninjamuffin99/Funkin/blob/master/assets/shared/sounds/clickText.mp3).** (NOT READY for per-project use yet!)

## If I didn't make it clear enough:

This is a personal helper lib. It is not optimised to be useful in any other projects. It is made to suit my needs without overcomplication, and thus might result buggy and even useless in other projects that aren't as messy and horribly designed as mine.

You can probably tell I don't trust myself with my projects at all. If _for some reason_ you use this library, and find a bug, you can DM me: `BSOD#2524`.