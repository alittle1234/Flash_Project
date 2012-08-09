package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.geom.Point;
	
	public class AOE_Rouge extends AreaOfEffect
	{
		var mTarget:Enemy;
		
		public function AOE_Rouge( twr:Tower, pos:Point, target:Enemy) 
		{
			//(Twr:Tower,Pos, Speed = 0, Attack = 10, Range = 10, LifeSpan = 10	) 
			var atk = twr.mAttack;
			super( twr, twr.mBoard, pos, 500, atk, 1, 500 )
			
			mTarget = target;
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new aoe_Rouge();
		}
		
		override function ApplyDamage( enm:Enemy )
		{
			// CALLED AT SPEED INTERVAL FOR DURATION
			
			enm.TakeDamage(mAttack);
		}
		
		override function GetEnemys()
		{
			mTargets.clear();
			
			if ( mTarget )
			{
				if ( !mTarget.mDead )
				{
					mTargets.append(mTarget);					
				}
			}
			
		}
	}

}