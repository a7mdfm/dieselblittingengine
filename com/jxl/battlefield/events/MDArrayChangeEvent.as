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
    
    MDArrayChangeEvent
    
    Event indicates when a value in a
    multidimensional array has changed.
	
    
*/

package com.jxl.battlefield.events
{
	import flash.events.Event;

	public class MDArrayChangeEvent extends Event
	{
		public static const TYPE_CHANGE:String = "MDArrayChangeEvent";
		public var row:int;
		public var col:int;
		public var value:Object;
		
		public function MDArrayChangeEvent(p_row:int=-1, p_col:int=-1, p_value:Object=null)
		{
			super(TYPE_CHANGE);
			row = p_row;
			col = p_col;
			value = p_value;
		}

		public override function clone():Event
		{
			return new MDArrayChangeEvent(row, col, value);
		}

		public override function toString():String
		{
			return formatToString(TYPE_CHANGE);
		}
	}
}