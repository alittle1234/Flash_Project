package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author AARON
	 */
	
	
	
	public class Wave_Box extends MovieClip
	{
		
		var mText;
		var mTxtFld:TextField;
		
		var mFadingOut;
		var mFadingIn;
		
		public function Wave_Box(  )
		{
			
			mFadingOut = false;
			mFadingIn = true;
			alpha = 0;
			
			mTxtFld = TextField(getChildByName("txt"));
			mText = "0";
			addEventListener(Event.ENTER_FRAME, DoFrameEvents, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, RemoveEvents, false, 0, true);
		}
		
		function DoFrameEvents( e:Event )
		{
			
			if ( mFadingOut )
			{
				this.alpha -= (0.2);
				if ( alpha <= 0 )
				{
					parent.removeChild(this);
					
				}
			}
			
			if ( mFadingIn )
			{
				this.alpha += (0.2);
				if ( alpha >= 1 )
				{
					alpha = 1; 
					mFadingIn = false;
				}
			}
			
			
			mTxtFld.text = mText;
		}
		
		function RemoveEvents( e )
		{
			
			removeEventListener(Event.ENTER_FRAME, DoFrameEvents);
			removeEventListener(Event.REMOVED_FROM_STAGE, RemoveEvents );
		}
		
	}
	
	
}