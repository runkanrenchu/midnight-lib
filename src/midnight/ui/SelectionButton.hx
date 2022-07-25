package midnight.ui;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.input.mouse.FlxMouseEventManager;
import midnight.ui.Button;

enum SelectionOptions
{
	OK;
	NO;
	YES;
	CANCEL;
}

enum Status
{
	HIGHLIGHT;
	PRESSED;
	RELEASED;
}

class SelectionButton extends Button
{
	var graphic_:FlxSprite;
	var text_:FlxText;
	var status:Status;
	var option:SelectionOptions;

	override public function new(x:Float, y:Float, _text:String, ?_graphic:FlxSprite, ?_option:SelectionOptions)
	{
		super(x, y, _text, _graphic);

		this.option = _option;
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

	override function onClick(sprite:FlxSprite)
	{
		switch (option)
		{
			case OK:
				confirm();
			case NO:
				deny();
			case YES:
				accept();
			case CANCEL:
				return;
		}
	}

	function confirm()
	{
		trace("confirmed");
	}

	function accept()
	{
		trace("accepted");
	}

	function deny()
	{
		trace("denied");
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
