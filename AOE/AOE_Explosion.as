package  
{
	import flash.geom.Point;
	import flash.events.Event;
	/**
	 * ...
	 * @author AARON
	 */
	public class AOE_Explosion extends AreaOfEffect
	{
		
		public function AOE_Explosion( twr:Tower, brd:GameBoard, pos:Point) 
		{
			//( TowerT:Tower, Board:GameBoard, Pos:Point, Speed = 0, Attack = 10, Range = 10, LifeSpan = 10	) 
			var rng = (twr.mRange - ( twr.mRange * .3) );
			super( twr, brd, pos, 200, twr.mAttack, rng, 200 )
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new ExplosionMC();			
		}
		
		override function ApplyDamage( enm:Enemy )
		{
			// CALLED AT SPEED INTERVAL FOR DURATION
			enm.TakeDamage( mAttack );
			
			if ( mTower.mLevel == 2 )
			{
				if ( ! enm.mDead )
				{
					if ( ! enm.mOnPoison )
					{		//					( twr:Tower, enm:Enemy, dmg, rate, lfspn ) 
						var psn =  new PFX_Poison( mTower, enm, 10, 500, 5000);
					}
				}
				
			}
			
		}
		
		override function EnmCheckForSwap()
		{
			
		}
		
		override function SpawnCheckForSwap()
		{
			
		}
		
	}

}