package GameStates
{
	import GameObjects.Player;
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class PlayState extends FlxState
	{
		public override function create():void
		{
			var temp:FlxText = new FlxText(0, 0, FlxG.width, "Hello, world!");
			
			temp.alignment = "center";
			
			var player:Player = new Player(22, 22);
			this.add(player);
			
			this.add(temp);
		}
	}
}