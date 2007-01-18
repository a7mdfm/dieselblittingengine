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
    
    LoaderQueueTicketCompleteEvent
    
    When a LoaderQueueTicket contents are done loading and being set,
    this event is generated.
	
*/
package com.jxl.util
{
	import flash.events.Event;
	
	public class LoaderQueueTicketCompleteEvent extends Event
	{
		public static const COMPLETE:String = "LoaderQueueTicketCompleteEvent";
		
		public var loaderQueueTicket:LoaderQueueTicket;
		
		public function LoaderQueueTicketCompleteEvent(p_loaderQueueTicket:LoaderQueueTicket)
		{
			super(COMPLETE);
			loaderQueueTicket = p_loaderQueueTicket;
		}
		
		public override function clone():Event
		{
			return new LoaderQueueTicketCompleteEvent(loaderQueueTicket);
		}

		public override function toString():String
		{
			return formatToString(COMPLETE);
		}
	}
}