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
    
    TileMap (depreciated)
    
    Original tilemap based on a sprite vs. pure blitting.
	
*/

package com.jxl.battlefield.view
{
	import com.jxl.battlefield.model.MDArray;
	import com.jxl.battlefield.model.MDArrayChangeEvent;
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class TileMap extends Sprite
	{
		
		private var rows:uint;
		private var cols:uint;
		private var tileWidth:uint;
		private var tileHeight:uint;
		private var mdarray:MDArray;
		
		private var bufferBitmap:Bitmap;
		private var tileBitmap:Bitmap;
		private var tile_sprite:Sprite;
		
		[Embed(source="grass_tile.png")]
		private var tile_image:Bitmap;

		
		public function TileMap()
		{
			rows = 0;
			cols = 0;
			tileWidth = 72;
			tileHeight = 72;
			mdarray = new MDArray(0, 0);
			mdarray.addEventListener(MDArrayChangeEvent, onTileMapChanged);
			
			bufferBitmap = new Bitmap();
			var bufferBitmapData:BitmapData = new BitmapData(1, 1, false, 0xffaaaaaa);
			bufferBitmap.bitmapData = bufferBitmapData;
			bufferBitmap.bitmapData.fillRect(new Rectangle(0, 0, 1, 1), 0xffaaaaaa);
			
			tileBitmap = new Bitmap();
			var tileBitmapData:BitmapData = new BitmapData(1, 1, false, 0xffaaaaaa);
			tileBitmap.bitmapData = tileBitmapData;
			tileBitmap.bitmapData.fillRect(new Rectangle(0, 0, 1, 1), 0xffaaaaaa);
		}
		
		public function setMDArray(mdarray:MDArray):Void
		{
			mdarray = mdarray;
			mdarray.addEventListener(MDArrayChangeEvent, onTileMapChanged);
			rows = mdarray.rows;
			cols = mdarray.cols;
			
			redraw();
		}
		
		private function onTileMapChanged(event:MDArrayChangeEvent):Void
		{
			redraw();	
		}
		
		public function redraw():Void
		{
			var startX:uint = 0;
			var startY:uint = 0;
			var sourceRect:Rectangle = new Rectangle(startX, startY, tileWidth, tileHeight);
			var startPoint:Point;
			for(var r:uint = 0; r<rows; r++)
			{
				for(var c:uint = 0; c<cols; c++)
				{
					startPoint = new Point(startX, startY);
					tileBitmap.bitmapData.copyPixels(tile_image.bitmapData, sourceRect, startPoint);
					startX += tileWidth;
				}
				startX = 0;
				startY += tileHeight;
			}

			
			viewingRect = new Rectangle(0, 0, viewableCols * tileWidth, viewableRows * tileHeight);
			viewingPoint = new Point(0, 0);
			tileMapBitmap = new Bitmap();
			var tileMapBitmapData:BitmapData = new BitmapData(viewingRect.width, 
															viewingRect.height, 
															false, 
															0xffaaaaaa);
			tileMapBitmap.bitmapData = tileMapBitmapData;
			tileMapBitmap.bitmapData.copyPixels(mapImage.bitmapData, viewingRect, viewingPoint);
			
			tile_sprite = new Sprite();
			tile_sprite.cacheAsBitmap = true;
			tile_sprite.scrollRect = new Rectangle(0, 0, totalWidth, totalHeight);
			addChild(tile_sprite);
			tile_sprite.addChild(tileMapBitmap);
			tile_sprite.addEventListener(KeyboardEventType.KEY_DOWN, onKeyPressDown);
			stage.focus = tile_sprite;
		}
	}
}