package Utils
{
	import GameObjects.Mirror;
	import GameObjects.MirrorObstacle;
	import GameObjects.Room;
	import GameObjects.RoomExit;
	import GameObjects.TwoWayMirror;
	
	import flash.utils.ByteArray;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	public class RoomLoader
	{
		
		private static const FLOOR_X:int = 0;
		private static const RED_FLOOR_Y:int = 0;
		
		private static const WALL_X:int = 10;
		private static const NORMAL_WALL_Y:int = 0;
		private static const MIRROR_WALL_Y:int = 10;
		private static const GLASS_WALL_Y:int = 20;
		
		private static const MIRROR_X:int = 20;
		private static const BASIC_VERTICAL_MIRROR:int = 0;
		private static const BASIC_HORIZONTAL_MIRROR:int = 10;
		
		/**
		 * Function that takes XML data (from the OGMO editor)
		 * and turns it into a Room object that can then be linked to other rooms
		 */
		public static function loadRoom(name:String, xml:Class):Room
		{
			var rawData:ByteArray = new xml;
			var dataString:String = rawData.readUTFBytes(rawData.length);
			var xmlData:XML = new XML(dataString);
			
			var dataList:XMLList;
			var dataElement:XML;
			dataList = xmlData.grid.tile;
			
			// first, initialize our grid array which we use to create the tilemap CSV later
			var tileArray:Array = [];
			for(var i:int = 0; i < Math.floor(FlxG.width/Globals.TILE_SIZE); i++)
			{
				var column:Array = [];
				for(var j:int = 0; j < Math.floor(FlxG.height/Globals.TILE_SIZE); j++)
						column.push(0);
				tileArray.push(column);
			}
			
			var roomToReturn:Room = new Room(name);
			
			for each (dataElement in dataList)
			{
				var tileX:int = dataElement.@x / Globals.TILE_SIZE;
				var tileY:int = dataElement.@y / Globals.TILE_SIZE;
				if (dataElement.@tx == FLOOR_X && dataElement.@ty == RED_FLOOR_Y)
					tileArray[tileX][tileY] = 1;
				
				// Walls
				if (dataElement.@tx == WALL_X)
				{
					// Normal wall
					if (dataElement.@ty == NORMAL_WALL_Y)
						tileArray[tileX][tileY] = Globals.NORMAL_WALL;
					
					// Mirror wall (wall existing only in a reflection
					if (dataElement.@ty == MIRROR_WALL_Y)
						roomToReturn.addMirrorObject(new MirrorObstacle(dataElement.@x, dataElement.@y, Globals.TILE_SIZE, Globals.TILE_SIZE));
					
					// Glass wall
					if (dataElement.@ty == GLASS_WALL_Y)
						tileArray[tileX][tileY] = Globals.GLASS_WALL;
				}
				
			}
			
			// load the tilemap
			roomToReturn.loadTiles(arrayToCSV(tileArray));
			
			//now load the mirrors
			dataList = xmlData.objects.vert_mirror;
			for each (dataElement in dataList)
			{
				var vertMirror:Mirror = new TwoWayMirror(dataElement.@x, dataElement.@y, dataElement.@width, Globals.TILE_SIZE, TwoWayMirror.VERTICAL);
				roomToReturn.addMirror(vertMirror);
			}
			
			dataList = xmlData.objects.hor_mirror;
			for each (dataElement in dataList)
			{
				var horMirror:Mirror = new TwoWayMirror(dataElement.@x, dataElement.@y, Globals.TILE_SIZE, dataElement.@height, TwoWayMirror.HORIZONTAL);
				roomToReturn.addMirror(horMirror);
			}
			
			// Load the exits
			dataList = xmlData.objects.exit_right;
			for each (dataElement in dataList)
			{
				var rightExit:RoomExit = new RoomExit(dataElement.@x, dataElement.@y, Globals.TILE_SIZE, dataElement.@height, FlxObject.RIGHT);
				rightExit.destRoom = dataElement.@dest_room;
				rightExit.destExitIndex = dataElement.@dest_index;
				roomToReturn.addExit(rightExit);
			}
			
			dataList = xmlData.objects.exit_down;
			for each (dataElement in dataList)
			{
				var downExit:RoomExit = new RoomExit(dataElement.@x, dataElement.@y, dataElement.@width, Globals.TILE_SIZE, FlxObject.DOWN);
				downExit.destRoom = dataElement.@dest_room;
				downExit.destExitIndex = dataElement.@dest_index;
				roomToReturn.addExit(downExit);
			}
			
			dataList = xmlData.objects.exit_left;
			for each (dataElement in dataList)
			{
				var leftExit:RoomExit = new RoomExit(dataElement.@x, dataElement.@y, Globals.TILE_SIZE, dataElement.@height, FlxObject.LEFT);
				leftExit.destRoom = dataElement.@dest_room;
				leftExit.destExitIndex = dataElement.@dest_index;
				roomToReturn.addExit(leftExit);
			}
			
			dataList = xmlData.objects.exit_up;
			for each (dataElement in dataList)
			{
				var upExit:RoomExit = new RoomExit(dataElement.@x, dataElement.@y, dataElement.@width, Globals.TILE_SIZE, FlxObject.UP);
				upExit.destRoom = dataElement.@dest_room;
				upExit.destExitIndex = dataElement.@dest_index;
				roomToReturn.addExit(upExit);
			}
			
			return roomToReturn;
			
		}
		
		private static function arrayToCSV(array:Array):String
		{
			var csv:String = "";
			// Need to scan through row by row
			for(var j:int = 0; j < array[0].length; j++)
			{
				for(var i:int = 0; i < array.length; i++)
				{
					csv += (array[i][j] as int).toString() + ((i < array.length-1) ? ",":"\n");
				}
			}
			return csv;
		}
		
	}
}