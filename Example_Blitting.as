/*

	Just an example to show you blit using ActionScript 3 via a loaded image.

*/

package
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class Example_Blitting extends Sprite
	{
		public function Example_Blitting()
		{
			super();
			
			// path relative to SWF file OR base attribute in HTML
			var req:URLRequest = new URLRequest("images/Sabin.png");
			// Loader is a DisplayObject as opposed to URLLoader
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.load(req);
		}
		
		public function onComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var content:Bitmap = loaderInfo.content as Bitmap;
			// make him twice as big
			content.width *= 2;
			content.height *= 2;
			// this shows it
			addChild(content);
			
			// this blits it
			var bd:BitmapData = new BitmapData(400, 400, true, 0x00000000);
			var b:Bitmap = new Bitmap(bd);
			b.x = content.x + content.width;
			
			var rows:int = 10;
			var cols:int = 10;
			var origX:int = 0;
			var origY:int = 0;
			for(var r:int = 0; r<rows; r++)
			{
				for(var c:int = 0; c<cols; c++)
				{
					origX += content.bitmapData.width;
					var rect:Rectangle = new Rectangle(0, 0, content.bitmapData.width, content.bitmapData.height);
					var point:Point = new Point(origX, origY);
					bd.copyPixels(content.bitmapData, rect, point);
				}
				origX = 0;
				origY += content.bitmapData.height;
			}
			
			addChild(b);
		}
	}
}