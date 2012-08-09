package  
{
	/**
	 * ...
	 * @author AARON
	 */
	
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class Enemy
	{
		var mType;
		var mSpeed;
		var mRoute:Number;			//index
		var mDestin:Number; 		//index
		var mSpawnTimer;
		var mHealth;
		var mMaxHealth; 
		var mHealthBar;
		var mAttack;
		var mColor;
		var mVisible;
		
		var mMoneyValue;
		var mXpValue;
		var mLifeValue;
		
		var mBoard:GameBoard;
		var mPlayer:Player;
		
		var mDead;
		
		var mY:Number;
		var mX:Number;
		var changeY;
		var changeX;
		
		var mMovieClip:MovieClip;
		
		var mOnFire;
		var mOnPoison;
		var mOnSmoke;
		var mOnFlash;
		
		var psnFrame;
		var smkFrame;
		var bthFrame;
		var normFrame;
		
		var mFirePnt:Point;
		var mPoisPnt:Point;
		var mSmkePnt:Point;
		var mFlshPnt:Point;
		
		var mPersFXArr:Array;  // CONTAINER FOR PERSITANT FX.  ONLY ONE OF EACH TYPE
		
		var mFacing;			// ONE NUMBER, CORRESPONDS WITH POSSIBLE DIRECTIONS TO FACE
								// DEGREE 0 - 270
		var mOldFacing;
		var mTurnSpeed;
		
		var mFlying:Boolean;
		
		var mDied:Boolean;
		var mDiedTime;
		
		var mEscaped:Boolean;
		
		var mWarping;
		
		var mSpawned = false;
		
		
		public function Enemy(y_pos, x_pos, type, speed, route:Number, destin:Number, timer, health, attack, color, BOARD ) 
		{
			mY = y_pos;
			mX = x_pos;
			
			mType = type;
			mSpeed = speed;
			mRoute = route;
			mDestin = destin;
			mSpawnTimer = timer;
			mHealth =  health;
			mMaxHealth = health;
			mAttack = attack;
			mColor = color;
			
			
			mBoard = BOARD;
			mPlayer = mBoard.mMain.MAIN_PLAYER;
			
			mVisible = true;
			mDead = false;
			mEscaped = false;
			
			mPersFXArr = [];
			mOnFire = false;
			mOnFlash = false;
			mOnSmoke = false;
			mOnPoison = false;
			
			bthFrame = 45;
			psnFrame = 30;
			smkFrame = 15;
			normFrame = 1;
		
			mFacing = 0;
			mOldFacing  = mFacing;
			mTurnSpeed = 8;
			
			mDied = false;
			mDiedTime = 0;
			
			mFlying = false;
			
			mWarping = 0;
			
			InitializePersPoints();
		}
		
		function InitializePersPoints()
		{
			
		}
		
		function DoPersFX()
		{
			for ( var i in mPersFXArr )
			{
				
				var p:PersistantEffect = mPersFXArr[i];
				if ( p.mMovieClip == null )
				{
					
					mPersFXArr.splice(i, 1);
				}
				else
				{
					p.DoFrameEvents();
				}
			}
		}
		
		function InitializeMovieClip()
		{
			mMovieClip.x = mX;
			mMovieClip.y = mY;
			
			//mMovieClip.visible = false;
			mMovieClip.addEventListener(Event.ENTER_FRAME, movieFrameEvent, false, 0, true );
			mMovieClip.addEventListener(Event.REMOVED_FROM_STAGE, ClearEvent , false, 0, true);			
		}
		
		function ClearEvent( e:Event )
		{
			//trace ( "CLEAR EVENT: " + mX + " " + mY);
			mMovieClip.removeEventListener( Event.ENTER_FRAME, movieFrameEvent);
			mMovieClip.removeEventListener( Event.REMOVED_FROM_STAGE, ClearEvent);
		}
		
		function movieFrameEvent( event:Event ):void
		{
			// THIS MOVIECLIP DOSE THIS FUNCTION EVEN IF NOT-VISIBLE
			if ( mBoard.mFrameCount % 30 == 0 )
			{
			
				//trace ("MOVIE.FRAME");
			}
			
			
				if ( mSpawned )	// <-- SET BY GAMEBOARD.   MOVIE EXISTS BEFORE BEING PLACED ON SCREEN
				{
					EnemyUpdate();
				}
				
		}
		
		function EnemyUpdate()
		{
			if ( mBoard.mFrameCount % 30 == 0 )
			{
			
				//trace ("ENM.UPDATE");
			}
			
			if ( !mDead )
			{
				//trace ("NOT DEAD");
				
					if ( !mPlayer.mPaused )
					{
						Walk();	
						HitTestForSwap();
						DoPersFX();					
						
						// FACING
						CheckFacing();
						
						CheckHealth();
					}
					
			}
			else
			{
				//trace ("ENEMY IS DEAD");
				
				if( mMovieClip )
				{				
					if ( !mDied )
					{
						KillMe();
						
						//mMovieClip.visible = false;
					}
					else
					{
						// Enemy has died
						// Enemy stays dead for . frames
						
						if( mDiedTime > 5 )
						{
							//trace ("ENMY.MC.VIS = FALSE-> REMOVING " + mX + " " + mY);
							if ( mMovieClip.parent )
							{
								mMovieClip.parent.removeChild(mMovieClip);
							}
							
							else 
							{								
								mMovieClip = null;
							}
							
							
						}
						
					}
					
				}
				
				mDiedTime += 1;
			}
			
		}
		
		function Walk()
		{
			
			if ( mWarping )
			{
				mWarping--;
			}
			else
			{
				mY += changeY;
				mX += changeX;	
			}
			
			if ( mMovieClip )
			{
				mMovieClip.x = mX;
				mMovieClip.y = mY;
			}
			
		}
		
		function Pathfinding( vLen:Number, vXLen, vYLen )
		{			
			
			changeX = vXLen / vLen * mSpeed * mPlayer.mSpeed;
			changeY = vYLen / vLen * mSpeed * mPlayer.mSpeed;
		}
		
		function CheckDestination( CALLS:Number )
		{
			var THRESHOLD = mSpeed * mPlayer.mSpeed * Math.ceil(CALLS / 2);			
			
			var vXLen = mBoard.mPathsWaypnts[mRoute][mDestin].value2 - mX;
			var vYLen = mBoard.mPathsWaypnts[mRoute][mDestin].value1 - mY;
			
			var vLen = Math.sqrt( (vXLen * vXLen) + (vYLen * vYLen ));
				
			if ( vLen < THRESHOLD )
			{			
				
				if ( mDestin == mBoard.mPathsWaypnts[mRoute].length -1 )
				{	// ENEMY HAS ARRIVED AT LAST DESTINATION
					
					changeX = 0;
					changeY = 0;
					// arrived at Final Destination
						// DOCK SOME POINTS HERE, MAKE NOT-VISIBLE, SOUND EFFECT
						
					//trace ("ARRIVED");
					if ( !mDead )
					{
						mPlayer.mLives -= mLifeValue;
						mBoard.mLivesLost += mLifeValue;
						
						var mFlt_Box = new LifeBox( 30 * 3 );
						
						mFlt_Box.x = 480;
						mFlt_Box.y = 70;						
						mFlt_Box.mText = "LIFE!";
						mFlt_Box.mCostText = "- " + (mLifeValue);
						mBoard.mMapSet.addChild( mFlt_Box );
						
					}
					mDead = true;			
					mEscaped = true;
					
				}
				else
				{
					// GO TO NEXT DESTINATION
					mDestin++;
					Pathfinding( vLen, vXLen, vYLen );
					GetDirection();
				}
			}
			else
			{
				Pathfinding( vLen, vXLen, vYLen );
			}
			
		}
		
		function HitTestForSwap()
		{
			
			// ONLY CALLED IF NOT DEAD
			
			var MIN = mX - mMovieClip.width - 60;
			var MAX = mX + mMovieClip.width + 60;
			
			var list:DLinkedList = mBoard.mEnemiesVisibleList;
			var iter:DListIterator = list.getListIterator();			
			
			if ( mMovieClip )
			{
				
				if ( mVisible )
				{
					
				
					//-------------------------------------
					// ENEMIES
					//-------------------------------------
					
					for ( var i = 0; i < list.size; ++i )
					{
						if ( iter.valid() )
						{
							if ( ! iter.data.mDead )
							{
								//-------------------------------------
								var xValu = iter.data.mX;
								if ( xValu >= MIN && xValu <= MAX )
								{
									
									var mc:MovieClip = iter.data.mMovieClip;
									
									//-------------------------------------
									if ( mc )
									{
										if ( mFlying )
										{
											if ( mMovieClip.hitTestObject(mc) )
											{
												if ( mBoard.mMapSet.getChildIndex(mMovieClip) < mBoard.mMapSet.getChildIndex(mc)  )							
												{
													mBoard.mMapSet.swapChildren(mMovieClip, mc);
												}	
												
											}
										}
										
									}
									//-------------------------------------
									
								}
								//-------------------------------------
							}
							
							iter.forth();
						}
					}
					
					//-------------------------------------
					// TOWERS
					//-------------------------------------
					var list:DLinkedList = mBoard.mTwrsOnBrd;
					var iter:DListIterator = list.getListIterator();	
					
					
					for ( var i = 0; i < list.size; ++i )
					{
						if ( iter.valid() )
						{
							var xValu = iter.data.mX;
							if ( xValu >= MIN && xValu <= MAX )
							{
								var twr:MovieClip = iter.data.mMovieClip;
								if ( twr )
								{
									if ( mMovieClip.hitTestObject(iter.data.mActualTowerClip) )
									{
										if ( ( mFlying ) && 
											( mBoard.mMapSet.getChildIndex(mMovieClip) < mBoard.mMapSet.getChildIndex(twr) ) )							
										{
											mBoard.mMapSet.swapChildren(mMovieClip, twr);
										}	
										else if ( ( !mFlying ) && 
											( mBoard.mMapSet.getChildIndex(mMovieClip) > mBoard.mMapSet.getChildIndex(twr) ) &&
											  !iter.data.mOnGround )						
										{
											mBoard.mMapSet.swapChildren(mMovieClip, twr);
										}	
									}
									
								}
								
							}
							
							iter.forth();
						}
					}
					
				
				}
				
				
			}
			
		}
		
		
		function CheckHealth()
		{
			/*
			if ( mHealthBar )
			{
				//trace ("HELTCHK");
				if ( mHealth > ( mMaxHealth * .95 ) )
				{
					mMovieClip.removeChild( mHealthBar );
					mHealthBar = null;
				}
				else
				{
					var bar = mHealthBar.getChildByName("bar");
					bar.width = mHealthBar.width * ( mHealth / mMaxHealth );
					bar = null;
				
			}
			else
			{
				// NO HEALTH BAR
				if ( mHealth <= ( mMaxHealth * .95 ) )
				{
					mHealthBar = new HealthBar();
					var bar = mHealthBar.getChildByName("bar");
					bar.width = mHealthBar.width * ( mHealth / mMaxHealth );
					
					mMovieClip.addChild( mHealthBar );					
					
					//mHealthBar.x = - (mHealthBar.width/2);
					mHealthBar.y = -80;
					bar = null;
				}
			}
			*/
			
			
			if ( mHealth <= 0 )
			{
				if ( mHealthBar )
				{				
					mMovieClip.removeChild( mHealthBar );
					mHealthBar = null;
				}
				
				mDead = true;
			}
		}
		
		
		function GetDirection()
		{
			
				var pY = mY;
				var pX = mX;
				
				var theX:int = mBoard.mPathsWaypnts[mRoute][mDestin].value2 - pX;
				var theY:int = (mBoard.mPathsWaypnts[mRoute][mDestin].value1 - pY) * -1;
				var angle = Math.atan(theY / theX) / (Math.PI / 180);				
				
				if (theX<0) {
					angle += 180;
				}
				if (theX>=0 && theY<0) {
					angle += 360;
				}
				
				mFacing = 90 - angle;   // <--- DEGREES OUT OF 360, 0* FACES NORTH(UP)
			
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
				mMovieClip.rotation = -1 * (360 - mOldFacing);
			}
			else
			{
				mMovieClip.rotation = mOldFacing;				
			}
			
		}
		
		
		function Attack()
		{
			
		}
		
		function TakeDamage( dmg )
		{
			//trace ("Enm DAMG: " + dmg);
			mHealth -= dmg;
		}
		
		function KillMe()
		{
			//trace ("ENEMY died");
			//-------------------------------------
			if( !mEscaped )
			{
				var death =  new Vehicle_Death() ;
				
				if ( mMovieClip.width > mMovieClip.height )
				{
					death.width = mMovieClip.width;
					death.height = mMovieClip.width;
				}
				else
				{
					death.width = mMovieClip.height;
					death.height = mMovieClip.height;
				}
				
				death.x = mMovieClip.x;
				death.y = mMovieClip.y;
				
				mBoard.mMapSet.addChild( death );
				
				
				
				// PLAY SOUND
				// 
				var num = Math.round( (Math.random() * 6) + 1);
				mBoard.mMain.SOUND_STAGE.PlaySound("car_explo_" + num , 320);
				// EXPLOSION
				
				//mBoard.mMain.SOUND_STAGE.PlaySound("ENEMY_DEATH", mX);
				
				
			}
			//-------------------------------------
			
			mY = -1500;
			mX = -1500;
			mMovieClip.x = -1500;
			mMovieClip.y = -1500;
			
			
			//-------------------------------------
			mDied = true;  //<--- call this func only once
			
			mDiedTime = 0;
			//-------------------------------------
			
			

			if( !mEscaped )
			{
				mPlayer.AwardMoney( mMoneyValue );
				mPlayer.AwardXP( mXpValue );
				
				mBoard.mXpEarned += mXpValue;
				mBoard.mKills += 1;
				
				
				//-------------------------------------
				var float = new MONEY_AWARD_FLOAT();
				float.x = 530;
				float.y = 53;
				
				float.text = "+ " + Math.round( mMoneyValue + (mMoneyValue * mPlayer.mWisMod) );
				
				float.scaleX = 1.5;
				float.scaleY = 1.5;	
				
				mBoard.mMapSet.addChild(float);
				
				
				var flotX:MovieClip = new XP_AWARD_FLOAT();
				flotX.x = 524;
				flotX.y = 405;
				
				flotX.text = "+ " + mXpValue;	
				
				flotX.scaleX = 1.5;
				flotX.scaleY = 1.5;		
				
				mBoard.mMapSet.addChild(flotX);
				//-------------------------------------
			}
			
			//-------------------------------------
			//mVisible = false;
			//mMovieClip.visible = false;
			
			for ( var i in mPersFXArr )
			{
				var p:PersistantEffect = mPersFXArr[i];
				
				p.mMovieClip = null;
				mPersFXArr.splice(i, 1);				
			}
			
			mBoard.mKillCounter += 1;
			
		}
		
		
		
	}

}