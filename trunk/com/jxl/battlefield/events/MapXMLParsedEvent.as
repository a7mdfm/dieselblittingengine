/*
    Battlefield
    version 0.0.1
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
    
    Event indicates when the GameMap has finished
    parsing the map.xml.
	
    This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

package com.jxl.battlefield.events
{
	import flash.events.Event;
	
	import com.jxl.battlefield.model.mapparsing.TilesDescriptor;

	public class MapXMLParsedEvent extends Event
	{
		
		public var success:Boolean;
		public var backgroundAudio:String;
		public var tilesDescriptor:TilesDescriptor;
		public var sprites_array:Array;
		
		public function MapXMLParsedEvent()
		{
			super("MapXMLParsedEvent");
		}

		public override function clone():Event
		{
			return new MapXMLParsedEvent();
		}

		public override function toString():String
		{
			return formatToString("MapXMLParsedEvent");
		}
	}
}