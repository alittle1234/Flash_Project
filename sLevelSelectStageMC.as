package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class sLevelSelectStageMC extends MovieClip
	{
		var mMain:Main;
		var mFadingOut;
		var mFadingIn;
		
		var mSkills_Tutorial:MovieClip;
		
		var Score1:TextField;
		var Score2:TextField;
		var Score3:TextField;
		var Score4:TextField;
		var Score5:TextField;
		var Score6:TextField;
		
		public function sLevelSelectStageMC( MAIN:Main ) 
		{
			trace (" Level Stage Loaded ");
			
			mSkills_Tutorial = null;
			
			
			addEventListener(Event.REMOVED_FROM_STAGE, beingRemoved, false, 0, true  );
			addEventListener(Event.ENTER_FRAME, DoFrameEvents, false, 0, true  );
			mMain = MAIN;
			
			mFadingOut = false;
			mFadingIn = true;
			alpha = 0;
			
			Score1 = TextField(getChildByName("score_1"));
			Score2 = TextField(getChildByName("score_2"));
			Score3 = TextField(getChildByName("score_3"));
			Score4 = TextField(getChildByName("score_4"));
			Score5 = TextField(getChildByName("score_5"));
			Score6 = TextField(getChildByName("score_6"));
			
			Score1.text = mMain.MAIN_PLAYER.mLevelHiScores[0];
			Score2.text = mMain.MAIN_PLAYER.mLevelHiScores[1];
			Score3.text = mMain.MAIN_PLAYER.mLevelHiScores[2];
			Score4.text = mMain.MAIN_PLAYER.mLevelHiScores[3];
			Score5.text = mMain.MAIN_PLAYER.mLevelHiScores[4];
			Score6.text = mMain.MAIN_PLAYER.mLevelHiScores[5];
			
		}
		
		function beingRemoved( event:Event ) : void
		{
			trace (" Level Stage UN-Loaded ");
			mMain.MAIN_PLAYER.mPaused = false;
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
			else
			{
				if ( mMain.blk )
				{
					mMain.opStage.removeChild( mMain.blk );
					mMain.blk = null;
				}
			}
			
			if ( mMain.MAIN_PLAYER.mLevel == 1 )
			{
				if ( mSkills_Tutorial == null )
				{
					mSkills_Tutorial = new Skills_Tutorial();
					addChild( mSkills_Tutorial );
				}
			}
			
			if ( mSkills_Tutorial )
			{
				if (mMain.MAIN_PLAYER.mPoints > 0 )
				{
					mSkills_Tutorial.gotoAndStop( 1 );
				}
				else
				{
					mSkills_Tutorial.gotoAndStop( 3 );
				}
			}
			
		}
		
	}

}