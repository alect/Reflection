package Utils
{
	import org.flixel.FlxObject;
	
	/** 
	 * A FlxGroup Class that properly extends FlxObject so it can follow paths and 
	 * move as if it were an object (which all of its objects moving along with it
	 */
	public class FlxObjectGroup extends FlxObject
	{
		public function FlxObjectGroup(X:Number=0, Y:Number=0, Width:Number=0, Height:Number=0)
		{
			super(X, Y, Width, Height);
		}
	}
}