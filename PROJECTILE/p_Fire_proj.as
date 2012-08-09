package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class p_Fire_proj extends MovieClip
	{
		var ChangeX;
		var ChangeY;
		var mSpeed;
		var mTimeAlive;
		var mBoard:GameBoard;
		
		public function p_Fire_proj( board:GameBoard) 
		{
			mBoard = board;
			
			ChangeX = 0;
			ChangeY = 0;
			mSpeed = 2;
			
			mTimeAlive = 100;  //frames
			
			addEventListener( Event.ENTER_FRAME, enterFrame, false, 0, true  );
		}
	
		function enterFrame( event:Event )
		{
			x += ChangeX * mSpeed * mBoard.mPlayer.mSpeed;
			y += ChangeY * mSpeed * mBoard.mPlayer.mSpeed;		
			
			mTimeAlive -= 1;
			
			if ( mTimeAlive <= 0 )
			{
				removeEventListener( Event.ENTER_FRAME, enterFrame);
				parent.removeChild(this);
			}
		}
	}

}