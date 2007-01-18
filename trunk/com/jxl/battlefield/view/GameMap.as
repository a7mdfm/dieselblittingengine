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
    
    GameMap
    
    Allows tilemaps to be created based on
    an external XML file.
	
*/

package com.jxl.battlefield.view
{
	import flash.util.trace;
	
	import com.jxl.battlefield.model.MDArray;
	import com.jxl.battlefield.view.WalkableMap;
	import com.jxl.battlefield.model.MapXMLParser;
	import com.jxl.battlefield.model.mapparsing.TileDescriptor;
	import com.jxl.battlefield.model.mapparsing.TilesDescriptor;
	import com.jxl.battlefield.model.mapparsing.SpriteDescriptor;
	import com.jxl.battlefield.events.MapXMLParsedEvent;
	
	public class GameMap extends WalkableMap
	{
		
		public var backgroundAudio:String;
		
		private var mapParser_xml:MapXMLParser;
		
		public function GameMap()
		{
			super();
		}
		
		public function loadMapXML2(filepath:String):Void
		{
			mapParser_xml = new MapXMLParser();
			mapParser_xml.addEventListener("MapXMLParsedEvent", onMapXMLParsed);
			mapParser_xml.loadMapXML(filepath);
			//var a:MapXMLParser = new MapXMLParser();
			//a.addEventListener("MapXMLParsedEvent", onMapXMLParsed);
			//a.loadMapXML(filepath);
		}
		
		private function onMapXMLParsed(event:MapXMLParsedEvent):Void
		{
			trace("onMapXMLParsed");
			//trace("GameMap::onMapXMLLoaded success=" + event.success);
			// Hack: This does not eloquently handle when the XML is loaded
			// twice, thus, I immediately remove the listener just in case
			//mapParser_xml.removeEventListener("MapXMLParsedEvent", onMapXMLParsed);
			
			backgroundAudio = event.backgroundAudio;
			
			var theRows:int = event.tilesDescriptor.rows;
			var theCols:int = event.tilesDescriptor.cols;
			var tileMod_array:Array = event.tilesDescriptor.tiles_array;
			
			var mapMDArray:MDArray = new MDArray(theRows, theCols);
			var walkableMDArray:MDArray = new MDArray(theRows, theCols);
			setMDArray(mapMDArray);
			setWalkableMDArray(walkableMDArray);
			
			var tileModLen:Number = tileMod_array.length;
			while(tileModLen--)
			{
				var tileMod:TileDescriptor = tileMod_array[tileModLen];
				map_mdarray.setCell(tileMod.row - 1, tileMod.col - 1, tileMod.value);
			}
			
			for(var r:int = 0; r<walkable_mdarray.rows; r++)
			{
				for(var c:int = 0; c<walkable_mdarray.cols; c++)
				{
					walkable_mdarray.setCell(r, c, null);
				}
			}
			
			// TODO: have character starting point in XML as well
			createCharacter(0, 0);
			
			var theSprites_array:Array = event.sprites_array;
			var spritesLen:Number = theSprites_array.length;
			while(spritesLen--)
			{
				var sprite_obj:SpriteDescriptor = theSprites_array[spritesLen];
				var theSprite:CharacterSprite = createSprite(sprite_obj.row - 1, sprite_obj.col - 1);
				theSprite.conversation_xml = sprite_obj.conversation_xml;
				//trace("created " + theSprite._name);
			}
			
			//dispatchEvent({type: "backgroundAudio", target: this, audio: event.background_audio});
			
			mapParser_xml = null;
			delete mapParser_xml;
		}
		
		
		
	}
}
