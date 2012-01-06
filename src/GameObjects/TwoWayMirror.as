package GameObjects
{
	import org.flixel.FlxTilemap;

	public class TwoWayMirror extends Mirror
	{
		public static const HORIZONTAL:uint = 0;
		public static const VERTICAL:uint = 1;
		
		private var _mirror1:Mirror, _mirror2:Mirror;
		
		public function TwoWayMirror(X:Number=0, Y:Number=0, Width:Number=0, Height:Number=0, alignment:uint=TwoWayMirror.HORIZONTAL)
		{
			// To easily maintain collisions
			this.x = X;
			this.y = Y;
			this.width = Width;
			this.height = Height;
			if(alignment == HORIZONTAL)
			{
				_mirror1 = new Mirror(X, Y, Width, Height, LEFT);
				_mirror2 = new Mirror(X, Y, Width, Height, RIGHT);
			}
			else
			{
				_mirror1 = new Mirror(X, Y, Width, Height, UP);
				_mirror2 = new Mirror(X, Y, Width, Height, DOWN);
			}
		}
		
		public override function update():void
		{
			_mirror1.update();
			_mirror2.update();
		}
		
		public override function draw():void
		{
			_mirror1.draw();
			_mirror2.draw();
		}
		
		public override function createTileReflections(tilemap:FlxTilemap):void
		{
			_mirror1.createTileReflections(tilemap);
			_mirror2.createTileReflections(tilemap);
		}
		
		public override function createMirrorObjects(possibleMirrorObjects:Array):void
		{
			_mirror1.createMirrorObjects(possibleMirrorObjects);
			_mirror2.createMirrorObjects(possibleMirrorObjects);
		}
	}
}