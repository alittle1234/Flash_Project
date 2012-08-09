package  
{
	/**
	 * ...
	 * @author AARON
	 */
	
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class PFX_Poison extends PersistantEffect
	{
		var mGeneration;
		var mTime;
		
		var mTargets:DLinkedList;
		var mRange;
		var mPos:Point;
		var MIN_X;
		var MAX_X;
		
		public function PFX_Poison( twr:Tower, enm:Enemy, dmg, rate, lfspn ) 
		{
			super ( twr, enm, dmg, rate, lfspn);
			
			mTime = twr.mBoard.mGlobalTimer;
			
			mTargets = new DLinkedList();
			mRange = 30;
			mPos = new Point(enm.mX, enm.mY);
			MIN_X = enm.mX - mRange - 30;
			MAX_X = enm.mX + mRange + 30;
		}
		
		override function AddMovieClip()
		{
			if ( mEnemy.mOnSmoke )
			{
				mEnemy.mMovieClip.gotoAndPlay(mEnemy.bthFrame);
			}
			else
			{
				mEnemy.mMovieClip.gotoAndPlay(mEnemy.psnFrame);
			}
			
				mLastFrameTime = mEnemy.mBoard.mGlobalTimer;
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new MovieClip();
			
			if ( ! mEnemy.mOnPoison )
			{
				//trace ("pushing psn ");
				mEnemy.mPersFXArr.push(this);
				mEnemy.mOnPoison = true;
				
				AddMovieClip();
			}
			
		}
		
		override function DoFrameEvents()
		{
			
			GetLifeSpan();
			if ( mLifespan < 0 )
			{
				RemoveThis();
				mEnemy.mOnPoison = false;
				if ( mEnemy.mOnSmoke )
				{
					mEnemy.mMovieClip.gotoAndPlay(mEnemy.smkFrame);
				}
				else
				{
					mEnemy.mMovieClip.gotoAndPlay(mEnemy.normFrame);
				}
			}
			else
			{
				mEnemy.mOnPoison = true;
				var FPS = mEnemy.mBoard.mMain.stage.frameRate;
				var dmg =  mDamage  * mRate/1000 / FPS;
				mEnemy.TakeDamage( dmg );
			}
			
			if ( mGeneration )
			{
				if ( 1000 < ( mTower.mBoard.mGlobalTimer - mTime) )
				{
					// FIND TARGETS
					// INFECT
					GetEnemys();
					Attack();
					
					mGeneration = 0;
				}
			}
		}
		
		function Attack()
		{
			if ( mTargets )
			{
				if ( ! mTargets.isEmpty() )
				{
						var iter:DListIterator = mTargets.getListIterator();
						
						for ( var i = 0; (i < mTargets.size) && (i < mGeneration); ++i )			
						{
							if ( iter.valid() )
							{
								
								var ENM:Enemy = Enemy(iter.data);
								if ( !ENM.mOnPoison )
								{
									var psn = new PFX_Poison( mTower, ENM, 40, 1000, 3000);
									psn.mGeneration = mGeneration - 1;
								}
								
							}
							iter.forth();
						}
						
					
				}
			}
		}
		
		function GetEnemys()
		{
			var list:DLinkedList = mTower.mBoard.mEnemiesVisibleList;
			var iter:DListIterator = list.getListIterator();
			
			mTargets.clear();
			
			//trace ("AOE:GET.ENM: " + mTargets.size );
			for ( var i = 0; i < list.size; ++i )			
			{
				if ( iter.valid() )
				{
						
					var ENM:Enemy = Enemy(iter.data);
					var ePnt:Point = new Point( ENM.mX, ENM.mY );
					
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
				iter.forth();
			}
			
			//trace ("MTRGT.S: " + mTargets.size);
		}
	}

}