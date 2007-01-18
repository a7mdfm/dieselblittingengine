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
    
    BitmapSpriteChangeEvent
    
    When a BitmapSprite has it's main bitmap change,
    this event is generated.
	
*/
package com.jxl.diesel.events
{
	import flash.events.Event;
	
	/*
		Class: diesel.events.BitmapSpriteChangeEvent
		
		Dispatched by BitmapSprite when its internal Bitmap is replaced or inited.
		
		See also:
		
			<diesel.view.core.BitmapSprite>, <diesel.view.core.BitmapSpriteDisplayObject>
	*/
	public class BitmapSpriteChangeEvent extends Event
	{
		/*
			Constant: TYPE_CHANGE
		*/
		public static const TYPE_CHANGE:String = "BitmapSpriteChangeEvent";
		
		public function BitmapSpriteChangeEvent()
		{
			super(TYPE_CHANGE);
		}
		
		/*
			Method: clone
			
			Returns:
			
				(Event) A new BitmapSpriteChangeEvent instance.
		*/
		public override function clone():Event
		{
			return new BitmapSpriteChangeEvent();
		}

		/*
			Method: toString
		*/
		public override function toString():String
		{
			return formatToString(TYPE_CHANGE);
		}
	}
}
