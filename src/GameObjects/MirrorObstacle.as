package GameObjects
{
	import org.flixel.FlxObject;
	
	/**
	 * Very simple class used to identify an object as an additional obstacle
	 * that only exists in the mirror world
	 */
	public class MirrorObstacle extends FlxObject
	{
		public function MirrorObstacle(X:Number=0, Y:Number=0, Width:Number=0, Height:Number=0)
		{
			super(X, Y, Width, Height);
		}
	}
}