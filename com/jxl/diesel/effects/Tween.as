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
    
    Tween
    
    Converted the Macromedia Tween from Flash MX 2004.
    Since this is an ActionScript only project, I cannot
    use the mx tween that comes with Flex.
    
    I still don't think this is write; perhaps if AnimationPackage
    was converted to AS3, it'd be better.
	
*/

package com.jxl.diesel.effects
{
	import flash.events.EventDispatcher;
	//import flash.util.setInterval;
	//import flash.util.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import com.jxl.diesel.effects.TweenUpdateEvent;
	import com.jxl.diesel.effects.TweenEndEvent;
	
	
	
	public class Tween extends EventDispatcher
	{
	
		public static var ActiveTweens : Array = new Array();
		public static var Interval : Number = 10;
		public static var IntervalToken : Number;
		public static var TweenTimer:Timer;
		public static var Dispatcher : Object = new Object();
	
		public static function AddTween(tween : Tween) : void
		{
			//trace("--------------------");
			//trace("Tween::AddTween");
			tween.ID = ActiveTweens.length;
			ActiveTweens.push(tween);
			//if (IntervalToken==undefined) {
			if(TweenTimer == null)
			{
				//Dispatcher.DispatchTweens = DispatchTweens;
				//IntervalToken = setInterval(Dispatcher, DispatchTweens, Interval);
				if(TweenTimer != null)
				{
					TweenTimer.stop();
					TweenTimer = null;
				}
				TweenTimer = new Timer(Interval, 0);
				TweenTimer.addEventListener(TimerEvent.TIMER, DispatchTweens);
				TweenTimer.start();
			}
		}
	
		public static function RemoveTweenAt(index : Number) : void
		{
			
			var aT:Array = ActiveTweens;
	
			if (index>=aT.length || index<0) return;
			//trace("----------------------------");
			//trace("Tween::RemoteTweenAt, index: " + index);
			//trace("before: " + aT.length);
			aT.splice(index, 1);
			//trace("after: " + aT.length);
			var len:int = aT.length;
			for (var i:int=index; i<len; i++) {
				aT[i].ID--;
			}
			if (len==0)
			{
				//clearInterval(IntervalToken);
				//delete IntervalToken;
				TweenTimer.stop();
				TweenTimer = null;
			}
		}
	
		public static function DispatchTweens(event:TimerEvent) : void
		{
			// TODO: there is a bug in that aTween will be null sometimes
			// duplicate array perhaps?
			
			//trace("-----------------");
			//trace("Tween::DispatchTweens");
			var aT:Array = ActiveTweens;
			//trace("aT: " + aT);
			var len:int = aT.length;
			//trace("len: " + len);
			for (var i:int=0; i<len; i++)
			{
				var aTween:Tween = aT[i];
				if(aTween != null)
				{
					aTween.doInterval()
				}
			}
			//updateAfterEvent();
		}
	
	
		/* Tween
	
		   arguments :
				listenerObj (tweenListener obj)
				init (array of nums, or one num)
				end (array of num, or one num)
				[ dur (int msecs),]
	
			tweenListener interface is :
				function onTweenUpdate(tweenValue)
					parameter : tweenValues
								an Array of the current values in each dimension
				function onTweenEnd(tweenValue); */
	
	
		protected var listener : Object;
		protected var initVal:Object; // relaxed type to accommodate numbers or arrays
		protected var endVal:Object;
		protected var duration : Number = 3000;
		protected var arrayMode : Boolean;
		protected var startTime : Number;
	
		protected var updateFunc : Function;
		protected var endFunc : Function;
		protected var ID : Number;
	
		public function Tween(listenerObj:*, init:Object, end:Object, dur:int)
		{
	
			if ( listenerObj == undefined ) return;
			if (typeof(init) != "number") arrayMode = true;
	
			listener = listenerObj;
			initVal = init;
			endVal = end;
			//if (dur!=undefined) {
				duration = dur;
			//}
	
			startTime = getTimer();
	
			if ( duration==0 ) {
	 			endTween(); //doInterval() this called easingEq which got a div/by/zero
			} else {
				AddTween(this);
			}
		}
	
	
	
		public function doInterval():void
		{
			//trace("--------------------");
			//trace("doInterval");
			var curTime:Number = getTimer()-startTime;
			var curVal:Object = getCurVal(curTime);
			
			//trace("curTime: " + curTime + ", duration: " + duration);
			if (curTime >= duration)
			{
				endTween();
			} else {
				/*
				if (updateFunc!=undefined) {
					listener[updateFunc](curVal);
				} else {
					listener.onTweenUpdate(curVal);
				}
				*/
				// jxl
				var e:TweenUpdateEvent = new TweenUpdateEvent(curVal);
				dispatchEvent(e);
			}
		}
	
	
		private function getCurVal(curTime:Number):Object
		{
			if(arrayMode)
			{
				var returnArray:Array = new Array();
				for (var i:Number=0; i<initVal.length; i++) {
					returnArray[i] = easingEquation(curTime, initVal[i], endVal[i]-initVal[i], duration);
				}
				return returnArray;
			}
			else 
			{
				var o:Number =  Number(endVal) - Number(initVal);
				return easingEquation(curTime, Number(initVal), o, duration);
			}
		}
	
		public function endTween():void
		{
			/*
			if (endFunc!=undefined) {
				listener[endFunc](endVal);
			} else {
				listener.onTweenEnd(endVal);
			}
			*/
			var e:TweenEndEvent = new TweenEndEvent(endVal);
			dispatchEvent(e);
			RemoveTweenAt(ID);
		}
	
		// defaults to sin
		public function easingEquation(t:Number,b:Number,c:Number,d:Number):Number
		{
			return c/2 * ( Math.sin( Math.PI * (t/d-0.5) ) + 1 ) + b;
		}
	
	}
}