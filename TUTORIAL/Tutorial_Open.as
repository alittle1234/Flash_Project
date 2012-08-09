package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author AARON
	 */
	public class Tutorial_Open extends MovieClip 
	{
		
		var mOk;
		var mBack;
		var mBoard:GameBoard;
		
		function Tutorial_Open( board:GameBoard )
		{
			// TUTORIAL OPENS IF CONDITIONS ARE MET
			mBoard = board;
			mOk = getChildByName("ok");
			mBack = getChildByName("back");
			
			mOk.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			mOk.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			mOk.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			mOk.gotoAndStop(1);
			
			mBack.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			mBack.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			mBack.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			mBack.gotoAndStop(1);
			
		}
		
		
		function clickHandler( e:Event )
		{
			
			if ( e.target == mOk )
			{
				mBoard.mSoundStage.PlaySound("CLICK_BUTTON" , 320);
				mOk.removeEventListener(MouseEvent.CLICK, clickHandler );
				mBack.removeEventListener(MouseEvent.CLICK, clickHandler );
				
				var Tut = new Tutorial_Screen_1(mBoard);
				parent.addChild(Tut);
				
				parent.removeChild( this );
			}
			
			if ( e.target == mBack )
			{
				mBoard.mSoundStage.PlaySound("CLICK_BUTTON" , 320);
				mOk.removeEventListener(MouseEvent.CLICK, clickHandler );
				mBack.removeEventListener(MouseEvent.CLICK, clickHandler );
				
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