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
    
    LoaderQueue
    
    Created a queue for doing multiple loads.  Since
    Loader is so useful, you can now load just about anything,
    but doing multiple loads is a pain.  So, I created
    this queue to allow you to throw tons of Loaders at it,
    and it'll load each sequentially.
    
    Bug in current alpha build of Flash Player 8.5 causes
    memory leak because Loaders are not removed from RAM
    when they are done.  Known and fixed in later build
    of Flash Player.
    
    TODO: better error handling
	
*/
package com.jxl.util
{
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	import com.jxl.util.LoaderQueueTicket;
	import com.jxl.util.LoaderQueueAddedEvent;
	import com.jxl.util.LoaderQueueRemovedEvent;
	import com.jxl.util.LoaderQueueTicketCompleteEvent;
	
	public class LoaderQueue extends EventDispatcher
	{
		
		private var queue_array:Array;
		private var processing:Boolean;
		private var waiting:Boolean;
		private var currentTicket:LoaderQueueTicket;
		private var mainLoader:Loader;
		
		public function LoaderQueue()
		{
			init();
		}
		
		public function init():void
		{
			trace("-----------------");
			trace("LoaderQueue::init");
			if(queue_array != null)
			{
				var i:int = queue_array.length;
				while(i--)
				{
					queue_array.splice(i, 1);	
				}
			}
			queue_array = [];
			mainLoader = new Loader();
			mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			//mainLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			mainLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			mainLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			mainLoader.contentLoaderInfo.addEventListener(Event.OPEN, onOpen);
			mainLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			mainLoader.contentLoaderInfo.addEventListener(Event.INIT, onInit);
			
			
			waiting = false;
			processing = false;
			currentTicket = null;
		}
		
		public function isProcessing():Boolean
		{
			trace("-----------------");
			trace("LoaderQueue::isProcessing");
			return processing;
		}
		
		public function isWaiting():Boolean
		{
			trace("-----------------");
			trace("LoaderQueue::isWaiting");
			return waiting;	
		}
		
		// Helper method
		public function addLoaderToQueue(p_request:URLRequest, p_x:Number=0, p_y:Number=0):void
		{
			trace("-----------------");
			trace("LoaderQueue::addLoaderToQueue");
			var len:int = queue_array.length;
			addLoaderToQueueAt(len, p_request, p_x, p_y);	
		}
		
		// Helper method
		public function addLoaderToQueueAt(p_index:int, p_request:URLRequest, p_x:Number=0, p_y:Number=0):void
		{
			trace("-----------------");
			trace("LoaderQueue::addLoaderToQueueAt");
			var lqt:LoaderQueueTicket = new LoaderQueueTicket(p_request, p_x, p_y);
			addLoaderTicketToQueueAt(p_index, lqt);
		}
		
		public function addLoaderTicketToQueue(p_loaderTicket:LoaderQueueTicket):void
		{
			trace("-----------------");
			trace("LoaderQueue::addLoaderTicketToQueue");
			var len:int = queue_array.length;
			addLoaderTicketToQueueAt(len, p_loaderTicket);
		}
		
		public function addLoaderTicketToQueueAt(p_index:int, p_loaderTicket:LoaderQueueTicket):void
		{
			trace("-----------------");
			trace("LoaderQueue::addLoaderTicketToQueueAt");
			queue_array[p_index] = p_loaderTicket;
			var e:LoaderQueueAddedEvent = new LoaderQueueAddedEvent(p_index, p_loaderTicket);
			dispatchEvent(e);
			processNext();
		}
		
		public function removeLoaderTickerFromQueueAt(p_index:int):void
		{
			trace("-----------------");
			trace("LoaderQueue::removeLoaderTickerFromQueueAt");
			// TODO: make more accurate
			queue_array.splice(p_index, 1);
			var lqre:LoaderQueueRemovedEvent = new LoaderQueueRemovedEvent(p_index);
			dispatchEvent(lqre);
			processNext();
		}
		
		public function getLoaderTicketInQueueAt(p_index:int):LoaderQueueTicket
		{
			trace("-----------------");
			trace("LoaderQueue::getLoaderTicketInQueueAt");
			var ldr:LoaderQueueTicket = LoaderQueueTicket(queue_array[p_index]);
			return ldr;
		}
		
		public function start():void
		{
			trace("-----------------");
			trace("LoaderQueue::start");
			processing = true;
			processNext();
		}
		
		public function stop():void
		{
			trace("-----------------");
			trace("LoaderQueue::stop");
			processing = false;
		}
		
		private function processNext():void
		{
			trace("------------");
			trace("LoaderQueue::processNext");
			if(processing == true)
			{
				trace("currentTicket == null: " + (currentTicket == null));
				if(currentTicket == null)
				{
					var len:int = queue_array.length;
					trace("len: " + len);
					if(len > 0)
					{
						trace("currentTicket: " + currentTicket);
						currentTicket = queue_array.shift();
						trace("currentTicket: " + currentTicket);
						
						waiting = true;
						trace("-----------");
						trace("Loading mofo: " + currentTicket.request.url);
						
						// adding unload only makes a small dent in memory usage
						//mainLoader.unload();
						
						mainLoader.load(currentTicket.request);
					}
					else
					{
					 	// no more to process
					 	processing = false;
					}
				}
			}
		}

		private function onComplete(event:Event):void
		{
			trace("-----------------");
			trace("LoaderQueue::onComplete");
			trace("x: " + currentTicket.x + ", y: " + currentTicket.y);
			//for(var p in mainLoader)
			//{
			//	trace(p + ": " + mainLoader[p]);	
			//}
			waiting = false;
			//var ticketClone:LoaderQueueTicket = currentTicket.clone();
			var ticketClone:LoaderQueueTicket = currentTicket;
			//trace("mainLoader.content: " + mainLoader.content);
			
			ticketClone.bitmap = Bitmap(mainLoader.content);
			releaseCurrentTicket();
			var lqtce:LoaderQueueTicketCompleteEvent = new LoaderQueueTicketCompleteEvent(ticketClone);
			dispatchEvent(lqtce);
			processNext();
		}

		private function onHTTPStatus(event:HTTPStatusEvent):void
		{
			trace("LoaderQueue::onHTTPStatus: " + event);
			waiting = false;
			releaseCurrentTicket();
			processNext();
		}

		private function onIOError(event:IOErrorEvent):void
		{
			trace("LoaderQueue::onIOError: " + event);
			waiting = false;
			releaseCurrentTicket();
			processNext();
		}

		private function onSecurityError(event:SecurityErrorEvent):void
		{
			trace("LoaderQueue::onSecurityError: " + event);
			waiting = false;
			releaseCurrentTicket();
			processNext();
		}
		
		private function onOpen(event:Event):void
		{
			//trace("LoaderQueue::onOpen");
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			//trace("LoaderQueue::onProgress");
		}
		
		private function onInit(event:Event):void
		{
			//trace("LoaderQueue::onInit");
		}
		
		private function releaseCurrentTicket():void
		{
			trace("-----------------");
			trace("LoaderQueue::releaseCurrentTicket");
			currentTicket = null;
		}
		
	}
	
	
	
	
	
}