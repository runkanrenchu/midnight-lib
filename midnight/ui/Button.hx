package midnight.ui;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEventManager;

class Button extends FlxTypedGroup<FlxSprite>
{
	var graphic:FlxSprite;
	var text:FlxText;
	var offset:FlxPoint;
	var callback:FlxSprite->Void;

	override public function new(x:Float, y:Float, _text:String, ?_graphic:FlxSprite, ?_callback:FlxSprite->Void)
	{
		super();

		if (callback != null)
			this.callback = _callback;
		else
			callback = (sprite) -> {};

		// text pos: graphic.width / 2 - text.fieldWidth /2
		if (_graphic == null)
		{
			#if !is_placeholder
			graphic = new FlxSliceSprite("assets/images/defaultbutton.png", new FlxRect(5, 5, 115 - 10, 30 - 10), 200, 155);
			#else
			graphic = new FlxSprite(0, 0).loadGraphic("assets/images/defaultbutton.png");
			this.add(graphic);
			#end
		}
		else
			this.graphic = _graphic;

		text = new FlxText(0, 0, 0, _text);
		text.x = graphic.width / 2 - text.fieldWidth / 2;
		text.y = graphic.height / 2 - text.height / 2;

		var objArr = [text, graphic];
		for (i in objArr)
			add(i);

		FlxMouseEventManager.add(graphic, onClick, onRelease, onMouseOver, onMouseOut);
	}

	function onClick(sprite:FlxSprite)
	{
		callback(sprite);
	}

	function onRelease(sprite:FlxSprite)
	{
		this.graphic.color = FlxColor.WHITE;
	}

	function onMouseOver(sprite:FlxSprite)
	{
		this.graphic.color = FlxColor.fromString("0xFFC5C5C5");
	}

	function onMouseOut(sprite:FlxSprite)
	{
		onRelease(sprite);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
