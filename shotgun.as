package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class shotgun extends MovieClip
	{
		var time;
		
		public function shotgun() 
		{
			time = getTimer();
			addEventListener(Event.ENTER_FRAME, FrameEvents, false, 0, true);
		}
		
		function FrameEvents( e )
		{
			if ( getTimer() - 500 > time )
			{
				removeEventListener(Event.ENTER_FRAME, FrameEvents);
				parent.removeChild(this);
				
			}
		}
		
	}

}