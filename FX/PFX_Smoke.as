package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author AARON
	 */
	public class PFX_Smoke extends PersistantEffect
	{
		var oldSpeed;
		var speed
		public function PFX_Smoke( twr:Tower, enm:Enemy, dmg, rate, lfspn ) 
		{
			super ( twr, enm, dmg, rate, lfspn);
			
			oldSpeed = mEnemy.mSpeed;
			
			speed = oldSpeed - ( oldSpeed * dmg );
			
			if ( speed < (0.1) )
			{
				speed = (0.1);
			}
		}
		override function AddMovieClip()
		{
			if ( mEnemy.mOnPoison )
			{
				mEnemy.mMovieClip.gotoAndPlay(mEnemy.bthFrame);
			}
			else
			{
				mEnemy.mMovieClip.gotoAndPlay(mEnemy.smkFrame);
			}
			
				mLastFrameTime = mEnemy.mBoard.mGlobalTimer;
		}
		override function CreateMovieClip()
		{
			mMovieClip = new MovieClip();
			mPoint = mEnemy.mSmkePnt;
			
			if ( ! mEnemy.mOnSmoke )
			{
				//trace ("pushing smoke ");
				mEnemy.mPersFXArr.push(this);
				mEnemy.mOnSmoke = true;
				
				AddMovieClip();
			}
		}
		
		override function DoFrameEvents()
		{
			
			GetLifeSpan();
			if ( mLifespan < 0 )
			{
				RemoveThis();
				mEnemy.mOnSmoke = false;
				mEnemy.mSpeed = oldSpeed;
				
				if ( mEnemy.mOnPoison )
				{
					mEnemy.mMovieClip.gotoAndPlay(mEnemy.psnFrame);
				}
				else
				{
					mEnemy.mMovieClip.gotoAndPlay(mEnemy.normFrame);
				}
			}
			else
			{
				mEnemy.mSpeed = speed;
			}
		}
	}

}