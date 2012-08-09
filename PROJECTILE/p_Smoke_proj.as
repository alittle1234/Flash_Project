package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class p_Smoke_proj extends Projectile
	{
		
		public function p_Smoke_proj(twr:Tower) 
		{
			var dest:Point =  twr.mProjDestn;
			
			// SPAWN X,Y DEPEND ON FACING OF TOWER
			var pos:Point = new Point( twr.mX, twr.mY );
			
			var speed = 10;
			
			super( pos, dest, speed, twr );
			
			mMovieClip = new p_slow_beam();
			
			twr.mHeadClip.addChild(mMovieClip);			
			
			mMovieClip.addEventListener( Event.ENTER_FRAME, enterFrame, false, 0, true  );
			
			mMovieClip.height = len;
			//mMovieClip.rotation = mTwr.mBulitRotn;	<- ATTACHED TO HEADCLIP
			
			mMyPos = twr.mProjSpwnPnt;
			
			mMovieClip.x = mMyPos.x;
			mMovieClip.y = mMyPos.y;			
		}
		
		function enterFrame( event:Event )
		{
			//DoFrameEvents();
			/*if ( mMovieClip )
			{
				mMovieClip.x = mMyPos.x;
				mMovieClip.y = mMyPos.y;
			}*/
			//mDest = new Point( mTwr.mMyTarget.mX, mTwr.mMyTarget.mY);
			//GetVector();
			//mMovieClip.height = len;
			
			mSpeed--;
			if ( mSpeed <= 0 )
			{
				SpawnGroundEffect();
			}
		}
		
		override public function SpawnGroundEffect()
		{
			if ( mMovieClip )
			{
				mMovieClip.removeEventListener(Event.ENTER_FRAME, enterFrame  );
				mTwr.mHeadClip.removeChild(mMovieClip);	
			}
			
			//var smk:AreaOfEffect = new AOE_Smoke( mTwr, mMyPos );
		}
		
	}

}