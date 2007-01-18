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
    
    CharacterSprite
    
    Simple spite that can generate move envets
    as well as change it's facing direction.  Used
    mainly for NPC's on maps.
	
*/

package com.jxl.battlefield.view
{
	

	//import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	//import mx.core.UIComponent;
	//import mx.effects.Move;
	//import mx.events.TweenEvent;
	//import mx.effects.Tween;
	
	
	import com.jxl.battlefield.events.LocationChangeEvent;
	import com.jxl.battlefield.events.MoveDirectionEvent;
	import com.jxl.battlefield.events.DoneMovingEvent;
	
	import com.jxl.diesel.view.core.BitmapSprite;
	import com.jxl.diesel.effects.Tween;
	import com.jxl.diesel.effects.TweenEndEvent;
	import com.jxl.diesel.effects.TweenUpdateEvent;
	import flash.display.BitmapData;
	
	public class CharacterSprite extends BitmapSprite
	{
		
		public static const NORTH:int = 0;
		public static const EAST:int = 1;
		public static const SOUTH:int = 2;
		public static const WEST:int = 3;
		
		[Embed(source="../../../../images/Circle_NORTH.png")]
		public static const CIRCLE_NORTH_IMG:Class;
		[Embed(source="../../../../images/Circle_EAST.png")]
		public static const CIRCLE_EAST_IMG:Class;
		[Embed(source="../../../../images/Circle_SOUTH.png")]
		public static const CIRCLE_SOUTH_IMG:Class;
		[Embed(source="../../../../images/Circle_WEST.png")]
		public static const CIRCLE_WEST_IMG:Class;
		
		public var lastRow:int;
		public var lastCol:int;
		public var currentRow:int;
		public var currentCol:int;
		public var thinkSpeed:int = 4000; // milliseconds
		public var moveSpeed:int = 1000; // milliseconds
		
		private var _spriteName:String = "Circle";
		private var _facing:int = SOUTH;
		private var thinkID:Number;
		private var spriteMove:Tween;
		
		public var conversation_xml:String;
		
		//private var sprite_sp:Sprite;
		private var facing_loader:Loader;
		
		public function CharacterSprite()
		{
			super();
			
			//if(thinkID != null && !isNaN(thinkID))
			//{
			//	clearInterval(thinkID);
			//}
			
			facing_loader = new Loader();
			facing_loader.addEventListener(Event.COMPLETE, onImageLoadedComplete);
			updateFacing();
		}
		
		public function get facing():Number
		{
			return _facing;
		}
		
		public function set facing(val:Number):void
		{
			_facing = val;
			updateFacing();
		}
		
		public function get spriteName():String
		{
			return _spriteName;
		}
		
		public function set spriteName(val:String):void
		{
			_spriteName = val;
			updateFacing();
		}
		
		private function updateFacing():void
		{
			//trace("CharacterSprite::updateFacing");
			switch(facing)
			{
				case NORTH:
					//trace("facing NORTH");
					var northImg:CIRCLE_NORTH_IMG = new CIRCLE_NORTH_IMG();
					var ibd:BitmapData = new BitmapData(northImg.width, northImg.height, true, 0x00000000);
					var internalBitmap:Bitmap = new Bitmap(ibd);
					internalBitmap.bitmapData.draw(northImg, new Matrix());
					setBitmap(internalBitmap);
					break;
				
				case SOUTH:
					//trace("facing SOUTH");
					var southImg:CIRCLE_SOUTH_IMG = new CIRCLE_SOUTH_IMG();
					var ibd:BitmapData = new BitmapData(southImg.width, southImg.height, true, 0x00000000);
					var internalBitmap:Bitmap = new Bitmap(ibd);
					internalBitmap.bitmapData.draw(southImg, new Matrix());
					setBitmap(internalBitmap);
					break;
				
				case EAST:
					//trace("facing EAST");
					var eastImg:CIRCLE_EAST_IMG = new CIRCLE_EAST_IMG();
					var ibd:BitmapData = new BitmapData(eastImg.width, eastImg.height, true, 0x00000000);
					var internalBitmap:Bitmap = new Bitmap(ibd);
					internalBitmap.bitmapData.draw(eastImg, new Matrix());
					setBitmap(internalBitmap);
					break;
				
				case WEST:
					//trace("facing WEST");
					var westImg:CIRCLE_WEST_IMG = new CIRCLE_WEST_IMG();
					var ibd:BitmapData = new BitmapData(westImg.width, westImg.height, true, 0x00000000);
					var internalBitmap:Bitmap = new Bitmap(ibd);
					internalBitmap.bitmapData.draw(westImg, new Matrix());
					setBitmap(internalBitmap);
					break;
			}
			
			
			
			/*
			var clipName:String = "";
			switch(facing)
			{
				case NORTH:
					clipName = spriteName + "_NORTH";
					break;
				
				case SOUTH:
					clipName = spriteName + "_SOUTH";
					break;
				
				case EAST:
					clipName = spriteName + "_EAST";
					break;
				
				case WEST:
					clipName = spriteName + "_WEST";
					break;
			}
			
			var filepath:String = "images/" + clipName + ".png";
			var request:URLRequest = new URLRequest(filepath);
			trace("loading filepath: " + filepath);
			facing_loader.load(request);
			*/
		}
		
		private function onImageLoadedComplete(event:Event):void
		{
			setBitmap(Bitmap(facing_loader.content));
		}
		
		public function setLocation(p_row:Number, p_col:Number):void
		{
			//trace("Sprite::setLocation p_row: " + p_row + ", p_col: " + p_col);
			var changed:Boolean = false;
			//trace("before lastRow: " + lastRow + ", lastCol: " + lastCol);
			lastRow = currentRow;
			lastCol = currentCol;
			//trace("after lastRow: " + lastRow + ", lastCol: " + lastCol);
			
			if(lastRow != p_row)
			{
				changed = true;
			}
			currentRow = p_row;
			
			if(lastCol != p_col)
			{
				changed = true;
			}
			currentCol = p_col;
			
			if(changed == true)
			{
				dispatchEvent(new LocationChangeEvent());
			}
		}
		
		public function startThinking():void
		{
			//trace(name + " started thinking");
			
			// HACK: only needed for build 8.5.0.133, otherwise, comment out the "if null" stuff
			//if(thinkID != null && !isNaN(thinkID))
			//{
				clearInterval(thinkID);
			//}
			thinkID = setInterval(think, thinkSpeed);
		}
		
		public function stopThinking():void
		{
			//if(thinkID != null && !isNaN(thinkID))
			//{
				clearInterval(thinkID);
			//}
			//spriteMove.listener = null;
			//spriteMove.removeEventListener("onEnd", this);
			//spriteMove = null;
			//delete spriteMove;
			//trace(name + " stopped thinking");
		}
		
		private function think():void
		{
			//trace(name + " thinking");
			var randomDirection:int = Math.floor(Math.random() * 4);
			facing = randomDirection;
			var mde:MoveDirectionEvent = new MoveDirectionEvent();
			mde.direction = randomDirection;
			dispatchEvent(mde);
		}
		
		public function smoothMove(p_x:Number, p_y:Number):void
		{
			//trace("CharacterSprite::smoothMove");
			// TODO: convert this
			//move(p_x, p_y);
			//dispatchEvent(new DoneMovingEvent());
			//return;
			
			/*
			//trace("my lastRow: " + lastRow + ", lastCol: " + lastCol);
			//stopThinking();
			spriteMove = new Move();
			spriteMove.target = this;
			// TODO: figure this out
			spriteMove.addEventListener(TweenEvent.TWEEN_END, onDoneMoving);
			//spriteMove.animationStyle(moveSpeed, 
			//							Linear.easeOut);
			//spriteMove.run(p_x, p_y);
			spriteMove.xFrom = x;
			spriteMove.yFrom = y;
			spriteMove.xTo = p_x;
			spriteMove.yTo = p_y;
			spriteMove.playEffect();
			*/
			
			
			if(spriteMove != null)
			{
				spriteMove.removeEventListener(TweenUpdateEvent.TWEEN_UPDATE, onMoveTweenUpdate);
				spriteMove.removeEventListener(TweenEndEvent.TWEEN_END, onMoveTweenEnd);
				spriteMove.endTween();
				spriteMove = null;
			}
			spriteMove = new Tween(this, [x, y], [p_x, p_y], 1000);
			spriteMove.addEventListener(TweenUpdateEvent.TWEEN_UPDATE, onMoveTweenUpdate);
			spriteMove.addEventListener(TweenEndEvent.TWEEN_END, onMoveTweenEnd);
			
			
		}
		
		private function onMoveTweenUpdate(event:TweenUpdateEvent):void
		{
			var p_vals:Object = event.tweenValue;
			//trace("CharacterSprite::onMoveTweenUpdate, x: " + p_vals[0] + ", y: " + p_vals[1]);
			move(p_vals[0], p_vals[1]);
		}
		
		private function onMoveTweenEnd(event:TweenEndEvent):void
		{
			var p_vals:Object = event.tweenValue;
			move(p_vals[0], p_vals[1]);
			spriteMove = null;
			dispatchEvent(new DoneMovingEvent());
		}
		
	}
}

