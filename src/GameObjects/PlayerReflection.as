package GameObjects
{
	import flash.geom.Rectangle;
	
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	
	/**
	 * Class representing a reflection of the player. 
	 * Has a few extensions to allow for the rendered frame to be clipped depending on 
	 * where the reflection is
	 */
	public class PlayerReflection extends FlxSprite
	{
		
		public function PlayerReflection(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
		}
		
		public function updateClippingInfo(rect:FlxRect):void
		{
			// Clear from the left if we need to 
			if(x < rect.x)
				framePixels.fillRect(new Rectangle(0, 0, rect.x-x, frameHeight), 0x00000000);
			
			if(y < rect.y)
				framePixels.fillRect(new Rectangle(0, 0, frameWidth, rect.y-y), 0x00000000);
			
			if(x+width > rect.x+rect.width)
				framePixels.fillRect(new Rectangle(frameWidth-(x+width-(rect.x+rect.width)), 0, x+width-(rect.x+rect.width), frameHeight), 0x00000000);
			
			if(y+height > rect.y+rect.height)
				framePixels.fillRect(new Rectangle(0, frameHeight-(y+height-(rect.y+rect.height)), frameWidth, y+height-(rect.y+rect.height)), 0x00000000);
			
			
		}
	}
}