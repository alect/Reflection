package GameStates
{
	import GameObjects.Player;
	import GameObjects.Room;
	import GameObjects.RoomExit;
	
	import Utils.Globals;
	import Utils.ResourceManager;
	import Utils.RoomLoader;
	
	import flash.utils.Dictionary;
	
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	
	public class PlayState extends FlxState
	{
		
		
		private static var _player:Player;

		private static var _currentRoom:Room = null;
		// A table of the rooms neighboring the current one so we can display them
		// (but not update them). Maps the room name to a loaded room object
		private static var _neighboringRooms:Dictionary = new Dictionary();
		// The next room to be the current room. Only non-null when switching rooms
		private static var _nextRoom:Room = null;
		// Similar for the next room, keep a dictionary of the next neighboring rooms
		private static var _nextNeighbors:Dictionary = new Dictionary();
		
		// whether we're currently waiting for the screen to transition to the next room
		private static var _roomTransition:Boolean = false;
		
		
		// Use the singleton pattern to control this state
		private static var _instance:PlayState;
		
		public static function get instance():PlayState
		{
			return _instance;
		}
		
		public static function get player():Player
		{
			return _player;
		}
		
		
		
		public override function create():void
		{
			
			_currentRoom = RoomLoader.loadRoom("testRoom3", ResourceManager.testRoom);
			// Load and position all of our exits
			for each(var exit:RoomExit in _currentRoom.exits)
			{
				var neighbor:Room;
				neighbor = RoomLoader.loadRoom(exit.destRoom, ResourceManager.roomTable[exit.destRoom]);
					// Make sure the neighboring rooms aren't active
					// Properly position the neighboring rooms so their exit positions correspond with ours
				var neighborExit:RoomExit = neighbor.exits[exit.destExitIndex];
				neighbor.setRoomPosition(exit.x-(neighborExit.x-neighbor.x), exit.y-(neighborExit.y-neighbor.y));
				
				_neighboringRooms[exit.destRoom] = neighbor;
				neighbor.active = false;
				if (this.members.indexOf(neighbor) == -1)
					this.add(neighbor);
			}
			
			this.add(_currentRoom);
			
			_player = new Player(FlxG.width/2, FlxG.height/2-40);
			this.add(_player);
			
			_instance = this;
		
		}
		
		public override function update():void
		{
			FlxG.collide(_currentRoom, _player);
			super.update();
		
			if(_roomTransition && FlxG.camera.target.pathSpeed == 0)
			{
				// Just assume the camera works for now
				// Remove any of the old rooms that are no longer relevant
				if (_nextNeighbors[_currentRoom.name] == null && _nextRoom != _currentRoom)
					this.remove(_currentRoom);
				for each (var oldNeighbor:Room in _neighboringRooms)
				{
					if (_nextNeighbors[oldNeighbor.name] == null && _nextRoom != oldNeighbor)
						this.remove(oldNeighbor, true);
				}
				
				
				_currentRoom = _nextRoom;
				_nextRoom = null;
				_neighboringRooms = _nextNeighbors;
				_nextNeighbors = new Dictionary();
				
				// Reactivate everything
				_currentRoom.active = true;
				_player.active = true;
				
				_roomTransition = false;
				trace("camera target: " + FlxG.camera.target.x);
				FlxG.camera.setBounds(_currentRoom.cameraTarget.x, _currentRoom.cameraTarget.y, FlxG.width, FlxG.height, true);

				
			}
			else if(_roomTransition &&  FlxG.camera.target.pathSpeed != 0)
			{
				//FlxG.camera.target.velocity = new FlxPoint();
				FlxG.camera.target.preUpdate();
				FlxG.camera.target.update();
				FlxG.camera.target.postUpdate();
			}
		}
		
		public function switchRooms(sourceExit:RoomExit):void
		{
			// First, deactivate the player so we don't scew things up with the transition
			_player.active = false;
			// Next, deactivate the current room for the same reason (it should be deactivated eventually anyways)
			if (_currentRoom != null)
				_currentRoom.active = false;
			
			
			// First, if the room we're switching to is in the neighboring rooms
			// (which it really should be in most cases), then we don't need to load it
			if (_neighboringRooms[sourceExit.destRoom] != null)
				_nextRoom = _neighboringRooms[sourceExit.destRoom];
			else
			{
				_nextRoom = RoomLoader.loadRoom(sourceExit.destRoom, ResourceManager.roomTable[sourceExit.destRoom]);
				// This room now needs to be positioned properly wrt to the current room
				var destExit:RoomExit = _nextRoom.exits[sourceExit.destExitIndex];
				_nextRoom.setRoomPosition(sourceExit.x-(destExit.x-_nextRoom.x), sourceExit.y-(destExit.y-_nextRoom.y));
			}
			
			_nextRoom.active = false;
			if (this.members.indexOf(_nextRoom) == -1)
				this.add(_nextRoom);
			
			// Now for the actual switch. Need to swap the current room with the dest room, 
			// and update the list of neighboring rooms while only loading when necessary. 
			_nextNeighbors = new Dictionary();
			for each(var exit:RoomExit in _nextRoom.exits)
			{
				var neighbor:Room;
				if (_currentRoom != null && _currentRoom.name == exit.destRoom)
					neighbor = _currentRoom;
				else if(_neighboringRooms[exit.destRoom] != null)
					neighbor = _neighboringRooms[exit.destRoom];
				// If a neighbor is not yet loaded, need to load it
				else
				{
					neighbor = RoomLoader.loadRoom(exit.destRoom, ResourceManager.roomTable[exit.destRoom]);
					// Make sure the neighboring rooms aren't active
					// Properly position the neighboring rooms so their exit positions correspond with ours
					var neighborExit:RoomExit = neighbor.exits[exit.destExitIndex];
					neighbor.setRoomPosition(exit.x-(neighborExit.x-neighbor.x), exit.y-(neighborExit.y-neighbor.y));
				}
				
				_nextNeighbors[exit.destRoom] = neighbor;
				neighbor.active = false;
				if (this.members.indexOf(neighbor) == -1)
					this.add(neighbor);
			}
			
			if(_currentRoom != null)
			{
				var cameraTarget:FlxObject = _currentRoom.cameraTarget;
				var nextCameraTarget:FlxObject = _nextRoom.cameraTarget;
				var cameraPath:FlxPath = new FlxPath([nextCameraTarget.getMidpoint()]);
				cameraTarget.followPath(cameraPath, Globals.CAMERA_SWITCH_SPEED);
			
			
				FlxG.camera.follow(cameraTarget, FlxCamera.STYLE_LOCKON);
				FlxG.camera.setBounds(Math.min(cameraTarget.x, nextCameraTarget.x), Math.min(cameraTarget.y, nextCameraTarget.y), cameraTarget.width+nextCameraTarget.width, cameraTarget.height+nextCameraTarget.height);
			}
			_roomTransition = true;
			
			
			// a little magic to make sure the player is always rendered on top.
			this.remove(_player, true);
			this.add(_player);	
			
		}
		
		
	}
}