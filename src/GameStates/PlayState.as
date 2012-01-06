package GameStates
{
	import GameObjects.Player;
	import GameObjects.Room;
	
	import Utils.RoomLoader;
	import Utils.ResourceManager;
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	
	public class PlayState extends FlxState
	{
		private static var _player:Player;
		private var room:Room;
		
		public static function get player():Player
		{
			return _player;
		}
		
		
		
		public override function create():void
		{
			
			room = RoomLoader.loadRoom(ResourceManager.testRoom);
			this.add(room);
			
			_player = new Player(FlxG.width/2, FlxG.height/2-40);
			this.add(_player);

		}
		
		public override function update():void
		{
			FlxG.collide(room, _player);
			
			//\\room.update();
			//Make sure the player updates before everything else
			//_player.update();
			
			
			super.update();
		
		}
	}
}