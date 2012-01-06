package Utils
{
	import GameObjects.Mirror;
	import GameObjects.Room;
	import GameObjects.TwoWayMirror;
	
	import flash.utils.ByteArray;
	
	import org.flixel.FlxG;
	
	public class RoomLoader
	{
		
		private static const FLOOR_X:int = 0;
		private static const RED_FLOOR_Y:int = 0;
		
		private static const WALL_X:int = 10;
		private static const GREY_WALL_Y:int = 0;
		
		private static const MIRROR_X:int = 20;
		private static const BASIC_VERTICAL_MIRROR:int = 0;
		private static const BASIC_HORIZONTAL_MIRROR:int = 10;
		
		/**
		 * Function that takes XML data (from the OGMO editor)
		 * and turns it into a Room object that can then be linked to other rooms
		 */
		public static function loadRoom(xml:Class):Room
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
			
			var roomToReturn:Room = new Room();
			
			for each (dataElement in dataList)
			{
				var tileX:int = dataElement.@x / Globals.TILE_SIZE;
				var tileY:int = dataElement.@y / Globals.TILE_SIZE;
				if (dataElement.@tx == FLOOR_X && dataElement.@ty == RED_FLOOR_Y)
					tileArray[tileX][tileY] = 1;
				
				if (dataElement.@tx == WALL_X && dataElement.@ty == GREY_WALL_Y)
					tileArray[tileX][tileY] = 2; // Place a wall
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