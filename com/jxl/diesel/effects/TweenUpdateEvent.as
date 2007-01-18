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
    
    Event generated when a tween updates.
	
*/

package com.jxl.diesel.effects
{
	import flash.events.Event;

	public class TweenUpdateEvent extends Event
	{
		public static const TWEEN_UPDATE:String = "TweenUpdateEvent";
		
		public var tweenValue:Object;
		
		public function TweenUpdateEvent(p_tweenValue:Object=null)
		{
			super(TWEEN_UPDATE);
			tweenValue = p_tweenValue;
		}
		
		public override function clone():Event
		{
			return new TweenUpdateEvent(tweenValue);
		}

		public override function toString():String
		{
			return formatToString(TWEEN_UPDATE);
		}
		
	}
}