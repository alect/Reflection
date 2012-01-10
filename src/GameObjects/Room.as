package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.ResourceManager;
	
	import flash.utils.Dictionary;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxTilemap;
	
	public class Room extends FlxGroup
	{
		private var _floorMap:FlxTilemap;

		
		// Temporary map to indicate what exits exist in this room.
		// Used after all rooms are loaded to construct the actual exit map
		private var _tempExitMap:Dictionary;
		
		
		// The extra objects that mirrors in this room might make use of 
		private var _mirrorObjects:Array;
		
		// The list of exits this room contains
		private var _exits:Array;
		
		// The name identifying this room
		private var _name:String;
		
		// Rooms have position in the world so we can have a nice contiguous adventure
		// Zelda style. Note, position needs to be used with great caution as FlxGroups
		// don't naturally support position. Position should only ever be changed with
		// setRoomPosition()
		private var _x:Number=0, _y:Number=0;
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		// Needed by switchRooms to position rooms properly with their neighbors
		public function get exits():Array
		{
			return _exits;
		}
		
		public function Room(name:String)
		{
			super();
			_floorMap = new FlxTilemap();
			this.add(_floorMap);
			_mirrorObjects = [];
			_exits = [];
			_name = name;
		}
		
		public function loadTiles(csv:String):void
		{
			_floorMap.loadMap(csv, ResourceManager.floorMapArt, 0, 0, FlxTilemap.OFF, 0, 1, 2);
		}
		
		public function addMirror(mirror:Mirror):void
		{
			mirror.createTileReflections(_floorMap);
			mirror.createMirrorObjects(_mirrorObjects);
			this.add(mirror);
		}
		
		public function addMirrorObject(object:FlxObject):void
		{
			_mirrorObjects.push(object);
		}
		
		public function addExit(exit:RoomExit):void
		{
			exit.preUpdate();
			_exits.push(exit);
		}
		
		/**
		 * When switching rooms, we want the camera to focus on the new room 
		 * as if it were located at the center of the screen. Therefore, we need
		 * to provide a target for the camera to focus on 
		 */
		public function get cameraTarget():FlxObject
		{
			return new FlxObject(_x, _y, FlxG.width, FlxG.height);
		}
		
		/**
		 * Function for altering this room's position. Needs to be used carefully
		 * as the room has to update the position of all of its members correspondingly
		 */
		public function setRoomPosition(X:Number, Y:Number):void
		{
			// need to update the values of all of our members
			for each (var object:FlxObject in this.members)
			{
				// The ratio needs to be the same 
				// object.x - _x == object.newX - x
				// object.newX = object.x - _x + x
				if (object is Mirror)
				{
					(object as Mirror).setPosition(object.x - _x + X, object.y - _y + Y);
				}
				else
				{
					object.x = object.x - _x + X;
					object.y = object.y - _y + Y;
				}
			}
			for each (var exit:RoomExit in _exits)
			{
				exit.x = exit.x - _x + X;
				exit.y = exit.y - _y + Y;
			}
			
			_x = X;
			_y = Y;
		}
		
		public override function update():void
		{
			super.update();
			
			// See if the player is attempting to leave the room. 
			for each(var exit:RoomExit in _exits)
			{
				if(exit.playerExiting(PlayState.player))
					PlayState.instance.switchRooms(exit);
			}
		}
	}
}