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
	
	public class PFX_Fire extends PersistantEffect
	{
		var mGeneration;
		var mTime;
		
		var mTargets:DLinkedList;
		var mRange;
		var mPos:Point;
		var MIN_X;
		var MAX_X;
		
		public function PFX_Fire( twr:Tower, enm:Enemy, dmg, rate, lfspn ) 
		{
			super ( twr, enm, dmg, rate, lfspn);
			
			mTime = twr.mBoard.mGlobalTimer;
			
			mPos = new Point(enm.mX, enm.mY);
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new MovieClip();
			mPoint = mEnemy.mFirePnt;
			
			if ( ! mEnemy.mOnFire )
			{
				mEnemy.mPersFXArr.push(this);
				mEnemy.mOnFire = true;
				
				AddMovieClip();
			}
		}
		
		override function DoFrameEvents()
		{
			
			GetLifeSpan();
			if ( mLifespan < 0 )
			{
				RemoveThis();
				mEnemy.mOnFire = false;
			}
			else
			{
				mEnemy.mOnFire = true;
				var FPS = mEnemy.mBoard.mMain.stage.frameRate;
				var dmg =  mDamage  * mRate/1000 / FPS;
				mEnemy.TakeDamage( dmg );
			}
			
		}
		
	}

}