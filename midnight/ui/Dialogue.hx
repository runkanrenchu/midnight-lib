package midnight.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.typeLimit.OneOfThree;
import openfl.Assets;
import openfl.media.Sound;

/**
	SIMPLE: A box with only a typed text, no portrait, no names.
	WITH_NAME: An additional box to show text, to indicate who's speaking.
	SIMPLE_PORTRAIT: Simple box, which includes a portrait that can be flipped around based on who is speaking.
	NAME_PORTRAIT; has both a name AND a portrait.
**/
enum BoxType
{
	SIMPLE;
	WITH_NAME;
	SIMPLE_PORTRAIT;
	NAME_PORTRAIT;
	NO_BOX;
}

class Dialogue extends FlxTypedGroup<FlxSprite>
{
	var typeText:FlxTypeText;
	var myText:Array<String>;
	var finishFlag:Bool = false;
	var textAmount:Int = 0;
	var type:String;
	var portrait:FlxSprite;
	var frameInd:Int;
	var nextSound:FlxSound;
	var path:String;
	var name:String;
	var style:BoxType;

	// useful for handling events outside of this class
	public var textIndex:Int = 0;
	public var box:FlxSprite;
	public var textIsTyping:Bool = false;

	/**
		Creates a simple dialogue box.

		@param x 
		@param y
		@param style Defines which type of dialogue box will be created out of 4 available options.
		@param path Contains the path to the text file where the text is retrieved from.
		@param name If the box type includes a name box, then provide a name for it. Else, don't.

	**/
	override public function new(x:Float, y:Float, _style:BoxType, ?_path:String, ?_name:String)
	{
		super();
		style = _style;

		path = _path;
		name = _name;
		box = new FlxSprite(0, 0).makeGraphic(FlxG.width, 200, FlxColor.BLACK);
		box.y = FlxG.height - box.height - 50;

		myText = getText();
		typeText = new FlxTypeText(box.y - 50, box.x + 20, FlxG.width - 40, myText[0], 16);

		typeText.showCursor = true;
		typeText.useDefaultSound = true;
		typeText.alignment = CENTER;
		nextSound = new FlxSound().loadEmbedded(#if web "assets/sounds/select.mp3" #else "assets/sounds/select.ogg" #end);

		switch (style)
		{
			case SIMPLE:
				createSimple();
			case WITH_NAME:
				createName();
			case SIMPLE_PORTRAIT:
				createPortrait();
			case NAME_PORTRAIT:
				createNamePortrait();
			case NO_BOX:
				createNoBox();
		}
	}

	function getText():Array<String>
	{
		var text = Assets.getText(path);
		var fixedText = StringTools.replace(text, '\\n', '\n');

		var dialogArr = fixedText.split("--");
		var textArr = [""];

		for (i in dialogArr)
		{
			textArr.push(i);
			textAmount++;
		}
		return textArr;
	}

	function createNoBox()
	{
		typeText.x = FlxG.width / 2 - typeText.fieldWidth / 2;
		typeText.y = FlxG.height / 2;
		add(typeText);
	}

	function createSimple()
	{
		add(box);
		FlxTween.tween(box, {y: box.y + 50}, 0.7, {
			ease: FlxEase.bounceInOut,
			onComplete: (_) ->
			{
				add(typeText);
			}
		});
	}

	function createName()
	{
		var nameText = new FlxText(0, 0, '$name');
		var nameBox = new FlxSprite(0, 0).makeGraphic(Std.int(nameText.fieldWidth), 25, FlxColor.GRAY);
		nameText.y = nameBox.getMidpoint().y;
		nameText.x = nameBox.getMidpoint().x;
		add(box);
		FlxTween.tween(box, {y: box.y + 25}, 0.7, {
			ease: FlxEase.bounceIn,
			onComplete: (_) ->
			{
				add(typeText);
				add(nameBox);
				add(nameText);
				typeText.start(null, false, false, null, () ->
				{
					finishFlag = true;
					textIsTyping = false;
				});
			}
		});
	}

	function createPortrait()
	{
		portrait = new FlxSprite(0, 112).loadGraphic(path + ".png");
		portrait.frames = FlxAtlasFrames.fromTexturePackerXml(path + ".png", path + ".xml");
		portrait.animation.frameIndex = 1;
	}

	function createNamePortrait() {}

	function next()
	{
		if (FlxG.keys.anyJustPressed([ENTER]) && !finishFlag)
		{
			if (textIndex >= textAmount)
				textIndex = 0;
			else
			{
				textIsTyping = true;
				textIndex++;
				typeText.resetText(myText[textIndex]);
				nextSound.play();
				typeText.start(null, false, false, null, () ->
				{
					textIsTyping = false;
					finishFlag = false;
				});
				finishFlag = true;

				// portrait.animation.frameIndex = frameInd;
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		frameInd = textIndex;
		next();
	}
}
