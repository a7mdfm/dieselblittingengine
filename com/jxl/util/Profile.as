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
    
    Profile
    
    Simple profiling class for timing how long code operations take.
    
    Sample usage:
    
    Profile.start();
    // some code
    var milliseconds:int = Profile.end();
    flash.util.trace("Took " + milliseconds + " milliseconds long to complete.");
	
*/
package com.jxl.util
{
	
	import flash.util.getTimer;
	
	public class Profile
	{
		
		private static var startTime:Number;
		
		public function Profile()
		{
			startTime = getTimer();
		}
		
		public static function start():Void
		{
			startTime = getTimer();
		}
		
		public static function end():Number
		{
			var currentTime:Number = getTimer();
			var elapsedTime:Number = currentTime - startTime;
			return elapsedTime;
		}
	}
}