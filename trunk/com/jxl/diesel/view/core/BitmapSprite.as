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
    
    BitmapSprite
    
    The core display object for the Diesel blitting engine.
    BitmapSprite is merely a simplified version of Sprite,
    with x, y, width, and height values.  When these change
    an event is generated to allow the BitmapSpriteDisplayObject
    a chance to repaint the sprite's bitmap to the main display bitmap.
    
    When using Diesel, you extend BitmapSprite and add it to
    a BitmapSpriteDisplayObject, much like creating a Sprite and
    adding it to a DisplayObject.
    
    Sample usage:
    
    var defaultBitmapData:BitmapData = new BitmapData(480, 256, true, 0x00000000);
	var bsdo:BitmapSpriteDisplayObject = new BitmapSpriteDisplayObject(defaultBitmapData);
	addChild(bsdo);
	
	var myBoo:BitmapSprite = new BitmapSprite();
	bsdo.addBitmapSprite(myBoo);
	
*/
package com.jxl.diesel.view.core
{
	import flash.events.EventDispatcher;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import com.jxl.diesel.events.BitmapSpriteMoveEvent;
	import com.jxl.diesel.events.BitmapSpriteSizeEvent;
	import com.jxl.diesel.events.BitmapSpriteChangeEvent;

	/*
		Class: diesel.view.core.BitmapSprite
		
		Events:
		
			<diesel.events.BitmapSpriteChangeEvent>, <diesel.events.BitmapSpriteMoveEvent>, 
			<diesel.events.BitmapSpriteSizeEvent>
		
		Suggestions:
		
			- Shouldn't the x, y, width and height properties be of type *int*
				instead of Number?
			- Add methods to get and set the position based on a Point.
			- Add methods to get and set the size based on a Rect.
			- Add an argument to the constructor so that we can pass a bitmap from the creation.
			- Shouldn't the init() method *always* reset the internal Bitmap object?
	*/
	public class BitmapSprite extends EventDispatcher
	{
		
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _width:Number = 1;
		protected var _height:Number = 1;
		
		public var bitmap:Bitmap;
		
		public function BitmapSprite()
		{
			init();
		}
		
		/*
			Property: x
		
			Getter only. Retrieves the position in pixel on the x axis of the BitmapSprite on the screen.
			
			Returns:
			
				(Number) The position in pixel on the x axis of the BitmapSprite on the screen.
			
			See also:
			
				<y>
		*/
		public function get x():Number
		{
			return _x;	
		}
		
		/*
			Property: y
			
			Getter only. Retrieves the position in pixel on the y axis of the BitmapSprite on the screen.
			
			Returns:
			
				(Number) The position in pixel on the y axis of the BitmapSprite on the screen.
			
			See also:
			
				<x>
			
		*/
		public function get y():Number
		{
			return _y;
		}
		
		/*
			Property: width
			
			Getter only. Retrieves the width in pixel of the BitmapSprite.
			
			Returns:
			
				(Number) The width in pixel of the BitmapSprite.
		
			See also:
			
				<width>
		*/
		public function get width():Number
		{
			return _width;	
		}
		
		/*
			Property: height
			
			Getter only. Retrieves the height in pixel of the BitmapSprite.
			
			Returns:
			
				(Number) The height in pixel of the BitmapSprite.
				
			See also:
			
				<height>
		
		*/

		public function get height():Number
		{
			return _height;
		}
		
		/*
			Method: init
			
			Resets the BitmapSprite instance.
		*/
		public function init():void
		{
			if(bitmap == null)
			{
				var defaultBitmapData:BitmapData = new BitmapData(100, 100, false, 0x00000000);
				bitmap = new Bitmap(defaultBitmapData);
			}
			setBitmap(bitmap);
		}
		
		/*
			Method: move
			
			Sets the position of the BitmapSprite.

			Example:
			(code)
				var bs:BitmapSprite = new BitmapSprite();
				bs.move(50, 50, true);
			(end)
			
			Parameters:
			
				x - The desired position in pixel on the x axis of the BitmapSprite on the screen.
				y - The desired position in pixel on the y axis of the BitmapSprite on the screen.
				noEvent - If *true*, the BitmapSpriteMoveEvent won't be generated when the position of 
						the BitmapSprite is updated. *False* by default.
		
		*/
		public function move(p_x:Number, p_y:Number, noEvent:Boolean=false):void
		{
			var oldX:Number = _x;
			var oldY:Number = _y;
			_x = p_x;
			_y = p_y;
			if(noEvent == false)
			{
				//trace("dispatching move event");
				var moveEvent:BitmapSpriteMoveEvent = new BitmapSpriteMoveEvent(oldX, oldY, x, y);
				dispatchEvent(moveEvent);
			}
		}
		
		/*
			Method: setSize
			
			Parameters:
				
				width - The desired width, in pixels, of the BitmapSprite.
				height - The desired height, in pixels, of the BitmapSprite.
				noEvent - If *true*, the BitmapSpriteSizeEvent won't be generated when the position of 
						the BitmapSprite is updated. *False* by default.
		*/
		public function setSize(p_width:Number, p_height:Number, noEvent:Boolean=false):void
		{
			var oldWidth:Number = _width;
			var oldHeight:Number = _height;
			_width = p_width;
			_height = p_height;
			var resizedBitmapData:BitmapData = new BitmapData(_width, _height, false, 0x00000000);
			bitmap.bitmapData = resizedBitmapData;
			bitmap.width = _width;
			bitmap.height = _height;
			if(noEvent == false)
			{
				var sizeEvent:BitmapSpriteSizeEvent = new BitmapSpriteSizeEvent(oldWidth, oldHeight, _width, _height);
				dispatchEvent(sizeEvent);
			}
		}
		
		/*
			Method: setBitmap
			
			Assigns a Bitmap object to the BitmapSprite. If a previous Bitmap was 
			assigned to the BitmapSprite it will be overwritten. 
			
			Parameters:
			
				bitmap - Reference to a Bitmap object that will be used when 
						the repaint() method is called.
						
			See also:
			
				<getBitmap>, <getBitmapData>, <repaint>
		*/
		public function setBitmap(p_bitmap:Bitmap):void
		{
			//trace("-------------------------");
			//trace("BitmapSprite::setBitmap");
			bitmap = p_bitmap;
			_width = bitmap.width;
			_height = bitmap.height;
			//trace("_width: " + _width);
			//trace("_height: " + _height);
			
			var changeEvent:BitmapSpriteChangeEvent = new BitmapSpriteChangeEvent();
			dispatchEvent(changeEvent);
		}
		
		/*
			Method: getBitmap
			
			Returns:
			
				(Bitmap) Reference to the internal Bitmap object used by the BitmapSprite.
				
			See also:
			
				<setBitmap>, <getBitmapData>, <repaint>
		*/
		public function getBitmap():Bitmap
		{
			return bitmap;	
		}
		
		/*
			Method: getBitmapData
			
			Returns:
			
				(BitmapData) Reference to the internal BitmapData object of the Bitmap used by the BitmapSprite.
				
			See also:
			
				<setBitmap>, <getBitmap>, <repaint>
		*/
		public function getBitmapData():BitmapData
		{
			return bitmap.bitmapData;
		}
		
		/*
			Method: repaint
			
			Updates the view based on the BitmapData specified.
			
			See also:
			
				<setBitmap>, <getBitmap>, <getBitmapData>
		*/
		public function repaint():void
		{
			bitmap.bitmapData.fillRect(new Rectangle(0, 0, bitmap.bitmapData.width, bitmap.bitmapData.height), 0x00000000);
		}
		
	}
}