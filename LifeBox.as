package 
{
	

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author AARON
	 */
	
	
	
	public class LifeBox extends Life_Box
	{
		
		
		var mFrames;
		
		public function LifeBox( frames )
		{
			super();
			
			mFrames = frames;
			
			mCostFld = TextField(getChildByName("cost"));
			mCostText = "0";
			mTxtFld = TextField(getChildByName("txt"));
			
			mText = "LIFE!";
			mCostText = "-1";
			
			mTxtFld.text = mText;	
			mCostFld.text = mCostText;
		}
		
		override function DoFrameEvents( e:Event )
		{
			--mFrames;
			
			if ( mFrames <= 0 )
			{
				mFadingOut = true;
			}
			
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
			mCostFld.text = mCostText;
			
		}
		
		
	}
	
	
}