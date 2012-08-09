package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class Tutorial_Screen_3 extends MovieClip  
	{
		
		var mBoard:GameBoard;
		var mFrame;
		
		function Tutorial_Screen_3(board:GameBoard)
		{
			
			mBoard = board;
			
			addEventListener(Event.ENTER_FRAME, FrameEvent, false, 0, true);
				
			mFrame = 0;
			
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
			mFrame += 1;
			
			if ( mFrame == 2 )
			{
				parent.swapChildren(this, parent.getChildAt(5) );
			}
			
			if ( (mBoard.mTowerAdd == null) && (mBoard.mTwrsOnBrd.size > 0) )
			{
				
				removeEventListener(Event.ENTER_FRAME, FrameEvent );
				
				var Tut = new Tutorial_Screen_4(mBoard);
				parent.addChild(Tut);
				
				parent.removeChild( this );
			}
			
			
		}
		
		
		
	}
	
}