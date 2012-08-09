package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class bTower_Button_Panel extends MovieClip
	{
		var mMachGunBut;
		var mArrowSnpBut;
		var mRougeBut;
		var mBombBut;
		var mPoisonBut;
		var mSamuraiBut;
		var mFlashBut;
		var mSmokeBut;
		var mHealBut;
		var mFireTwrBut;
		
		var mMoneyBut;
		var mMoneyTxtF:TextField;
		var mSpeedBut;
		var mAutoBut;
		
		var mPauseBut;
		
		var mWaveField:TextField;
		
		var mLeft:Boolean;
		var mSlidingLeft:Boolean;
		var mSlidingRight:Boolean;
		var mRightX;
		var mLeftX;
		
		var mMoneyLeft:Boolean;
		var mMoneySlidingLeft:Boolean;
		var mMoneySlidingRight:Boolean;
		var mMoneyRightX;
		var mMoneyLeftX;
		
		var mAccel;
		var mSpeed;
		
		var mPlayer:Player;
		var mBoard:GameBoard;
		
		var mFlt_Box;
		
		var mNukeCost;
		
		// -- lifes------
		var slidingUp;
		var slidingDown;
		var Panel;
		var accel;
		var accel_const;
		var top_pos;
		var bot_pos;
		
		var lifeBut;
		var lifeText:TextField;
		// -- lifes------
		
		public function bTower_Button_Panel( plyr:Player, board:GameBoard ) 
		{
			var panel = getChildByName("panel");
			
			mPlayer = plyr;
			mBoard = board;
			
			mLeft = false;
			mRightX = 632;
			mLeftX = 632 - 80;
			mSlidingLeft = false;
			mSlidingRight = false;			
			
			// -- lifes------
			Panel =  new life_panel();
			Panel.x = 310;
			Panel.y = 440;
			mBoard.mGraphicsStage.addChild(Panel);
			
			accel_const = 14;
			accel = accel_const;
			slidingDown = false;
			slidingUp = false;
			top_pos = 380;// Panel.height;
			bot_pos = 440
			
			lifeBut = Panel.getChildByName("lives");
			lifeText = lifeBut.getChildByName("text_f");
			lifeText.text = mPlayer.mLives.toString();
			// -- lifes------
			
			mSpeed = 20;
			mAccel = mSpeed;
			
			mMachGunBut = panel.getChildByName("machine_gun");
			mArrowSnpBut = panel.getChildByName("arrow_sniper");
			mFireTwrBut = panel.getChildByName("fire_tower");
			mRougeBut = panel.getChildByName("rouge");
			mBombBut = panel.getChildByName("bomb");
			mPoisonBut = panel.getChildByName("poison");
			mSamuraiBut = panel.getChildByName("samurai");
			mFlashBut = panel.getChildByName("flash");
			mSmokeBut = panel.getChildByName("smoke");
			mHealBut = panel.getChildByName("heal");
			
			mMoneyBut = panel.getChildByName("money");
			mMoneyTxtF = mMoneyBut.getChildByName("t_field");
			mMoneyTxtF.text = mPlayer.mMoney.toString();
			
			
			mSpeedBut = panel.getChildByName("speed_but");
			mSpeedBut.gotoAndStop(1);
			mAutoBut = panel.getChildByName("autoplay");
			
			mPauseBut = panel.getChildByName("pause_but");
			mWaveField = panel.getChildByName("wave");
			
			mMoneyLeft = false;
			mMoneyRightX = mMoneyBut.x;
			mMoneyLeftX = mMoneyBut.x - 80;
			mMoneySlidingLeft = false;
			mMoneySlidingRight = false;
			
			mFlt_Box = mBoard.mFlt_Box;
			
			mAutoBut.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true  );
			mSpeedBut.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true  );
			mPauseBut.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true  );
			
			mRougeBut.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true  );			
			mRougeBut.addEventListener(MouseEvent.ROLL_OVER, MouseRollOver, false, 0, true );
			mRougeBut.addEventListener(MouseEvent.ROLL_OUT, MouseRollOut, false, 0, true );
			
			addEventListener( Event.ENTER_FRAME, DoFrameEvents, false, 0, true  );
			
			mWaveField.text = "WAVE 1";
			
			mRougeBut.gotoAndStop(1);
			if ( mPlayer.mLevel >= 12 )
			{
				trace ("PLAYER IS ABOVE 12");
				mRougeBut.gotoAndStop(2);				
			}
			mNukeCost = 650;
		}
		
		function DoFrameEvents( e:Event )
		{
			if ( mSlidingLeft )
			{
				slidingUp = true;
				SlideLeft();
			}
			else if ( mSlidingRight )
			{
				slidingDown = true;
				SlideRight();
			}
			
			if ( mAccel < 5 )
			{
				mAccel = 5;
			}
			
			
			
			if ( slidingUp )
			{
				slideUp();
			}
			
			if ( slidingDown )
			{
				slideDown();
			}
			
			
			if ( mMoneySlidingLeft )
			{
				
				MoneySlideLeft();
			}
			else if ( mMoneySlidingRight )
			{
				
				MoneySlideRight();
			}
			
			GetMoneyText();
			CheckStartImage();
			mWaveField.text = "WAVE " + (mBoard.mCurnWav + 1);
			
			// ROUGE BUTTON STUFF
			//	1.  LOCKED
			//	2.  READY
			//	3.  WARMING UP/MONEY (NOT AVAIL)
			if ( mPlayer.mLevel >= 12)
			{
					if ( mPlayer.mMoney >= (mNukeCost -( mNukeCost * mPlayer.mWisMod))  && ( mBoard.mGlobalTimer - mPlayer.mLastNukeTime > (60 * 1000) )  )
					{
							mRougeBut.gotoAndStop(2);	
					}
					else
					{
						mRougeBut.gotoAndStop(3);
					}
			}
			
		}
		
		function GetMoneyText()
		{
			
			mMoneyTxtF.text = addCommas( mPlayer.mMoney );
			
			lifeText.text = mPlayer.mLives.toString();
		}
		
		function addCommas(theNumber) 
		{
			var numString:String = String(theNumber+"");
			//convert # to string
			var newString = "";
			//return string
			var index = 1;
			// string index
			var trip = 0;
			// trip, as in triple.
			while (numString.length>=index) {
				if (trip != 3) {
					//haven't reached 3 chars yet
					newString = numString.charAt(numString.length-index)+newString;
					//add char
					index++;
					trip++;
				} else {
					//reached 3 chars, add comma
					newString = ","+newString;
					trip = 0;
				}
			}
			return (newString);
		}
		
		function mouseClick( e:Event )
		{
			if ( e.target == mSpeedBut )
			{
				
				mBoard.mMain.SOUND_STAGE.PlaySound("CLICK_PANEL" , 320);
				
				if ( !mBoard.mStart )
				{
					mBoard.mStart = true;
					mSpeedBut.gotoAndStop(2);
				}
				
				
				else if ( mPlayer.mSpeed == 1 )
				{
					mPlayer.mSpeed = 2;
					mSpeedBut.gotoAndStop(3);
				}
				else if ( mPlayer.mSpeed == 2 )
				{
					mPlayer.mSpeed = 3;
					mSpeedBut.gotoAndStop(4);
					
				}
				else if ( mPlayer.mSpeed == 3 )
				{
					mPlayer.mSpeed = 1;
					mSpeedBut.gotoAndStop(2);
				}
			}
			
			else if ( e.target == mAutoBut )
			{
				mBoard.mMain.SOUND_STAGE.PlaySound("CLICK_PANEL" , 320);
				if ( mBoard.mAutoPlay == true )
				{
					mBoard.mAutoPlay = false;
				}
				else
				{
					mBoard.mAutoPlay = true;
				}
			}
				
			else if ( e.target == mPauseBut )
			{
				trace ("clicking pause");
				if ( !mPlayer.mPaused )
				{
					mBoard.keyDownHandler( new KeyboardEvent( KeyboardEvent.KEY_DOWN, true, false, 32, 32) );
				}
				
			}
			
			else if ( e.target == mRougeBut )
			{
				if ( mPlayer.mLevel >= 12)
				{
					if ( mPlayer.mMoney >= (mNukeCost -( mNukeCost * mPlayer.mWisMod)) )
					{
						if ( mBoard.mGlobalTimer - mPlayer.mLastNukeTime > (60 * 1000) )
						{
							mBoard.mMain.SOUND_STAGE.PlaySound("NUKE_FULL_1" , 320);
							
							mPlayer.mMoney -= Math.floor(mNukeCost -( mNukeCost * mPlayer.mWisMod));
							 
							mPlayer.mNukeFrames = mPlayer.mNukeFrmStrt;
							mPlayer.mLastNukeTime = mBoard.mGlobalTimer;
							
							var timer = new TimerMov( mBoard, (60 * 1000) );
							timer.width = mRougeBut.width;
							timer.height = mRougeBut.height;
							timer.x = mRougeBut.x;
							timer.y = mRougeBut.y;
							mRougeBut.parent.addChild(timer);
						}
					}
					
				}
				
				
			}
		}
		
		function SlideLeft()
		{
			//trace ("PAN.X: " + x + " Mx: " + mLeftX);
			
				x -= mAccel;
				mAccel--;
				if ( x < mLeftX )
				{
					x = mLeftX;
					mLeft = true;
					mSlidingLeft = false;					
					mAccel = mSpeed;
				}
			
		}
		
		function SlideRight()
		{
			x += mAccel;
			mAccel--;
			if ( x > mRightX )
			{
				x = mRightX;
				mLeft = false;
				mSlidingRight = false;				
				mAccel = mSpeed;
			}
		}
		
		function slideUp()
		{
			//trace ("sliding Up");
			if ( Panel.y <= top_pos )
			{
				Panel.y = top_pos;
				slidingUp = false;
				accel = accel_const;
			}
			else 
			{
				Panel.y -= accel;
				--accel;
				if ( accel < 1)
				{
					accel = 1;
				}
			}
		}
		
		function slideDown()
		{
			if ( Panel.y > bot_pos )
			{
				Panel.y = bot_pos;
				slidingUp = false;
				slidingDown = false;
				accel = accel_const;
			}
			else 
			{
				Panel.y += accel;
				--accel;
				if ( accel < 1)
				{
					accel = 1;
				}
			}
		}
		
		
		function MoneySlideLeft()
		{
			if ( !mSlidingLeft || mLeft )
			{
				mMoneyBut.x -= mAccel;
				mAccel--;
				if ( mMoneyBut.x < mMoneyLeftX )
				{
					mMoneyBut.x = mMoneyLeftX;
					mMoneyLeft = true;
					mMoneySlidingLeft = false;
					mAccel = mSpeed;
				}
			}
		}
		
		function MoneySlideRight()
		{
			mMoneyBut.x += mAccel;
			mAccel--;
			if ( mMoneyBut.x > mMoneyRightX )
			{
				mMoneyBut.x = mMoneyRightX;
				mMoneyLeft = false;
				mMoneySlidingRight = false;
				mAccel = mSpeed;
			}
		}
		
		function CheckStartImage()
		{
			if ( mBoard.mStart )
			{
				if ( mPlayer.mSpeed == 1)
				{
					mSpeedBut.gotoAndStop(2);
				}
				else if ( mPlayer.mSpeed == 2)
				{
					mSpeedBut.gotoAndStop(3);
				}
				else if ( mPlayer.mSpeed == 3)
				{
					mSpeedBut.gotoAndStop(4);
				}
				else // a differnet speed
				{
					mSpeedBut.gotoAndStop(2);
				}
			}
			else
			{
				mSpeedBut.gotoAndStop(1);
			}
			
			if ( mBoard.mAutoPlay )
			{
				mAutoBut.gotoAndStop(1);
			}
			else
			{
				mAutoBut.gotoAndStop(2);
			}
			
		}
		
		function MouseRollOut( e:Event )
		{
			//trace ("ROLLING OUT!");
			if ( mFlt_Box )
			{
				mFlt_Box.mFadingOut = true;
				mFlt_Box.mFadingIn = false;
				mFlt_Box = null;
			}
		}
		
		function MouseRollOver( e:Event )
		{
			if ( e.target == mRougeBut )
			{
				mFlt_Box = new FloatingBox();
				
				// E.TARGET  IS A  BUTTON
				
				mFlt_Box.x = 480;
				mFlt_Box.y = mBoard.mMapSet.mouseY;
				
				mFlt_Box.mText = "Boom.";
				mFlt_Box.mCostText = "- " + (1000 -( 1000 * mPlayer.mWisMod));
				
				mBoard.mMapSet.addChild( mFlt_Box );
			}
		}
		
		
	}

}