package  
{
	/**
	 * ...
	 * @author AARON
	 */
	
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import GameBoard;
	
	public class Player
	{
		var mLevel;
		var mXP;
		var mXpNeeded:Array;
		
		var mStrength;	// DAMAGE DELT, LIVES, UNIT HEALTH
		var mWisdom;	// STARTING MONEY, COST OF UNITS, COST OF SELL
		var mAgility;	// FASTER ATTACKS, LONGER RANGE
		
		var mStrMod;
		var mWisMod;
		var mAgiMod;
		
		var mPoints;
		var mPntsSpent;
		var mLives;
		var mMoney:Number;
		
		var mPaused;
		var mSpeed;
		
		var mNukeFrames;
		var mOldSpeed;
		var mNukeFrmStrt;
		var mMyTarget:Enemy;
		var mLastNukeTime;
		
		//----------------------
		var mLevelKills;
		var mTotalKills;
		
		var mLevelLivesLost;
		
		var mSumoKilled;
		var mDragonKilled;
		
		var mLevelFinished:Array;	// 0 - 5 // 6 normal levels.  x >= 0;
		var mBonusFinished:Array;	// 0 - 2 // 3 bonus levels.  x >= 0;
		//-------------------------
		
		var mLevelHiScores:Array;
		
		public function Player() 
		{
			trace ("NEW PLAYER");
			
			mPaused = false;
			mSpeed = 1;
			
			mMoney = 1000;
			mLevel = 1;
			mStrength = 0;
			mAgility = 0;
			mWisdom = 0;
			
			mLives = 100;
			
			mPoints = 2;
			mPntsSpent = 0;
			
			mXP = 0;
			mXpNeeded = 
			[0,
			390,
			440,
			560,
			700,
			
			3100,
			4000,
			5200,
			6100,
			7000,
			
			12000,
			13000,
			14000,
			15000,
			16000];
			
			SetModifiers();
			
			mNukeFrames = 0;
			mOldSpeed = mSpeed;
			mNukeFrmStrt = 180;
			mMyTarget = null;
			
			mLevelHiScores = [0, 0, 0, 0, 0, 0];
		}
		
		function LevelUp()
		{
			mXP = mXP - mXpNeeded[mLevel];
			mLevel += 1;
			
			if ( mLevel < 6 )
			{
				mPoints += 1;
			}
			mPoints += 1;
			
			SetModifiers();
		}
		
		function SetModifiers()
		{
			if ( mStrength > 14 )
			{
				mStrMod = 1;
			}
			else
			{
				mStrMod = mStrength * (.05);
			}
			
			if ( mAgility > 14 )
			{
				mAgiMod = 1;
			}
			else
			{
				mAgiMod = mAgility * (.05);
			}
			
			if ( mWisdom > 14 )
			{
				mWisMod = (0.5);
			}
			else
			{
				mWisMod = mWisdom * (.031);
				trace ("WISmOD: " + mWisMod);
			}
			
		}
		
		function AwardXP( value )
		{
			mXP += value;
		}
		
		function AwardMoney( value )
		{
			mMoney += Math.round( value + (value * mWisMod) );
		}
		
		function SearchForTarget( board:GameBoard )
		{
			var mBoard:GameBoard = board;
			var mX = 640 / 2;
			var mY = 480 / 2;
				
				// IF FOUND TARGET, DONT SEARCH AGAIN?		-- SEARCH ALWAYS
				
				if ( mMyTarget )
				{
					var CURTV_x_len = mMyTarget.mX - mX;
					var CURTV_y_len = mMyTarget.mY - mY;
					
					// ENEMY VECTOR LENGTH TO TARGET
					var CURTV_len = Math.sqrt( (CURTV_x_len * CURTV_x_len) + (CURTV_y_len * CURTV_y_len  ) );
					
					if ( mMyTarget.mDead )
					{
						AssginTarget( null );
					}
					
				}
				
				if ( mBoard.mEnemVisListTemp )
				{
					
					if ( !mBoard.mEnemVisListTemp.isEmpty() )
					{
						var list:DLinkedList = mBoard.mEnemVisListTemp;
						var iter:DListIterator = list.getListIterator();		
						
						
						for ( var i = 0; i < list.size; ++i )
						{
							if ( iter.valid() )
							{
									//
								var ENM:Enemy = Enemy(iter.data);
								var eX = ENM.mX;
								var eY = ENM.mY;
								
										
									//		// LIST OF POSSIBLES TO CHECK VECTOR
											// GET VECTOR
							
											var enmV_x_len = eX - mX;
											var enmV_y_len = eY - mY;
											
											// ENEMY VECTOR LENGTH TO TARGET
											var ENMV_len = Math.sqrt( (enmV_x_len * enmV_x_len) + (enmV_y_len * enmV_y_len ));
											
									//		
												// IN RANGE, NOW DISCRIMINATE
												//trace ("RANGE" + ENM.mX);
												if ( mMyTarget )
												{
													
													// IF CUR TARGET IS NULL, ASSIGN NEW TARGET 
													switch( 1 )
													{
														case 1:
														{
															if ( ENMV_len < CURTV_len )
															{
																if ( !ENM.mDead  )
																{
																	AssginTarget( ENM );
																}
															}
															break;
														}
														
													}
													
												}
												else
												{
									//				// NO CUR TARGET
													// ASSIGN THIS TARGET TO CURRENT 
													if ( ENM )
													{
														if( !ENM.mDead )
														AssginTarget( ENM );
													}
												}
									//			
									
								iter.forth();
								
							}
							
						}
						
					}
				}
				
		}
		
		function AssginTarget( tgt )
		{
			
			mMyTarget = tgt;	
		}

	}
}