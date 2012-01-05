package GameStates
{
	import GameObjects.Player;
	import GameObjects.Room;
	
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
			
			room = new Room();
			this.add(room);
			
			_player = new Player(22, 22);
			this.add(_player);

		}
		
		public override function update():void
		{
			FlxG.collide(room, _player);
			
			//room.update();
			//Make sure the player updates before everything else
			//_player.update();
			
			
			super.update();
		
		}
	}
}