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
    
    DoneMovingEvent
    
    Event indicates when a sprite is done moving.
	
*/

package com.jxl.battlefield.events
{
	import flash.events.Event;

	public class DoneMovingEvent extends Event
	{
		public static const TYPE_DONE:String = "DoneMovingEvent";
		
		public function DoneMovingEvent()
		{
			super(TYPE_DONE);
		}
		
		public override function clone():Event
		{
			return new DoneMovingEvent();
		}

		public override function toString():String
		{
			return formatToString(TYPE_DONE);
		}
	}
}
