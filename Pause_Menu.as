package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class Pause_Menu extends MovieClip
	{
		var mContinue;
		var mQuit;
		var mBoard:GameBoard;
		
		public function Pause_Menu( board ) 
		{
			mBoard = board;
			
			mContinue = getChildByName("cont_game");
			mQuit = getChildByName("quit_main");
			
			mContinue.addEventListener(MouseEvent.CLICK, ClickMouse, false, 0, true  );
			mQuit.addEventListener(MouseEvent.CLICK, ClickMouse, false, 0, true  );
			
			mContinue.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true  );
			mQuit.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true  );
			
			mContinue.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true  );
			mQuit.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true  );
			
			mContinue.gotoAndStop(1);
			mQuit.gotoAndStop(1);
		}
		
		function ClickMouse( e:Event )
		{
			if ( e.target == mContinue )
			{
				mBoard.mMain.SOUND_STAGE.PlaySound("CLICK_PANEL" , 320);
				
				parent.removeChild(this);
				mBoard.mPauseMenu = null;
				mBoard.mPlayer.mPaused = false;
			}
			else if ( e.target == mQuit )
			{
				mBoard.mMain.SOUND_STAGE.PlaySound("CLICK_PANEL" , 320);		
				
				
				parent.removeChild(this);
				mBoard.mPauseMenu = null;
				mBoard.mPlayer.mPaused = false;
				
				mBoard.mQuit = true;
				
			}
		}
		
		function RollOver( event:Event )
		{
			
			mBoard.mMain.SOUND_STAGE.PlaySound("SOFT_HOVER" , 320);
			event.target.gotoAndStop( 2 );
			
		}
		
		function RollOff(event:MouseEvent):void 
		{
			event.target.gotoAndStop( 1 );
		}
		
	}

}