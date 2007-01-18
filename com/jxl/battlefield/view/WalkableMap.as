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
    
    WalkableMap
    
    Extending the SpriteMap, allows a player sprite
    to be created and "walk" around the map.  He/she
    is held to the same rules as sprites, in that the
    sprite cannot walk into an occupied tile, nor
    walk outside the map boundaries.
	
*/

package com.jxl.battlefield.view
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.jxl.battlefield.view.SpriteMap;
	import com.jxl.battlefield.view.CharacterSprite;
	
	import com.jxl.battlefield.events.LocationChangeEvent;
	
	public class WalkableMap extends SpriteMap
	{
		private var character_sp:CharacterSprite;
		
		public function WalkableMap()
		{
			super();
		}
		
		public function get character():CharacterSprite
		{
			return character_sp;
		}
		
		public function createCharacter(p_row:int, p_col:int):Boolean
		{
			if(walkable_mdarray != null && walkable_mdarray.length > 0)
			{
				character_sp = new CharacterSprite();
				character_sp.addEventListener(LocationChangeEvent.TYPE_CHANGE, onCharacterLocationChanged);
				character_sp.lastRow = p_row;
				character_sp.lastCol = p_col;
				character_sp.currentRow = p_row;
				character_sp.currentCol = p_col;
				character_sp.setLocation(p_row, p_col);
				walkable_mdarray.setCell(p_row, p_col, character_sp);
				moveCharacterToTile(p_row, p_col);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function moveCharacterToTile(p_row:int, p_col:int):Boolean
		{
			if(canMoveTo(character_sp, p_row, p_col))
			{
				var theX:Number = p_col * tileWidth;
				//var theY:Number = ((p_row * _tileHeight) - character_sp.height) + (_tileHeight / 2);
				var theY:Number = p_row * tileHeight;
				character_sp.setLocation(p_row, p_col);
				walkable_mdarray.setCell(character_sp.lastRow, character_sp.lastCol, null);
				walkable_mdarray.setCell(p_row, p_col, character_sp);
				character_sp.move(theX, theY);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function moveCharacter(p_x:Number, p_y:Number):Boolean
		{
			//if(p_x >= 0 && p_x <= width)
			if(p_x >= 0 && p_x + tileWidth <= viewingRect.x + viewingRect.width)
			{
				//if(p_y >= 0 && p_y <= height)
				if(p_y >= 0 && p_y + tileHeight <= + viewingRect.y + viewingRect.height)
				{
					var targetRow:Number = Math.round(p_y / tileHeight);
					var targetCol:Number = Math.round(p_x / tileWidth);
					trace("targetRow: " + targetRow + ", targetCol: " + targetCol);
					if(canMoveTo(character_sp, targetRow, targetCol))
					{
						character_sp.setLocation(targetRow, targetCol);
						if(walkable_mdarray.getCell(character_sp.lastRow, character_sp.lastCol) == character_sp)
						{
							walkable_mdarray.setCell(character_sp.lastRow, character_sp.lastCol, null);
						}
						walkable_mdarray.setCell(targetRow, targetCol, character_sp);
						character_sp.move(p_x, p_y);
						return true;
					}
					else
					{
						trace("can't move to that row/col");
						return false;
					}
				}
				else
				{
					trace("y isn't right");
					return false;
				}
			}
			else
			{
				trace("x isn't right");
				return false;
			}
		}
		
		public function talkToSprite():CharacterSprite
		{
			var targetRow:Number = character_sp.currentRow;
			var targetCol:Number = character_sp.currentCol;
			switch(character_sp.facing)
			{
				case DIRECTION_NORTH: targetRow--; break;
				case DIRECTION_SOUTH: targetRow++; break;
				case DIRECTION_EAST: targetCol++; break;
				case DIRECTION_WEST: targetCol--; break;
			}
			var targetSprite:CharacterSprite = CharacterSprite(walkable_mdarray.getCell(targetRow, targetCol));
			if(targetSprite != null)
			{
				if(targetSprite != character_sp)
				{
					targetSprite.stopThinking();
					switch(character_sp.facing)
					{
						case DIRECTION_NORTH: targetSprite.facing = DIRECTION_SOUTH; break;
						case DIRECTION_SOUTH: targetSprite.facing = DIRECTION_NORTH; break;
						case DIRECTION_EAST: targetSprite.facing = DIRECTION_WEST; break;
						case DIRECTION_WEST: targetSprite.facing = DIRECTION_EAST; break;
					}
				}
			}
			return targetSprite;
		}
		
		protected function onCharacterLocationChanged(event:LocationChangeEvent):void
		{
			invalidate();
		}
		
		override public function repaint():void
		{
			super.repaint();
			
			//trace("----------------------");
			//trace("character_sp.x: " + character_sp.x);
			//trace("viewingRect.x: " + viewingRect.x);
			var csRect:Rectangle = new Rectangle(0, 0, character_sp.width, character_sp.height);
			var csPoint:Point = new Point(character_sp.x - viewingRect.x, character_sp.y - viewingRect.y);
			bitmap.bitmapData.copyPixels(character_sp.bitmap.bitmapData, csRect, csPoint);
		}
	}
}