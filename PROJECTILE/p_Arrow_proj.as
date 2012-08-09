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
	public class p_Arrow_proj extends Projectile
	{
		
		public function p_Arrow_proj(twr:Tower) 
		{
			var dest:Point =  twr.mProjDestn;
			
			// SPAWN X,Y DEPEND ON FACING OF TOWER
			var pos:Point = new Point( twr.mX, twr.mY );
			
			var speed = 3;
			
			super( pos, dest, speed, twr );
			
			//-------------------------------
			var LVL = mTwr.mLevel;
			
			var resClass = getDefinitionByName( "p_arrowMC" + LVL ) as Class;	
			
			mMovieClip = new resClass();
			
			twr.mHeadClip.addChild(mMovieClip);			
			//-------------------------------
			
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
			if ( mMovieClip )
			{
				
			}
			
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
				mMovieClip.parent.removeChild(mMovieClip);	
				
				
				
			}
			
			// IMPACT ON ENM
		}
		
	}

}