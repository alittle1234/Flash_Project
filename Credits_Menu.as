package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class Credits_Menu extends MovieClip
	{
		var mOk;
		
		var mFadingOut;
		var mFadingIn;
		
		public function Credits_Menu( ) 
		{
			
			mOk = getChildByName("OK");
			
			mOk.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			mOk.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			mOk.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			mOk.gotoAndStop(1);
			
			mFadingOut = false;
			mFadingIn = true;
			alpha = 0;
			addEventListener(Event.ENTER_FRAME, DoFrameEvents, false, 0, true);
			
		}
		
		function clickHandler( e:Event )
		{
			
			if ( e.target == mOk )
			{
				
				mOk.removeEventListener(MouseEvent.CLICK, clickHandler );
				mFadingOut = true;
			}
		}
		
		function RollOver( event:Event )
		{
			
			
			event.target.gotoAndStop( 2 );
			
		}
		
		function RollOff(event:MouseEvent):void 
		{
			event.target.gotoAndStop( 1 );
		}
		
		
		function DoFrameEvents( e:Event )
		{
			if ( mFadingOut )
			{
				this.alpha -= (0.05);
				if ( alpha <= 0 )
				{
					parent.removeChild(this);
					removeEventListener(Event.ENTER_FRAME, DoFrameEvents );
					
				}
			}
			
			if ( mFadingIn )
			{
				this.alpha += (0.05);
				if ( alpha >= 1 )
				{
					alpha = 1; 
					mFadingIn = false;
					
				}
			}
		}
		
	}

}