package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class HitEffectMC extends MovieClip
	{
		
		public function HitEffectMC() 
		{
			addEventListener(Event.ENTER_FRAME, enterFrame );
		}
		
		function enterFrame( event:Event )
		{
			//trace ("HIT.FX.FRMS: " + framesLoaded);
			if ( event.target == this )
			{
				
				if ( currentFrame == framesLoaded )
				{
					//trace ("HIT.REMOVE?: " + parent);
					parent.removeChild(this);
					removeEventListener(Event.ENTER_FRAME, enterFrame );
					
				}
			}
		}
	}

}