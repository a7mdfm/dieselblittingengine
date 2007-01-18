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
    
    MoveDirectionEvent
    
    Event indicates when a sprite has moved
    one of the four directions (north, east,
    south, west).
	
*/

package com.jxl.battlefield.events
{
	import flash.events.Event;

	public class MoveDirectionEvent extends Event
	{
		public static const TYPE_MOVE:String = "MoveDirectionEvent";
		public var direction:int;
		
		public function MoveDirectionEvent(p_direction:int=0)
		{
			super(TYPE_MOVE);
			direction = p_direction;
		}
		
		public override function clone():Event
		{
			return new MoveDirectionEvent(direction);
		}

		public override function toString():String
		{
			return formatToString(TYPE_MOVE);
		}
	}
}
