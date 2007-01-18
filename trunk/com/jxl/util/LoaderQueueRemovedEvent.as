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
    
    LoaderQueueRemovedEvent
    
    When a Loader or LoaderTicket is removed from a LoaderQueue,
    this event is generated.
	
*/
package com.jxl.util
{
	
	import flash.events.Event;
	
	public class LoaderQueueRemovedEvent extends Event
	{
		public static const REMOVED:String = "LoaderQueueRemovedEvent";
		
		public var index:int;
		
		public function LoaderQueueRemovedEvent(p_index:int)
		{
			super(REMOVED);
			index = p_index;
		}
		
		public override function clone():Event
		{
			return new LoaderQueueRemovedEvent(index);
		}

		public override function toString():String
		{
			return formatToString(REMOVED);
		}
	}
}