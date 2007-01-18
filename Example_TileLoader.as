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
    
    Battlefield
    
    Battlefield is a sample tile engine that uses
    Diesel to create tile maps used for games.
	
	Example_TileLoader
	
	This shows how you can load a set of external
	bitmap tiles to a map.
	
	Got RAM?  This'll need it.
	
*/
package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.BitmapData;

	import com.jxl.diesel.view.core.BitmapSpriteDisplayObject;
	
	import com.jxl.battlefield.model.MDArray;
	import com.jxl.battlefield.view.DefaultTileMap;

	public class Example_TileLoader extends Sprite
	{
		
		private var tile_mdarray:MDArray;
		private var tileMap:DefaultTileMap;
		
		public function Example_TileLoader()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			tabEnabled = true;
			
			var defaultBitmapData:BitmapData = new BitmapData(480, 256, true, 0x00000000);
			var bsdo:BitmapSpriteDisplayObject = new BitmapSpriteDisplayObject(defaultBitmapData);
			addChild(bsdo);	
			
			tile_mdarray = new MDArray(16, 30);
			tileMap = new DefaultTileMap();
			tileMap.setViewableRange(16, 30);
			tileMap.setMDArray(tile_mdarray);
			bsdo.addBitmapSprite(tileMap);
			
			tileMap.loadExternalTiles(getTileMapImageName);
		}
		
		private function getTileMapImageName(p_row:int, p_col:int, value:Object):String
		{
			//trace("getTileMapImageName p_row: " + p_row + ", p_col: " + p_col + ", value: " + value);
			var img:String = "images/auenland/auenland_" + "r" + (p_row + 1) + "_c" + (p_col + 1) + ".png";
			//var img:String = "images/auenland/auenland_" + "r" + (p_row + 1) + "_c" + (p_col + 1) + ".jpg";
			return img;
		}
	}
}