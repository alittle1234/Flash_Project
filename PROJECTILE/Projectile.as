package  
{
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * ...
	 * @author AARON
	 */
	public class Projectile
	{
		var BullRot;
		
		var mMyPos:Point;
		var mDest:Point;
		var mChangeRate:Point;
		var mSpeed;
		var mTwr:Tower;
		var mPlyr:Player;
		var mBoard:GameBoard;
		var mGrndEffct;
		var mMovieClip;
		
		var mDone;
		
		var mFrameCount;
		
		var len;
		
		// CLASS OBJ, SPAWNS A MOVIECLIP(OR NOT) AND MOVES IN THE DIRECTION
		// OF THE DESTINATION AT THE SPEED GIVN.
		// WHEN ARRIVES, SPAWNS GROUND EFFECT
		// GROUND EFFECT MAY BE AN AOE, OR MAY JUST BE FOR APPEARANCE
		
		public function Projectile( pos:Point, dest:Point, speed, tower ) 
		{
			
			mDest = dest;
			mChangeRate = new Point();
			mSpeed = speed;
			mTwr = tower;	
			mPlyr = mTwr.mBoard.mPlayer;
			mBoard = mTwr.mBoard;
			
			mMyPos = mTwr.mHeadClip.localToGlobal(mTwr.mProjSpwnPnt);
			
			GetVector();
			// DO FRAME EVENTS ATTACHED TO CALLING TOWER MC
			// OR TO MOVIELIP OF PROJECTILE
			
			mDone = false;
			mFrameCount = 0;
		}
		
		function BullitVector()
		{
			var pY = mMyPos.y;
			var pX = mMyPos.x;
			
				
				var theX:int = mDest.x - pX;
				var theY:int = (mDest.y - pY) * -1;
				var angle = Math.atan(theY / theX) / (Math.PI / 180);
				
				
				if (theX<0) {
					angle += 180;
				}
				if (theX>=0 && theY<0) {
					angle += 360;
				}
				
				BullRot = (angle * -1) + 90;
					
		}
		
		
		function GetVector()
		{
			len = Point.distance(mDest, mMyPos);
			
			var x_len = mDest.x - mMyPos.x;
			var y_len = mDest.y - mMyPos.y;			
			
			mChangeRate.x = x_len / len * mSpeed * mPlyr.mSpeed;
			mChangeRate.y = y_len / len * mSpeed * mPlyr.mSpeed;
		}
		
		function Move()
		{
			mMyPos.x += mChangeRate.x;
			mMyPos.y += mChangeRate.y;
		}
		
		function DoFrameEvents()
		{
			if ( !mPlyr.mPaused )
			{
				if ( !mDone )
				{
					Move();
					if ( Point.distance(mMyPos, mDest) < mSpeed * mPlyr.mSpeed )
					{
						DeleteFromCalling();
						//trace ("PROJ.ARRIVED!");
					}
					
					if ( mFrameCount )
					{
						if ( mMovieClip )
						{
							if ( !mDone )
							{
								HitTestForSwap();
							}
							
						}
						
						mFrameCount = -1;
					}
					++mFrameCount;
					
				}
				
			}
			
			if ( mMyPos.x > 680  || mMyPos.x < -50  || mMyPos.y > 550 || mMyPos.y < -50 )
			{
				DeleteFromCalling();
			}
			
		}
		
		function DeleteFromCalling()
		{
			SpawnGroundEffect();
			
			// NULLIFY TOWER PROJECTILE CALL, IF ARRAY OR SINGLE.  SET TO NULL
			mDone = true;
			
		}
		
		public function SpawnGroundEffect()
		{
			
		}
		
		function HitTestForSwap()
		{
			var MIN = mMyPos.x - mMovieClip.width - 60;
			var MAX = mMyPos.x + mMovieClip.width + 60;
			
			var list:DLinkedList = mBoard.mEnemiesVisibleList;
			var iter:DListIterator = list.getListIterator();			
			
			if ( mMovieClip )
			{
				//-------------------------------------
				// ENEMIES
				//-------------------------------------
				
				for ( var i = 0; i < list.size; ++i )
				{
					if ( iter.valid() )
					{
						var xValu = iter.data.mX;
						if ( xValu >= MIN && xValu <= MAX )
						{
							
							if ( !iter.data.mDead )
							{
								if ( iter.data.mVisible )
								{
									var enm_mc:MovieClip = iter.data.mMovieClip;
									
									//-------------------------------------
									if ( enm_mc )
									{
										if ( mMovieClip.hitTestObject(enm_mc) )
										{
											if ( mBoard.mMapSet.getChildIndex(mMovieClip) < mBoard.mMapSet.getChildIndex(enm_mc) )							
											{
												mBoard.mMapSet.swapChildren(mMovieClip, enm_mc);
											}
										}
									}
									//-------------------------------------
								}
								
							}
							
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
								if ( twr.root )
								{
									if ( mMovieClip.hitTestObject(iter.data.mActualTowerClip) )
									{
										if ( mBoard.mMapSet.getChildIndex(mMovieClip) < mBoard.mMapSet.getChildIndex(twr)  )							
										{
											mBoard.mMapSet.swapChildren(mMovieClip, twr);
										}	
										
									}
									
								}
							}
							
						}
						
						iter.forth();
					}
				}
				//-------------------------------------
				
			}
			
		}
		
	}

}