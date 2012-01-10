package GameObjects
{
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	
	/**
	 * Simple Class that represents the exit to a room
	 * Maintains a string pointer to the room it exits to
	 * along with an index pointer indicating which exit it corresponds to in the 
	 * destination room
	 */ 
	public class RoomExit extends FlxObject
	{
		private var _destRoom:String;
		private var _destExitIndex:int;
		// The direction of the exit.
		// Takes on the values defined in FlxObject (UP, LEFT, DOWN, RIGHT)
		private var _facing:uint;
		
		// Accessors and mutators
		public function get destRoom():String
		{
			return _destRoom;
		}
		
		public function set destRoom(value:String):void
		{
			_destRoom = value;
		}
		
		public function get destExitIndex():int
		{
			return _destExitIndex;
		}
		
		public function set destExitIndex(value:int):void
		{
			_destExitIndex = value;
		}
		
		
		public function RoomExit(X:Number=0, Y:Number=0, Width:Number=0, Height:Number=0, Facing:uint=LEFT)
		{
			super(X, Y, Width, Height);
			_facing = Facing;
		}
		
		// Function to test if the player is currently attempting to use this exit
		public function playerExiting(player:Player):Boolean
		{
			if (!player.overlaps(this))
				return false;
			
			// Different rules for different directions
			switch(_facing)
			{
				case UP:
					return (player.y <= this.y && FlxG.keys.UP);
				case LEFT:
					return (player.x <= this.x && FlxG.keys.LEFT);
				case DOWN:
					return (player.y+player.height >= this.y+this.height && FlxG.keys.DOWN);
				case RIGHT:
					return (player.x+player.width >= this.x+this.width && FlxG.keys.RIGHT);
				default:
					return false;
			}
		}
	}
}