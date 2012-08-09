package  
{
	/**
	 * ...
	 * @author AARON
	 */
	
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import flash.display.DisplayObject;
	import flash.display.MorphShape;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextColorType;
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Tower
	{
		var mType;
		var mTypeMC;
		var mSpeed;
		var mAttack;
		var mRange;
		var mLevel;
		var mHealth;
		var mMaxHealth;		
		
		var mBeingAdded:Boolean;
		var mSpawnable:Boolean;
		
		var mUpgradeCost:Array;
		var mUpgradeText:Array;
		var mSellCost:Number;
		var mLevelReqrmnt;
		
		var mColor;
		var mVisible;
		
		var mBoard:GameBoard;
		var mPlayer:Player;
		
		var mDead;
		
		var mY;
		var mX;
		var changeY;
		var changeX;
		
		var mMovieClip:MovieClip;
		var mActualTowerClip:MovieClip;
		var mRangeClip:MovieClip;		// RANGE CLIP IS 2*RANGE (R)
		var mHeadClip:MovieClip;
		
		var mMyTarget:Enemy;
		var mLastTrgt:Enemy;
		var mLstAtkTime;
		var mTrgDesgPri;			// TARGET DESIGNATOR PRIORITY (1.CLOSE, 2.FAR, ETC.)
		var mDamage;				// DAMAGE ACCUMULATION TO DEAL AT ONE TIME
		var mLastTimeCalled;		// LAST TIME DAMAGE WAS ACCUMULATED
		
		var mE_Y_Length;
		var mE_X_Length;
		var mE_T_Length;
		
		var mProjectiles:Array;
		
		var mFacing;
		var mOldFacing;
		var mBulitRotn;
		var mTurnSpeed;
		
		var mAttackFrames;
		var mAttkFrmTime;
		var upFrame;
		var atkFrame;
		var prjSpwnFrame;
		
		var mMaxUpgLevl;
		
		var mProjSpwnPnt:Point;
		var mProjSpwnArry;
		var mProjDestn:Point;
		
		var mOnGround:Boolean;
		
		var mColorLayer:ColorTransform;
		
		public function Tower(y_pos, x_pos, type, typeClass, speed, level, health, attack, range, color, upgrd:Array, BOARD ) 
		{
			mY = y_pos;
			mX = x_pos;
			
			mBoard = BOARD;
			mPlayer = mBoard.mMain.MAIN_PLAYER;
			
			mTypeMC = type;
			mType = typeClass;
			mSpeed = speed - ( speed * mPlayer.mAgiMod );
			mLevel = level;
			mHealth =  health;
			mAttack = attack + ( attack * mPlayer.mStrMod );
			mColor = color;
			mMaxHealth = health;
			mRange = range + ( range * mPlayer.mAgiMod );
			
			mDamage = 0;
			mLstAtkTime = 0;
			mTrgDesgPri = 1;
			mLastTimeCalled = 0;
			mProjectiles = [];
			
			mLastTrgt = null;
			mMyTarget = null;
			
			mE_Y_Length = 0;
			mE_X_Length = 0;
			mE_T_Length = 0;
			
			mUpgradeCost = new Array(0, 1, 2, 3);
			mUpgradeCost[0] = Math.round( upgrd[0]  - ( upgrd[0] * mPlayer.mWisMod ) );
			mUpgradeCost[1] = Math.round( upgrd[1]  - ( upgrd[1] * mPlayer.mWisMod ) );
			mUpgradeCost[2] = Math.round( upgrd[2]  - ( upgrd[2] * mPlayer.mWisMod ) );
			mUpgradeCost[3] = Math.round( upgrd[3]  - ( upgrd[3] * mPlayer.mWisMod ) );
			
			mAttackFrames = 0;
			mAttkFrmTime = 0;
			upFrame = 10;
			atkFrame = 11;
			prjSpwnFrame = 5;
			
			mVisible = true;
			mDead = false;
			mBeingAdded = false;
			mSpawnable = false;
			
			mFacing = 0;
			mOldFacing = mFacing;
			mBulitRotn = 0;
			mTurnSpeed = 8;			
			
			mProjSpwnPnt = new Point( 18, 0 );
			
			mOnGround = false;
			
			var tMC:Class = getDefinitionByName( mTypeMC ) as Class;			
			mActualTowerClip = new tMC() as MovieClip;			
			
			InitializeMovieClip();			
		}
		
		function InitializeMovieClip()
		{
			mMovieClip = new tTowerMC();
			mMovieClip.x = mX;
			mMovieClip.y = mY;
			
			mMovieClip.visible = true;
			
			
			mMovieClip.addEventListener(Event.ENTER_FRAME, movieFrameEvent, false, 0, true );
			mActualTowerClip.addEventListener(MouseEvent.CLICK, mouseClick, false, 0, true );
			
			
			mMovieClip.addEventListener(Event.REMOVED_FROM_STAGE, ClearEvent , false, 0, true);
			
			mRangeClip = MovieClip(mMovieClip.getChildByName("rangeclip"));
			mRangeClip.alpha = .5;
			mRangeClip.addEventListener(Event.ADDED_TO_STAGE, addToStage, false, 0, true );
			
			mMovieClip.addChild(mActualTowerClip);
			
			if ( mActualTowerClip )
			{				
				mHeadClip = MovieClip(mActualTowerClip.getChildByName("head_clip"));
			}
			
			//SetColor();
			GetSellCost();
		}
		
		function SetColor()
		{
			var mov:MovieClip = MovieClip(mActualTowerClip.getChildAt(1));
			var clrobj:ColorObj = new ColorObj();
			
			var myColor:ColorTransform = mov.transform.colorTransform;
			
			myColor.color = clrobj.GetColor(mColor);		
			mov.transform.colorTransform = myColor; 
		}
		
		function addToStage( event:Event ):void
		{
			var rP:Point = mRangeClip.localToGlobal( ( new Point(mRangeClip.x, mRangeClip.y)) );
			
			mMovieClip.removeChild( mRangeClip );
			
			var newChild:MovieClip = MovieClip( new RangeClip() );
			mBoard.mMapSet.addChild( newChild );
			
			newChild.x = rP.x;
			newChild.y = rP.y;
			mBoard.mMapSet.setChildIndex(newChild, 2);
			
			mRangeClip = newChild;
			mRangeClip.width = mRange * 2;
			mRangeClip.height = mRange * 2;
			mRangeClip.alpha = 0;
			
			var hm:MovieClip = MovieClip( mActualTowerClip.getChildByName("hitmask") );
			hm.alpha = 0;
		}
		
		function HitTestForSpawn()
		{
			var notHit = true;
			var hm:MovieClip = MovieClip( mActualTowerClip.getChildByName("hitmask") );
			
			var mapHM:MovieClip = MovieClip( mBoard.mMapHM );
			
			//trace ("MAP " + mapHM.numChildren);
			for ( var c = 0; c < mapHM.numChildren; c++ )
			{
				var movHT = mapHM.getChildAt(c);
				if ( hm.hitTestObject(movHT) )
				{
					//trace ("Hit a something!!!");
					notHit = false;
					mSpawnable = false;
					c = mapHM.numChildren;
					break;
					
				}
				
			}
			
			var Ledges:MovieClip = MovieClip( mBoard.mMapHM_A );
			
			for ( var g = 0; g < Ledges.numChildren; g++ )
			{
				var LedgChild = Ledges.getChildAt(g);
				if ( hm.hitTestObject(LedgChild) )
				{
					//trace ("Hit a something!!!");
					notHit = false;
					mSpawnable = false;
					g = Ledges.numChildren;
					break;
					
				}
				
			}
			
			
			if ( notHit )
			{
				mSpawnable = true;
			}
			
			var furnL:Array = mBoard.mFurnOnBrd;	
			var mc:MovieClip;
			for ( var j = 0; j < furnL.length; ++j )
			{
				mc = furnL[j].mMovieClip.getChildByName("hitmask");
				
				if ( hm.hitTestObject(mc) )
				{
					//trace ("Hit Furniture");
					mSpawnable = false;
				}
				
			}
			
			var list:DLinkedList = mBoard.mTwrsOnBrd;
			var iter:DListIterator = list.getListIterator();	
			
			for ( var i = 0; i < list.size; ++i )
			{
				if ( iter.valid() )
				{
					
						var twrHM:MovieClip = iter.data.mActualTowerClip.getChildByName("hitmask");
						
						if ( hm.hitTestObject(twrHM) )
						{
							//trace ("Hit Tower");
							mSpawnable = false;	
						}
					
					
					iter.forth();
				}
			}
			
		}
		
		function movieFrameEvent( event:Event ):void
		{
			// THIS MOVIECLIP DOSE THIS FUNCTION EVEN IF NOT-VISIBLE
			//mHeadClip.gotoAndStop(mActualTowerClip.currentFrame);
			
			if ( ! mPlayer.mPaused )
			{
				if ( mVisible && !mBeingAdded )
				{
					//trace ("xy: " + mX + " " + mY + " RANG " + mRange);					
					TowerUpdate();
				}
				else if (mBeingAdded)
				{
					//mMovieClip.alpha = .25;
					//mRangeClip.alpha = .25;
					
					mMovieClip.x = mMovieClip.parent.mouseX;
					mMovieClip.y = mMovieClip.parent.mouseY+2;
					mRangeClip.x = mMovieClip.parent.mouseX;
					mRangeClip.y = mMovieClip.parent.mouseY+2;
					
					//trace ("MPST: " + mMovieClip.parent.alpha);
					
					HitTestForSpawn();
					
					if ( mSpawnable )
					{
						mMovieClip.alpha = .75;
						mRangeClip.alpha = .75;
					}
					else
					{
						mMovieClip.alpha = .25;
						mRangeClip.alpha = .25;
					}
				}

				
				if ( mProjectiles.length )
				{
					
					for ( var i in mProjectiles )
					{
						if ( mProjectiles[i].mDone )
						{
							mProjectiles.splice(i, 1)
							//trace ("FOUND PROJ IN TWR.PROJTS");
						}
					}
				}
			
			
			}
			
		}
		
		function ClearEvent( e:Event )
		{
			mMovieClip.removeEventListener( Event.ENTER_FRAME, movieFrameEvent);
			mMovieClip.removeEventListener( Event.REMOVED_FROM_STAGE, ClearEvent);
		}
		
		function mouseClick( event:MouseEvent ):void
		{
			//trace ("INSIDE TOWER: MOUSE CLIK");
			if ( mBoard.mUpgradeFocusTwr )
			{
				if ( mBoard.mUpgradeFocusTwr != this )
				{
					if ( mBoard.mUpgradeFocusTwr )
					{
						mBoard.mUpgradeFocusTwr.mRangeClip.alpha = 0;
					}
					mBoard.mUpgradeFocus = null;
					mBoard.mUpgradeFocusTwr = null;
					
					mBoard.mUpgradePanel.slidingUp = false;
					mBoard.mUpgradePanel.slidingDown = true;
					
					//mBoard.mTowerPanel.mMoneySlidingRight = true;
				}
			}
			
			mBoard.mUpgradeFocus = mHeadClip;
			mBoard.mUpgradeFocusTwr = this;
			mRangeClip.alpha = .25;
		}
		
		//  ALL OTHER ON FRAME FUNCTIONS  CALLED BY BOARD.  PAUSE HANDELING
		function TowerUpdate()
		{
			
			if ( !mDead )
			{
				SearchForTarget();
				
				GetDirection();
				
				Attack();				
				
				if ( mAttkFrmTime )
				{
					mAttkFrmTime -= (1);
					
					if ( mAttkFrmTime == prjSpwnFrame )
					{
						SpawnProjectile();
					}
				}
				else if ( (mAttkFrmTime <= 0)  && (mAttkFrmTime > -6) )
				{
					mHeadClip.gotoAndPlay( (mLevel * upFrame) );
					mAttkFrmTime = -6;
				}
				
				CheckFacing();
				
				FreqCallJunkFunc();
				
				mMovieClip.x = mX;
				mMovieClip.y = mY;				
			}
			
		}
		
		function FreqCallJunkFunc()
		{
			
		}
		
		function SearchForTarget()
		{
			
				// IS TARGET SELECTION  AOE, OR DIRECT FIRE
				// TARGET IS ALWYAS SELECTION, ATTACKS ARE AOE, OR DIRECT
				//  -- GIVEN AS REFERENCE OR, FOUND IN DIFFERENT FUNCT
				var MIN = mX - mRange - 60;
				var MAX = mX + mRange + 60;
				
				// RANGE IS A VECTOR, INCLUDE ALL WHO'S 'HALF-WIDTH' ARE IN RANGE
				//  -- NOT JUST POINT, Y,X
				
				var mTowV_Len = mRange;				
				
				// IF FOUND TARGET, DONT SEARCH AGAIN?		-- SEARCH ALWAYS
				//  IF TARGET LEAVES RANGE, LOOSE TARGET
				
				// NEW VECTOR FOR CURRENT TARGET
				if ( mMyTarget )
				{
					var CURTV_x_len = mMyTarget.mX - mX;
					var CURTV_y_len = mMyTarget.mY - mY;
					
					// ENEMY VECTOR LENGTH TO TARGET
					var CURTV_len = Math.sqrt( (CURTV_x_len * CURTV_x_len) + (CURTV_y_len * CURTV_y_len ))
										
					// GET NEW VECTOR LENGTH FOR RANGE AS IF RANGE CIRCLE WAS ELLIPSE: (.5) FOR Y CHANGE
					var newV_Len = mTowV_Len;
					
					// --SET FACING VARIABLES-----
					mE_Y_Length = CURTV_y_len;
					mE_X_Length = CURTV_x_len;
					mE_T_Length = CURTV_len;
					
					if (CURTV_len  > newV_Len)
					{
						// OUT OF RANGE
						// DESG NEW TARGET TO COMPARE
						//trace ("LEAVING RANGE" + CURTV_len);
						AssginTarget( null );
						Attack();
					}
					
					if ( mMyTarget )
					{
						if (  mMyTarget.mDead )
						{
							AssginTarget( null );
						}
					}
					
				}
				
				var list:DLinkedList = mBoard.mEnemiesVisibleList;
				var iter:DListIterator = list.getListIterator();		
				
				
				for ( var i = 0; i < list.size; ++i )
				{
					if ( iter.valid() )
					{
						
						var ENM:Enemy = Enemy(iter.data);
						var eX = ENM.mX;
						var eY = ENM.mY;
						
						
						if ( (mType != "tMachine_gun") && (mType != "tArrow_sniper") )
						{
							if ( !ENM.mFlying )
							{
								if ( eX >= MIN && eX <= MAX )
								{
									// LIST OF POSSIBLES TO CHECK VECTOR
									// GET VECTOR
					
									var enmV_x_len = eX - mX;
									var enmV_y_len = eY - mY;
									
									// ENEMY VECTOR LENGTH TO TARGET
									var ENMV_len = Math.sqrt( (enmV_x_len * enmV_x_len) + (enmV_y_len * enmV_y_len ));
									
									if ( ENMV_len <= mTowV_Len )
									{
										// IN RANGE, NOW DISCRIMINATE
										
										if ( mMyTarget )
										{
											
											// IF CUR TARGET IS NULL, ASSIGN NEW TARGET 
											
											// TARGET OPTIONS: CLOSEST( SMALLEST VECTOR )	1.
											//				**	CLOSEST && NO SMOKE      	2.  **
											//					STRONGEST( HIGEST ATTACK )	3.
											//					WEAKEST						4.
											//					HEALTHY ( HIGH MAX HELTH)	5.
											//					WEAKEST ( LOWEST HEALTH	)	6.
										
											// COMPARE WITH SWITCH
										
											switch( mTrgDesgPri )
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
													case 2:
													{
														if ( ENMV_len < CURTV_len && !ENM.mOnSmoke )
														{
															if ( !ENM.mDead  )
															{
																AssginTarget( ENM );
															}
														}
														break;
													}
													case 3:
													{
														if ( ENM.mAttack > mMyTarget.mAttack )
														{
															if ( !ENM.mDead  )
															{
																AssginTarget( ENM );
															}
														}
														break;
													}
													case 4:
													{
														if ( ENM.mAttack < mMyTarget.mAttack )
														{
															if ( !ENM.mDead  )
															{
																AssginTarget( ENM );
															}
														}
														break;
													}
													case 5:
													{
														if ( ENM.mMaxHealth > mMyTarget.mMaxHealth )
														{
															if ( !ENM.mDead  )
															{
																AssginTarget( ENM );
															}
														}
														break;
													}
													case 6:
													{
														if ( ENM.mMaxHealth < mMyTarget.mMaxHealth )
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
											// NO CUR TARGET
											// ASSIGN THIS TARGET TO CURRENT 
											if ( ENM )
											{
												if( !ENM.mDead )
												AssginTarget( ENM );
											}
										}
										
									}
								}
								
							}
						}
						else
						{
							
							if ( eX >= MIN && eX <= MAX )
							{
								// LIST OF POSSIBLES TO CHECK VECTOR
								// GET VECTOR
				
								var enmV_x_len = eX - mX;
								var enmV_y_len = eY - mY;
								
								// ENEMY VECTOR LENGTH TO TARGET
								var ENMV_len = Math.sqrt( (enmV_x_len * enmV_x_len) + (enmV_y_len * enmV_y_len ));
								
								
								//trace ("LENGS E,R " + (ENMV_len - halfWidth) + " " + mTowV_Len );
								if ( ENMV_len  <= mTowV_Len )
								{
									// IN RANGE, NOW DISCRIMINATE
									//trace ("RANGE" + ENM.mX);
									if ( mMyTarget )
									{
										
										// IF CUR TARGET IS NULL, ASSIGN NEW TARGET 
										
										// TARGET OPTIONS: CLOSEST( SMALLEST VECTOR )	1.
										//					FURTHEST( LARGETS VECTOR )	2.
										//					STRONGETS( HIGEST ATTACK )	3.
										//					WEAKEST						4.
										//					HEALTHY ( HIGH MAX HELTH)	5.
										//					WEAKEST ( LOWEST HEALTH	)	6.
									
										// COMPARE WITH SWITCH
									
										switch( mTrgDesgPri )
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
												case 2:
												{
													if ( ENMV_len > CURTV_len )
													{
														if ( !ENM.mDead  )
														{
															AssginTarget( ENM );
														}
													}
													break;
												}
												case 3:
												{
													if ( ENM.mAttack > mMyTarget.mAttack )
													{
														if ( !ENM.mDead  )
														{
															AssginTarget( ENM );
														}
													}
													break;
												}
												case 4:
												{
													if ( ENM.mAttack < mMyTarget.mAttack )
													{
														if ( !ENM.mDead  )
														{
															AssginTarget( ENM );
														}
													}
													break;
												}
												case 5:
												{
													if ( ENM.mMaxHealth > mMyTarget.mMaxHealth )
													{
														if ( !ENM.mDead  )
														{
															AssginTarget( ENM );
														}
													}
													break;
												}
												case 6:
												{
													if ( ENM.mMaxHealth < mMyTarget.mMaxHealth )
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
										// NO CUR TARGET
										// ASSIGN THIS TARGET TO CURRENT 
										if ( ENM )
										{
											if( !ENM.mDead )
											AssginTarget( ENM );
										}
									}
									
								}
							}
							
						}
						iter.forth();
						
					}
				}
				
		}
		
		function AssginTarget( tgt )
		{
			mLastTrgt = mMyTarget;
			mMyTarget = tgt;			
			
			if ( tgt )
			{
				GetDirection();
			}
		}
		
		function GetDirection()
		{
			if ( mMyTarget )
			{
				
				var pY = mY;
				var pX = mX;
				
				var theX:int = mMyTarget.mX - pX;
				var theY:int = (mMyTarget.mY - pY) * -1;
				var angle = Math.atan(theY / theX) / (Math.PI / 180);				
				
				if (theX<0) {
					angle += 180;
				}
				if (theX>=0 && theY<0) {
					angle += 360;
				}
				
				mFacing = 90 - angle;   // <--- DEGREES OUT OF 360, 0* FACES NORTH(UP)
				
			}
		}
		
		
		function CheckFacing()
		{
			
			if ( mOldFacing != mFacing )
			{
				
				// convert the difference between the two angles to radians
				var diff:Number = (mFacing - mOldFacing) * (Math.PI / 180);
				
				// find the rotation of the vector created by the sin and cos of the difference
				var rotationDifference:Number = Math.atan2( Math.sin(diff), Math.cos(diff) );
				
				// rotate the clip accordingly
				// TURN OBJECT -----
				mOldFacing += Math.max( Math.min( (180 / Math.PI) * rotationDifference, mTurnSpeed ) , -mTurnSpeed );
				
				// STOP TURNING IF CLOSE ---
				if ( Math.abs(mOldFacing - mFacing) <= mTurnSpeed )
				{
					mOldFacing = mFacing;
				}
				
			}
			
			// CONVERT FROM 360 T0 180/-180
			if ( mOldFacing > 180 )
			{
				mHeadClip.rotation = -1 * (360 - mOldFacing);
			}
			else
			{
				mHeadClip.rotation = mOldFacing;				
			}
			
		}
		
		
		
		function Attack()
		{
			//  TGT HELATH -= ( ATK + (MODIFIER) ) / ( SPEED * GAME SPEED )
			
			if ( mLastTrgt != mMyTarget )
				{
					if ( mLastTrgt )
					{
						// APPLY DAMAGE, TARGET HAS CHANGED
						
						// REMOVED DAMAGE FOR ALL TOWERS.  FOR SNIPER, DAMAGE MUST BE DEALT 'AFTER'
						// ENEMY HAS BEEN IN RANGE FOR 'TIME'.  NO LONGER A PERCENTAGE OF AMOUNT OF TIME ENM
						// 'WAS' IN RANGE.
						
						//mLastTrgt.mHealth -= mDamage;
						
						mDamage = 0;
						mLastTrgt = mMyTarget;
					}
				}
				
			if ( mMyTarget )
			{
				//var str = mAttack ;
				//var times_in_sec = ( 1000 / mSpeed );//+ mPlayer.mAgility) ) * mPlayer.mSpeed );
				
				// should get called evry frame, so damge gets distrib(divided by frames)
				//var ms = mBoard.mMain.stage.frameRate;
				//mDamage +=  str  * times_in_sec / ms;//fps;
				
				mLastTimeCalled = mBoard.mGlobalTimer;
				
				// 500 * 1 < time_now - last attack
				
				// CALLED ON ATTACK SPEED
				if ( (mSpeed / mPlayer.mSpeed) < mBoard.mGlobalTimer - mLstAtkTime )
				{
					mLstAtkTime = mBoard.mGlobalTimer;
					mMyTarget.mHealth -= mAttack;
					mDamage = 0;					
					
					mAttkFrmTime = mAttackFrames;
					
					mHeadClip.gotoAndPlay( (mLevel * upFrame) + atkFrame );
					
					mProjDestn = new Point(mMyTarget.mX, mMyTarget.mY);
				}
			}
			
			
		}
		
		
		function SpawnProjectile()
		{
			// OVERRIDE			
		}
		
		function HitTestForSwap()
		{
			var MIN = mX - mMovieClip.width - 60;
			var MAX = mX + mMovieClip.width + 60;
			
			var list:DLinkedList = mBoard.mTwrsOnBrd;
			var iter:DListIterator = list.getListIterator();	
			
			for ( var i = 0; i < list.size; ++i )
			{
				if ( iter.valid() )
				{
					var xValu = iter.data.mX;
					if ( xValu >= MIN && xValu <= MAX )
					{
						var actT:MovieClip = iter.data.mActualTowerClip;
						var mC:MovieClip = iter.data.mMovieClip;
						if ( mActualTowerClip.hitTestObject(actT) )
						{
							//trace ("Hit Tower");
							if ( mMovieClip.y > mC.y && 
								( mBoard.mMapSet.getChildIndex(mMovieClip) < mBoard.mMapSet.getChildIndex(mC) ) )							
							{
								mBoard.mMapSet.swapChildren(mMovieClip, mC);
							}	
							else if ( mMovieClip.y < mC.y && 
								( mBoard.mMapSet.getChildIndex(mMovieClip) > mBoard.mMapSet.getChildIndex(mC) )	)						
							{
								mBoard.mMapSet.swapChildren(mMovieClip, mC);
							}	
						}
					}
					
					iter.forth();
				}
			}
			
		}
		
		function UpgradeThisTower()
		{
			//trace ("Upgrading Tower");
			var cost = mUpgradeCost[mLevel + 1];
			if ( mLevel < mMaxUpgLevl )
			{
				if ( mPlayer.mMoney >= cost )
				{
					mLevel += 1;
					mPlayer.mMoney -= cost;
					
					UpdateStats();
					GetSellCost();
					mHeadClip.gotoAndPlay( (mLevel * upFrame) );
				}
				//trace("Level: " + mLevel);
			}
			
		}
		
		function UpdateStats()
		{
			
		}
		
		function SellThisTower()
		{
			
			mPlayer.mMoney += Math.round(mSellCost);
			
			RemoveMe();			
			
			// PLAY SOUND: SELL
			if ( mUpgradeCost[mLevel]  > 0 )
			{
				//play sound
			}
			// MONEY SLIDE OUT
		}
		
		function RemoveMe()
		{
			//trace ("removing function " + mType);
			
			var itr:DListIterator = mBoard.mTwrsOnBrd.getListIterator();
			for ( var k = 0; k < mBoard.mTwrsOnBrd.size; ++k)
			{
				if ( itr.valid() )
				{
					if ( itr.data == this )
					{
						//trace ("REMOVING: " + mType);
						mBoard.mTwrsOnBrd.remove(itr);
					}
				}
				itr.forth();
			}
			
			mMovieClip.removeEventListener(Event.ENTER_FRAME, movieFrameEvent );
			mMovieClip.parent.removeChild(mMovieClip);
			mRangeClip.parent.removeChild(mRangeClip);
			mVisible = false;
			mDead = true;
		}
		
		function TakeDamage( dmg )
		{
			//trace("Twr TAKING DAMAGE " + dmg);
		}
		
		function GetSellCost()
		{
			mSellCost = 0;
			
			for ( var ml = mLevel; ml >= 0; --ml )
			{
				mSellCost += Math.round(mUpgradeCost[mLevel] / 2);
			}
			
			//mSellCost -= (mSellCost * (1 - (mHealth / mMaxHealth)) );
			mSellCost += Math.round( mSellCost * mPlayer.mWisMod );
		}
	}
	

}