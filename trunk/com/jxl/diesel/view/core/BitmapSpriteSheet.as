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
    
   	BitmapSpriteSheet
   	
   	JXL says: TODO: fill this out whoever created this class whenever you get around to it.
	
*/

package com.jxl.diesel.view.core
{
	import flash.util.trace;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.events.*;
	
	import com.jxl.diesel.view.core.BitmapSprite;
	
	/*
		TO DO:
		
			- Objects added to the sprite array are not currently of type BitmapSprite.
				I need to modify the algorythms so that they're not dealing directly with Bitmap objects.
	
	*/
	
	public class BitmapSpriteSheet extends EventDispatcher
	{
		private var _widthColorRef:uint;
		private var _heightColorRef:uint;
		private var _xRegistrationPointColorRef:uint;
		private var _yRegistrationPointColorRef:uint;
		private var _alphaChannelColorRef:uint;
		private var _cuePointColorRef:uint;
		private var _aSprites:Array;
		private var _aRegistrationPoints:Array;  //to be removed once the sprites are of BitmapSprite type
		private var _bmSheet:Bitmap;
		private var _cellWidth:uint;
		private var _cellHeight:uint;
		private var _scope:Sprite;
		
		private const _HEADER_HEIGHT:uint = 10;
		private const _HEADER_MARGIN:uint = 2;
		private const _COLOR_REF_SPACING:uint = 10;
		private const _MAX_SPRITE_SIZE:uint = 500;
		
		public function BitmapSpriteSheet(o:Sprite)
		{			
			_aSprites = new Array;
			_aRegistrationPoints = new Array();
			_scope = o;
		}
		
		public function load(url:String):void
		{
			var request:URLRequest = new URLRequest(url);
			var loader:Loader = new Loader();
			loader.addEventListener(Event.COMPLETE, _onLoad);
			loader.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
			loader.load(request);
		}
		
		public function getSprites(begin:uint, length:uint):Array
		{
			return _aSprites.slice(begin, begin+length-1);
		}
		
		
		/*
			TO DO:
			
				To be removed once the sprites are of BitmapSprite type.
		*/
		public function getRegistrationPoint(index:int):Point
		{
			return _aRegistrationPoints[index];
		}
		
		private function _onLoad(event:Event):void
		{
			var loader:Loader = Loader(event.target);
			_bmSheet = Bitmap(loader.content);
			
			_getColorReferences();
			_getCellSize();
			_processBitmap();
			
			var evt:Event = new Event("complete", false, false);
			dispatchEvent(evt);
		}
		
		private function _getColorReferences():void
		{
			_widthColorRef = _bmSheet.bitmapData.getPixel(_HEADER_MARGIN, _HEADER_MARGIN);
			_heightColorRef = _bmSheet.bitmapData.getPixel(_HEADER_MARGIN + _COLOR_REF_SPACING, _HEADER_MARGIN);
			_xRegistrationPointColorRef = _bmSheet.bitmapData.getPixel(_HEADER_MARGIN + _COLOR_REF_SPACING*2, _HEADER_MARGIN);
			_yRegistrationPointColorRef = _bmSheet.bitmapData.getPixel(_HEADER_MARGIN + _COLOR_REF_SPACING*3, _HEADER_MARGIN);
			_alphaChannelColorRef = _bmSheet.bitmapData.getPixel(_HEADER_MARGIN + _COLOR_REF_SPACING*4, _HEADER_MARGIN);
			_cuePointColorRef = _bmSheet.bitmapData.getPixel(_HEADER_MARGIN + _COLOR_REF_SPACING*5, _HEADER_MARGIN);
		}

		private function _getCellSize():void
		{
			var x:uint = 0;
			var y:uint = _HEADER_HEIGHT;
			var width:uint = 1;
			var height:uint = _HEADER_HEIGHT+1;
			
			while(true)
			{
				if(_bmSheet.bitmapData.getPixel(width, y) == _cuePointColorRef)
				{
					break;
				}
				else
				{
					if(width > _MAX_SPRITE_SIZE)
					{
						break;
					}
					else
					{
						width++;
					}	
				}
			}
			
			while(true)
			{
				if(_bmSheet.bitmapData.getPixel(x, height) == _cuePointColorRef)
				{
					break;
				}
				else
				{
					if(height > _MAX_SPRITE_SIZE)
					{
						break;
					}
					else
					{
						height++;
					}
				}
			}
			
			_cellWidth = width;
			_cellHeight = height - _HEADER_HEIGHT;
		}
		
		private function _processBitmap():void
		{
			for(var i:uint=0; i<_bmSheet.height; i += _cellHeight)
			{
				for(var j:uint=0; j<_bmSheet.width; j += _cellWidth)
				{
					var img:Bitmap = new Bitmap(new BitmapData(_cellWidth, _cellHeight, true, 0x00000000));
					_generateRegistrationModifier(new Point(j, i+_HEADER_HEIGHT));
					//var copied:BitmapData = new BitmapData(150, 150, true, 0x00000000).copyPixels(image.bitmapData, new Rectangle(150, 150), new Point(0,0));
					img.bitmapData.copyPixels(_bmSheet.bitmapData, new Rectangle(j, i+_HEADER_HEIGHT, _cellWidth, _cellHeight), new Point(0,0));
					_aSprites.push(img);
				}
			}
		}
		
		
		
		private function _generateRegistrationModifier(p:Point):void
		{
			var x:int = 0;
			var y:int = 0;
			var img:Bitmap = new Bitmap(new BitmapData(_cellWidth, _cellHeight, false, 0x00000000));
			img.bitmapData.copyPixels(_bmSheet.bitmapData, new Rectangle(p.x, p.y, _cellWidth, _cellHeight), new Point(0,0));
			
			while(true)
			{
				//trace(img.bitmapData.getPixel(x, 0));
				if(img.bitmapData.getPixel(x, 0) == _xRegistrationPointColorRef)
				{
					break;
				}
				else
				{
					if(x > _MAX_SPRITE_SIZE)
					{
						break;
					}
					else
					{
						x++;
					}	
				}
			}
			
			while(true)
			{
				if(img.bitmapData.getPixel(0, y) == _yRegistrationPointColorRef)
				{
					break;
				}
				else
				{
					if(y > _MAX_SPRITE_SIZE)
					{
						break;
					}
					else
					{
						y++;
					}	
				}
			}
			//trace(x+", "+y);
			
			_aRegistrationPoints.push(new Point(x, y));
			//return new Point(x, y);
		}
		
		private function _onIOError(event:Event):void
		{
			trace("IO error: "+event);
		}
	}
}