/*
    Battlefield
    version 0.0.1
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
    ---------------------------------------------
    
    Diesel
    
    Diesel is a blitting engine for Flash Player 8.5 
	using ActionScript 3. Uses 1 bitmap to paint to vs. 
	using many DisplayObjects in an 
	effort to utilize less CPU & RAM.
	
*/

package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Graphics;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	
	import flash.display.Loader;
	import com.jxl.util.LoaderQueue;
	import flash.net.URLRequest;
	import com.jxl.battlefield.model.MDArray;
	import com.jxl.battlefield.view.CharacterSprite;
	
	import com.jxl.battlefield.view.DefaultTileMap;
	import com.jxl.battlefield.view.SpriteMap;
	import com.jxl.battlefield.view.WalkableMap;
	
	import com.jxl.diesel.view.core.BitmapSpriteDisplayObject;
	import flash.display.BitmapData;
	
	public class Example_Diesel extends Sprite
	{
		
		
		private var tile_mdarray:MDArray;
		private var tileMap:DefaultTileMap;
		
		private var walkable_mdarray:MDArray;
		private var spriteMap:SpriteMap;
		
		private var walkableMap:WalkableMap;
		
		private var rows:int;
		private var cols:int;
		
		// BUG: the Map's speed to scroll, and the walkablemap's sprite
		// both have to have the same speed, or the sprite's position 
		// gets screwed up.  They both use this speed variable.
		public var speed:Number;
		
		public function Example_Diesel()
		{
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			tabEnabled = true;
			
			speed = 2;
			
			
			
			/*
			// *** LoaderQueue Testing *** //
			var queue:LoaderQueue = new LoaderQueue();
			var prefixPath:String = "images/auenland/auenland_";
			var rows:int = 10;
			var cols:int = 10;
			var origX:Number = 0;
			var origY:Number = 0;
			var w:Number = 16;
			var h:Number = 16;
			for(var r:int = 0; r<rows; r++)
			{
				for(var c:int = 0; c<cols; c++)
				{
					var ldr:Loader = new Loader();
					ldr.x = origX;
					ldr.y = origY;
					addChild(ldr);
					var img:String = prefixPath + "r" + (r + 1) + "_c" + (c + 1) + ".png";
					var req:URLRequest = new URLRequest(img);
					queue.addLoaderToQueue(ldr, req);
					origX += w;
				}
				origX = 0;
				origY += h;
			}
			
			queue.start();
			return;
			// *************************** //
			*/
			
			var defaultBitmapData:BitmapData = new BitmapData(480, 256, true, 0x00000000);
			var bsdo:BitmapSpriteDisplayObject = new BitmapSpriteDisplayObject(defaultBitmapData);
			addChild(bsdo);
			//bsdo.scrollRect = new Rectangle(0, 0, 320, 240);
			
			/*
			// *** Testing DefaultTileMap *** //
			
			tile_mdarray = new MDArray(16, 30);
			tileMap = new DefaultTileMap();
			tileMap.setViewableRange(16, 30);
			tileMap.setMDArray(tile_mdarray);
			bsdo.addBitmapSprite(tileMap);
			
			//tileMap.addEventListener(KeyboardEventType.KEY_DOWN, onKeyDown);
			//addEventListener(EventType.ENTER_FRAME, onEnterFrame);
			tileMap.loadExternalTiles(getTileMapImageName);
			*/
			
			
			// *** Testing SpriteMap *** //
			/*
			tile_mdarray = new MDArray(40, 40);
			walkable_mdarray = new MDArray(40, 40, null);
			spriteMap = new SpriteMap();
			spriteMap.setViewableRange(11, 11);
			spriteMap.setMDArray(tile_mdarray);
			spriteMap.setWalkableMDArray(walkable_mdarray);
			bsdo.addBitmapSprite(spriteMap);
			
			var total:int = 30;
			for(var r:int=0; r<total; r++)
			{
				spriteMap.createCharacterSprite(2, r, null);
			}
			
			
			
			addEventListener(EventType.ENTER_FRAME, onEnterFrame);
			spriteMap.speed = 1;
			*/
			
			
			
			
			// *** Testing WalkableMap *** //
			
			rows = 16;
			cols = 30;
			tile_mdarray = new MDArray(rows, cols, 0);
			walkable_mdarray = new MDArray(rows, cols, null);
			walkableMap = new WalkableMap();
			bsdo.addBitmapSprite(walkableMap);
			walkableMap.speed = speed;
			walkableMap.setViewableRange(10, 11);
			walkableMap.setMDArray(tile_mdarray);
			walkableMap.setWalkableMDArray(walkable_mdarray);
			var total:int = 30;
			for(var r:int=0; r<total; r++)
			{
				walkableMap.createCharacterSprite(2, r, null);
				walkableMap.createCharacterSprite(3, r, null);
				walkableMap.createCharacterSprite(4, r, null);
			}
			//walkableMap.createCharacterSprite(2, 3, null);
			
			
			var g:Graphics = graphics;
			g.beginFill(0xFFFFFF);
			g.lineTo(width, 0);
			g.lineTo(width, height);
			g.lineTo(0, height);
			g.lineTo(0, 0);
			g.endFill();
			
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false);
			walkableMap.createCharacter(5, 5);
			
			
			stage.focus = this;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//walkableMap.loadExternalTiles(getTileMapImageName);
			
		}
		
		private function onEnterFrame(event:Event):void
		{
			stage.focus = this;
		}
		
		private function getTileMapImageName(p_row:int, p_col:int, value:Object):String
		{
			//trace("getTileMapImageName p_row: " + p_row + ", p_col: " + p_col + ", value: " + value);
			var img:String = "images/auenland/auenland_" + "r" + (p_row + 1) + "_c" + (p_col + 1) + ".png";
			return img;
		}
		
		/*
		private function onEnterFrame(event:Event):void
		{
			trace("onEnterFrame");
			tileMap.moveMap(DefaultTileMap.DIRECTION_EAST);
			//spriteMap.moveMap(DefaultTileMap.DIRECTION_EAST);
		}
		*/
		
		/*
		// TileMap keydown //
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					tileMap.moveMap(DefaultTileMap.DIRECTION_WEST);
					//tileMap.move(tileMap.x + 1, tileMap.y);
					
					break;
				
				case Keyboard.RIGHT:
					 tileMap.moveMap(DefaultTileMap.DIRECTION_EAST);
					//tileMap.move(tileMap.x - 1, tileMap.y);
					break;
				
				case Keyboard.UP:
					tileMap.moveMap(DefaultTileMap.DIRECTION_NORTH);
					//tileMap.move(tileMap.x, tileMap.y + 1);
					break;
				
				case Keyboard.DOWN:
					tileMap.moveMap(DefaultTileMap.DIRECTION_SOUTH);
					//tileMap.move(tileMap.x, tileMap.y - 1);
					break;
			}
		}
		*/
		
		
		public function onKeyDown(event:KeyboardEvent):void
		{
			trace("onKeyDown, event.keyCode: " + event.keyCode);
			var x:Number = walkableMap.character.x;
			var y:Number = walkableMap.character.y;
			var row:Number = walkableMap.character.currentRow;
			var col:Number = walkableMap.character.currentCol;
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					walkableMap.character.facing = CharacterSprite.WEST;
					if(walkableMap.moveCharacter(x - speed, y))
					{
						walkableMap.moveMap(DefaultTileMap.DIRECTION_WEST);	
					}
					break;
				
				case Keyboard.RIGHT:
					walkableMap.character.facing = CharacterSprite.EAST;
					if(walkableMap.moveCharacter(x + speed, y))
					{
						walkableMap.moveMap(DefaultTileMap.DIRECTION_EAST);
					}
					break;
				
				case Keyboard.UP:
					walkableMap.character.facing = CharacterSprite.NORTH;
					if(walkableMap.moveCharacter(x, y - speed))
					{
						walkableMap.moveMap(DefaultTileMap.DIRECTION_NORTH);
					}
					break;
				
				case Keyboard.DOWN:
					walkableMap.character.facing = CharacterSprite.SOUTH;
					if(walkableMap.moveCharacter(x, y + speed))
					{
						walkableMap.moveMap(DefaultTileMap.DIRECTION_SOUTH);
					}
					break;
					/*
				case 65: // a
					talkingToSprite = walkableMap.talkToSprite();
					var data:Object = talkingToSprite.data;
					if(data.conversation_xml != null)
					{
						var thePath:String = CONVERSATIONS_PATH + data.conversation_xml;
						conversationWindow_mc.loadConversationXML(thePath);
					}
					else
					{
						talkingToSprite.startThinking();
						talkingToSprite = null;
					}
					break;
					*/
					
			}
			
			event.updateAfterEvent();
			
		}
		
		
	}
}
