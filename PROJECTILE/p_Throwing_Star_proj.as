package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class p_Throwing_Star_proj extends Projectile
	{
		
		
		public function p_Throwing_Star_proj(twr:Tower) 
		{
			var dest:Point = twr.mProjDestn;
			
			// SPAWN X,Y DEPEND ON FACING OF TOWER
			var pos:Point = new Point( twr.mX, twr.mY );
			
			var speed = 12;
			
			super( pos, dest, speed, twr );
			//-------------------------------
			var LVL = mTwr.mLevel;
			
			var resClass = getDefinitionByName( "p_thrwStrMC" + LVL ) as Class;	
			
			mMovieClip = new resClass();
			
			twr.mBoard.mMapSet.addChild(mMovieClip);		
			//-------------------------------
			
			BullitVector();
			
			mMovieClip.rotation = BullRot;
			
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
				mMovieClip.parent.removeChild(mMovieClip);	
				mMovieClip.removeEventListener(Event.ENTER_FRAME, enterFrame  );
				mMovieClip = null;
				
				
				
				var hit = new pulse_hit_mc();
				mTwr.mBoard.mMapSet.addChild(hit);
				hit.x = mMyPos.x;
				hit.y = mMyPos.y;
			}
						
			// PLAYER HIT?
		}
		
	}

}