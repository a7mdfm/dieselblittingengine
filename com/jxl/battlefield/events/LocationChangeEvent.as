/*
    Battlefield
    version 0.0.1
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
    
    Event indicates when a sprite has changed tiles.
	
    This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

package com.jxl.battlefield.events
{
	import flash.events.Event;

	public class LocationChangeEvent extends Event
	{
		public static const TYPE_CHANGE:String = "LocationChangeEvent";
		
		public function LocationChangeEvent()
		{
			super(TYPE_CHANGE);
		}
		
		public override function clone():Event
		{
			return new LocationChangeEvent();
		}

		public override function toString():String
		{
			return formatToString(TYPE_CHANGE);
		}
	}
}
