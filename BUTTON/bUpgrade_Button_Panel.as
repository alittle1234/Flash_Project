package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class bUpgrade_Button_Panel extends MovieClip
	{
		var slidingUp;
		var slidingDown;
		var Panel:MovieClip;
		var accel;
		var accel_const;
		var dist;		
		
		
		var mPlayer:Player;
		var mBoard:GameBoard;
		
		public function bUpgrade_Button_Panel( board:GameBoard ) 
		{
			mBoard = board;
			mPlayer = board.mPlayer;
			
			Panel = MovieClip( getChildByName("panel") );
			accel_const = 14;
			accel = accel_const;
			slidingDown = false;
			slidingUp = false;
			dist = 60;// Panel.height;		
			
			
			var but = Panel.getChildByName("button");
			but.gotoAndStop(1);
			but = null;
			
			addEventListener(Event.ENTER_FRAME, frameEvent, false, 0, true  );
		}
		
		function frameEvent( event:Event ):void
		{
			
			if ( slidingUp )
			{
				slideUp();
			}
			
			if ( slidingDown )
			{
				slideDown();
			}
			
			
		}
		
		
		function slideUp()
		{
			//trace ("sliding Up");
			if ( Panel.y <= -dist )
			{
				Panel.y = -dist;
				slidingUp = false;
				accel = accel_const;
			}
			else {
				Panel.y -= accel;
				--accel;
				if ( accel < 1)
				{
					accel = 1;
				}
			}
		}
		
		function slideDown()
		{
			if ( Panel.y > 0 )
			{
				Panel.y = 0;
				slidingUp = false;
				slidingDown = false;
				accel = accel_const;
			}
			else {
				Panel.y += accel;
				--accel;
				if ( accel < 1)
				{
					accel = 1;
				}
			}
		}
		
		
		
	}

}