package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import openfl.Assets;
import openfl.media.Sound;

class Dialogue extends FlxTypedGroup<FlxSprite>
{
	var typeText:FlxTypeText;
	var myText:Array<String>;
	var finishFlag:Bool = false;
	var textIndex:Int = 0;
	var textAmount:Int = 0;
	var type:String;
	var box:FlxSprite;
	var portrait:FlxSprite;
	var frameInd:Int;
	var nextSound:FlxSound;

	/**
		NOT READY TO BE USED
	**/
	override public function new(x:Float, y:Float, path:String)
	{
		super();
		myText = getText();
		typeText = new FlxTypeText(20, 540, 0, myText[0], 16);
		typeText.color = 0x000000;
		typeText.showCursor = true;
		typeText.useDefaultSound = true;
		typeText.alignment = CENTER;

		portrait = new FlxSprite(0, 112).loadGraphic(path + ".png");
		portrait.frames = FlxAtlasFrames.fromTexturePackerXml(path + ".png", path + ".xml");
		portrait.animation.frameIndex = 1;

		box = new FlxSprite(0, 0).makeGraphic(FlxG.width, 200, if (type == "tankman") FlxColor.WHITE else FlxColor.GRAY);
		box.y = FlxG.height - box.height;

		nextSound = new FlxSound().loadEmbedded(#if web "assets/sounds/select.mp3" #else "assets/sounds/select.ogg" #end);
		add(portrait);
		add(box);
		add(typeText);

		typeText.start(null, false, false, null, () -> finishFlag = true);
	}

	function getText():Array<String>
	{
		var text = Assets.getText("assets/data/" + type + ".txt");
		var dialogArr = text.split("--");
		var textArr = [""];

		for (i in dialogArr)
		{
			textArr.push(i);
			textAmount++;
		}
		return textArr;
	}

	function next()
	{
		if (FlxG.keys.anyJustPressed([ENTER]) && finishFlag)
		{
			trace("enter pressed");
			if (textIndex >= textAmount)
				textIndex = 0;
			else
			{
				textIndex++;
				typeText.resetText(myText[textIndex]);
				nextSound.play();
				typeText.start(null, false, false, null, () -> finishFlag = true);
				finishFlag = false;
				portrait.animation.frameIndex = frameInd;
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
