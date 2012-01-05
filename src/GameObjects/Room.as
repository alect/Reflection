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

		private var _testMap:String = 
				"1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1\n" +
				"1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1\n" +
				"1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1\n" + 
				"1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1\n" + 
				"1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1\n" +
				"1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1\n" +
				"1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1\n" + 
				"1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1\n";
		
		// Temporary map to indicate what exits exist in this room.
		// Used after all rooms are loaded to construct the actual exit map
		private var _tempExitMap:Dictionary;
		
		// A group representing the mirrors inside this room
		private var _mirrors:FlxGroup;
		
		public function Room()
		{
			super();
			_floorMap = new FlxTilemap();
			_floorMap.loadMap(_testMap, ResourceManager.floorMapArt, 0, 0, FlxTilemap.OFF, 0, 0);
			trace("floor width: " + (_floorMap.x+_floorMap.width).toString());
			this.add(_floorMap);
			_mirrors = new FlxGroup();
			// Let's test out some mirrors
			var testMirror:Mirror = new Mirror(80, 10, 10, 30, FlxObject.RIGHT);
			testMirror.createTileReflections(_floorMap);
			_mirrors.add(testMirror);
			
			var testMirror2:Mirror = new Mirror(40, 40, 40, 10, FlxObject.DOWN);
			testMirror2.createTileReflections(_floorMap);
			_mirrors.add(testMirror2);
			
			var testMirror3:Mirror = new Mirror(40, 40, 40, 10, FlxObject.UP);
			testMirror3.createTileReflections(_floorMap);
			_mirrors.add(testMirror3);
			
			var testMirror4:Mirror = new Mirror(80, 10, 10, 30, FlxObject.LEFT);
			testMirror4.createTileReflections(_floorMap);
			_mirrors.add(testMirror4);
			
			this.add(_mirrors);
		}
	}
}