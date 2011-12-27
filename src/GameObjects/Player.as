package GameObjects
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		private static var PLAYER_WALK_SPEED:Number = 60;
		
		public function Player(X:Number=0, Y:Number=0)
		{
			super(X, Y, null);
			this.makeGraphic(10, 20, 0xffffffff);
			
			// Set up Drag for natural movement
			drag.x = PLAYER_WALK_SPEED * 8;
			drag.y = PLAYER_WALK_SPEED * 8;
			this.maxVelocity = new FlxPoint(PLAYER_WALK_SPEED, PLAYER_WALK_SPEED);
		}
		
		public override function update():void
		{
			// Player movement controls
			this.acceleration = new FlxPoint();
			if(FlxG.keys.DOWN || FlxG.keys.UP || FlxG.keys.LEFT || FlxG.keys.RIGHT)
			{
				if (FlxG.keys.DOWN)
					this.acceleration.y = drag.y;
				if (FlxG.keys.UP)
					this.acceleration.y = -drag.y;
				if (FlxG.keys.LEFT)
					this.acceleration.x = -drag.x;
				if (FlxG.keys.RIGHT)
					this.acceleration.x = drag.x;				
			}
			
			// Update our max-velocity to take diagonal movement into account
			if ((FlxG.keys.UP && FlxG.keys.LEFT) || (FlxG.keys.UP && FlxG.keys.RIGHT) ||
				(FlxG.keys.DOWN && FlxG.keys.LEFT) || (FlxG.keys.DOWN && FlxG.keys.RIGHT))
				this.maxVelocity = new FlxPoint(PLAYER_WALK_SPEED*Math.SQRT1_2, PLAYER_WALK_SPEED*Math.SQRT1_2);
			else
				this.maxVelocity = new FlxPoint(PLAYER_WALK_SPEED, PLAYER_WALK_SPEED);
			
			// Update our movement and enforce bounds
			super.update();
			if (this.x < 0)
				this.x = 0;
			if (this.x + this.width > FlxG.width)
				this.x = FlxG.width-this.width;
		}
	}
}