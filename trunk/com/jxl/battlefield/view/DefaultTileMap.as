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
    
    DefaultTileMap
    
    Tile-based map.  By default, draws a bunch
    of white tiles with black outlines.  You pass a
    MDArray to it, and it'll draw the tiles based
    on the MDArrays' rows and columns.
    
    Additionally, supports a viewable rect, so if
    you have a 40x40 map (max supported for 16x16 tiles),
    you can only show 10x10 of those tiles, or more, or less.
    
    You can move the viewing rect to cause the map to scroll.
    TODO: need to do more tests to ensure that scrollRect
    and bitmap.move are not faster.  So far, simply
    moving a rectangle for copyPixels has been the fastest.
    
    Finally, supports loading of external bitmap tiles based
    on the values in the MDArray.  Much like Array.sort,
    it takes a function to determine what the values mean,
    and allows you to return a custom image path to load.
    It uses a queing system to load the tiles.  This
    unfortunately causes a memory leak in earlier alpha
    builds of the Flash Player 8.5 because of a bug in
    not clearing loaders from memory.  This is fixed in
    later builds of the player.
	
*/

package com.jxl.battlefield.view
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.jxl.battlefield.model.MDArray;
	import com.jxl.battlefield.events.MDArrayChangeEvent;
	
	import com.jxl.diesel.view.core.BitmapSprite;
	import com.jxl.diesel.events.BitmapSpriteMoveEvent;
	
	import com.jxl.util.LoaderQueue;
	import com.jxl.util.LoaderQueueTicket;
	import com.jxl.util.LoaderQueueTicketCompleteEvent;

	public class DefaultTileMap extends BitmapSprite
	{
		public static const DIRECTION_NORTH:int = 0;
		public static const DIRECTION_SOUTH:int = 1;
		public static const DIRECTION_EAST:int = 2;
		public static const DIRECTION_WEST:int = 3;
		
		public static const EMPTY_TILE:Number = 0;
		public static const FILLED_TILE:Number = 1;
		
		public var tileWidth:int;
		public var tileHeight:int;
		public var rows:int;
		public var cols:int;
		public var speed:Number;
		
		protected var viewableRows:int;
		protected var viewableCols:int;
		protected var viewingPoint:Point;
		protected var viewingRect:Rectangle;
		protected var addedInvalidationListener:Boolean;
		
		protected var map_mdarray:MDArray;
		protected var buffer_bitmap:Bitmap;
		protected var beacon_sprite:Sprite;
		protected var beaconHolder_sprite:Sprite;
		
		private var queue:LoaderQueue;
		
		public function DefaultTileMap()
		{
			super();
			
			addedInvalidationListener = false;
			beacon_sprite = new Sprite();
			beaconHolder_sprite = new Sprite();
			beaconHolder_sprite.addChild(beacon_sprite);
			
			rows = 2;
			cols = 2;
			
			tileWidth = 16;
			tileHeight = 16;
			
			viewableRows = 2;
			viewableCols = 2;
			
			speed = 1;
			
			viewingPoint = new Point(0, 0);
			viewingRect = new Rectangle(0, 0, viewableCols * tileWidth, viewableRows * tileHeight);
			
			setSize(viewingRect.width, viewingRect.height);
			
			setupBitmaps();
		}
		
		public function setViewableRange(rows:int, cols:int):void
		{
			viewableRows = rows;
			viewableCols = cols;
			viewingRect.width = viewableCols * tileWidth;
			viewingRect.height = viewableRows * tileHeight;
			trace("width: " + viewingRect.width + ", viewingRect.height: " + viewingRect.height);
			setSize(viewingRect.width, viewingRect.height);
			if(map_mdarray != null)
			{
				setupBitmaps();
				redrawTiles();
			}
		}
		
		public function setMDArray(mdarray:MDArray):void
		{
			this.map_mdarray = mdarray;
			this.map_mdarray.addEventListener(MDArrayChangeEvent.TYPE_CHANGE, redrawTiles);
			
			rows = this.map_mdarray.rows;
			cols = this.map_mdarray.cols;
			
			setupBitmaps();
			redrawTiles();
		}
		
		protected function setupBitmaps():void
		{
			var totalWidth:int = cols * tileWidth;
			var totalHeight:int = rows * tileHeight;
			
			//if(buffer_bitmap != null)
			//{
			//	if(buffer_bitmap.bitmapData != null)
				//{
					//buffer_bitmap.bitmapData.dispose();
				//}	
			//}
			var buffer_bitmapData:BitmapData = new BitmapData(totalWidth, totalHeight, false, 0xaaaaaaaa);
			buffer_bitmap = new Bitmap(buffer_bitmapData);
		}
		
		protected function redrawTiles():void
		{
			var tileFillColor:int = 0xFFFFFF;
			var tileLineColor:int = 0x999999;
			var totalWidth:int = cols * tileWidth;
			var totalHeight:int = rows * tileHeight;
			
			var tileBitmapData:BitmapData = new BitmapData(tileWidth, tileHeight, false, 0xffffffff);
			// make it white
			for(var r:int=0; r<tileWidth; r++)
			{
				for(var c:int=0; c<tileHeight; c++)
				{
					tileBitmapData.setPixel(r, c, tileFillColor);
				}	
			}
			//var tileBitmap:Bitmap = new Bitmap(tileBitmapData);
			var tileBitmap:Bitmap = new Bitmap(tileBitmapData);
		
			// make the left column black
			c = 0;
			for(r = 0; r<tileWidth; r++)
			{
				tileBitmapData.setPixel(r, c, tileLineColor);
			}
			
			// make the right column black
			c = tileHeight - 1;
			for(r = 0; r<tileWidth; r++)
			{
				tileBitmapData.setPixel(r, c, tileLineColor);
			}
			
			// make the top row black
			r = 0;
			for(c = 0; c<tileHeight; c++)
			{
				tileBitmapData.setPixel(r, c, tileLineColor);
			}
			
			// make the top row black
			r = tileWidth - 1;
			for(c = 0; c<tileHeight; c++)
			{
				tileBitmapData.setPixel(r, c, tileLineColor);
			}
			
			// copy to the canvas
			buffer_bitmap.bitmapData.copyPixels(tileBitmapData, 
												new Rectangle(0, 0, tileWidth, tileHeight), 
												new Point(0, 0));
												
			//tileBitmapData.dispose();
			
			
			var startX:int = 0;
			var startY:int = 0;
			var sourceRect:Rectangle = new Rectangle(startX, startY, tileWidth, tileHeight);
			//var sourceRect:Rectangle = new Rectangle(0, 0, 72, 72);
			var startPoint:Point = new Point(0, 0);
			for(r = 0; r<rows; r++)
			{
				for(c = 0; c<cols; c++)
				{
					startPoint.x = startX;
					startPoint.y = startY;
					buffer_bitmap.bitmapData.copyPixels(buffer_bitmap.bitmapData, sourceRect, startPoint);
					startX += tileWidth;
				}
				startX = 0;
				startY += tileHeight;
			}
			
			invalidate();
		}
		
		public function moveMap(direction:int):void
		{
			switch(direction)
			{
				case DIRECTION_NORTH:
					//trace("moving north");
					viewingRect.y -= speed;
					//_y += speed;
					break;
				
				case DIRECTION_SOUTH:
					//trace("moving south");
					viewingRect.y += speed;
					//_y -= speed;
					break;
				
				case DIRECTION_EAST:
					//trace("moving east");
					viewingRect.x += speed;
					//_x -= speed;
					break;
				
				case DIRECTION_WEST:
					//trace("moving west");
					viewingRect.x -= speed;
					//_x += speed;
					break;
			}
			
			//move(x, y, false);
			//bitmap.bitmapData.scroll(x, y);
			invalidate();
		}
		
		public function loadExternalTiles(p_imageNameFunction:Function):void
		{
			if(queue != null)
			{
				queue.stop();
				queue = null;
			}
			
			queue = new LoaderQueue();
			queue.addEventListener(LoaderQueueTicketCompleteEvent.COMPLETE, onTileLoadComplete);
			var rows:int = map_mdarray.rows;
			var cols:int = map_mdarray.cols;
			var origX:Number = 0;
			var origY:Number = 0;
			var imagePath:String;
			var ldr:Loader;
			var req:URLRequest;
			for(var r:int = 0; r<rows; r++)
			{
				for(var c:int = 0; c<cols; c++)
				{
					// get our data
					var cellData:int = int(map_mdarray.getCell(r, c));
					// get our image path from the data
					imagePath = p_imageNameFunction(r, c, cellData);
					// make a request for said image path
					req = new URLRequest(imagePath);
					// make a loader to load our image
					//ldr = new Loader();
					// pre-position him
					//ldr.x = origX;
					//ldr.y = origY;
					
					queue.addLoaderToQueue(req, origX, origY);
					origX += tileWidth;
				}
				origX = 0;
				origY += tileHeight;
			}
			queue.start();
		}
		
		protected function onTileLoadComplete(p_loaderQueueTicketEvent:LoaderQueueTicketCompleteEvent):void
		{
			//trace("onTileLoadComplete");
			if(p_loaderQueueTicketEvent.loaderQueueTicket != null)
			{
				var ldrQueueTicket:LoaderQueueTicket = p_loaderQueueTicketEvent.loaderQueueTicket;
				//trace("ldrQueueTicket.bitmap != null: " + (ldrQueueTicket.bitmap != null));
				if(ldrQueueTicket.bitmap != null)
				{
					var tileBitmap:Bitmap = ldrQueueTicket.bitmap;
					var rect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight);
					var point:Point = new Point(ldrQueueTicket.x, ldrQueueTicket.y);
					//trace("x: " + ldrQueueTicket.x + ", y: " + ldrQueueTicket.y);
					buffer_bitmap.bitmapData.copyPixels(tileBitmap.bitmapData, rect, point);
					
					//tileBitmap.bitmapData.dispose();
					
					invalidate();
				}
			}
		}
		
		public function invalidate():void
		{
			if(addedInvalidationListener == false)
			{
				addedInvalidationListener = true;
				beacon_sprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			repaint();
			beacon_sprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			addedInvalidationListener = false;
		}
		
		override public function repaint():void
		{
			super.repaint();
			
			/*
			trace("----------------------");
			trace("this.width: " + width);
			trace("this.height: " + height);
			trace("viewingRect.width: " + viewingRect.width);
			trace("bitmap.width: " + bitmap.width);
			trace("bitmap.bitmapData.width: " + bitmap.bitmapData.width);
			trace("buffer_bitmap.width: " + buffer_bitmap.width);
			trace("viewingPoint.x: " + viewingPoint.x);
			*/
			bitmap.bitmapData.copyPixels(buffer_bitmap.bitmapData, viewingRect, viewingPoint);
			
			// TODO: change this to a repaint event
			var moveEvent:BitmapSpriteMoveEvent = new BitmapSpriteMoveEvent(x, y, x, y);
			dispatchEvent(moveEvent);
		}
	}
}