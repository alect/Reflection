package
{
	import flash.display.Sprite;
	import GameStates.MainMenuState;
	
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	
	
	public class Reflection extends FlxGame
	{
		public function Reflection()
		{
			super(320, 240, MainMenuState, 2);
		}
	}
}