package  
{
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import de.polygonal.ds.LinkedQueue;
	import flash.display.DisplayObject;
	import flash.display.MorphShape;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	import XML;
	import XMLList;
	import flash.utils.getDefinitionByName;
	import Pair;
	import mochi.as3.*;
	
	
	// ALL CLASSES CALLED BY STRING, NOT IN LIBRARY, IMPORT HERE
	//------------------------------
	import tMachine_gun;
	import eLight_infantry;
	//import eHeavy_infantry;
	
	//------------------------------
	
	/**
	 * ...
	 * @author AARON
	 */
	public class GameBoard
	{
		
		var mMain:Main;
		var mGraphicsStage:MovieClip;
		var mSoundStage:SoundEngine;
		var mPlayer:Player;
		
		var mLevel;
		var mQuit;
		var mDone:Boolean;  //  DO NOTHING AFTER QUIT.
		
		var mEndLevelScreen;
		
		var mHotKeyPanel;
		var mTowerPanel;
		var mUpgradePanel:MovieClip;
		var mMapSet:MovieClip;
		var mMapHM:MovieClip;
		var mMapHM_A:MovieClip;
		var mMapPlace:MovieClip;		
		var mMapPlaceB:MovieClip;
		
		// BUTTONS FOR EVERY TOWER TO BUY
		// ---------------------------
		var mMachineGunBut:bMachineGunButton;
		var mArrowSniperBut:bArrowSniperButton;
		var mFireTrapBut:bFireTowerButton;
		var mRougeBut;
		var mBombBut:bBombButton;
		var mPoisonBut:bPoisonButton;
		var mSamuraiBut;
		var mbBut;
		var mSmokeBut:bSmokeButton;
		var mHealBut:bHealButton;
		// ---------------------------
		
		
		var xtra:XML;
		
		var mGlobalTimer;			// Set every frame
		var mLastTimeCheck;
		var mPauseAccumulation;
		var mExtraTimer;
		var mFrameCount;
		
		var mPauseMenu;
		
		var mWaves;					// [#]
		var mCurnWav;				// [#]
		var mWavePopulated:Boolean;
		
		var mStart;
		var mAutoPlay;
		var mAutoAlways;
		var mWaveStarted;
		
		var mBossWave1;
		var mBossWave2;
		
		var mEnemiesToSpawn:Array;		// [path#][enemy#, timeB4spwn (pair)]
		var mEnemVisListTemp:DLinkedList;
		var mEnemiesVisibleList:DLinkedList;
		var mLastSpawnTime;
		var mPathsWaypnts:Array;	// [path#][waypnt#(pair:y,x)]
		var mPathLastSpwns:Array;
		var mSpawnDone:Boolean;
		
		var mTwrsOnBrd:DLinkedList;
		var mFurnOnBrd:Array;
		
		var mUpgradeFocus:MovieClip;
		var mUpgradeFocusTwr:Tower;
		var mUpgradeFTLast:Tower;
		var mTowerAdd;
		var mLastButton;
		
		var upgrade_button;
		var sell_button;
		
		var mFlt_Box:FloatingBox;
		
		var mWindEng:WindEngine;
		
		var mKills;
		var mXpEarned;
		var mLivesLost;
		var mKillCounter;
		var mStartTime;
		
		var mTut:Tutorial_Open;
		
		var mXp_Bar;
		
		var mNukeClip;
		
		// UNUSED VARIABLES TO COMPILE CLASS FILES
		//---------------------------------
		private var _UNUSED_ENEMY1:e_1Compact;
		private var _UNUSED_ENEMY2:e_2HatchBack;
		private var _UNUSED_ENEMY3:e_3MiniVan;
		private var _UNUSED_ENEMY4:e_4SUV;
		private var _UNUSED_ENEMY5:e_5CityBus;
		private var _UNUSED_ENEMY6:e_6SchoolBus;
		private var _UNUSED_ENEMY7:e_7ArmoredBus;
		private var _UNUSED_ENEMY8:e_8APC;
		private var _UNUSED_ENEMY9:e_9M113;
		private var _UNUSED_ENEMY10:e_91CropDuster;
		private var _UNUSED_ENEMY11:e_92Hellicopter;
		private var _UNUSED_ENEMY12:e_93_BMP;
		
		private var _UNUSED_Machine1:tMachine_gun;
		//private var _UNUSED_Samurai2:tSamurai_tower;
		private var _UNUSED_Arrow3:tArrow_sniper;
		private var _UNUSED_Bomb4:tBomb_tower;
		private var _UNUSED_Poison5:tWarp_tower;
		private var _UNUSED_Heal6:tHealing_tower;
		private var _UNUSED_Fire7:tFire_tower;
		//private var _UNUSED_Flash8:tFlash_tower;
		private var _UNUSED_Smoke9:tSmoke_tower;
		//private var _UNUSED_Rouge10:tRouge_tower;
		//------------------------------------
		
		
		public function GameBoard( MAIN:Main, Level:Number, LevelXML:XML ) 
		{
			trace ("Game Board Loaded");
			
			mMain = MAIN;
			xtra = LevelXML;
			mLevel = Level;
			
			trace ("XML LEVEL  " + xtra.Number);
			
			mMain.MBOARD = this;
			
			mGraphicsStage = MAIN.GRAPHICS_STAGE;
			mSoundStage = MAIN.SOUND_STAGE;
			
			mPlayer = MAIN.MAIN_PLAYER;			
			mPlayer.SetModifiers();
			
			mQuit = false;
			mDone = false;
			
			mFurnOnBrd = [];
			mEnemiesToSpawn = [];
			mEnemVisListTemp = new DLinkedList();
			mEnemiesVisibleList = new DLinkedList();
			mTwrsOnBrd = new DLinkedList();
			mLastSpawnTime = 0;
			mPathsWaypnts = [];
			mPathLastSpwns = [];
			mSpawnDone = false;
			
			
			mCurnWav = 0;
			mWavePopulated = false;
			
				var list:XMLList  = xtra.Waves.wave;
			mWaves = list.length();
				trace ("xml waves " + mWaves);
				
			
			
			mFrameCount = 0;
			
			mGlobalTimer = getTimer();			// Set every frame
			mLastTimeCheck = 0;
			mPauseAccumulation = 0;
			mExtraTimer = 0;
			
			mStart = false;
			mAutoPlay = false
			mAutoAlways = false;
			mWaveStarted = false;
			
			mBossWave1 = false;
			mBossWave2 = false;
			
			mWindEng = new WindEngine( this, false, true );
			
			
			mPlayer.mLives = 100;
			mPlayer.mPaused = false;
			
			mPlayer.mMoney = Number(xtra.Money);
			mPlayer.mMoney += Math.round( (mPlayer.mMoney * mPlayer.mWisMod) );
			
			mPlayer.mLastNukeTime = mGlobalTimer - (60 * 1000);
			
			mKills = 0;
			mLivesLost = 0;
			mXpEarned = 0;
			mKillCounter = 0;
			mStartTime = getTimer();
			// 
			// -----------------------------
			function SubmitScore()
		{
			//Math.round( ( stats[0] * 5 ) + (stats[9] * 2) - ( (stats[8] - stats[7]) / 1000 ) );
			var names:Array = [ "CITY", "SAND", "SHORE", "SUBURBS", "FOREST", "PORTAL" ];
			var player_score = Math.round( ( 20 ) + (300) - ( 5 ) );
			
			mMain.MindJoltAPI.service.submitScore( player_score , "CITY" );
				
				
			var o:Object;
			
			switch ( mLevel )
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
			MochiScores.showLeaderboard( { boardID: boardID, score: player_score } );			
			
		}
		
		//SubmitScore();
			// -----------------------------
			
			GetFurnAndRoutes();
			
			GetTowers();
			
			BoardDrawMap(); // <-- Draw Furniture, Towers
			//BoardDrawHotKey();
			BoardDrawTowerPanel();
			BoardDrawUpgradePanel();
			
			// ------------------
			// TUTORIAL
			//------------------
			if ( mLevel == 1 || mLevel == 4 )
			{
				if ( mPlayer.mLevel == 1 )
				{
					mTut = new Tutorial_Open(this);
					mMapSet.addChild(mTut);
				}
			}
			// ---------------------
			
			mMain.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true );
			
			mMapSet.addEventListener(Event.ENTER_FRAME, BoardFrameEvent, false, 0, true );
			mMapSet.addEventListener(MouseEvent.CLICK, mouseClick, false, 0, true );
			
			
			
			trace ("PLAYER LIVES: " + mPlayer.mLives );
		}
		
		function BoardDrawMap()
		{
			trace ("Clearing Graphics Stage");
			mMain.LoadGraphicsStage();
			mGraphicsStage = mMain.GRAPHICS_STAGE;
			
			trace ("Drawing Map");
			mMapHM = new MapHM();
			mGraphicsStage.addChild( mMapHM );
			mMapHM.gotoAndStop(mLevel);
			
			mMapHM_A = new MapHM_A();
			mGraphicsStage.addChild( mMapHM_A );
			mMapHM_A.gotoAndStop(mLevel);
			
			mMapSet = new MapSetMC();
			mGraphicsStage.addChild( mMapSet );
			mMapSet.gotoAndStop(mLevel);
			//---------------------------
			mMapPlace = new MapPlace();
			mMapSet.addChild( mMapPlace );
			mMapPlace.gotoAndStop(mLevel);
			
			mMapPlace.visible = false;
			//---------------------------
			mMapPlaceB = new MapPlaceB();
			mMapSet.addChild( mMapPlaceB );
			mMapPlaceB.gotoAndStop(mLevel);
			
			mMapPlaceB.visible = false;
			//---------------------------
			DrawFurniture();
			DrawTowers();
			
			
			mMain.SOUND_STAGE.PlayMusic("FINAL_COUNT");
			
			
			mochi.as3.MochiEvents.startPlay( mLevel.toString() );
			

			/*
			 * DRAW FURNITURE ARRAY ON MAPSET MC
			 * DRAW BUTTON PANEL - ON GRAPHICS STAGE
			 * DRAW HOTKEY PANEL - ON GRAPHICS STAGE
			 * 
			 * ALL ENEMIES SPAWN ON MAPSET MC
			 * ALL TOWERS SPAWN ON MAPSET MC
			 * 
			 * POPULATE ENEMIES
			 * POPULATE TIMER
			 * ADD TOWER FUNC
			 * DELET TOWER FUNC
			 * 
			 * UPDATE ENEMIES
			 * UPDATE TOWERS
			 * 
			 * CHECK PAUSE
			 * CHECK BASE SPEED FOR ALL ANIMATIONS, SPEED, LINGER EFFECTS, PERSISTANT EFFECTS, ALL TIMER
			 * CHECK TOWER STRENGTH AGAINST PLAYER STATS
			 * 
			 * 
			 */
			
		}
		
		function mouseClick( event:MouseEvent ):void 
		{
			
			/*trace ("Clicked...tower handlr");
			var pnt:Point = new Point(mMapSet.stage.mouseX, mMapSet.stage.mouseY);
			var objs = mMapSet.getObjectsUnderPoint(pnt);
			for ( var j in objs )
			{
				//trace ("CHECKING " + objs[j] + " " + objs[j].parent + " ");
				if (  objs[j].parent is RangeClip )
				{
					//trace ("IS rangeclip...");					
				}
				
				else				
				{
					//trace ("P: " + objs[j].parent.parent);					
					
					var iter = mTwrsOnBrd.getListIterator();
					for ( var i = 0; i < mTwrsOnBrd.size; ++i)
					{
						if ( objs[j].parent.parent == iter.data.mMovieClip )
						{
							trace ("FOUND A TOWR!");
							mUpgradeFocus = MovieClip(event.target);// iter.data.mMovieClip;
							mUpgradeFocusTwr = iter.data;							
							trace ("EVNT.TGT: " + event.target );
						}
						iter.forth();
					}
				}
				
				
			}
			*/
			
			if ( event.target == mUpgradeFocus )
			{
				//trace ("Clicked on Tower " + mUpgradeFocus);
				
				//var mBeingAdded:Boolean;
				//var mSpawnable:Boolean;
				//trace (mUpgradeFocusTwr.mBeingAdded );
				if ( mUpgradeFocusTwr.mBeingAdded )
				{
					//trace (" BEING ADDED");
					if ( mUpgradeFocusTwr.mSpawnable )
					{
						mMain.SOUND_STAGE.PlaySound("PLANT_TOWER" , 320);
						
						mTwrsOnBrd.append(mTowerAdd);
						mTowerAdd.mX = mMapSet.mouseX;
						mTowerAdd.mY = mMapSet.mouseY;
						
						// subtract cost
						mPlayer.mMoney -= mLastButton.mCost;
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mMovieClip.alpha = 1;
						mTowerAdd.mRangeClip.alpha = 0;
						// POSSIBLY SET REFS TO NULL
						
						mTowerPanel.mMoneySlidingRight = true;
						
						mTowerAdd = null;
						mUpgradeFocus = null;
						mUpgradeFocusTwr = null;
					}
				}
				else
				{
					UpgradePanel();
					
					mMain.SOUND_STAGE.PlaySound("CLICK_TOWER" , mUpgradeFocus.x);
				}
				
				
				if ( mUpgradeFTLast )
				{
					// IF CURRENT TOWER CLASS IS NOT-EQL TO LAST TOWER CLASS
					if ( mUpgradeFTLast != mUpgradeFocusTwr )
					{
						
						mUpgradeFTLast.mRangeClip.alpha = 0;
						
					}
				}
				mUpgradeFTLast = mUpgradeFocusTwr;
				
			}
			else
			{
				if ( mUpgradeFocusTwr )
				{
					mUpgradeFocusTwr.mRangeClip.alpha = 0;
				}
				mUpgradeFocus = null;
				mUpgradeFocusTwr = null;
				
				mUpgradePanel.slidingUp = false;
				mUpgradePanel.slidingDown = true;
				
				mTowerPanel.mMoneySlidingRight = true;
			}
			
			/*if ( mUpgradeFocusTwr )
			{
				trace("UPF: " + mUpgradeFocusTwr.mX);
			}*/
			
		}
		
		function BoardFrameEvent( event:Event ):void
		{
			if ( !mDone )
			{
				if ( mQuit )
				{
					if (!mDone)
					{
						BoardQuit();
					}
				}
				else
				{
				
					if ( mPlayer.mLives <= 0 )
					{
						trace ("LIVES <= 0 !!! " + mPlayer.mLives);
						EndLevel();
					}
					
					if ( mPlayer.mPaused )
					{
						mPauseAccumulation += getTimer() - mLastTimeCheck;// time now - lasttimechecked
						mLastTimeCheck = getTimer();
						
					}
					else // UN-PAUSED
					{
						mGlobalTimer = getTimer() - mPauseAccumulation;// time now - any pause accumulation			
						mPauseAccumulation = 0;
						mLastTimeCheck = getTimer();
						
						CheckStart();
						if ( !mWavePopulated )
						{
							GetWaveEnemies()
						}
						
						if ( !mWaveStarted )
						{
							for ( var k in mPathLastSpwns )
							{
								mPathLastSpwns[k] = mGlobalTimer;
							}
						}
						
						BoardSpawnEnemy();  // <-- Checks for Start Button
						
						if ( mSpawnDone )
						{
							if ( mFrameCount  % 120 == 0 )
							{
								trace ("SPAWN.DONE: ENMS " + mEnemiesVisibleList.size  + " " + mMapSet.numChildren);
								var iterA:DListIterator = mEnemiesVisibleList.getListIterator();
								var enm:Enemy;
									
								for ( var i = 0; i < mEnemiesVisibleList.size; ++i)
								{
									if ( iterA.valid() )
									{
										enm = iterA.data;
										trace ("Enm.mx: " + enm.mX );
										trace ("Enm.my: " + enm.mY );
										trace ("Enm.dieTime: " + enm.mDiedTime);
										trace ("---------------");
									}
									iterA.forth();
								}
							}
							
							if ( CheckEnemiesDone() )
							{
								// ENEMIES GONE
								StartWave();  // <-- INCRMNT WAVE, CHECK FOR LAST, START = FALSE, GET ENEMIES, SPWN.DONE = FALSE
							}
							
						}
						
						CheckEnemyPaths();
						ChecTempListForDead();
						
						BoardMergeList();
						
						if ( mFrameCount > 240 )
						{
							mFrameCount = 0;
							
							/*//trace ("ENM_L: " + mEnemiesVisibleList.size + " ENM_T: " + mEnemVisListTemp.size);
							//trace ("GRPH.CHD: " + mGraphicsStage.numChildren + " MAP.CHLD: " + mMapSet.numChildren);
							
							//
							var iterA:DListIterator = mEnemVisListTemp.getListIterator();
							var enm:Enemy;
								
							for ( var i = 0; i < mEnemVisListTemp.size; ++i)
							{
								if ( iterA.valid() )
								{
									enm = iterA.data;
									trace(enm.mMovieClip.visible + enm.mVisible + " X,Y " + enm.mX + " " + enm.mY);
									iterA.forth();
								}
							}*/
							
						}
						
						++mFrameCount;
						
						if ( mPlayer.mNukeFrames == mPlayer.mNukeFrmStrt )
						{
							StartNuke();
						}
						
						if ( mPlayer.mNukeFrames > 0 )
						{
							NuclearBomb();
						}
						
						if ( mUpgradeFocus )
						{
							UpgradePanel();
						}
						
						if ( mTowerAdd )
						{
							if ( mTowerAdd.mBeingAdded )
							{
								if ( mTowerAdd.mType == "tFire_tower" ||
										mTowerAdd.mType == "tWarp_tower" )
								{
									mMapPlaceB.visible = true;
									mMapPlaceB.alpha = .40;
								}
								else
								{
									mMapPlace.visible = true;
									mMapPlace.alpha = .40;
								}
								
							}
							else
							{
								mMapPlace.visible = false;
								mMapPlaceB.visible = false;
							}
						}
						else
						{
							mMapPlace.visible = false;
							mMapPlaceB.visible = false;
						}
						
					
					}
					
					mWindEng.DoFrameEvents();
					
					if ( mSoundStage.mMusicList.length == 0 )
					{
						mSoundStage.PlayMusic( "FINAL_COUNT" );
					}
					
					if ( mKillCounter > 20 )
					{
						if ( mMain.URLF.text == "kongregate" )
						{
							mMain.kongregate.stats.submit( "EnemiesKilled", mKillCounter ); // FINISHED LEVEL
						}
				
						mKillCounter = 0;
						mMain.SavePlayerData();
					}
					
				}
				
			}
			
			
		}
		
		function BoardMergeList()
		{
			mEnemiesVisibleList = mEnemVisListTemp;
			//trace ("NEW.VIS.LIS.SIZ: " + mEnemiesVisibleList.size);
			// TEMP LIST ADDED TO BY: SPAWN FUNCTION
			// TEMP LIST			: DEAD ENEMIES REMOVED
			
			// 		LIST			: ENEMY PATHS
			//		LIST			: CHECK SPAWN DONE
		}
		
		function compareFunction(objA:Enemy, objB:Enemy)
		{
			var value = 0;
			if ( objA.mX > objB.mX )
			{
				value = -1;
			}
			else if ( objA.mX == objB.mX )
			{
				value = 0;
			}
			else // ( objA.mX < objB.mX )
			{
				value = 1;
			}
			return value;
		}
		
		function BoardSpawnEnemy()
		{
			
			if ( mStart )//mStart )
			{
				
				mWaveStarted = true;
				
				if ( !mSpawnDone )
				{
					for ( var i in mPathsWaypnts )
					{
						
						// CHECK THAT AN ENEMY EXISTS IN PATH
						var enemRef:Enemy = mEnemiesToSpawn[i].peek();
						if ( enemRef )
						{
							// CHECK PATH SPAWN TIMER WITH PATH.NEXT ENEMY. SPAWN TIME
							if ( (mGlobalTimer - mPathLastSpwns[i]) > ( mEnemiesToSpawn[i].peek().mSpawnTimer / mPlayer.mSpeed ) )
							{
								// RESET SPAWN TIMER FOR PATH
								mPathLastSpwns[i] = mGlobalTimer;
								
								// TAKE ENEMY OFF SPAWN QUEUE FOR PATH
								enemRef = mEnemiesToSpawn[i].dequeue();
								
								if ( enemRef )
								{
									enemRef.mSpawned = true;
									
									mEnemVisListTemp.append( enemRef );	
									mEnemVisListTemp.sort( compareFunction, 2 );
									
									mMapSet.addChild( enemRef.mMovieClip ) ;
									enemRef.CheckDestination(1);
									
								}
								
							}
							
						}
						
					}
					
					mSpawnDone = CheckSpawnDone();
					if ( mSpawnDone )
					{
						// SPAWNING IS DONE, BUT ENEMIES MAY REMAIN ON SCREEN
						trace ("SPAWNING DONE!");						
					}
					
				}
				
			}
		}
		
		function StartWave()
		{
			mCurnWav += 1;
			
			if ( mCurnWav >= mWaves )
			{
				// 0 - n waves: if w == mW -> last wave is over
				// end the level
				EndLevel();
			}
			else
			{
				mStart = false;
				mWaveStarted = false;
				
				GetWaveEnemies();
				
				
				mSpawnDone = false;
			}
			
		}
		
		function CheckEnemiesDone():Boolean
		{
			// RETURNS TRUE WHEN ALL ENEMIES ARE SPAWNED AND REMVOED
			var value = false;
			if ( mEnemiesVisibleList.isEmpty() )
			{
				value = true;
			}
			return value;
			
			
		}
		
		function CheckStart()
		{
			if ( mAutoAlways )
			{
				mAutoPlay = true;
			}
			if ( mAutoPlay )
			{
				mStart = true;				
			}
		}
		
		function EndLevel()
		{
			// IF LIVES = 0, POST LOOSE LEVEL
			// ELSE POST WIN LEVEL
			trace ("ENDING LEVEL.CHECK MEM");
			
			
			mAutoAlways = false;
			mAutoPlay = false;
			mPlayer.mSpeed = 1;
			mStart = false;
			
			//---------------------------------------------------------------
			trace ("stage has: " + mGraphicsStage.numChildren );
			
			for ( var o = mGraphicsStage.numChildren - 1; o > 0; --o)
			{				
				trace ("REMOVING: " + o + " : " + mGraphicsStage.getChildAt(o) );
				mGraphicsStage.removeChild( mGraphicsStage.getChildAt(o) );
			}
			
			// STAGE IS CLEAR.
			//---------------------------------------------------------------
			
			mMapSet.removeEventListener(Event.ENTER_FRAME, BoardFrameEvent );
			
			var stats:Array = new Array();
			
			if ( mPlayer.mLives <= 0 )
			{
				// KILLS
				// XP EARNED
				// LIVES LOST
				// xp have
				// xp need
				stats[0] = mKills;
				stats[1] = mXpEarned;
				stats[2] = mLivesLost;
				stats[3] = mPlayer.mXP;
				stats[4] = mPlayer.mXpNeeded[mPlayer.mLevel];
				
				mEndLevelScreen = new loose_level( stats, mMain );
			}
			else
			{
				// KILLS
				// XP EARNED
				
				// LIVES LOST
				// xp have
				
				// xp need
				// bonux xp
				stats[0] = mKills;
				stats[1] = mXpEarned;
				
				stats[2] = mLivesLost;
				stats[3] = mPlayer.mXP;
				
				stats[4] = mPlayer.mXpNeeded[mPlayer.mLevel];
				stats[5] = Math.round( ( mXpEarned * (0.30) ) + ( mXpEarned * mPlayer.mWisMod ) );
				
				mPlayer.mXP += stats[5];
				stats[3] = mPlayer.mXP;
				
				//-------------
				// 6 = levl
				// 7 = time start
				// 8 = time end
				// 9 = money
				stats[6] = mLevel;
				stats[7] = mStartTime;
				stats[8] = mGlobalTimer;
				stats[9] = mPlayer.mMoney;
				
				mEndLevelScreen = new win_level( stats, mMain );
			}
			
			if ( mKillCounter )
			{
				if ( mMain.URLF.text == "kongregate" )
				{
							mMain.kongregate.stats.submit( "EnemiesKilled", mKillCounter ); // FINISHED LEVEL
				}
				
				mKillCounter = 0;
				
			}
			
			mMain.SavePlayerData();
			
			mGraphicsStage.addChild(mEndLevelScreen);			
			
		}
		
		function ClearLevel( e:Event )
		{
			BoardQuit();
		}
		
		function ChecTempListForDead()
		{
			//trace ("CHECKING DEAD");
			var iterA:DListIterator = mEnemVisListTemp.getListIterator();
			var enm:Enemy;
				
			for ( var i = 0; i < mEnemVisListTemp.size; ++i)
			{
				if ( iterA.valid() )
				{
					enm = iterA.data;
					if ( enm.mMovieClip == null )
					{
						
						mEnemVisListTemp.remove(iterA);
						
					}
					else if ( mSpawnDone )
					{
						if ( enm.mX < -500 )
						{
							mEnemVisListTemp.remove(iterA);
						
							if ( enm.mMovieClip )
							{
								if ( enm.mMovieClip.parent )
								{
									enm.mMovieClip.parent.removeChild( enm.mMovieClip );
								}
							}
						}
					}
					
					if( iterA.hasNext() )
					{
						iterA.forth()
					}
				}
			}
			
		}
		
		function CheckEnemyPaths()
		{
			//trace ("Enm Vis: " + mEnemiesVisibleList.size);
			if ( mEnemiesVisibleList.size )
			{
				if ( true )//mEnemiesVisibleList.size < 5 )
				{
					var iterA:DListIterator = mEnemiesVisibleList.getListIterator();
					var enm:Enemy;
					if ( iterA.valid() )
					{
						for ( var i = 0; i < mEnemiesVisibleList.size; ++i)
						{
							if ( iterA.valid() )
							{
								enm = iterA.data;
								enm.CheckDestination(1); 
							}
							
							if ( iterA.hasNext() )
							{
								iterA.forth()
							}
						}	
					}
				}
				else
				{
					var range = mEnemiesVisibleList.size / 4;  // 20  = 5
					var start = mFrameCount * range;			// 1 = 5, 2 = 10
					
					var iterB:DListIterator = mEnemiesVisibleList.getListIterator();
					var enm:Enemy;
					for ( var i = 0; i < start; ++i )
					{
						iterB.forth();
					}
					
					if ( iterB.valid() )
					{
						for ( var i = start; i < range + start; ++i )
						{
							if ( iterB.valid() )
							{
								enm = iterB.data;
								enm.CheckDestination(5); 
							}
							
							if ( iterB.hasNext() )
							{
								iterB.forth()
							}
						}
					}
				}
				
			}
			
		}
		
		function CheckSpawnDone():Boolean
		{
			var empty = true;
			
			for ( var i in mEnemiesToSpawn )
			{
				if ( mEnemiesToSpawn[i].isEmpty() )
				{
					// empty
				}
				else
				{
					empty = false;
					break;
				}
				//trace ("PATHS " + mPathsWaypnts[i].isEmpty() + " " + i )
			}
			
			return empty;
		}
		
		function BoardGetTowerButtons()
		{	
			var resClass:Class;
		
			mMachineGunBut = mTowerPanel.mMachGunBut;
			resClass = getDefinitionByName( mMachineGunBut.mType ) as Class;	
				var newTower = new resClass( this );
				newTower.mVisible = false;
				
			mMachineGunBut.mCost = newTower.mUpgradeCost[0];
			mMachineGunBut.mLevReq = newTower.mLevelReqrmnt;			
			mMachineGunBut.mText = newTower.mUpgradeText[0];
			
			mMachineGunBut.addEventListener(MouseEvent.CLICK, TowerButtonClick, false, 0, true );
			mMachineGunBut.addEventListener("MCLK", TowerButtonClick, false, 0, true );
			mMachineGunBut.addEventListener(Event.ENTER_FRAME, TowButEnterFrame, false, 0, true );
			mMachineGunBut.addEventListener(MouseEvent.ROLL_OVER, MouseRollOver, false, 0, true );
			mMachineGunBut.addEventListener(MouseEvent.ROLL_OUT, MouseRollOut, false, 0, true );
			
			//---------------------------------
			mArrowSniperBut = mTowerPanel.mArrowSnpBut;
			resClass = getDefinitionByName( mArrowSniperBut.mType ) as Class;	
				newTower = new resClass( this );
				newTower.mVisible = false;
				
			mArrowSniperBut.mCost = newTower.mUpgradeCost[0];
			mArrowSniperBut.mLevReq = newTower.mLevelReqrmnt;				
			mArrowSniperBut.mText = newTower.mUpgradeText[0];
			
			mArrowSniperBut.addEventListener(MouseEvent.CLICK, TowerButtonClick, false, 0, true );
			mArrowSniperBut.addEventListener("MCLK", TowerButtonClick, false, 0, true );
			mArrowSniperBut.addEventListener(Event.ENTER_FRAME, TowButEnterFrame, false, 0, true );
			mArrowSniperBut.addEventListener(MouseEvent.ROLL_OVER, MouseRollOver, false, 0, true );
			mArrowSniperBut.addEventListener(MouseEvent.ROLL_OUT, MouseRollOut, false, 0, true );
			
			//---------------------------------
			mFireTrapBut = mTowerPanel.mFireTwrBut;
			resClass = getDefinitionByName( mFireTrapBut.mType ) as Class;	
				newTower = new resClass( this );
				newTower.mVisible = false;
				
			mFireTrapBut.mCost = newTower.mUpgradeCost[0];
			mFireTrapBut.mLevReq = newTower.mLevelReqrmnt;				
			mFireTrapBut.mText = newTower.mUpgradeText[0];
			
			mFireTrapBut.addEventListener(MouseEvent.CLICK, TowerButtonClick, false, 0, true );
			mFireTrapBut.addEventListener("MCLK", TowerButtonClick, false, 0, true );
			mFireTrapBut.addEventListener(Event.ENTER_FRAME, TowButEnterFrame, false, 0, true );
			mFireTrapBut.addEventListener(MouseEvent.ROLL_OVER, MouseRollOver, false, 0, true );
			mFireTrapBut.addEventListener(MouseEvent.ROLL_OUT, MouseRollOut, false, 0, true );
			
			
			//---------------------------------
			mBombBut = mTowerPanel.mBombBut;			
			resClass = getDefinitionByName( mBombBut.mType ) as Class;	
				newTower = new resClass( this );
				newTower.mVisible = false;
				
			mBombBut.mCost = newTower.mUpgradeCost[0];
			mBombBut.mLevReq = newTower.mLevelReqrmnt;				
			mBombBut.mText = newTower.mUpgradeText[0];
			
			mBombBut.addEventListener(MouseEvent.CLICK, TowerButtonClick, false, 0, true );
			mBombBut.addEventListener("MCLK", TowerButtonClick, false, 0, true );
			mBombBut.addEventListener(Event.ENTER_FRAME, TowButEnterFrame, false, 0, true );
			mBombBut.addEventListener(MouseEvent.ROLL_OVER, MouseRollOver, false, 0, true );
			mBombBut.addEventListener(MouseEvent.ROLL_OUT, MouseRollOut, false, 0, true );
			
			//---------------------------------
			mPoisonBut = mTowerPanel.mPoisonBut;		
			resClass = getDefinitionByName( mPoisonBut.mType ) as Class;	
				newTower = new resClass( this );
				newTower.mVisible = false;
				
			mPoisonBut.mCost = newTower.mUpgradeCost[0];
			mPoisonBut.mLevReq = newTower.mLevelReqrmnt;				
			mPoisonBut.mText = newTower.mUpgradeText[0];
			
			mPoisonBut.addEventListener(MouseEvent.CLICK, TowerButtonClick, false, 0, true );
			mPoisonBut.addEventListener("MCLK", TowerButtonClick, false, 0, true );
			mPoisonBut.addEventListener(Event.ENTER_FRAME, TowButEnterFrame, false, 0, true );
			mPoisonBut.addEventListener(MouseEvent.ROLL_OVER, MouseRollOver, false, 0, true );
			mPoisonBut.addEventListener(MouseEvent.ROLL_OUT, MouseRollOut, false, 0, true );
			
			
			//---------------------------------
			mSmokeBut = mTowerPanel.mSmokeBut;
			resClass = getDefinitionByName( mSmokeBut.mType ) as Class;	
				newTower = new resClass( this );
				newTower.mVisible = false;
				
			mSmokeBut.mCost = newTower.mUpgradeCost[0];
			mSmokeBut.mLevReq = newTower.mLevelReqrmnt;					
			mSmokeBut.mText = newTower.mUpgradeText[0];
			
			mSmokeBut.addEventListener(MouseEvent.CLICK, TowerButtonClick, false, 0, true );
			mSmokeBut.addEventListener("MCLK", TowerButtonClick, false, 0, true );
			mSmokeBut.addEventListener(Event.ENTER_FRAME, TowButEnterFrame, false, 0, true );
			mSmokeBut.addEventListener(MouseEvent.ROLL_OVER, MouseRollOver, false, 0, true );
			mSmokeBut.addEventListener(MouseEvent.ROLL_OUT, MouseRollOut, false, 0, true );
			
			//---------------------------------
			mHealBut = mTowerPanel.mHealBut;
			resClass = getDefinitionByName( mHealBut.mType ) as Class;	
				newTower = new resClass( this );
				newTower.mVisible = false;
				
			mHealBut.mCost = newTower.mUpgradeCost[0];
			mHealBut.mLevReq = newTower.mLevelReqrmnt;				
			mHealBut.mText = newTower.mUpgradeText[0];
			
			mHealBut.addEventListener(MouseEvent.CLICK, TowerButtonClick, false, 0, true );
			mHealBut.addEventListener("MCLK", TowerButtonClick, false, 0, true );
			mHealBut.addEventListener(Event.ENTER_FRAME, TowButEnterFrame, false, 0, true );
			mHealBut.addEventListener(MouseEvent.ROLL_OVER, MouseRollOver, false, 0, true );
			mHealBut.addEventListener(MouseEvent.ROLL_OUT, MouseRollOut, false, 0, true );
			
			resClass = null;
			newTower = null;
			
		}
		
		function TowerButtonClick( event )
		{
			//trace ("TOWER BUT Click");
		
			if ( mTowerAdd )
			{
				mMapSet.removeChild(mTowerAdd.mMovieClip);
				mMapSet.removeChild(mTowerAdd.mRangeClip);
				mTowerAdd.mBeingAdded = false;
				mTowerAdd.mVisible = false;
				mTowerAdd = null;
				
				mTowerPanel.mMoneySlidingRight = true;
			}
			
			if ( mUpgradeFocusTwr )
			{
				mUpgradeFocusTwr.mRangeClip.alpha = 0;
				
				mUpgradeFocus = null;
				mUpgradeFocusTwr = null;
				
				mUpgradePanel.slidingUp = false;
				mUpgradePanel.slidingDown = true;
				
				mTowerPanel.mMoneySlidingRight = true;
			}
			
			if ( event.target.currentFrame == 1 )
			{
				mMain.SOUND_STAGE.PlaySound("CLICK_PANEL" , 320);
				
				var resClass:Class = getDefinitionByName( event.target.mType ) as Class;	
				var newTower = new resClass( this );
				newTower.mBeingAdded = true;
				
				var mov = newTower.mMovieClip;
				
				mMapSet.addChild(mov);
				//trace ("MPST: " + newTower.mMovieClip.parent.alpha);
				
				mTowerAdd = newTower;
				
				mLastButton = event.target;
				
				mTowerPanel.mMoneySlidingLeft = true;
				
				// CHANGE MOUSE COURSER, ADD CHILD TO MOUSE,mMapSet.
				// HIT TEST ON MAPSET, HITMC, AND FURNITURE-HITMC
				// SUBTRACT MONEY, ADD TO TOWER ON BOARD MC
			}
			
		}
		
		function TowButEnterFrame( event:Event ):void
		{
			
			var money = mPlayer.mMoney;
			var button = event.target;
			
			
			if ( mPlayer.mLevel >= button.mLevReq )
			{
				if ( money >= button.mCost )
				{
					button.gotoAndStop(  1 );		// READY
				}
				else
				{
					button.gotoAndStop(  2 );		// NO MONEY
				}
			}
			else
			{
				button.gotoAndStop(  3 );			// LOCKED
			}
		}
		
		function BoardDrawTowerPanel()
		{			
			trace ("Drawing Tower Panel");
			
			mXp_Bar = new XP_BAR( mPlayer );
			mXp_Bar.x = 0;
			mXp_Bar.y = 435;
			mGraphicsStage.addChild(mXp_Bar);
			
			mTowerPanel = new bTower_Button_Panel( mPlayer, this );
			mTowerPanel.x = mMain.GRAPHICS_STAGE.width - 10 ;
			mTowerPanel.y = 0;
			mGraphicsStage.addChild(mTowerPanel);
			
			
			
			mMapSet.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true );
			
			BoardGetTowerButtons();
		}
		
		function BoardDrawHotKey()
		{
			trace ("Drawing Hot Keys");	
			
			mHotKeyPanel = new bHotkey_Button_Panel();
			mHotKeyPanel.x = 0;
			mHotKeyPanel.y = mMain.GRAPHICS_STAGE.height - (58);  // OPTIONS STAGE LOWER HEIGHT
			mGraphicsStage.addChild(mHotKeyPanel);		
			
			
		}
		
		function BoardDrawUpgradePanel()
		{
			var opstage = mMain.opStage.getChildByName("background");
			mUpgradePanel = new bUpgrade_Button_Panel( this );
			mUpgradePanel.x = 0;
			mUpgradePanel.y = 480 - (opstage.height) ;  // OPTIONS STAGE LOWER HEIGHT
			mGraphicsStage.addChild( mUpgradePanel );	
		}
		
		function UpgradePanel()
		{
			
			if ( mUpgradeFocus )
			{
				//trace ("mUpgradeFocus true");	
				if ( !mUpgradeFocusTwr.mBeingAdded )
				{
					//trace ("mUpgradeFocusTwr ! mBeingAdded");	
					
					//mUpgradePanel.parent.
					mUpgradePanel.slidingDown = false;
					mUpgradePanel.slidingUp = true;
					mTowerPanel.mMoneySlidingLeft = true;
					
					var panel:MovieClip = MovieClip( mUpgradePanel.getChildByName("panel") );
					
					upgrade_button = MovieClip(panel.getChildByName("button"));
					
					panel.gotoAndStop(1);
					panel.stop();
					
					upgrade_button.gotoAndStop(1);
					upgrade_button = MovieClip(panel.getChildByName("button"));
					
					
					var lvl = mUpgradeFocusTwr.mLevel;
					
					if ( mPlayer.mMoney >= mUpgradeFocusTwr.mUpgradeCost[lvl + 1] )
					{
						upgrade_button.gotoAndStop( 1 );
					}
					else
					{
						upgrade_button.gotoAndStop( 2 );
					}
					
					if ( mUpgradeFocusTwr.mMaxUpgLevl == mUpgradeFocusTwr.mLevel )
					{
						upgrade_button.gotoAndStop( 3 );
					}
					
					
					
					sell_button = MovieClip( panel.getChildByName("sell") );
					
					
					upgrade_button.addEventListener(MouseEvent.CLICK, UpgradeTower, false, 0, true );
					upgrade_button.addEventListener(MouseEvent.ROLL_OVER, MouseRollOver, false, 0, true );
					upgrade_button.addEventListener(MouseEvent.ROLL_OUT, MouseRollOut, false, 0, true );
					
					sell_button.addEventListener(MouseEvent.CLICK, SellTower, false, 0, true );
					sell_button.addEventListener(MouseEvent.ROLL_OVER, MouseRollOver, false, 0, true );
					sell_button.addEventListener(MouseEvent.ROLL_OUT, MouseRollOut, false, 0, true );
					
				}
				
			}
			else
			{
				mUpgradePanel.slidingUp = false;
				mUpgradePanel.slidingDown = true;
				mTowerPanel.mMoneySlidingRight = true;
			}
		}
		
		function UpgradeTower( event:MouseEvent ):void
		{
			//trace ("clicked on upgrade");
			var lvl = mUpgradeFocusTwr.mLevel;
			
			if ( upgrade_button.currentFrame ==  1 )
			{
				mMain.SOUND_STAGE.PlaySound("CLICK_PANEL" , 320);
				
				mUpgradeFocusTwr.UpgradeThisTower();
				
				mUpgradeFocusTwr.mRangeClip.alpha = 0;
				
				mUpgradeFocus = null;
				mUpgradeFocusTwr = null;
				
				mUpgradePanel.slidingUp = false;
				mUpgradePanel.slidingDown = true;
				mTowerPanel.mMoneySlidingRight = true;
				
				/*lvl = mUpgradeFocusTwr.mLevel;
				
				if ( mPlayer.mMoney >= mUpgradeFocusTwr.mUpgradeCost[lvl + 1] )
				{
					upgrade_button.gotoAndStop(lvl*2 + 1);
				}
				else
				{
					upgrade_button.gotoAndStop(lvl*2 + 2);
				}*/
			}
		}
		
		function SellTower( event:MouseEvent ):void
		{
			mMain.SOUND_STAGE.PlaySound("SELL_FINAL" , 320);
			
			mUpgradeFocusTwr.SellThisTower();
			
			//sell.removeEventListener(MouseEvent.CLICK, SellTower );
			
			mUpgradePanel.slidingUp = false;
			mUpgradePanel.slidingDown = true;
			mTowerPanel.mMoneySlidingRight = true;
			
			mUpgradeFocus = null;
			mUpgradeFocusTwr = null;
		}
		
		function MouseRollOver( e:Event )
		{
			if ( e.target == upgrade_button )
			{
				if ( mUpgradeFocus )
				{
					if ( mUpgradeFocusTwr.mLevel != mUpgradeFocusTwr.mMaxUpgLevl )
					{
						mFlt_Box = new FloatingBox();
						
						mFlt_Box.x = upgrade_button.x;
						mFlt_Box.y = 345;
						
						mFlt_Box.mText = (mUpgradeFocusTwr.mUpgradeText[mUpgradeFocusTwr.mLevel + 1])
						mFlt_Box.mCostText = "- " + (mUpgradeFocusTwr.mUpgradeCost[mUpgradeFocusTwr.mLevel + 1]);
						
						mMapSet.addChild( mFlt_Box );
					}
				}
				
			}
			
			else if ( e.target == sell_button )
			{
				
				if ( mUpgradeFocus )
				{
					mFlt_Box = new FloatingBox();
				
					mFlt_Box.x = sell_button.x;
					mFlt_Box.y = 345;
					
					mFlt_Box.mText = "SELL "
					mFlt_Box.mCostText = "+ " + (mUpgradeFocusTwr.mSellCost);
					
					mMapSet.addChild( mFlt_Box );
				}
				
			}
			
			else
			{
				mFlt_Box = new FloatingBox();
				
				// E.TARGET  IS A  BUTTON
				
				mFlt_Box.x = 480;
				mFlt_Box.y = mMapSet.mouseY;
				
				mFlt_Box.mText = (e.target.mText);
				mFlt_Box.mCostText = "- " + (e.target.mCost);
				
				mMapSet.addChild( mFlt_Box );
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
		
		function mouseMove( e:Event )
		{
			var panel:bTower_Button_Panel = mTowerPanel;
			
			if ( mMapSet.mouseX > 600 )
			{
				if ( !panel.mLeft )
				{
					panel.mSlidingLeft = true;
				}
			}
			else if( panel.mLeft && ( mMapSet.mouseX < 550 ) )
			{
				panel.mSlidingRight = true;
			}
			
		}
		
		
		
		function keyDownHandler( event:KeyboardEvent ):void
		{
			trace ("Key pressed " + event.keyCode);
			if ( event.keyCode == 27 ) // ESC
			{
				if ( !mPlayer.mPaused )
				{
					if ( mTowerAdd )
					{
						mMapSet.removeChild(mTowerAdd.mMovieClip);
						mMapSet.removeChild(mTowerAdd.mRangeClip);
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mVisible = false;
						mTowerAdd = null;
						
						mTowerPanel.mMoneySlidingRight = true;
					}
				}
				else // PAUSED
				{
					mPlayer.mPaused = false;
				}
			}
				
			if ( event.keyCode == 32 ) // SPACE
			{
				trace ("SPACE Key pressed");	
				if ( mPlayer.mPaused )
				{
					trace ("UNPAUSING");
					mPlayer.mPaused = false;
					mGraphicsStage.removeChild( mPauseMenu );
					mPauseMenu = null;
				}
				else
				{
					trace ("PAUSING");
					
					if ( mTowerAdd )
					{
						mMapSet.removeChild(mTowerAdd.mMovieClip);
						mMapSet.removeChild(mTowerAdd.mRangeClip);
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mVisible = false;
						mTowerAdd = null;
						
						mTowerPanel.mMoneySlidingRight = true;
					}
					
					mPlayer.mPaused = true;
					mPauseMenu = new Pause_Menu( this );
					mGraphicsStage.addChild( mPauseMenu );
				}
				
			}
			
			if ( event.keyCode == 49 ) // 1
			{
				
				if ( !mPlayer.mPaused )
				{
					if ( mTowerAdd )
					{
						mMapSet.removeChild(mTowerAdd.mMovieClip);
						mMapSet.removeChild(mTowerAdd.mRangeClip);
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mVisible = false;
						mTowerAdd = null;
						
						mTowerPanel.mMoneySlidingRight = true;
					}
					else 
					{
						var but:MovieClip = mMachineGunBut;				
						but.dispatchEvent( new Event( "MCLK" ) );
					}
				}
				
				
			}
			
			if ( event.keyCode == 50 ) //2
			{
				if ( !mPlayer.mPaused )
				{
					if ( mTowerAdd )
					{
						mMapSet.removeChild(mTowerAdd.mMovieClip);
						mMapSet.removeChild(mTowerAdd.mRangeClip);
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mVisible = false;
						mTowerAdd = null;
						
						mTowerPanel.mMoneySlidingRight = true;
					}
					else 
					{
						var but:MovieClip = mArrowSniperBut;				
						but.dispatchEvent( new Event( "MCLK" ) );
					}
				}
			}
			
			if ( event.keyCode == 51 ) // 3
			{
				
				if ( !mPlayer.mPaused )
				{
					if ( mTowerAdd )
					{
						mMapSet.removeChild(mTowerAdd.mMovieClip);
						mMapSet.removeChild(mTowerAdd.mRangeClip);
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mVisible = false;
						mTowerAdd = null;
						
						mTowerPanel.mMoneySlidingRight = true;
					}
					else 
					{
						var but:MovieClip = mSmokeBut;				
						but.dispatchEvent( new Event( "MCLK" ) );
					}
				}
				
				
			}
			
			if ( event.keyCode == 52 ) // 4
			{
				
				if ( !mPlayer.mPaused )
				{
					if ( mTowerAdd )
					{
						mMapSet.removeChild(mTowerAdd.mMovieClip);
						mMapSet.removeChild(mTowerAdd.mRangeClip);
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mVisible = false;
						mTowerAdd = null;
						
						mTowerPanel.mMoneySlidingRight = true;
					}
					else 
					{
						var but:MovieClip = mBombBut;				
						but.dispatchEvent( new Event( "MCLK" ) );
					}
				}
				
				
			}
			
			if ( event.keyCode == 53 ) // 5
			{
				
				if ( !mPlayer.mPaused )
				{
					if ( mTowerAdd )
					{
						mMapSet.removeChild(mTowerAdd.mMovieClip);
						mMapSet.removeChild(mTowerAdd.mRangeClip);
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mVisible = false;
						mTowerAdd = null;
						
						mTowerPanel.mMoneySlidingRight = true;
					}
					else 
					{
						
						var but:MovieClip = mHealBut;				
						but.dispatchEvent( new Event( "MCLK" ) );
					}
				}
				
				
			}
			
			if ( event.keyCode == 54 ) // 6
			{
				
				if ( !mPlayer.mPaused )
				{
					if ( mTowerAdd )
					{
						mMapSet.removeChild(mTowerAdd.mMovieClip);
						mMapSet.removeChild(mTowerAdd.mRangeClip);
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mVisible = false;
						mTowerAdd = null;
						
						mTowerPanel.mMoneySlidingRight = true;
					}
					else 
					{
						var but:MovieClip = mPoisonBut;				
						but.dispatchEvent( new Event( "MCLK" ) );
					}
				}
				
				
			}
			
			if ( event.keyCode == 55 ) // 7
			{
				
				if ( !mPlayer.mPaused )
				{
					if ( mTowerAdd )
					{
						mMapSet.removeChild(mTowerAdd.mMovieClip);
						mMapSet.removeChild(mTowerAdd.mRangeClip);
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mVisible = false;
						mTowerAdd = null;
						
						mTowerPanel.mMoneySlidingRight = true;
					}
					else 
					{
						var but:MovieClip = mFireTrapBut;				
						but.dispatchEvent( new Event( "MCLK" ) );
					}
				}
				
				
			}
			
			if ( event.keyCode == 56 ) // 8
			{
				
				if ( !mPlayer.mPaused )
				{
					if ( mTowerAdd )
					{
						mMapSet.removeChild(mTowerAdd.mMovieClip);
						mMapSet.removeChild(mTowerAdd.mRangeClip);
						mTowerAdd.mBeingAdded = false;
						mTowerAdd.mVisible = false;
						mTowerAdd = null;
						
						mTowerPanel.mMoneySlidingRight = true;
					}
					else 
					{
						
					}
				}
				
				
			}
			
			
			
			if ( event.keyCode == 83 )  // S
			{
				if ( !mPlayer.mPaused )
				{
					if ( mUpgradeFocus )
					{
						SellTower( new MouseEvent(MouseEvent.CLICK) );
					}
				}
			}
			
			if ( event.keyCode == 85 )  // U
			{
				if ( !mPlayer.mPaused )
				{
					if ( mUpgradeFocus )
					{
						UpgradeTower( new MouseEvent(MouseEvent.CLICK) );
					}
				}
			}
			
		}
		
		function clickHandler(event:MouseEvent):void 
		{
			
            mMain.stage.focus = mGraphicsStage;
			mGraphicsStage.focusRect = false;
        }

		function GetFurnAndRoutes()
		{
			var furnList:XMLList  = xtra.Furniture.f;
		
			for ( var i = 0; i < furnList.length(); ++i)
			{
				var name = xtra.Furniture.f[i].name.toString();
				var yVal:Number = Number( xtra.Furniture.f[i].y.toString() );
				var xVal:Number = Number( xtra.Furniture.f[i].x.toString() );
				var tempFurn:Furniture = new Furniture(yVal, xVal, name);
				mFurnOnBrd.push(tempFurn);
			}
			
			trace( mFurnOnBrd.length ); 
			
			ParseRoutes();
		}
		
		function ParseRoutes()
		{
			//var mPathsWaypnts:Array;	// [path#][waypnt#(pair:y,x)]
			var pathList:XMLList  = xtra.Paths.path;
			
			for ( var i = 0; i < pathList.length(); ++i )
			{
				var pointList:XMLList  = xtra.Paths.path[i].y;
				
				var pointArray:Array = new Array();
				for ( var j = 0; j < pointList.length(); ++j )
				{
					var yval:Number = Number( xtra.Paths.path[i].y[j].toString() );
					var xval:Number = Number( xtra.Paths.path[i].x[j].toString() );
					
					var tempPair:Pair = new Pair(yval, xval);
				
					pointArray.push(tempPair);				
				}
				
				mPathsWaypnts.push(pointArray);
				mPathLastSpwns.push(0);
			}
			
		}
		
		function DrawFurniture()
		{
			for ( var i = 0; i < mFurnOnBrd.length; ++i )
			{
				if ( mFurnOnBrd[i].mMovieClip )
				{
					mMapSet.addChild( mFurnOnBrd[i].mMovieClip );
				}
				
			}
		}
		
		function DrawTowers()
		{
			var iter:DListIterator = mTwrsOnBrd.getListIterator();
			if ( iter.valid() )
			{
				for ( var i = 0; i < mTwrsOnBrd.size; ++i )
				{
					if ( iter.valid() )
					{
						mMapSet.addChild( iter.data.mMovieClip );
						iter.data.mVisible = true;
						iter.data.HitTestForSwap();
						iter.forth();
					}
					
				}
			}
		}
		
		function GetWaveEnemies()
		{
			trace ("WAVES " + mCurnWav);
				
			var enmList:XMLList  = xtra.Waves.wave[mCurnWav].enemy;
			
			mEnemiesToSpawn = new Array();
			
			// CREATE QUES
			for ( var i in mPathsWaypnts )
			{
				mEnemiesToSpawn.push(new LinkedQueue());
			}
				
			for ( var i = 0; i < enmList.length(); ++i )
			{
				var Amount:Number = Number( xtra.Waves.wave[mCurnWav].enemy[i].amount.toString() );
				
				for ( var j = 0; j < Amount; ++j )
				{					
					var typ = xtra.Waves.wave[mCurnWav].enemy[i].type.toString();						
					var rte:Number = Number( xtra.Waves.wave[mCurnWav].enemy[i].route.toString() );
					var timr:Number = Number( xtra.Waves.wave[mCurnWav].enemy[i].timer.toString() );
					var colr = xtra.Waves.wave[mCurnWav].enemy[i].color.toString();
						var spd:Number = Number( xtra.Waves.wave[mCurnWav].enemy[i].speed.toString() );
						var hlth:Number = Number( xtra.Waves.wave[mCurnWav].enemy[i].health.toString() );
						var atk:Number = Number( xtra.Waves.wave[mCurnWav].enemy[i].attack.toString() );
					
					
					// var mPathsWaypnts:Array;	// [path#][waypnt#(pair:y,x)]
					var yVal:Number = Number( mPathsWaypnts[rte][0].value1 );
					var xVal:Number = Number( mPathsWaypnts[rte][0].value2 );
					
					var dest = 1;				
					
					var tMC:Class = getDefinitionByName( typ ) as Class;
					
					//tempEnem = new tMC() as MovieClip;
			
					
					var tempEnem = new tMC(this, yVal, xVal, rte, dest, timr, colr, spd, hlth, atk, typ);
					
					//var mEnemiesToSpawn:Array;		// [path#][queue]					
					mEnemiesToSpawn[rte].enqueue( tempEnem );
				}
			}
			
			for ( i in mEnemiesToSpawn )
			{
				//trace ("PATHS&LEN: " + mEnemiesToSpawn[i].size);
			}
			mWavePopulated = true;
			mSpawnDone = false;
			
			var wave_box = new WaveBox( 90 );
			var TXT = xtra.Title;
			
			wave_box.mText = ("LEVEL " + TXT + "    WAVE " + (mCurnWav + 1) );
			
			mMapSet.addChild( wave_box );
		}
		
		function GetTowers()
		{
			var twrList:XMLList  = xtra.Towers.twr;
			
			for ( var i = 0; i < twrList.length(); ++i )
			{
				
					var typ = xtra.Towers.twr[i].type.toString();
					var spd:Number = Number( xtra.Towers.twr[i].speed.toString() );
					var lvl:Number = Number( xtra.Towers.twr[i].level.toString() );
					var yVal:Number = Number( xtra.Towers.twr[i].y.toString() );
					var xVal:Number = Number( xtra.Towers.twr[i].x.toString() );
					var hlth:Number = Number( xtra.Towers.twr[i].health.toString() );
					var atk:Number = Number( xtra.Towers.twr[i].attack.toString() );
					var rng:Number = Number( xtra.Towers.twr[i].range.toString() );
					var colr = xtra.Towers.twr[i].color.toString();
				
					// GET SUB-CLASS FROM XML, ADD TO QUEUE
					var tMC:Class = getDefinitionByName( typ ) as Class;
					
					//(BOARD, y_pos = 0, x_pos = 0, type = "tMachine_gun", speed = 500, level = 0, health = 100, attack = 10, range = 80, color = "NONE" )
					var tempTwr = new tMC(this, yVal, xVal, typ, spd, lvl, hlth, atk, rng, colr);
					
					//var mEnemiesToSpawn:Array;		// [path#][queue]					
					mTwrsOnBrd.append( tempTwr );
				
			}
			
		}
		
		function SaveLevel( so:SharedObject )
		{
			if ( !mStart )
			{
				trace ("Saving Level");
				// SAVE LEVEL NUM
				// TOWERS ON BOARD
				// WAVE NUM
				// MONEY
				// LIVES
				
				so.data.level = mLevel;
				so.data.wave = mCurnWav;
				so.data.money = mPlayer.mMoney;
				so.data.lives = mPlayer.mLives;
				
				var TowerArray:Array = new Array();
				var itr:DListIterator = mTwrsOnBrd.getListIterator();			
				
				for ( var i = 0; i < mTwrsOnBrd.size; ++i )
				{
					if ( itr.valid() )
					{
						// get variables
						var twr:Tower = itr.data;
						
						var typ = twr.mType;
						var spd = twr.mSpeed.toString();
						var lvl = twr.mLevel.toString();
						var yVal = twr.mY.toString();
						var xVal = twr.mX.toString();
						var hlth = twr.mHealth.toString();
						var atk = twr.mAttack.toString();
						var colr = twr.mColor;
						
						var tpri = twr.mTrgDesgPri.toString();
						var mxh = twr.mMaxHealth.toString();
						var rang = twr.mRange.toString();
						// assign to array
						var tower:Array = new Array(typ, spd, lvl, yVal, xVal,
							hlth, atk, colr, tpri, mxh, rang);
						// assign array to array
						TowerArray.push(tower);
					}
					itr.forth();
				}
				
				so.data.towers = TowerArray;
				trace ("SAVING: TWRS: " + TowerArray.length );
				so.flush();
				trace (so.data.towers);
			}
		}
		
		function ContinueLevel( obj:SharedObject )
		{
			trace ("CONTINUING LEVEL");
			
			mLevel = Number(obj.data.level);
			mCurnWav = Number(obj.data.wave) ;
			mPlayer.mMoney = Number(obj.data.money);
			mPlayer.mLives = Number(obj.data.lives);
			
			trace ("STUFF " + obj.data.money + obj.data.towers);
			GetTowersSaved( obj );
		}
		
		function GetTowersSaved( obj:SharedObject )
		{
			var twrList:Array  = obj.data.towers;
			
			trace ("TWR.LOOP: " + twrList.length );
			for ( var i = 0; i < twrList.length; ++i )
			{
				/*
				var tower:Array = new Array(typ, spd, lvl, yVal, xVal,
							hlth, atk, colr, tpri, mxh, rang);
				*/
					var typ = twrList[i][0];
					var spd:Number = Number( twrList[i][1] );
					var lvl:Number = Number( twrList[i][2] );
					var yVal:Number = Number( twrList[i][3] );
					var xVal:Number = Number( twrList[i][4] );
					var hlth:Number = Number( twrList[i][5] );
					var atk:Number = Number( twrList[i][6] );
					var colr = twrList[i][7];
				
					// GET SUB-CLASS FROM XML, ADD TO QUEUE
					
					var tMC:Class = getDefinitionByName( typ ) as Class;
					
					var tempTwr = new tMC(this, yVal, xVal, typ, spd, lvl, hlth, atk, colr);
					
					tempTwr.mTrgDesgPri = Number(twrList[i][8]);
					tempTwr.mMaxHealth = Number(twrList[i][9]);
					tempTwr.mRange = Number(twrList[i][10]);
					
					trace ("MAKING BABIES: " + typ + i + " " + tempTwr.mRange + " " + tempTwr.mX );
					
					// REMOVE DUPLICAT TOWER IN TOWER LIST
					var iter:DListIterator = mTwrsOnBrd.getListIterator();
					for ( var j = 0; j < mTwrsOnBrd.size; ++j)
					{
						if ( iter.valid() )
						{
							var tower:Tower = iter.data;
							if ( Math.floor(tower.mX) == Math.floor(tempTwr.mX) 
								&& Math.floor(tower.mY) == Math.floor(tempTwr.mY) )
								{
									mMapSet.removeChild(tower.mMovieClip);
									mMapSet.removeChild(tower.mRangeClip);
									tower.mVisible = false;
									tower.mMovieClip.removeEventListener(Event.ENTER_FRAME, tower.movieFrameEvent );
									mTwrsOnBrd.remove(iter);
								}
						}
						
					}
					
					// ADD TO TOWER LIST
					mTwrsOnBrd.append( tempTwr );
					trace ("APPEND " + mTwrsOnBrd.head.data.mRange + " " + mTwrsOnBrd.head.data.mX );
					
				
			}
			
			DrawTowers();
		}
		
		function BoardQuit()
		{	
			//trace( " BOARD QUIT()..." );
			mDone = false;
			mAutoAlways = false;
			mAutoPlay = false;
			mPlayer.mSpeed = 1;
			mStart = false;
			
			
			for ( var o = mGraphicsStage.numChildren - 1; o > 0; --o)
			{				
				//trace ("REMOVING: " + o + " : " + mGraphicsStage.getChildAt(o) );
				mGraphicsStage.removeChild( mGraphicsStage.getChildAt(o) );
			}
			
		
			mMapSet.removeEventListener(Event.ENTER_FRAME, BoardFrameEvent );
			
			//mochi.as3.MochiEvents.endPlay();
			
			if ( mKillCounter )
			{
				if ( mMain.URLF.text == "kongregate" )
				{
							mMain.kongregate.stats.submit( "EnemiesKilled", mKillCounter ); // FINISHED LEVEL
				}
				
				mKillCounter = 0;
				
			}
			
			mMain.SavePlayerData();
			
			mMain.LoadAfterPlay();
			
			//trace( "....BOARD QUIT DONE " );
		}
		
		function StartNuke()
		{
			// attach nuke vid to screen over everything
			mNukeClip = new p_nuke_clip();
			mMain.opStage.addChildAt( mNukeClip, 1 );
			mPlayer.mOldSpeed = mPlayer.mSpeed;
			
			mNukeClip.blendMode = "add";
		}
		
		function NuclearBomb()
		{
			mPlayer.mNukeFrames--;
			
			mPlayer.mSpeed = (.4);
			//trace ( "frame: " + mPlayer.mNukeFrames );
			
			var nK = 0;
			
			var LIST:DLinkedList = mEnemVisListTemp;
			var ITER:DListIterator = LIST.getListIterator();
			
			for ( var CI = 0; CI < LIST.size; ++CI )
			{
				if ( ITER.valid() )
				{
					if ( !ITER.data.mDead )
					{
						nK += 1;
					}
					ITER.forth();
				}
			}
			
			if ( nK )
			{
				
				var nJ = mPlayer.mNukeFrames;
				
				var nToKill = Math.round( nK / nJ );
				
				for ( var num = 0; num < nToKill; ++num )
				{
					if ( nToKill > 0 )
					{
						//trace ( "searching...  " + num );
						mPlayer.SearchForTarget( this );
						if ( mPlayer.mMyTarget )
						{
							mPlayer.mMyTarget.mHealth = 0;							
						}
						
					}
				}
				
			}
			
			
			
			if ( mPlayer.mNukeFrames <= 0 )
			{
				mMain.opStage.removeChild( mNukeClip );
				mPlayer.mSpeed = 1;
				//mMapSet.blendMode("difference");
			}
			
			
		}
		
	}

}