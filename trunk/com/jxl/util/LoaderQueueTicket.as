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
    
    LoaderQueueTicket
    
    The LoaderQueue uses LoaderQueueTickets to know what URL to load from
    and where to stuff the bitmap it loads.  The X and Y are there for
    those who create the tickets to know where the bitmap should be
    blitted to in the case of loading tilemaps.
	
*/
package com.jxl.util
{
	
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	
	public class LoaderQueueTicket
	{
		
		public var request:URLRequest;
		public var x:Number;
		public var y:Number;
		public var bitmap:Bitmap;
		
		public function LoaderQueueTicket(p_request:URLRequest, p_x:Number=0, p_y:Number=0)
		{
			request = p_request;
			x = p_x;
			y = p_y;
		}
		
		public function clone():LoaderQueueTicket
		{
			var meClone:LoaderQueueTicket = new LoaderQueueTicket(request, x, y);
			return meClone;
		}
	}
}