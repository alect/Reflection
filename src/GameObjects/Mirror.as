package GameObjects
{
	import GameStates.PlayState;
	
	import Utils.ResourceManager;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.osmf.layout.AbsoluteLayoutFacet;
	
	public class Mirror extends FlxObject
	{
		public static const MIRROR_TILE_SIZE:int = 10;
		
		// Mirrors need to maintain a list of the objects that they exclusively reflect
		private var _mirrorExtraObjects:FlxGroup;

		// Every mirror has a distinct reflection of the player. 
		private var _playerReflection:FlxSprite;
		
		// Whether or not this mirror is active 
		private var _active:Boolean = false;
		
		private var _syncRequired:Boolean;
		
		// alignment of the mirror. May or may not be a useful parameter. Haven't decided yet
		// Uses the FlxObject Facing constants to keep things simple
		private var _alignment:uint;
		
		
		// a basic reflection of the encapsulating room's tilemap
		private var _mirrorTilemap:FlxTilemap;
		
		// The FlxSprite used to represent the mirror tiles.
		private static var _mirrorSprite:FlxSprite = null;
		// The FlxSprite used to construct a slight transparency over the mirror tiles
		private var _mirrorTransparency:FlxSprite = null;
		
		// Accessors and mutators
		public function get isActive():Boolean 
		{
			return _active;
		}
		
		public function Mirror(X:Number=0, Y:Number=0, Width:Number=0, Height:Number=0, alignment:uint=LEFT)
		{
			super(X, Y, Width, Height);
			
			// Mirrors should not be movable
			this.immovable = true;
			_alignment = alignment;
			
			// Load our sprite if we haven't already. 
			if(_mirrorSprite == null)
			{
				_mirrorSprite = new FlxSprite(0, 0, ResourceManager.mirrorArt);
			}
			 
			// Set up the transparency
			_mirrorTransparency = new FlxSprite();
			_mirrorTransparency.makeGraphic(1, 1, 0x80808080);
			
			// The player's reflection is basically the same sprite as the player
			// It mainly needs to be reflected in certain ways
			_playerReflection = new FlxSprite();
			_playerReflection.loadGraphic(ResourceManager.playerArt, true, true, 8, 15);
			
			// set up our group of extra objects
			_mirrorExtraObjects = new FlxGroup();
		}
		
		
		public override function draw():void
		{
			// The actual mirror sprites are tiled across our width and height
			// TODO: write code to actually make the mirror tiles face a certain direction with the alignment. 
			for(var i:int = 0; i < (int)(this.width/_mirrorSprite.width); i++ )
			{
				for(var j:int = 0; j < (int)(this.height/_mirrorSprite.height); j++) 
				{
					_mirrorSprite.x = this.x+_mirrorSprite.width*i;
					_mirrorSprite.y = this.y+_mirrorSprite.height*j;
					_mirrorSprite.draw();
				}
			}
			
			if(_active)
			{
				// TODO: Code to render the mirror objects assuming the mirror is active
				_mirrorTilemap.draw();
				_mirrorExtraObjects.draw();
				_playerReflection.draw();
				_mirrorTransparency.draw();
			}
		}
		
		public override function update():void
		{
			var player:Player = PlayState.player;
			// First, determine whether we're active or not
			if (objectInRange(player))
				activate();
			else
				deactivate();
			
			// Now, if we're active, need to update our extra objects. 
			if(_active)
			{
				
				
				// TODO: update mirror objects. 
				
				// update the player's reflection to reflect the player's position
				if(!_syncRequired)
				{
					updateReflection();
				}
				
				
				if(!_syncRequired)
				{
					_syncRequired = FlxG.collide(_mirrorTilemap, _playerReflection);
					_syncRequired = FlxG.collide(_playerReflection, _mirrorExtraObjects) || _syncRequired;
				}
				else 
				{
					_syncRequired = false;
				}
				_playerReflection.preUpdate();
				_playerReflection.update();
				_playerReflection.postUpdate();
				
				_mirrorTilemap.preUpdate();
				_mirrorTilemap.update();
				_mirrorTilemap.postUpdate();
				
				_mirrorExtraObjects.update();
				
				

				
				if(_syncRequired)
					syncWithReflection(player);
				
				
				
			}
		}
		
		private function updateReflection():void
		{
			var player:Player = PlayState.player;
			switch(_alignment) 
			{
				case UP:
					_playerReflection.x = player.x;
					_playerReflection.y = this.y+this.height + (this.y-(player.y+player.height));
					_playerReflection.frame = player.frame;
					_playerReflection.facing = player.facing;
					// Now flip it vertically
					_playerReflection.scale.y = -1;
					_playerReflection.velocity = new FlxPoint(player.velocity.x, -player.velocity.y);
					_playerReflection.acceleration = new FlxPoint(player.acceleration.x, -player.acceleration.y);
					break;
				case LEFT:
					_playerReflection.y = player.y;
					_playerReflection.x = this.x+this.width + (this.x-(player.x+player.width));
					_playerReflection.frame = player.frame;
					_playerReflection.facing = player.facing;
					_playerReflection.velocity = new FlxPoint(-player.velocity.x, player.velocity.y);
					_playerReflection.acceleration = new FlxPoint(-player.acceleration.x, player.acceleration.y);
					// Flip it horizontally
					_playerReflection.scale.x = -1;
					break;
				case DOWN:
					_playerReflection.x = player.x;
					_playerReflection.y = this.y - ((player.y-(this.y+this.height))+player.height);
					_playerReflection.frame = player.frame;
					_playerReflection.facing = player.facing;
					_playerReflection.velocity = new FlxPoint(player.velocity.x, -player.velocity.y);
					_playerReflection.acceleration = new FlxPoint(player.acceleration.x, -player.acceleration.y);
					// Flip it vertically
					_playerReflection.scale.y = -1;
					break;
				case RIGHT:
					_playerReflection.y = player.y;
					_playerReflection.x = this.x - ((player.x-(this.x+this.width))+player.width);
					_playerReflection.frame = player.frame;
					_playerReflection.facing = player.facing;
					_playerReflection.velocity = new FlxPoint(-player.velocity.x, player.velocity.y);
					_playerReflection.acceleration = new FlxPoint(-player.acceleration.x, player.acceleration.y);
					// Flip it horizontally
					_playerReflection.scale.x = -1;
					break;
			}
		}
		
		/** 
		 * Function called by the player to update its position with respect to a reflection
		 */
		public function syncWithReflection(player:Player):Boolean
		{
			switch(_alignment)
			{
				case UP:
					player.x = _playerReflection.x;
					player.y = this.y+this.height + (this.y-(_playerReflection.y+_playerReflection.height));
					break;
				case LEFT:
					player.y = _playerReflection.y;
					//player.x = this.x+this.width + (this.x-(_playerReflection.x+_playerReflection.width));
					player.x = this.x-(_playerReflection.x-(this.x+this.width))-player.width;
					break;
				case DOWN:
					player.x = _playerReflection.x;
					player.y = this.y - ((_playerReflection.y-(this.y+this.height))+_playerReflection.height);
					break;
				case RIGHT:
					player.y = _playerReflection.y;
					player.x = this.x - ((_playerReflection.x-(this.x+this.width))+_playerReflection.width);
					break;
			}

			return true;
		}
		
		/**
		 * Function to determine if an object has entered the range of this mirror (in which case, it should be activated
		 * Returns true of the player is within our range
		 * False otherwise
		 */
		private function objectInRange(object:FlxObject):Boolean
		{
			// First, make sure that the player is within our "rectangle of influence"
			// For now, return true if the player intersects our rectangle. 
			// In the future, might also want to check if the player is hidden behind objects etc. 
			var objectInRange:Boolean = false;
			switch(this._alignment)
			{
				case UP:
					objectInRange = (object.y+object.height/2 < this.y && object.x+object.width > this.x && object.x < this.x+this.width);
					break;
				case LEFT:
					objectInRange = (object.x+object.width/2 < this.x && object.y+object.height > this.y && object.y < this.y+this.height);
					break;
				case DOWN:
					objectInRange = (object.y > this.y+this.height/2 && object.x+object.width > this.x && object.x < this.x+this.width);
					break;
				case RIGHT:
					objectInRange = (object.x > this.x+this.width/2 && object.y+object.height > this.y && object.y < this.y + this.height);
			}
			
			return objectInRange;	
		}
		
		/** 
		 * Function that officially activates this mirror. Needs to do some book-keeping like
		 * binding reflections to the player 
		 */
		private function activate():void
		{
			// TODO: Activation book-keeping
			if(!_active) 
			{
				updateReflection();
				_playerReflection.last = new FlxPoint(_playerReflection.x, _playerReflection.y);
			}
			_active = true;
			
		}
		
		/**
		 * Similar function for deactivating this mirror. Also needs to do some book-keeping
		 */
		private function deactivate():void
		{
			// TODO: Deactivation book-keeping
			_playerReflection.x = 0;
			_playerReflection.y = 0;
			_active = false;
			
			
		}
		
		/** 
		 * Function called by the room when the mirror is created 
		 * Allows the mirror to reflect relevant information in the room, such as tilemaps, obstacles, etc. 
		 */
		public function createTileReflections(tilemap:FlxTilemap):void
		{
			var i:int, j:int, tileX:int, tileY:int;
			var tileWidth:int = (int)(tilemap.width/tilemap.widthInTiles);
			var tileHeight:int = (int)(tilemap.height/tilemap.heightInTiles);
			var csv:String = "";
			_mirrorTilemap = new FlxTilemap();
			// iterate through all possible tiles within our range and reflect them if necessary
			switch(_alignment) 
			{
				case UP:
					// Need to start at the bottom and move up if we want it to be coherent
					
					for(j = this.y-tileHeight; j >= 0; j-=tileHeight)
					{	
						// If there are no tiles at this coordinate, should continue
						if(j >= tilemap.y+tilemap.height || j < tilemap.y) 
						{
							// Pad with 0s
							csv+="0,\n";
							continue;
						}
						// Otherwise, iterate from left to right
						for(i = this.x; i < this.x+this.width; i+=tileWidth)
						{
							// again, if we're out of range of any tiles, should just continue
							if(i >= tilemap.x+tilemap.width || i < tilemap.x) {
								csv+="0";
							}
							else
							{
								// Otherwise, go ahead and mirror that guy
								tileX = (i - tilemap.x)/tileWidth;
								tileY = (j - tilemap.y)/tileHeight;
								csv += tilemap.getTile(tileX, tileY).toString();
							}
							if(i < this.x+this.width-tileWidth)
								csv+=",";
						}
						
						csv+="\n";
					}
					_mirrorTilemap.x = this.x;
					_mirrorTilemap.y = this.y+this.height;
					break;
				case LEFT:
					// need to start at the top right and move down
					for(j = this.y; j < this.y+this.height; j+=tileHeight)
					{
						if(j >= tilemap.y+tilemap.height || j < tilemap.y)
						{
							csv+="0,\n";
							continue;
						}
						
						for(i = this.x-tileWidth; i >= 0; i-=tileWidth) 
						{
							// If there are no tiles at this coordinate, should continue
							if (i >= tilemap.x + tilemap.width || i < tilemap.x)
							{
								// Pad with 0 again
								csv+="0";
								if(i > 0)
									csv+=",";
								continue;
							}
							
							// Otherwise, mirror that guy
							tileX = (i - tilemap.x)/tileWidth;
							tileY = (j - tilemap.y)/tileWidth;
							csv += tilemap.getTile(tileX, tileY).toString();
							if (i > 0)
								csv+=",";
							
						}
						csv+="\n"
					}
					_mirrorTilemap.x = this.x+this.width;
					_mirrorTilemap.y = this.y;
					break;
				case DOWN:
					// Need to start at the bottom left and move up
					for(j = FlxG.height-tileHeight; j >= this.y+this.height; j-=tileHeight)
					{
						
						for(i = this.x; i < this.x+this.width; i+= tileWidth)
						{
							// again, if we're out of range of any tiles, should just continue
							if((i >= tilemap.x+tilemap.width || i < tilemap.x) ||
							(j >= tilemap.y+tilemap.height || j < tilemap.y)) {
								csv+="0";
							}
							else
							{
								// Otherwise, go ahead and mirror that guy
								tileX = (i - tilemap.x)/tileWidth;
								tileY = (j - tilemap.y)/tileHeight;
								csv += tilemap.getTile(tileX, tileY).toString();
							}
							if(i < this.x+this.width-tileWidth)
								csv+=",";
						}
						csv+="\n";
					}
					_mirrorTilemap.loadMap(csv, ResourceManager.floorMapArt, 0, 0, FlxTilemap.OFF, 0, 0);
					_mirrorTilemap.x = this.x;
					_mirrorTilemap.y = this.y-_mirrorTilemap.height;
					_mirrorTransparency.scale = new FlxPoint(_mirrorTilemap.width, _mirrorTilemap.height);
					_mirrorTransparency.x = _mirrorTilemap.x+_mirrorTilemap.width/2;
					_mirrorTransparency.y = _mirrorTilemap.y+_mirrorTilemap.height/2;
					return;
				case RIGHT:
					// Need to start at the top right and move left
					for(j = this.y; j < this.y+this.height; j+=tileHeight)
					{
						for(i = FlxG.width-tileWidth; i > this.x+this.width-tileWidth; i-=tileWidth)
						{
							if( (i >= tilemap.x+tilemap.width || i < tilemap.x) ||
								(j >= tilemap.y+tilemap.height || j < tilemap.y) ) {
								csv+="0";
							}
							else
							{
								// Otherwise, go ahead and mirror that guy
								tileX = (i - tilemap.x)/tileWidth;
								tileY = (j - tilemap.y)/tileHeight;
								csv += tilemap.getTile(tileX, tileY).toString();
							}
							if(i > this.x +this.width)
								csv+=",";
						}
						csv+="\n";
					}
					_mirrorTilemap.loadMap(csv, ResourceManager.floorMapArt, 0, 0, FlxTilemap.OFF, 0, 0);
					_mirrorTilemap.y = this.y;
					_mirrorTilemap.x = this.x-_mirrorTilemap.width;
					_mirrorTransparency.scale = new FlxPoint(_mirrorTilemap.width, _mirrorTilemap.height);
					_mirrorTransparency.x = _mirrorTilemap.x+_mirrorTilemap.width/2;
					_mirrorTransparency.y = _mirrorTilemap.y+_mirrorTilemap.height/2;
					return;
			}
			
			_mirrorTilemap.loadMap(csv, ResourceManager.floorMapArt, 0, 0, FlxTilemap.OFF, 0, 0);
			_mirrorTransparency.scale = new FlxPoint(_mirrorTilemap.width, _mirrorTilemap.height);
			_mirrorTransparency.x = _mirrorTilemap.x+_mirrorTilemap.width/2;
			_mirrorTransparency.y = _mirrorTilemap.y+_mirrorTilemap.height/2;

		}
		
		
		/**
		 * Function that looks through the possible extra mirror objects and adds them
		 * to our list of extended objects. Should only add objects within our reflected rectangle
		 * assumes that createReflectedTilemap has already been called. 
		 */
		public function createMirrorObjects(possibleMirrorObjects:Array):void
		{
			for each (var object:FlxObject in possibleMirrorObjects)
			{
				if(!_mirrorTilemap.getBounds().overlaps(new FlxRect(object.x, object.y, object.width, object.height)))
					continue;
				if(object is MirrorObstacle)
				{
					var tileWidth:int = _mirrorTilemap.width/_mirrorTilemap.widthInTiles;
					var tileHeight:int = _mirrorTilemap.height/_mirrorTilemap.heightInTiles;
					var tileX:int = (object.x - _mirrorTilemap.x)/tileWidth;
					var tileY:int = (object.y - _mirrorTilemap.y)/tileHeight;
					_mirrorTilemap.setTile(tileX, tileY, 1);
				}
				else
					_mirrorExtraObjects.add(object);
			}
		}
		
	}
}