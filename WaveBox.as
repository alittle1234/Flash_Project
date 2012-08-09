package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author AARON
	 */
	
	
	
	public class WaveBox extends Wave_Box
	{
		
		
		var mFrames;
		
		public function WaveBox( frames )
		{
			super();
			
			mFrames = frames;
			
			x = 320;
			y = 50;
			
			mText = "JOHNSON ";
			
			mTxtFld.width = 500;
			mTxtFld.x = -250;
			
			mTxtFld.text = mText;
			
			var TXT:TextFormat = new TextFormat( "Gill Sans MT", 20, 0XFFFFFF, false, true, false );
			
			mTxtFld.setTextFormat(TXT);
			
			var SHAPE = getChildByName( "bkrd" );
			
			SHAPE.width = 640;
			SHAPE.height = 10;
			
			SHAPE.x = -1*width/2;
			SHAPE.y =  -1 * 15;
			
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
				this.alpha -= (0.1);
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
			
			
			
			var TXT:TextFormat = new TextFormat( "Gill Sans MT", 20, 0XFFFFFF, false, true, false );
			mTxtFld.setTextFormat(TXT);
			mTxtFld.text = mText;
			
			var SHAPE = getChildByName( "bkrd" );
			SHAPE.width = 640;
			SHAPE.height = 10;
			
			SHAPE.x = -1*width/2;
			SHAPE.y =  -1 * 5;
			
		}
		
		
	}
	
	
}