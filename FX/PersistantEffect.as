package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author AARON
	 */
	public class PersistantEffect
	{
		var mDamage;
		var mRate;
		var mLifespan;
		var mLastFrameTime;
		
		var mTower:Tower;
		var mEnemy:Enemy;
		
		var mMovieClip;
		var mPoint:Point;
		
		public function PersistantEffect( twr:Tower, enm:Enemy, dmg, rate, lfspn ) 
		{
			mTower = twr;
			mEnemy = enm;
			
			mDamage = dmg;
			mRate = rate;
			mLifespan = lfspn;
			
			
			if ( mEnemy )
			{
				CreateMovieClip();				
			}
		}
		
		function AddMovieClip()
		{
			if ( mEnemy.mOnSmoke )
			{
				mEnemy.mMovieClip.gotoAndPlay(mEnemy.bthFrame);
			}
			
				mLastFrameTime = mEnemy.mBoard.mGlobalTimer;
		}
		
		function CreateMovieClip()
		{
			
		}
		
		function DoFrameEvents()
		{
			
		}
		
		function GetLifeSpan()
		{
			mLifespan -= (mEnemy.mBoard.mGlobalTimer - mLastFrameTime) * mTower.mPlayer.mSpeed;
			mLastFrameTime = mEnemy.mBoard.mGlobalTimer;
		}
		
		function RemoveThis()
		{
			//trace ("removing pfx");
			//mEnemy.mMovieClip.removeChild(mMovieClip);
			mMovieClip = null;
		}
	}

}