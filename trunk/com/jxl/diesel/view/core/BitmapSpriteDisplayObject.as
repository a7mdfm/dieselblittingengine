/*
    Diesel
    version 0.0.1
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
    ---------------------------------------------
    
    BitmapSpriteDisplayObject
    
    The core of the blitting engine for Diesel.  This class allows
    the adding and removal of BitmapSprites to it, much like the
    DisplayList does for DisplayObjects.  It blits the bitmaps
    from the BitmapSprites to it's main internal bitmap using
    copyPixels every frame there is an invalidation event.
    
    TODO: need to optimize
    
    Sample usage:
    
    var defaultBitmapData:BitmapData = new BitmapData(480, 256, true, 0x00000000);
	var bsdo:BitmapSpriteDisplayObject = new BitmapSpriteDisplayObject(defaultBitmapData);
	addChild(bsdo);
	
*/
package com.jxl.diesel.view.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	import com.jxl.diesel.view.core.BitmapSprite;
	import com.jxl.diesel.events.BitmapSpriteChangeEvent;
	import com.jxl.diesel.events.BitmapSpriteMoveEvent;
	import com.jxl.diesel.events.BitmapSpriteSizeEvent;
	
	/*
		Class: diesel.view.core.BitmapSpriteDisplayObject
		
		Parameters:
		
			bitmapData - (BitmapData) Optional.
			
		Suggestions:
		
			- There's a second argument in the removeBitmapSpriteAt() method that doesn't belong there.
			- A reference to the removed BitmapSprite instance could be returned in the removeBitmapSpriteAt() method.
			- One of the biggest optimization would be to redraw only the the regions that have been changed, 
				or maybe only the BitmapSprites that have been modified. There's some of that commented out in the 
				invalidate() method already.
				
		
	*/
	public class BitmapSpriteDisplayObject extends Bitmap
	{
		
		protected var renderList:Array;
		protected var buffer_bitmap:Bitmap;
		protected var invalidating:Boolean;
		protected var addedInvalidateListener:Boolean;
		
		private var holder_sprite:Sprite;
		private var beacon_sprite:Sprite;
		
		
		//private var invalidationRectList:Array;
		//private var invalidateAll:Boolean;
		
		public function BitmapSpriteDisplayObject(p_bitmapData:BitmapData=null)
		{
			super(p_bitmapData);
			init();
		}
		
		/*
			Method: init
			
			Resets the BitmapSpriteDisplayObject instance.
		*/
		public function init():void
		{
			//invalidateAll = false;
			//invalidationRectList = [];
			
			renderList = [];
			invalidating = false;
			addedInvalidateListener = false;
			
			var theWidth:Number = Math.max(width, 600);
			var theHeight:Number = Math.max(height, 600);
			//var theWidth:Number = 2880;
			//var theHeight:Number = 2880;
			var buffer_bitmapData:BitmapData = new BitmapData(theWidth, theHeight, true, 0xaaaaaaaa);
			buffer_bitmap = new Bitmap(buffer_bitmapData);
			
			holder_sprite = new Sprite();
			beacon_sprite = new Sprite();
			holder_sprite.addChild(beacon_sprite);
			
			bitmapData = buffer_bitmap.bitmapData.clone();
		}
		
		/*
			Method: numBitmapSpriteChildren
			
			Returns:
			
				(uint) The number of BitmapSprite currently in the render list.
		*/
		public function get numBitmapSpriteChildren():int
		{
			return renderList.length;	
		}
		
		/*
			Method: addBitmapSprite
		 
			Parameters:
			
				bitmapSprite - (BitmapSprite) A reference to the BitmapSprite 
								instance to add to the rendering list.
			
			See also:
			
				<addBitmapSpriteAt>, <diesel.view.core.BitmapSprite>
		*/
		public function addBitmapSprite(p_bitmapSprite:BitmapSprite):void
		{			
			addBitmapSpriteAt(renderList.length, p_bitmapSprite);	
		}
		
		/*
			Method: addBitmapSpriteAt
		 
			Parameters:
			
				index - (int) The index where to add the BitmapSprite instance.
				bitmapSprite - (BitmapSprite) A reference to the BitmapSprite 
								instance to add to the rendering list.
								
			See also:
			
				<addBitmapSprite>, <diesel.view.core.BitmapSprite>
		*/
		public function addBitmapSpriteAt(p_index:int, p_bitmapSprite:BitmapSprite):void
		{
			p_bitmapSprite.addEventListener(BitmapSpriteChangeEvent.TYPE_CHANGE, onSpriteBitmapChange);
			p_bitmapSprite.addEventListener(BitmapSpriteMoveEvent.MOVE_TYPE, onSpriteMove);
			p_bitmapSprite.addEventListener(BitmapSpriteSizeEvent.TYPE_SIZE, onSpriteSized);
			
			renderList[p_index] = p_bitmapSprite;
			invalidate();
		}
		
		/*
			Method: removeBitmapSpriteAt
			
			Parameters:
			
				index - (int) The index of the BitmapSprite instance to remove.
		*/
		public function removeBitmapSpriteAt(p_index:int, p_bitmapSprite:BitmapSprite):void
		{
			renderList.splice(p_index, 1);
			invalidate();	
		}
		
		/*
			Method: replaceBitmapSpriteAt
			
			Parameters:
			
				index - The index of the BitmapSprite to be replaced.
				bitmapSprite - Reference to the BitmapSprite instance
							that will replace the one at the indicated index.
								
			See also:
			
				<diesel.view.core.BitmapSprite>
		
		*/
		public function replaceBitmapSpriteAt(p_index:int, p_bitmapSprite:BitmapSprite):void
		{
			renderList.splice(p_index, 1, p_bitmapSprite);
			invalidate();	
		}
		
		/*
			Method: setBitmapSpriteIndex
			
			Parameters:
			
				bitmapSprite - Reference to the BitmapSprite instance that will 
							have its rendering order modified.
				index - The new index to be given to the BitmapSprite instance.
			
			See also:
			
				<getBitmapSpriteIndex>, <diesel.view.core.BitmapSprite>
		
		*/
		public function setBitmapSpriteIndex(p_bitmapSprite:BitmapSprite, p_index:int):void
		{
			renderList.splice(getBitmapSpriteIndex(p_bitmapSprite), 1);
			renderList.splice(p_index, 0, p_bitmapSprite);
			invalidate();
		}
		
		/*
			Method: getBitmapSpriteIndex
			
			Parameters:
			
				bitmapSprite - Reference to the BitmapSprite instance from
							which we want to retrieve the index.
			
			See also:
			
				<setBitmapSpriteIndex>, <diesel.view.core.BitmapSprite>
		
		*/
		public function getBitmapSpriteIndex(p_bitmapSprite:BitmapSprite):int
		{
			var i:int = renderList.length;
			while(i--)
			{
				if(renderList[i] == p_bitmapSprite)
				{
					return i;
				}
			}
			return -1;
		}
		
		/*
			Method: getBitmapSpriteAt
			
			Parameters:
			
				index - The index where to find the Bitmap instance.
				
			Returns:
			
				(BitmapSprite) Reference to the BitmapSprite located at the specified index.
		*/
		public function getBitmapSpriteAt(p_index:int):BitmapSprite
		{
			return renderList[p_index];	
		}
		
		public function redrawBitmap():void
		{
			//trace("redrawBitmap");
			var rectangle:Rectangle = new Rectangle(0, 0, buffer_bitmap.width, buffer_bitmap.height);
			buffer_bitmap.bitmapData.fillRect(rectangle, 0x00000000);
			
			var i:int = renderList.length;
			var c:int = -1;
			var bitmapSprite:BitmapSprite;
			var rect:Rectangle;
			var point:Point;
			while(i--)
			{
				c++;
				bitmapSprite = renderList[c];
				rect = new Rectangle(0, 0, bitmapSprite.width, bitmapSprite.height);
				//trace("bitmapSprite.x: " + bitmapSprite.x);
				point = new Point(bitmapSprite.x, bitmapSprite.y); 
				buffer_bitmap.bitmapData.copyPixels(bitmapSprite.getBitmapData(), rect, point);
			}
			
			var viewingPoint:Point = new Point(0, 0);
			var viewingRect:Rectangle = new Rectangle(0, 0, width, height);
			bitmapData.copyPixels(buffer_bitmap.bitmapData, viewingRect, viewingPoint);
			
			// temporary
			invalidating = false;
		}
		
		//public function invalidate(p_point:Point, p_rect:Rectangle):void
		/*
			Method: invalidate 
		
				Forces the BitmapSpriteDisplayObject to redraw on the next
				onEnterFrame event.
		*/
		public function invalidate():void
		{
			//trace("invalidate");
			if(invalidating == false)
			{
				invalidating = true;
				//setTimeout(redrawBitmap, 10);
			}
			//if(invalidateAll == true) return;
			
			//var o:Object = {point: p_point, rect: p_rect};
			//invalidationRectList.push(o);
			
			// uncomment for getting the movieclip enterFrame event
			//var gotAListener:Boolean = beacon_sprite.hasEventListener(Event.ENTER_FRAME);
			//trace("gotAListener: " + gotAListener);
			//if(gotAListener == false)
			//{
			if(addedInvalidateListener == false)
			{
				addedInvalidateListener = true;
				beacon_sprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			
		}
		/*
		public function invalidateAll():void
		{
			invalidateAll = true;
			invalidationRectList = [];
			if(hasEventListener(Event.ENTER_FRAME) removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		*/
		
		private function onEnterFrame(event:Event):void
		{
			//trace("onEnterFrame");
			redrawBitmap();
			
			//invalidateAll = false;
			//invalidationRectList = [];
			
			//if(beacon_sprite.hasEventListener(Event.ENTER_FRAME))
			//{
			//	trace("removing listener");
				beacon_sprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				addedInvalidateListener = false;
			//}
		}
		
		// events
		protected function onSpriteMove(event:Event):void
		{
			//trace("onSpriteMove");
			var bitmapSprite:BitmapSprite = BitmapSprite(event.target);
			//var theX:int = Math.min(event.oldX, event.newX);
			//var theY:int = Math.min(event.oldY, event.newY);
			//var theRight:int = Math.max(event.oldX, event.newX);
			//var theBottom:int = Math.max(event.oldY, event.newY);
			//var point:Point = new Point(theX, theY);
			//var rect:Rectangle = new Rectangle(theX, theY, theRight, theBottom);
			//invalidate(point, rect);
			invalidate();
			//redrawBitmap();
		}
		
		// TODO: create resize event
		protected function onSpriteSized(event:Event):void
		{
			invalidate();
		}
		
		protected function onSpriteBitmapChange(event:Event):void
		{
			//trace("BitmapSpriteDisplayObject::onSpriteBitmapChange");
			invalidate();
		}
	}
}