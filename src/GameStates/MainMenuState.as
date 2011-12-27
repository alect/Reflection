package GameStates
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class MainMenuState extends FlxState
	{
		public override function create():void
		{
			var title:FlxText = new FlxText(0, 100, FlxG.width, "Reflection");
			title.size = 16;
			title.alignment = "center";
			
			var titleReflection:FlxText = new FlxText(0, title.y+title.height*1.5, FlxG.width, "Reflection");
			titleReflection.size = 16;
			titleReflection.alignment = "center";
			titleReflection.scale = new FlxPoint(1, -1);
			
			this.add(title);
			this.add(titleReflection);
			
			var enter:FlxText = new FlxText(0, titleReflection.y+titleReflection.height+50, FlxG.width, "Press Enter to Start");
			enter.alignment = "center";
			this.add(enter);
		}
			
		public override function update():void
		{
			if(FlxG.keys.justPressed("ENTER"))
				FlxG.switchState(new PlayState());
		}
	}
}