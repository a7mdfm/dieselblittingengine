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
    
    MDArray
    
    Multidimensional array.  Originally ported from
    Tab Julius Lingo! to Flash 5.  Now ported to
    ActionScript 3.  Used to hold map data.  Faster
    than multiple arrays because it only uses 1 array
    vs. arrays within arrays.
	
*/

package com.jxl.battlefield.model
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.jxl.battlefield.events.MDArrayChangeEvent;
	
	public class MDArray extends EventDispatcher
	{
		public var rows:uint;
		public var cols:uint;
		private var totalCells:Number;
		private var _array:Array;
		
		public function MDArray(p_rows:uint, p_cols:uint, optional:Object=null)
		{
			init(p_rows, p_cols, optional);
		}
		
		public function get length():Number
		{
			return _array.length;
		}
		
		public function init(pRows:Number, pCols:Number, optional:Object=null):void
		{
			_array = [];
			rows = pRows;
			cols = pCols;
			
			/*
			if(optional == null)
			{
				for(var r:uint=0; r<rows; r++){
					_array[r]= [];
					for(var c:uint=0; c<cols; c++){
						_array[r][c] = 0;
					}
				}
			}
			else
			{
				for(var r:uint=0; r<rows; r++){
					_array[r] = [];
					for(var c:uint=0; c<cols; c++){
						_array[r][c] = optional;
					}
				}
			}
			*/
			for(var r:uint=0; r<rows; r++){
				_array[r] = [];
				for(var c:uint=0; c<cols; c++){
					_array[r][c] = optional;
				}
			}
		}
		
		public function setCell(r:uint, c:uint, whichValue:Object):void
		{
			_array[r][c] = whichValue;
			var mce:MDArrayChangeEvent = new MDArrayChangeEvent();
			mce.row = r;
			mce.col = c;
			mce.value = whichValue;
			dispatchEvent(mce);
		}
		
		public function getCell(r:uint, c:uint):Object
		{
			var cellValue:Object = _array[r][c];
			return cellValue;
		}
		
		/*
		// IEventDispatcher
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0) : void
		{
			ed.addEventListener(type, listener, useCapture, priority);
		}
		
		public function dispatchEvent(event:Event) : Boolean
		{
			return ed.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String) : Boolean
		{
			return ed.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
		{
			ed.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String) : Boolean
		{
			return ed.willTrigger(type);
		}
		*/
	}
}