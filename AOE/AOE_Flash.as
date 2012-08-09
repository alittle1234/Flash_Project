package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.geom.Point;
	
	public class AOE_Flash extends AreaOfEffect
	{
		
		public function AOE_Flash( twr:Tower, pos:Point) 
		{
			//(Twr:Tower,Pos, Speed = 0, Attack = 10, Range = 10, LifeSpan = 10	) 
			super( twr, twr.mBoard, pos, 500, 50, 50, 2000 )
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new aoe_Flash();
		}
		
		override function ApplyDamage( enm:Enemy )
		{
			// CALLED AT SPEED INTERVAL FOR DURATION
			if ( ! enm.mOnFlash )
			{
				//( twr:Tower, enm:Enemy, dmg, rate, lfspn ) 
				var smk =  new PFX_Flash( mTower, enm, 0, 0, 4000);
			}
			
		}
	}

}