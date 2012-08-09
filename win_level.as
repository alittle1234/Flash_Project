package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.display.LoaderInfo;
	import mochi.as3.*;
	/**
	 * ...
	 * @author AARON
	 */
	public class win_level extends MovieClip
	{
		var mOk;
		
		var Kills:TextField;
		var XPEarned:TextField;
		var LivesLost:TextField;
		var XPHave:TextField;
		var XPNeed:TextField;
		var XPBonus:TextField;
		
		var MoneyLeft:TextField;
		var TimeElapsed:TextField;
		
		var HiScore:TextField;
		var ThisScore:TextField;
		
		var mTimeStart;
		var mTimeStop;
		var mMoney;
		
		var mStats:Array;
		
		var mFadingOut;
		var mFadingIn;
		
		var LvlUpPnt:Point;
		
		var mMainRef:Main;
		
		public function win_level( stats:Array, main:Main ) 
		{
			// KILLS
			// XP EARNED
			// LIVES LOST
			// xp have
			// xp need
			// bonus
			mMainRef = main;
			
			mStats = stats;
			
			mOk = getChildByName("ok");
			
			Kills = TextField(getChildByName("kills"));
			XPEarned = TextField(getChildByName("xp_earned"));
			LivesLost = TextField(getChildByName("lives_lost"));
			XPHave = TextField(getChildByName("xp_have"));
			XPNeed = TextField(getChildByName("xp_need"));
			XPBonus = TextField(getChildByName("xp_bonus"));
			
			HiScore = TextField(getChildByName("hi_score"));
			ThisScore = TextField(getChildByName("this_score"));
			
			MoneyLeft = TextField(getChildByName("money"));
			TimeElapsed = TextField(getChildByName("time"));
			
			Kills.text = stats[0];
			XPEarned.text = stats[1];
			LivesLost.text = stats[2];
			XPHave.text = stats[3];
			XPNeed.text = stats[4];
			XPBonus.text = stats[5];
			
			MoneyLeft.text = stats[9];
			TimeElapsed.text = String(  Math.round( (stats[8] - stats[7]) / 1000 ) ) + " sec";
			
			//-------------
			// 6 = levl
			// 7 = time start
			// 8 = time end
			// 9 = money
			//var score = (Kills * 5) + (MONEy * 2) - (sec elapsed)
			
			ThisScore.text = String(  Math.round( ( stats[0] * 5 ) + (stats[9] * 2) - ( (stats[8] - stats[7]) / 1000 ) )  );
			
			if ( Math.round( ( stats[0] * 5 ) + (stats[9] * 2) - ( (stats[8] - stats[7]) / 1000 ) ) >
					mMainRef.MAIN_PLAYER.mLevelHiScores[ stats[6] - 1 ] )
					{
						mMainRef.MAIN_PLAYER.mLevelHiScores[ stats[6] - 1 ] = 
							Math.round( ( stats[0] * 5 ) + (stats[9] * 2) - ( (stats[8] - stats[7]) / 1000 ) );
							
						
					}
			SubmitScore();
			HiScore.text = mMainRef.MAIN_PLAYER.mLevelHiScores[ stats[6] - 1 ];
			//-------------
			
			
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
				this.alpha -= (0.05);
				if ( alpha <= 0 )
				{
					parent.removeChild(this);
					removeEventListener(Event.ENTER_FRAME, DoFrameEvents );
					
					trace ("CALLING LOAD FROM WIN_SCREEN");
					mMainRef.LoadAfterPlay();
				}
			}
			
			


			if ( mFadingIn )
			{
				this.alpha += (0.05);
				if ( alpha >= 1 )
				{
					alpha = 1; 
					mFadingIn = false;
					
			
					mMainRef.SOUND_STAGE.PlaySound("CHEER_FINAL" , 320);
				}
			}
		}
		
		function SubmitScore()
		{
			//Math.round( ( stats[0] * 5 ) + (stats[9] * 2) - ( (stats[8] - stats[7]) / 1000 ) );
			
			var names:Array = [ "CITY", "SAND", "SHORE", "SUBURBS", "FOREST", "PORTAL" ];
			var player_score = Math.round( ( mStats[0] * 5 ) + (mStats[9] * 2) - ( (mStats[8] - mStats[7]) / 1000 ) );
			
			/////////mochi///////////////////////
			var o:Object;			
			switch ( mStats[6] )
			{
				case 1:
				{
					o = { n: [10, 2, 4, 13, 4, 1, 9, 14, 15, 10, 11, 13, 3, 12, 6, 9],
					f: function (i:Number, s:String):String { if (s.length == 16) return s; return this.f(i + 1, s + this.n[i].toString(16)); }};
					
					break;
				}
				
				case 2:
				{
					o = { n: [13, 9, 0, 14, 5, 6, 10, 15, 13, 1, 13, 0, 15, 13, 15, 6],
					f: function (i:Number, s:String):String { if (s.length == 16) return s; return this.f(i + 1, s + this.n[i].toString(16)); }};
					
					break;
				}
				
				case 3:
				{
					o  = { n: [2, 7, 7, 8, 12, 10, 12, 10, 12, 4, 0, 15, 0, 7, 5, 4],
					f: function (i:Number, s:String):String { if (s.length == 16) return s; return this.f(i + 1, s + this.n[i].toString(16)); }};
					
					break;
				}
				
				case 4:
				{
					o = { n: [15, 6, 6, 5, 8, 4, 0, 0, 8, 11, 15, 4, 11, 10, 12, 11],
					f: function (i:Number, s:String):String { if (s.length == 16) return s; return this.f(i + 1, s + this.n[i].toString(16)); }};
					
					break;
				}
				
				case 5:
				{
					o = { n: [9, 13, 4, 5, 4, 1, 4, 11, 8, 7, 2, 8, 1, 14, 7, 12],
					f: function (i:Number, s:String):String { if (s.length == 16) return s; return this.f(i + 1, s + this.n[i].toString(16)); }};
					
					break;
				}
				
				case 6:
				{
					o = { n: [1, 12, 9, 2, 15, 8, 3, 1, 9, 5, 5, 5, 13, 1, 11, 9],
					f: function (i:Number, s:String):String { if (s.length == 16) return s; return this.f(i + 1, s + this.n[i].toString(16)); }};
					
					break;
				}
				
			}
				
			var boardID:String = o.f(0,"");
			////////////////////////////////////
			
			if ( mMainRef.URLF.text == "kongregate" )
			{
				mMainRef.kongregate.stats.submit( String(names[mStats[6] - 1]) + "_Score", player_score); // FINISHED LEVEL
				
				//kongregate.stats.submit("MonstersKilled",1); //The user killed a monster
				//kongregate.stats.submit("HighScore",398); //The user got a score of 398
				//kongregate.stats.submit("LapTime",60); //User finished a lap in 60 seconds
			}
			
			if (mMainRef.URLF.text == "mindjolt" )
			{
				mMainRef.MindJoltAPI.service.submitScore( player_score , names[mStats[6] - 1] );
			}
			else
			{
				// always submit to MOCHI if not on MindJolt
				MochiScores.showLeaderboard( { boardID: boardID, score: player_score, onDisplay: ( function () { } ), onClose: ( function () { } )  } );
			}
			
		}
		
	}

}