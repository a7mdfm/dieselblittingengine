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
    
    LoaderQueueAddedEvent
    
    When a Loader or LoaderTicket is added to a LoaderQueue,
    this event is generated.
	
*/

package com.jxl.util
{
	import flash.events.Event;
	
	public class LoaderQueueAddedEvent extends Event
	{
		public static const ADDED:String = "LoaderQueueAddedEvent";
		
		public var index:int;
		public var loaderQueueTicket:LoaderQueueTicket;
		
		public function LoaderQueueAddedEvent(p_index:int, p_loaderTicket:LoaderQueueTicket)
		{
			super(ADDED);
			index = p_index;
			loaderQueueTicket = p_loaderTicket;
		}
		
		public override function clone():Event
		{
			return new LoaderQueueAddedEvent(index, loaderQueueTicket);
		}

		public override function toString():String
		{
			return formatToString(ADDED);
		}
	}
}