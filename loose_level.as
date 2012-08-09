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
	public class loose_level extends MovieClip
	{
		var mOk;
		
		var Kills:TextField;
		var XPEarned:TextField;
		var LivesLost:TextField;
		var XPHave:TextField;
		var XPNeed:TextField;
		
		var mFadingOut;
		var mFadingIn;
		
		var LvlUpPnt:Point;
		
		var mMainRef:Main;
			
		public function loose_level( stats:Array, main:Main ) 
		{
			// KILLS
			// XP EARNED
			// LIVES LOST
			// xp have
			// xp need
			
			mMainRef = main;
			
			mOk = getChildByName("ok");
			
			Kills = TextField(getChildByName("kills"));
			XPEarned = TextField(getChildByName("xp_earned"));
			LivesLost = TextField(getChildByName("lives_lost"));
			XPHave = TextField(getChildByName("xp_have"));
			XPNeed = TextField(getChildByName("xp_need"));
			
			Kills.text = stats[0];
			XPEarned.text = stats[1];
			LivesLost.text = stats[2];
			XPHave.text = stats[3];
			XPNeed.text = stats[4];
			
			var pnt = getChildByName("pnt");
			LvlUpPnt = new Point( pnt.x, pnt.y );
			pnt.parent.removeChild(pnt);
			
			if ( stats[3] > stats[4] )
			{
				var mov = new LeveledUp();
				addChild(mov);
				mov.x = LvlUpPnt.x;
				mov.y = LvlUpPnt.y;
			}
			
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
				mMainRef.SOUND_STAGE.PlaySound("CLICK_BUTTON" , 320);
				
				mOk.removeEventListener(MouseEvent.CLICK, clickHandler );
				mFadingOut = true;
			}
		}
		
		function RollOver( event:Event )
		{
			
			mMainRef.SOUND_STAGE.PlaySound("SOFT_HOVER" , 320);
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
				this.alpha -= (0.2);
				if ( alpha <= 0 )
				{
					parent.removeChild(this);
					removeEventListener(Event.ENTER_FRAME, DoFrameEvents );
					
					mMainRef.LoadAfterPlay();
				}
			}
			
			if ( mFadingIn )
			{
				this.alpha += (0.2);
				if ( alpha >= 1 )
				{
					alpha = 1; 
					mFadingIn = false;
					
					mMainRef.SOUND_STAGE.PlaySound("YOU_LOOSE_FINAL" , 320);
				}
			}
		}
		
	}

}