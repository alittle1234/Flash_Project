package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class p_Flash_proj extends Projectile
	{
		
		public function p_Flash_proj(twr:Tower) 
		{
			var dest:Point =  twr.mProjDestn;
			
			// SPAWN X,Y DEPEND ON FACING OF TOWER
			var pos:Point = new Point( twr.mX, twr.mY );
			
			var speed = 5;
			
			super( pos, dest, speed, twr );
			
			mMovieClip = new p_bombMC();
			
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
			
			var smk:AreaOfEffect = new AOE_Flash( mTwr, mMyPos );
		}
		
	}

}