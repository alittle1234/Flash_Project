package  
{
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class bHotkey_Button_Panel extends MovieClip
	{
		var mSlidingUp;
		var mSlidingDwn;
		var mUpY;
		var mDwnY;
		
		var mUp;
		
		var mSpeed;
		var mAccel;
		
		var mSelection;
		var mTimer;
		var mTimeUp;
		
		public function bHotkey_Button_Panel() 
		{
			mDwnY = 423;
			mUpY = 423 - 80;
			mSlidingUp = false;
			mSlidingDwn = false;
			
			mSpeed = 20;
			mAccel = mSpeed;
			
			mTimer = 300;
			mTimeUp = 0;
			
			addEventListener( Event.ENTER_FRAME, DoFrameEvents, false, 0, true  );
		}
		
		function DoFrameEvents( e:Event )
		{
			if ( mSlidingUp )
			{
				SlideUp();
			}
			else if ( mSlidingDwn )
			{
				SlideDwn();
			}
			
			if ( mAccel < 5 )
			{
				mAccel = 5;
			}
			
			if ( mUp )
			{
				if ( getTimer() - mTimeUp > mTimer )
				{
					mSlidingDwn = true;
				}
				
			}
			
		}
		
		function SlideUp()
		{
				y -= mAccel;
				mAccel--;
				if ( y < mUpY )
				{
					y = mUpY;
					mUp = true;
					mSlidingUp = false;
					mAccel = mSpeed;
					mTimeUp = getTimer();
				}
			
		}
		
		function SlideDwn()
		{
			y += mAccel;
			mAccel--;
			if ( y > mDwnY )
			{
				y = mDwnY;
				mUp = false;
				mSlidingDwn = false;
				mAccel = mSpeed;
			}
		}
	}

}