package GameObjects
{
	import Utils.ResourceManager;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		private static const PLAYER_WALK_HOR_SPEED:Number = 60;
		private static const PLAYER_WALK_VERT_SPEED:Number = 50;
		
		
		public function Player(X:Number=0, Y:Number=0)
		{
			super(X, Y, null);
			this.loadGraphic(ResourceManager.playerArt, true, true, 8, 15);
			this.addAnimation("idle", [0]);
			this.addAnimation("walk", [1, 2], 10, true);
			this.play("idle");
			
			// Set up Drag for natural movement
			drag.x = PLAYER_WALK_HOR_SPEED * 8;
			drag.y = PLAYER_WALK_VERT_SPEED * 8;
			this.maxVelocity = new FlxPoint(PLAYER_WALK_HOR_SPEED, PLAYER_WALK_VERT_SPEED);
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
				if (FlxG.keys.LEFT) {
					this.acceleration.x = -drag.x;
					this.facing = LEFT;
				}
				if (FlxG.keys.RIGHT) {
					this.acceleration.x = drag.x;	
					this.facing = RIGHT;
				}
				this.play("walk");
			}
			else
				this.play("idle");
			
			// Update our max-velocity to take diagonal movement into account
			if ((FlxG.keys.UP && FlxG.keys.LEFT) || (FlxG.keys.UP && FlxG.keys.RIGHT) ||
				(FlxG.keys.DOWN && FlxG.keys.LEFT) || (FlxG.keys.DOWN && FlxG.keys.RIGHT))
				this.maxVelocity = new FlxPoint(PLAYER_WALK_HOR_SPEED*Math.SQRT1_2, PLAYER_WALK_HOR_SPEED*Math.SQRT1_2);
			else
				this.maxVelocity = new FlxPoint(PLAYER_WALK_HOR_SPEED, PLAYER_WALK_VERT_SPEED);
			
			// Update our movement and enforce bounds
			super.update();
			if (this.x < 0)
				this.x = 0;
			if (this.x + this.width > FlxG.width)
				this.x = FlxG.width-this.width;
			if (this.y < 0)
				this.y = 0;
			if (this.y + this.height > FlxG.height)
				this.y = FlxG.height - this.height;
		}
		
	}
}