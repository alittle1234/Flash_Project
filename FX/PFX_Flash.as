package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author AARON
	 */
	public class PFX_Flash extends PersistantEffect
	{
		var oldAttack;
		var attack;
		public function PFX_Flash( twr:Tower, enm:Enemy, dmg, rate, lfspn ) 
		{
			super ( twr, enm, dmg, rate, lfspn);
			
			oldAttack = mEnemy.mAttack;
			
			attack = oldAttack - ( oldAttack * .20 );
			
			if ( attack < 0 )
			{
				attack = .1;
			}
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new MovieClip();
			mPoint = mEnemy.mFlshPnt;
			
			if ( ! mEnemy.mOnFlash )
			{
				mEnemy.mPersFXArr.push(this);
				mEnemy.mOnFlash = true;
				
				AddMovieClip();
			}
		}
		
		override function DoFrameEvents()
		{
			
			GetLifeSpan();
			if ( mLifespan < 0 )
			{
				RemoveThis();
				mEnemy.mOnFlash = false;
				mEnemy.mAttack = oldAttack;
			}
			else
			{
				mEnemy.mAttack = attack;
			}
		}
	}

}