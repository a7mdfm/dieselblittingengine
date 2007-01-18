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
    
    BitmapSpriteSizeEvent
    
    Generated when a BitmapSprite changes size.
	
*/
package com.jxl.diesel.events
{
	import flash.events.Event;

	/*
		Class: diesel.events.BitmapSpriteSizeEvent
		
		Dispatched when a BitmapSprite object changes size.
		
		Parameters:
		
			oldWith - The previous width in pixels of the BitmapSprite object.
			oldHeight - The previous height in pixels of the BitmapSprite object.
			newWidth - The new width in pixels of the BitmapSprite object.
			newHeight - The new height in pixels of the BitmapSprite object.
			
		See also:
		
			<diesel.view.core.BitmapSprite>, <diesel.view.core.BitmapSpriteDisplayObject>
	*/
	public class BitmapSpriteSizeEvent extends Event
	{
		/*
			Constant: TYPE_SIZE
		*/
		public static const TYPE_SIZE:String = "BitmapSpriteSizeEvent";
		
		/*
			Property: oldWith
			
			The previous width in pixels of the BitmapSprite object.
		*/
		public var oldWidth:Number;
		
		/*
			Property: oldHeight
			
			The previous height in pixels of the BitmapSprite object.
		*/
		public var oldHeight:Number;
		
		/*
			Property: newWidth
			
			The new width in pixels of the BitmapSprite object.
		*/
		public var newWidth:Number;
		
		/*
			Property: newHeight
			
			The new height in pixels of the BitmapSprite object.
		*/
		public var newHeight:Number;
		
		public function BitmapSpriteSizeEvent(p_oldWidth:Number, p_oldHeight:Number, p_newWidth:Number, p_newHeight:Number)
		{
			super(TYPE_SIZE);
			oldWidth = p_oldWidth;
			oldHeight = p_oldHeight;
			newWidth = p_newWidth;
			newHeight = p_newHeight;
		}
		
		/*
			Method: clone
			
			Returns:
			
				(Event) A copy of the BitmapSpriteSizeEvent object.
		*/
		public override function clone():Event
		{
			return new BitmapSpriteSizeEvent(oldWidth, oldHeight, newWidth, newHeight);
		}
		
		/*
			Method: toString
		*/
		public override function toString():String
		{
			return formatToString(TYPE_SIZE);
		}
	}
}
