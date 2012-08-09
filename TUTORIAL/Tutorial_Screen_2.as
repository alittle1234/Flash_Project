package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class Tutorial_Screen_2 extends MovieClip  
	{
		
		var mBoard:GameBoard;
		
		function Tutorial_Screen_2(board:GameBoard)
		{
			
			mBoard = board;
			
			addEventListener(Event.ENTER_FRAME, FrameEvent, false, 0, true);
			
			if ( mBoard.mLevel == 4 )
			{
				gotoAndStop( 2 );
			}
			else
			{
				gotoAndStop( 1 );
			}
			
		}
		
		function FrameEvent( e:Event )
		{
			
			if ( mBoard.mTowerAdd != null )
			{
				
				removeEventListener(Event.ENTER_FRAME, FrameEvent );
				
				var Tut = new Tutorial_Screen_3(mBoard);
				parent.addChild(Tut);
				
				parent.removeChild( this );
			}
			
			
		}
		
		
		
	}
	
}