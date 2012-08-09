package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author AARON
	 */
	
	
	
	public class TimerMov extends MovieClip
	{
		var mBoard:GameBoard;
	
		var mTimeNow;
		var mTimeSpawn;
		var mTimeLastSpawn;
		
		var mText;
		var mTxtFld:TextField;
		
		var mFadingOut;

		public function TimerMov( board:GameBoard, time:Number )
		{
			mBoard = board;
			
			mTimeSpawn = time;
			mTimeLastSpawn = mBoard.mGlobalTimer;
			mTimeNow = mBoard.mGlobalTimer;
			
			mFadingOut = false;
			
			mTxtFld = TextField(getChildByName("txt"));
			
			addEventListener(Event.ENTER_FRAME, DoTime, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, RemoveEvents, false, 0, true);
			
			trace ("MADE A TIMER!!! " + mTimeSpawn + " NOW: "+ mTimeNow+ " LST: " +mTimeLastSpawn);
		}
		
		function DoTime( e:Event )
		{
			mTimeNow = mBoard.mGlobalTimer;
			
			mText = 0;
			mText = Math.floor( (mTimeSpawn - (mTimeNow - mTimeLastSpawn) ) / 1000 );
			//trace ("TIMING " + mTimeSpawn + " NOW: "+ mTimeNow+ " LST: " +mTimeLastSpawn);
		
			if ( mTimeNow - mTimeLastSpawn > mTimeSpawn )
			{
				mFadingOut = true;
				mText = "0";
			}
			
			if ( mFadingOut )
			{
				alpha -= (0.2);
				
				if ( alpha <= 0 )
				{
					parent.removeChild(this);
				}
			}
			
			mTxtFld.text = mText;
		}
		
		function RemoveEvents( e )
		{
			removeEventListener(Event.ENTER_FRAME, DoTime);
			removeEventListener(Event.REMOVED_FROM_STAGE, RemoveEvents );
		}
		
	}
	
	
}