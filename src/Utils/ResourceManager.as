package Utils
{
	import flash.utils.Dictionary;

	public class ResourceManager
	{
		// Art
		
		[Embed(source="Assets/Art/temptiles.png")]
		public static var floorMapArt:Class;
		
		[Embed(source="Assets/Art/playertiles-1.png")]
		public static var playerArt:Class;
		
		[Embed(source="Assets/Art/mirrortile-1.png")]
		public static var mirrorArt:Class;
		
		
		// Rooms
		[Embed(source="Assets/Rooms/testRoom3.oel", mimeType="application/octet-stream")]
		public static var testRoom:Class;
		
		[Embed(source="Assets/Rooms/testRoom4.oel", mimeType="application/octet-stream")]
		public static var testRoom2:Class;
		
		// The table matching room names to room data
		public static var roomTable:Dictionary = new Dictionary();
		roomTable["testRoom3"] = testRoom;
		roomTable["testRoom4"] = testRoom2;
	}
}