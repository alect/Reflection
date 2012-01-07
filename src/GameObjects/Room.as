package GameObjects
{
	import Utils.ResourceManager;
	
	import flash.utils.Dictionary;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxTilemap;

	public class Room extends FlxGroup
	{
		private var _floorMap:FlxTilemap;

		
		// Temporary map to indicate what exits exist in this room.
		// Used after all rooms are loaded to construct the actual exit map
		private var _tempExitMap:Dictionary;
		
		// A group representing the mirrors inside this room
		private var _mirrors:FlxGroup;
		
		// The extra objects that mirrors in this room might make use of 
		private var _mirrorObjects:Array;
		
		public function Room()
		{
			super();
			_floorMap = new FlxTilemap();
			this.add(_floorMap);
			_mirrors = new FlxGroup();
			this.add(_mirrors);
			_mirrorObjects = [];
			
		}
		
		public function loadTiles(csv:String):void
		{
			_floorMap.loadMap(csv, ResourceManager.floorMapArt, 0, 0, FlxTilemap.OFF, 0, 1, 2);
		}
		
		public function addMirror(mirror:Mirror):void
		{
			mirror.createTileReflections(_floorMap);
			mirror.createMirrorObjects(_mirrorObjects);
			_mirrors.add(mirror);
		}
		
		public function addMirrorObject(object:FlxObject):void
		{
			_mirrorObjects.push(object);
		}
	}
}