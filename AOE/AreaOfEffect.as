package  
{
	import adobe.utils.CustomActions;
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import flash.display.MorphShape;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author AARON
	 */
	public class AreaOfEffect
	{
		var mSpeed;
		var mAttack;
		var mRange;
		var mLifeSpan;
		var mSpawnTime;
		var mTargets:DLinkedList;
		var mMovieClip:MovieClip;
		
		var mPos:Point;
		//var mTwr:Tower;
		var mBoard:GameBoard;
		var mTower:Tower;
		
		var MIN_X;
		var MAX_X;
		
		var mLstAtkTime;
		
		public function AreaOfEffect( TowerT:Tower, Board:GameBoard, Pos:Point, Speed = 0, Attack = 10, Range = 10, LifeSpan = 10	) 
		{
			mTower = TowerT;
			mBoard = Board;
			mSpeed = Speed;
			mAttack = Attack;
			mRange = Range;
			mLifeSpan = LifeSpan;
			
			
			mPos = new Point(Pos.x, Pos.y);
			mTargets = new DLinkedList();
			
			mSpawnTime = mBoard.mGlobalTimer;
			
			MIN_X = mPos.x - mRange - 60;
			MAX_X = mPos.x + mRange + 60;
			
			mLstAtkTime = 0;
			
			CreateMovieClip();
			if ( mMovieClip )
			{
				mBoard.mMapSet.addChild(mMovieClip);
				mMovieClip.addEventListener(Event.ENTER_FRAME, DoEveryFrame  );
				mMovieClip.x = mPos.x;
				mMovieClip.y = mPos.y;
				SpawnCheckForSwap();
			}
			//trace ("MADE AOE?");
		}
		
		function CreateMovieClip()
		{
			
		}
		
		function SpawnCheckForSwap()
		{
			
			if ( mMovieClip )
			{
				// TWRS
				var list:DLinkedList = mBoard.mTwrsOnBrd;
				var iter:DListIterator = list.getListIterator();	
				
				for ( var i = 0; i < list.size; ++i )
				{
					if ( iter.valid() )
					{
						var xValu = iter.data.mX;
						if ( xValu >= MIN_X && xValu <= MAX_X )
						{
							var actT:MovieClip = iter.data.mActualTowerClip;
							var twr:MovieClip = iter.data.mMovieClip;
							if ( mMovieClip.hitTestObject(actT) )
							{
								if ( twr.y > mMovieClip.y )
								{
									if (  mBoard.mMapSet.getChildIndex(mMovieClip) > mBoard.mMapSet.getChildIndex(twr) )							
									{
										mBoard.mMapSet.swapChildren(mMovieClip, twr);
									}
								}
								else // mc.y <=
								{
									if (  mBoard.mMapSet.getChildIndex(mMovieClip) < mBoard.mMapSet.getChildIndex(twr) )							
									{
										mBoard.mMapSet.swapChildren(mMovieClip, twr);
									}
								}
							}
						}
						
						iter.forth();
					}
					
					
				}
				
				
				// ENM
				EnmCheckForSwap();
			
			}
			
		}
		
		function EnmCheckForSwap()
		{
			// ENM
			var list:DLinkedList = mBoard.mEnemiesVisibleList;
			var iter:DListIterator = list.getListIterator();			
			
			for ( var i = 0; i < list.size; ++i )
			{
				if ( iter.valid() )
				{
					var xValu = iter.data.mX;
					if ( xValu >= MIN_X && xValu <= MAX_X )
					{
						var mc:MovieClip = iter.data.mMovieClip;
						
						if ( mc )
						{
							if ( mMovieClip.hitTestObject(mc) )
							{
								if ( mc.y > mMovieClip.y )
								{
									if (  mBoard.mMapSet.getChildIndex(mMovieClip) > mBoard.mMapSet.getChildIndex(mc) )							
									{
										mBoard.mMapSet.swapChildren(mMovieClip, mc);
									}
								}
								else // mc.y <=
								{
									if (  mBoard.mMapSet.getChildIndex(mMovieClip) < mBoard.mMapSet.getChildIndex(mc) )							
									{
										mBoard.mMapSet.swapChildren(mMovieClip, mc);
									}
								}
							}
							
						}
						
					}
					
					iter.forth();
				}
			}
			
		}
		
		function GetEnemys()
		{
			var list:DLinkedList = mBoard.mEnemiesVisibleList;
			var iter:DListIterator = list.getListIterator();
			
			mTargets.clear();
			
			//trace ("AOE:GET.ENM: " + mTargets.size );
			for ( var i = 0; i < list.size; ++i )			
			{
				if ( iter.valid() )
				{
						
					var ENM:Enemy = Enemy(iter.data);
					var ePnt:Point = new Point( ENM.mX, ENM.mY );
					
					if ( !ENM.mFlying )
					{
						//var halfWidth = ENM.mMovieClip.width / 2;
						
						// LIST OF POSSIBLES TO CHECK VECTOR
						if ( ePnt.x >= MIN_X && ePnt.x <= MAX_X )
						{
							// GET VECTOR
							var eDist = Point.distance(ePnt, mPos);
							//trace ("DIST: " + i + " "  + eDist + " "  + mRange);
							if ( (eDist) <= mRange )
							{
								mTargets.append(ENM);
							}
						}
					}
					
				}
				iter.forth();
			}
			
			//trace ("MTRGT.S: " + mTargets.size);
		}
		
		function DoEveryFrame( event:Event )
		{
			//trace ("dOING FRAME?");
			if ( !mBoard.mPlayer.mPaused )
			{
				TempFrameFunc();
				GetEnemys();
				SpawnCheckForSwap();
				Attack();
				GoAway();
				
			}
		}
		
		function TempFrameFunc()
		{
			
		}
		
		function Attack()
		{
			if ( mTargets )
			{
				if ( ! mTargets.isEmpty() )
				{
					// CALLED ON ATTACK SPEED
					if ( (mSpeed / mBoard.mPlayer.mSpeed) < mBoard.mGlobalTimer - mLstAtkTime )
					{
						mLstAtkTime = mBoard.mGlobalTimer;
						
						var iter:DListIterator = mTargets.getListIterator();
						
						for ( var i = 0; i < mTargets.size; ++i )			
						{
							if ( iter.valid() )
							{
								
								var ENM:Enemy = Enemy(iter.data);
								//trace ("ATTAKING: " + ENM.mOnSmoke + " " + i+ " " +mTargets.size  + " " + ENM.mX);
								ApplyDamage( ENM );
								
							}
							iter.forth();
						}
						
					}
				}
			}
		}
		
		function ApplyDamage( enm:Enemy )
		{
			
		}
		
		function GoAway()
		{
			//  TIME NOW - TIME SPAWNED >> AMNT OF TIME TO LIVE
			if ( mBoard.mGlobalTimer - mSpawnTime > mLifeSpan / mBoard.mPlayer.mSpeed )
			{			
				//trace ("LEAVING?");

				mMovieClip.removeEventListener(Event.ENTER_FRAME, DoEveryFrame);
				
				if ( mMovieClip )
				{
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
		
	}

}