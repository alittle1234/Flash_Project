package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class Tutorial_Screen_6 extends MovieClip  
	{
		var mOk;
		var mBoard:GameBoard;
		
		function Tutorial_Screen_6(board:GameBoard)
		{
			
			mBoard = board;
			mOk = getChildByName("ok");
			
			
			mOk.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			mOk.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			mOk.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			mOk.gotoAndStop(1);
			
			
			if ( mBoard.mLevel == 4 )
			{
				gotoAndStop( 2 );
			}
			else
			{
				gotoAndStop( 1 );
			}
			
		}
		
		function clickHandler( e:Event )
		{
			
			if ( e.target == mOk )
			{
				mBoard.mSoundStage.PlaySound("CLICK_BUTTON" , 320);
				mOk.removeEventListener(MouseEvent.CLICK, clickHandler );
				
				
				
				parent.removeChild( this );
			}
			
			
		}
		
		function RollOver( event:Event )
		{
			
			mBoard.mSoundStage.PlaySound("SOFT_HOVER" , 320);
			event.target.gotoAndStop( 2 );
			
		}
		
		function RollOff(event:MouseEvent):void 
		{
			event.target.gotoAndStop( 1 );
		}
		
	}
	
}