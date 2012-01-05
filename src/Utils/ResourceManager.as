package Utils
{
	public class ResourceManager
	{
		[Embed(source="Assets/Art/temptiles.png")]
		public static var floorMapArt:Class;
		
		[Embed(source="Assets/Art/playertiles-1.png")]
		public static var playerArt:Class;
		
		[Embed(source="Assets/Art/mirrortile-1.png")]
		public static var mirrorArt:Class;
	}
}