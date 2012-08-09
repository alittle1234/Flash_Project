package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.geom.Point;
	import flash.events.Event;
	
	public class AOE_Sam_Smash extends AreaOfEffect
	{
		
		public function AOE_Sam_Smash( twr:Tower, pos:Point) 
		{
			//(Twr:Tower,Pos, Speed = 0, Attack = 10, Range = 10, LifeSpan = 10	) 
			super( twr, twr.mBoard, pos, 1, twr.mAttack, twr.mRange, 1 )
			trace ("SAM SMASH");
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new sam_smash();
		}
		
		override function ApplyDamage( enm:Enemy )
		{
			// CALLED AT SPEED INTERVAL FOR DURATION
			enm.TakeDamage(mAttack);			
		}
		
		override function GoAway()
		{
			mMovieClip.alpha -= .02;
			if ( mBoard.mGlobalTimer - mSpawnTime > mLifeSpan )
			{			
				//trace ("LEAVING?");

				mMovieClip.removeEventListener(Event.ENTER_FRAME, DoEveryFrame);
				mBoard.mMapSet.removeChild(mMovieClip);
			}
		}
		
	}

}