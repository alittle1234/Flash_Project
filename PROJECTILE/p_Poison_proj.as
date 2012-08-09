package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class p_Poison_proj extends Projectile
	{
		
		public function p_Poison_proj(twr:Tower) 
		{
			var dest:Point =  twr.mProjDestn;
			
			// SPAWN X,Y DEPEND ON FACING OF TOWER
			var pos:Point = new Point( twr.mX, twr.mY );
			
			var speed = 8;
			
			super( pos, dest, speed, twr );
			
			mMovieClip = new p_arrowMC();
			twr.mBoard.mMapSet.addChild(mMovieClip);			
			
			mMovieClip.addEventListener( Event.ENTER_FRAME, enterFrame, false, 0, true  );
		}
		
		function enterFrame( event:Event )
		{
			DoFrameEvents();
			if ( mMovieClip )
			{
				mMovieClip.x = mMyPos.x;
				mMovieClip.y = mMyPos.y;
			}
		}
		
		override public function SpawnGroundEffect()
		{
			if ( mMovieClip )
			{
				mMovieClip.removeEventListener(Event.ENTER_FRAME, enterFrame  );
				mTwr.mBoard.mMapSet.removeChild(mMovieClip);	
			}
			
			if ( mTwr.mMyTarget )
			{
				var perfx:PFX_Poison = new PFX_Poison( mTwr, mTwr.mMyTarget, 40, 1000, 3000);
				perfx.mGeneration = 3;
			}
			
		}
		
	}

}