package components;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

enum Style
{
	TOPDOWN;
	PLATFORMER;
}

enum FramesFormat
{
	SPARROW;
	TEXPACKER;
}

class Entity extends FlxSprite
{
	var _path:String;
	var style:Style;
	var speed:Float = 200;
	var _graphicLoaded:Bool = false;
	var updatingMovement:Bool = false;

	override public function new(X:Float, Y:Float, style:Style)
	{
		super(X, Y);

		this.style = style;
	}

	/**
		* Automatically loads a spritesheet into the entity and adds animations to it. Default added nimations are `walk`, `jump`, and in case the STYLE is TOPDOWN, `behind` and `forwards` animations.
		*
		* WARNING: Works with TexPacker's XML format by default. This can be overriden, though.
		*
		* WARNING: If a graphic was loaded in using `spawnBasic()`, it will be overriden.

		@param format This specifies the format of the spritesheet (Sparrow V2, Texture Packer XML)

		@param path The path where the required files are located. For either format, this path must include both the .png and .xml files corresponding. Don't worry about adding the extension; we can handle that.

		@param doLoadDefaults Whether to load default animations (walk, jump, behind and forwards)

	**/
	public function loadAnimations(format:String, path:String, doLoadDefaults:Bool = true)
	{
		// wip
	}

	/**
		* Spawns a new basic entity with basic movement (based on STYLE). Can provide a graphic for the entity.

		@param isPlayer Whether the entity is supposed to be the player or not. If it's `true`, the movement keys will be the arrow keys, and the default graphic will be blue. Else, the movement keys default to WASD, and the graphic will be red.

		@param path Optional path, must contain an image that will be loaded into the sprite.

	**/
	public function spawnBasic(isPlayer:Bool = false, ?path:String):Entity
	{
		if (path != null)
		{
			loadGraphic(path);
			_graphicLoaded = true;
		}
		else
		{
			if (isPlayer)
				makeGraphic(16, 16, FlxColor.BLUE);
			else
				makeGraphic(16, 16, FlxColor.RED);
		}

		updatingMovement = true;

		return this;
	}

	function movement()
	{
		var left = FlxG.keys.anyPressed([LEFT]);
		var right = FlxG.keys.anyPressed([RIGHT]);

		this.drag.x = this.drag.y = 1200;

		if (left && right)
			left = right = false;
		if (style == TOPDOWN)
		{
			var up = FlxG.keys.anyPressed([UP]);
			var down = FlxG.keys.anyPressed([DOWN]);
			if (left)
				this.velocity.x = -(speed);
			else if (right)
				this.velocity.x = speed;
			else if (up)
				this.velocity.y = -speed;
			else if (down)
				this.velocity.y = speed;
			else
				this.velocity.x = this.velocity.y = 0;
		}
		else
		{
			this.acceleration.y = 1500;

			var jump = FlxG.keys.anyJustPressed([UP, SPACE]);

			if (left)
				this.velocity.x = -(speed + 100);
			else if (right)
				this.velocity.x = speed + 100;
			else
				this.velocity.x = 0;

			if (jump && isTouching(FLOOR))
			{
				this.velocity.y = -(speed + 200);
			}
		}
	}

	override public function update(elapsed:Float)
	{
		if (updatingMovement)
			movement();
		super.update(elapsed);
	}
}
