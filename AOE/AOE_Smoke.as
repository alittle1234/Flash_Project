package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.geom.Point;
	
	public class AOE_Smoke extends AreaOfEffect
	{
		
		public function AOE_Smoke( twr:Tower, pos:Point) 
		{
			//(Twr:Tower,Pos, Speed = 0, Attack = 10, Range = 10, LifeSpan = 10	) 
			super( twr, twr.mBoard, pos, 500, twr.mAttack, twr.mRange/2, 2000 +(2000*twr.mPlayer.mWisMod) )
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new aoe_Smoke();
			mMovieClip.width = mRange;
			mMovieClip.height = mRange / 2;
		}
		
		override function ApplyDamage( enm:Enemy )
		{
			// CALLED AT SPEED INTERVAL FOR DURATION
			if ( ! enm.mOnSmoke )
			{
				//( twr:Tower, enm:Enemy, dmg, rate, lfspn ) 
				var smk =  new PFX_Smoke( mTower, enm, mAttack, 0, 4000 + (4000 * mTower.mPlayer.mWisMod) );
			}
			
		}
	}

}