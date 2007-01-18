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
    
    BitmapSpriteMoveEvent
    
    Generated when a BitmapSprite moves.
	
*/
package com.jxl.diesel.events
{
	import flash.events.Event;

	/*
		Class: diesel.events.BitmapSpriteMoveEvent
		
		Dispatched by BitmapSprite when its it's location on the parent BitmapSpriteDisplayObject is modified.
		
		Parameters:
		
			oldX - Previous position on the x axis of the parent BitmapSpriteDisplayObject.
			oldY - Previous position on the y axis of the parent BitmapSpriteDisplayObject.
			newX - New position on the x axis of the parent BitmapSpriteDisplayObject.
			newY - New position on the y axis of the parent BitmapSpriteDisplayObject.
		
		See also:
			
			<diesel.view.core.BitmapSprite>, <diesel.view.core.BitmapSpriteDisplayObject>
		
		Suggestions:
		
			- Shouldn't the oldx, oldy, newx, newy props be of type int?
			- The constant MOVE_TYPE is reversed compared to TYPE_CHANGE and TYPE_SIZE. 
	*/
	public class BitmapSpriteMoveEvent extends Event
	{
		/*
			Constant: MOVE_TYPE
		*/
		public static const MOVE_TYPE:String = "BitmapSpriteMoveEvent";
		
		/*
			Property: oldX
			
			The previous position of the BitmapSprite object on the x axis of the parent BitmapSpriteDisplayObject.
		*/
		public var oldX:Number;
		
		/*
			Property: oldY
			
			The previous position of the BitmapSprite object on the y axis of the parent BitmapSpriteDisplayObject.
		*/
		public var oldY:Number;
		
		/*
			Property: newX
			
			The new position of the BitmapSprite object on the x axis of the parent BitmapSpriteDisplayObject.
		*/
		public var newX:Number;
		
		/*
			Property: newY
			
			The new position of the BitmapSprite object on the y axis of the parent BitmapSpriteDisplayObject.
		*/
		public var newY:Number;
		
		public function BitmapSpriteMoveEvent(p_oldX:Number, p_oldY:Number, p_newX:Number, p_newY:Number)
		{
			super(MOVE_TYPE);
			oldX = p_oldX;
			oldY = p_oldY;
			newX = p_newX;
			newY = p_newY;
		}
		
		/*
			Method: clone
			
			Returns:
			
				(Event) A copy of the BitmapSpriteMoveEvent.
		*/
		public override function clone():Event
		{
			return new BitmapSpriteMoveEvent(oldX, oldY, newX, newY);
		}

		/*
			Method: toString
		*/
		public override function toString():String
		{
			return formatToString(MOVE_TYPE);
		}
	}
}
