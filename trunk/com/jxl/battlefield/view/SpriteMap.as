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
    
    SpriteMap
    
    Extending the DefaultTileMap, allowings the
    adding and removal of autonomous sprites.
    These sprites can be made to walk around
    the map without ever walking into an occupied
    tile.
    
    TODO: need to optimize.  I've attempted to
    only draw those sprites that are in the current
    viewing rect so those offscreen still update their
    positions if moving, but don't actually get blitted.
	
*/

package com.jxl.battlefield.view
{
	//import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.jxl.battlefield.model.MDArray;
	import com.jxl.battlefield.events.MDArrayChangeEvent;
	import com.jxl.battlefield.view.CharacterSprite;
	import com.jxl.battlefield.events.DoneMovingEvent;
	import com.jxl.battlefield.events.LocationChangeEvent;
	import com.jxl.battlefield.events.MoveDirectionEvent;
	
	import com.jxl.diesel.view.core.BitmapSprite;
	import com.jxl.diesel.events.BitmapSpriteChangeEvent;
	import com.jxl.diesel.events.BitmapSpriteMoveEvent;
	
	import com.jxl.util.Profile;
	
	
	public class SpriteMap extends DefaultTileMap
	{
		
		public static var spriteCounter:int;
		
		protected var walkable_mdarray:MDArray;
		
		private var sprites_bitmap:Bitmap;
		private var sprites:Object;
		
		public function SpriteMap()
		{
			super();
			
			sprites = {};
			spriteCounter = -1;
		}
		
		override protected function setupBitmaps():void
		{
			super.setupBitmaps();
			
			var totalWidth:int = cols * tileWidth;
			var totalHeight:int = rows * tileHeight;
			
			var spriteBitmapData:BitmapData = new BitmapData(totalWidth, totalHeight, true, 0x00000000);
			sprites_bitmap = new Bitmap(spriteBitmapData);	
		}
		
		public function setWalkableMDArray(mdarray:MDArray):void
		{
			walkable_mdarray = mdarray;
			walkable_mdarray.removeEventListener(MDArrayChangeEvent.TYPE_CHANGE, onWalkableChanged);
			walkable_mdarray.addEventListener(MDArrayChangeEvent.TYPE_CHANGE, onWalkableChanged);
			onWalkableChanged(new MDArrayChangeEvent());
		}
		
		protected function canMoveTo(p_sprite:CharacterSprite, p_row:int, p_col:int):Boolean
		{
			if(p_row < 0 || p_row >= walkable_mdarray.rows)
			{
				trace("row is wrong");
				return false;
			}
			if(p_col < 0 || p_col >= walkable_mdarray.cols)
			{
				trace("col is wrong");
				return false;
			}
			var tileValue:int = int(map_mdarray.getCell(p_row, p_col));
			if(tileValue == EMPTY_TILE)
			{
				var val:Object = walkable_mdarray.getCell(p_row, p_col);
				if(val == null)
				{
					return true;
				}
				else if(val == p_sprite)
				{
					return true;
				}
				else
				{
					trace("occupied");
					return false;
				}
			}
			else
			{
				trace("not a walkable tile");
				return false;
			}
		}
		
		public function createCharacterSprite(p_row:int, p_col:int, p_conversationXML:String=null):CharacterSprite
		{
			var ref_cs:CharacterSprite = new CharacterSprite();
			ref_cs.conversation_xml = p_conversationXML;
			ref_cs.addEventListener(LocationChangeEvent.TYPE_CHANGE, onLocationChanged);
			ref_cs.addEventListener(MoveDirectionEvent.TYPE_MOVE, onMoveDirection);
			ref_cs.addEventListener(BitmapSpriteMoveEvent.MOVE_TYPE, onSpriteMove);
			ref_cs.addEventListener(DoneMovingEvent.TYPE_DONE, onSpriteDoneMoving);
			ref_cs.addEventListener(BitmapSpriteChangeEvent.TYPE_CHANGE, onCharacterSpriteBitmapChanged);
			walkable_mdarray.setCell(p_row, p_col, ref_cs);
			ref_cs.lastRow = p_row;
			ref_cs.lastCol = p_col;
			ref_cs.currentRow = p_row;
			ref_cs.currentCol = p_col;
			ref_cs.setLocation(p_row, p_col);
			var theX:int = p_col * tileWidth;
			var theY:int = p_row * tileHeight;
			ref_cs.move(theX, theY);
			ref_cs.startThinking();
			sprites[++spriteCounter] = ref_cs;
			invalidate();
			return ref_cs;
		}
		
		// TODO: figure out wtf to do with this function
		/*
		public function getSprite(p_name:String):CharacterSprite
		{
			return sprites_sp[p_name];
		}
		*/
		
		public function moveCharacterSpriteToTile(p_sprite:CharacterSprite, p_row:int, p_col:int):Boolean
		{
			if(canMoveTo(p_sprite, p_row, p_col))
			{
				var theX:int = p_col * tileWidth;
				var theY:int = p_row * tileHeight;
				p_sprite.setLocation(p_row, p_col);
				if(walkable_mdarray.getCell(p_sprite.lastRow, p_sprite.lastCol) == p_sprite)
				{
					walkable_mdarray.setCell(p_sprite.lastRow, p_sprite.lastCol, null);
				}
				walkable_mdarray.setCell(p_row, p_col, p_sprite);
				p_sprite.stopThinking();
				p_sprite.smoothMove(theX, theY);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function moveCharacterSprite(p_sprite:CharacterSprite, p_x:int, p_y:int):Boolean
		{
			if(p_x >= 0 && p_x <= width)
			{
				if(p_y >= 0 && p_y <= height)
				{
					var targetRow:int = Math.round(p_y / tileHeight);
					var targetCol:int = Math.round(p_x / tileWidth);
					if(canMoveTo(p_sprite, targetRow, targetCol))
					{
						p_sprite.move(p_x, p_y);
						p_sprite.setLocation(targetRow, targetCol);
						if(walkable_mdarray.getCell(p_sprite.lastRow, p_sprite.lastCol) == p_sprite)
						{
							walkable_mdarray.setCell(p_sprite.lastRow, p_sprite.lastCol, null);
						}
						walkable_mdarray.setCell(targetRow, targetCol, p_sprite);
						return true;
					}
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
			return false;
		}
		
		private function onLocationChanged(event:LocationChangeEvent):void
		{
			//trace("SpriteMap::onLocationChanged");
			// TODO: is this how bubbling works now?  Do I need to do this?
			// bubble the event up
			dispatchEvent(event);
		}
		
		private function onMoveDirection(event:MoveDirectionEvent):void
		{
			//trace("SpriteMap::onMoveDirection");
			var d:int = event.direction;
			var t:CharacterSprite = CharacterSprite(event.target);
			var row:int = t.currentRow;
			var col:int = t.currentCol;
			switch(d)
			{
				case CharacterSprite.NORTH:
					row--;
					break;
				
				case CharacterSprite.SOUTH:
					row++;
					break;
				
				case CharacterSprite.EAST:
					col++;
					break;
				
				case CharacterSprite.WEST:
					col--;
					break;
			}
			//trace("---------------");
			//trace(t + "'s currentRow: " + t.currentRow + ", currentCol: " + t.currentCol);
			//trace("target row: " + row + ", col: " + col);
			var r:Boolean = moveCharacterSpriteToTile(t, row, col);
			//trace("allowed to move there?: " + r);
		}
		
		private function onSpriteMove(event:BitmapSpriteMoveEvent):void
		{
			invalidate();
		}
		
		private function onSpriteDoneMoving(event:DoneMovingEvent):void
		{
			//trace("onSpriteDoneMoving: " + event_obj.target._name);
			event.target.startThinking();
		}
		
		private function onWalkableChanged(event:MDArrayChangeEvent):void
		{
			//removeChild(sprites_sp);
			//delete sprites_sp;
			//sprites_sp = new Sprite();
			//addChild(sprites_sp);
			invalidate();
		}
		
		private function onCharacterSpriteBitmapChanged(event:BitmapSpriteChangeEvent):void
		{
			invalidate();
		}
		
		private function modelChanged(event:MDArrayChangeEvent):void
		{
			/*
			var r:int = event.row;
			var c:int = event.col;
			var mc:MovieClip = map_mc[r + "_" + c];
			var val:Object = event.value;
			mc.lineStyle(0, 0x000000);
			if(val == null)
			{
				mc.beginFill(0xEEEEEE);
			}
			else if(val instanceof Sprite)
			{
				mc.beginFill(0x999999);
			}
			else
			{
				mc.beginFill(0xFF0000);
			}
			mc.lineTo(tileWidth, 0);
			mc.lineTo(tileWidth, tileHeight);
			mc.lineTo(0, tileHeight);
			mc.lineTo(0, 0);
			mc.endFill();
			*/
		}
		
		// TODO: blit this to the same bitmap in the super-class
		// this moving the sprite makes it jump from 6% cpu to 22%!!@@
		override public function moveMap(direction:int):void
		{
			super.moveMap(direction);
			
			/*
			switch(direction)
			{
				case DIRECTION_NORTH:
					sprites_sp.y += speed;
					break;
				
				case DIRECTION_SOUTH:
					sprites_sp.y -= speed;
					break;
				
				case DIRECTION_EAST:
					sprites_sp.x -= speed;
					break;
				
				case DIRECTION_WEST:
					sprites_sp.x += speed;
					break;
			}	
			*/
			
			//buffer_bitmap.bitmapData.copyPixels(buffer_bitmap.bitmapData, sourceRect, startPoint);
		}
		
		override public function repaint():void
		{
			//trace("SpriteMap::repaint");
			super.repaint();
			
			//Profile.start();
			//normalPaint();
			otherPaint();
			//var r:Number = Profile.end();
			//trace("r: " + r);
			
		}
		
		private function normalPaint():void
		{
			var csRect:Rectangle;
			var csPoint:Point;
			var origRect:Rectangle = new Rectangle(0, 0, sprites_bitmap.bitmapData.width, sprites_bitmap.bitmapData.height);
			sprites_bitmap.bitmapData.fillRect(origRect, 0x00000000);
			for(var p:String in sprites)
			{
				var ref_cs:CharacterSprite = sprites[p];
				csRect = new Rectangle(0, 0, ref_cs.width, ref_cs.height);
				csPoint = new Point(ref_cs.x, ref_cs.y);
				sprites_bitmap.bitmapData.copyPixels(ref_cs.bitmap.bitmapData, csRect, csPoint);
			}
			
			bitmap.bitmapData.copyPixels(sprites_bitmap.bitmapData, viewingRect, viewingPoint);
		}
		
		
		private function otherPaint():void
		{
			//trace("********************");
			var csRect:Rectangle;
			var csPoint:Point;
			var origRect:Rectangle = new Rectangle(0, 0, sprites_bitmap.bitmapData.width, sprites_bitmap.bitmapData.height);
			sprites_bitmap.bitmapData.fillRect(origRect, 0x00000000);
			for(var p:String in sprites)
			{
				//trace("----------------");
				var ref_cs:CharacterSprite = sprites[p];
				// is the sprite in our current viewable rect?  If so, paint, otherwise, NEXT!
				if(ref_cs.x + ref_cs.width >= viewingRect.x)
				{
					//trace((ref_cs.x + ref_cs.width) + " is greater than/equal to " + viewingRect.x);
					if(ref_cs.x <= viewingRect.x + viewingRect.width)
					{
						//trace(ref_cs.x + " is less than/equal to " + viewingRect.width);
						if(ref_cs.y + ref_cs.height >= viewingRect.y)
						{
							//trace((ref_cs.y + ref_cs.height) + " is greater than/equal to " + viewingRect.y);
							if(ref_cs.y <= viewingRect.y + viewingRect.height)
							{
								//trace(ref_cs.y + " is less than/equal to " + viewingRect.height);
								csRect = new Rectangle(0, 0, ref_cs.width, ref_cs.height);
								csPoint = new Point(ref_cs.x, ref_cs.y);
								sprites_bitmap.bitmapData.copyPixels(ref_cs.bitmap.bitmapData, csRect, csPoint);
							}	
						}	
					}
				}
			}
			
			bitmap.bitmapData.copyPixels(sprites_bitmap.bitmapData, viewingRect, viewingPoint);
		}
		
	}
}