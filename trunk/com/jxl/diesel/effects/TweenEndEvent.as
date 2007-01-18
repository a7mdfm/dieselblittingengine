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
    
    TweenEndEvent
    
    Event generated when a tween is finished.
	
*/

package com.jxl.diesel.effects
{
	import flash.events.Event;

	public class TweenEndEvent extends Event {
	
		public static const TWEEN_END:String = "TweenEndEvent";
		
		public var tweenValue:Object;
		
		public function TweenEndEvent(p_tweenValue:Object)
		{
			super(TWEEN_END);
			tweenValue = p_tweenValue;
		}
		
		public override function clone():Event
		{
			return new TweenEndEvent(tweenValue);
		}

		public override function toString():String
		{
			return formatToString(TWEEN_END);
		}	
	}
}