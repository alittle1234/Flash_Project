package  
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class LevelUpScreen extends MovieClip
	{
		var mLevelT:TextField;
		var mWisTempT:TextField;
		var mAgiTempT:TextField;
		var mStrTempT:TextField;
		var mXPT:TextField;
		var mXP_needT:TextField;
		var mPntsTempT:TextField;
		
		var mFadingOut;
		var mFadingIn;
		
		var mPlayer:Player;
		var mMain:Main;
		
		//--BUTTONS---------
		var mWis_up;
		var mWis_dwn;
		var mAgi_up;
		var mAgi_dwn;
		var mStr_up;
		var mStr_dwn;
		var mCancel;
		var mSave;
		
		var mInfoTxt:MovieClip;
		
		var mLvl;
		var mWisTmp;
		var mAgiTmp;
		var mStrTmp;
		var mXp;		// CURRENT XP OF PLAYER
		var mXp_need:Number;	// XP NEEDED TO LEVEL
		var mPntsTmp;
		
		var leveled;	// TAG IF NEED < HAVE  AND TEMP MOVIE CLIP FOR "YOU LEVELED UP!"
		
		var mWisMAX;
		var mAgiMAX;
		var mStrMAX;
		
		var mChar;
		
		var mSkills_Tutorial:MovieClip;
		
		public function LevelUpScreen( plyr:Player, main:Main ) 
		{
			mLevelT =  TextField(getChildByName("lvl"));
			mWisTempT =  TextField(getChildByName("wis"));
			mAgiTempT =  TextField(getChildByName("agi"));
			mStrTempT =  TextField(getChildByName("str"));
			mXPT =  TextField(getChildByName("xp"));
			mXP_needT =  TextField(getChildByName("xp_need"));
			mPntsTempT =  TextField(getChildByName("pts"));
			
			mMain = main;
			
			mPlayer = plyr;
			leveled = null;
			
			mFadingOut = false;
			mFadingIn = true;
			alpha = 0;
			
			mSkills_Tutorial = null;
			
			mLvl = mPlayer.mLevel;
			
			mWisMAX = mLvl;
			mAgiMAX = mLvl;
			mStrMAX = mLvl;
			
			mWis_up =  getChildByName("wis_up");
			mWis_dwn =  getChildByName("wis_dwn");
			mAgi_up =  getChildByName("agi_up");
			mAgi_dwn =  getChildByName("agi_dwn");
			mStr_up =  getChildByName("str_up");
			mStr_dwn =  getChildByName("str_dwn");
			mCancel = getChildByName("cancel");
			mSave = getChildByName("save");
			
			mInfoTxt = MovieClip(getChildByName("info_txt"));
			mInfoTxt.gotoAndStop(4);
			
			
			
			mWisTmp = mPlayer.mWisdom;
			mAgiTmp = mPlayer.mAgility;
			mStrTmp = mPlayer.mStrength;
			
			mXp = mPlayer.mXP;
			if ( mLvl > 14 )
			{
				mXp_need = mXp + 1;
			}
			else
			{
				mXp_need = mPlayer.mXpNeeded[mLvl];
			}
			
			mPntsTmp = mPlayer.mPoints;
			
			
			mChar = getChildByName("char");
			mChar.gotoAndStop( mLvl );
			
			addEventListener(Event.ENTER_FRAME, DoFrameEvents, false, 0, true );
			
			mWis_up.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true);
			mWis_dwn.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true );
			mAgi_up.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true );
			mAgi_dwn.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true );
			mStr_up.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true );
			mStr_dwn.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true );
			
			mWis_up.addEventListener( MouseEvent.MOUSE_OVER, mouseOver, false, 0, true );
			mWis_dwn.addEventListener( MouseEvent.MOUSE_OVER, mouseOver, false, 0, true );
			mAgi_up.addEventListener( MouseEvent.MOUSE_OVER, mouseOver, false, 0, true );
			mAgi_dwn.addEventListener( MouseEvent.MOUSE_OVER, mouseOver, false, 0, true );
			mStr_up.addEventListener( MouseEvent.MOUSE_OVER, mouseOver, false, 0, true );
			mStr_dwn.addEventListener( MouseEvent.MOUSE_OVER, mouseOver, false, 0, true );
			
			mInfoTxt.addEventListener( MouseEvent.MOUSE_MOVE, mouseOver, false, 0, true );
			
			mCancel.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true );
			mSave.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true );
			
			mCancel.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true  );
			mSave.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true  );
			
			mCancel.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true  );
			mSave.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true  );
			
			mCancel.gotoAndStop(1);
			mSave.gotoAndStop(1);
		}
		
		function mouseClick( e:Event )
		{
			if ( e.target == mWis_up )
			{
				trace ("WIS UP");
				if ( mPntsTmp > 0 )
				{
					if ( mWisTmp < mWisMAX)
					{
						mPntsTmp--;
						mWisTmp++;
						
						mMain.SOUND_STAGE.PlaySound("CLICK_TOWER" , 320);
					}
					
				}
			}
			
			else if ( e.target == mWis_dwn )
			{
				trace ("mWis_dwn");
				if ( mPntsTmp < mPlayer.mPoints )
				{
					if ( mWisTmp > mPlayer.mWisdom )
					{
						mPntsTmp++;
						mWisTmp--;
						
						mMain.SOUND_STAGE.PlaySound("CLICK_TOWER" , 320);
					}
				}
			}
			
			else if ( e.target == mAgi_up )
			{
				trace ("mAgi_up");
				if ( mPntsTmp > 0 )
				{
					if ( mAgiTmp < mAgiMAX)
					{
						mPntsTmp--;
						mAgiTmp++;
						
						mMain.SOUND_STAGE.PlaySound("CLICK_TOWER" , 320);
					}
					
				}
			}
			
			else if ( e.target == mAgi_dwn )
			{
				trace ("mAgi_dwn");
				if ( mPntsTmp < mPlayer.mPoints )
				{
					if ( mAgiTmp > mPlayer.mAgility )
					{
						mPntsTmp++;
						mAgiTmp--;
						
						mMain.SOUND_STAGE.PlaySound("CLICK_TOWER" , 320);
					}
				}
			}
			
			else if ( e.target == mStr_up )
			{
				trace ("mStr_up");
				if ( mPntsTmp > 0 )
				{
					if ( mStrTmp < mStrMAX)
					{
						mPntsTmp--;
						mStrTmp++;
						
						mMain.SOUND_STAGE.PlaySound("CLICK_TOWER" , 320);
					}
					
				}
			}
			
			else if ( e.target == mStr_dwn )
			{
				trace ("mStr_dwn");
				if ( mPntsTmp < mPlayer.mPoints )
				{
					if ( mStrTmp > mPlayer.mStrength )
					{
						mPntsTmp++;
						mStrTmp--;
						
						mMain.SOUND_STAGE.PlaySound("CLICK_TOWER" , 320);
					}
					
				}
			}
			
			else if ( e.target == mCancel )
			{
				mFadingOut = true;
				mMain.SOUND_STAGE.PlaySound("CLICK_BUTTON" , 320);
			}
			
			else if ( e.target == mSave )
			{
				mMain.SOUND_STAGE.PlaySound("CLICK_BUTTON" , 320);
				
				mPlayer.mAgility = mAgiTmp;
				mPlayer.mWisdom = mWisTmp;
				mPlayer.mStrength = mStrTmp;
				
				if ( mPntsTmp < mPlayer.mPoints ) 
				{
					mPlayer.mPntsSpent += mPlayer.mPoints;
					mPlayer.mPoints = mPntsTmp;
				}
				
				mPlayer.mLevel = mLvl;
				mPlayer.mXP = mXp;
				
				mPlayer.SetModifiers();
				
				mFadingOut = true;
				
				mMain.SavePlayerData();
				
				
			}
			
		}
		
		function mouseOver( e:Event )
		{
			if ( e.target == mWis_up )
			{
				mInfoTxt.gotoAndStop(1);
			}
			
			else if ( e.target == mWis_dwn )
			{
				mInfoTxt.gotoAndStop(1);
			}
			
			else if ( e.target == mAgi_up )
			{
				mInfoTxt.gotoAndStop(2);
			}
			
			else if ( e.target == mAgi_dwn )
			{
				mInfoTxt.gotoAndStop(2);
			}
			
			else if ( e.target == mStr_up )
			{
				mInfoTxt.gotoAndStop(3);
			}
			
			else if ( e.target == mStr_dwn )
			{
				mInfoTxt.gotoAndStop(3);
			}
			
			else {
				mInfoTxt.gotoAndStop(4);
			}
			
		}
		
		
		function DoFrameEvents( e:Event )
		{
			mLevelT.text = mLvl.toString();
			mWisTempT.text = mWisTmp.toString();
			mAgiTempT.text = mAgiTmp.toString();
			mStrTempT.text = mStrTmp.toString();
			mXPT.text = mXp.toString();
			mXP_needT.text = mXp_need.toString();
			mPntsTempT.text = mPntsTmp.toString();
			
			if ( mXp >= mXp_need )
			{
				if ( leveled == null )
				{
					// LEVEL UP
					mPlayer.LevelUp();
					
					mXp = mPlayer.mXP;
					
					mLvl = mPlayer.mLevel;
					mXp_need = mPlayer.mXpNeeded[mLvl];
					mPntsTmp = mPlayer.mPoints;
					
					mWisMAX = mLvl;
					mAgiMAX = mLvl;
					mStrMAX = mLvl;
					
					leveled = new m_leveled( mPlayer );
					parent.addChild(leveled);
					leveled.addEventListener( Event.REMOVED_FROM_STAGE, removedStage, false, 0, true  );
					
				}
			}
			
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
			
			if ( (mPlayer.mLevel == 1)  && (mPlayer.mPoints > 0) )
			{
				if ( mSkills_Tutorial == null )
				{
					mSkills_Tutorial = new Skills_Tutorial();
					addChild( mSkills_Tutorial );
				}
			}
			
			if ( mSkills_Tutorial )
			{				
				mSkills_Tutorial.gotoAndStop( 2 );				
			}
			
			mChar.gotoAndStop(mLvl);
			
		}
		
		function removedStage(e:Event) 
		{ 
			leveled = null; trace ("leftStage"); 
		}
		
		
		function RollOver( event:Event )
		{
			
			mMain.SOUND_STAGE.PlaySound("SOFT_HOVER" , 320);
			event.target.gotoAndStop( 2 );
			
		}
		
		function RollOff(event:MouseEvent):void 
		{
			event.target.gotoAndStop( 1 );
		}
		
	}

}