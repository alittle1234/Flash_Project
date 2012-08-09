package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class p_Bomb_proj extends Projectile
	{
		var rotat;
		var rotatSpeed;
		var dist;
		
		public function p_Bomb_proj(twr:Tower) 
		{
			var dest:Point =  twr.mProjDestn;
			
			// SPAWN X,Y DEPEND ON FACING OF TOWER
			var pos:Point = new Point( twr.mX, twr.mY );
			
			var speed = 6;
			
			super( pos, dest, speed, twr );
			
			mMovieClip = new p_bombMC();
			twr.mBoard.mMapSet.addChild(mMovieClip);			
			
			mMovieClip.addEventListener( Event.ENTER_FRAME, enterFrame, false, 0, true  );
			mMovieClip.x = mMyPos.x;
			mMovieClip.y = mMyPos.y;
			
			rotat = 0;
			rotatSpeed = 6;
			dist = len;
			
			mMovieClip.gotoAndPlay( mTwr.mLevel * 2 );
		}
		
		function enterFrame( event:Event )
		{
			DoFrameEvents();
			if ( mMovieClip )
			{
				mMovieClip.x = mMyPos.x;
				mMovieClip.y = mMyPos.y;
			
			
				rotat += rotatSpeed;
				
				if ( rotat > 180 )
				{
					mMovieClip.rotation = -1 * (360 - rotat);
				}
				else
				{
					mMovieClip.rotation = rotat;				
				}
				
				//recalculate length every frame.
				len = Point.distance(mDest, mMyPos);
				
				if ( len >= dist / 2 )
				{
					mMovieClip.width += mMovieClip.width * .05;
					mMovieClip.height += mMovieClip.height * .05;
				}
				else// ( len < dist / 2 )
				{
					mMovieClip.width -= mMovieClip.width * .05;
					mMovieClip.height -= mMovieClip.height* .05;
				}
				
			}
			
		}
		
		override public function SpawnGroundEffect()
		{
			if ( mMovieClip )
			{
				mMovieClip.removeEventListener(Event.ENTER_FRAME, enterFrame  );
				mMovieClip.parent.removeChild(mMovieClip);	
				mMovieClip = null;
			}
			
			if ( mTwr )
			{
				var effect = new AOE_Explosion( mTwr, mTwr.mBoard, mDest);
			}
			
			var num = Math.round( Math.random() * 1 ) + 1;
			mBoard.mMain.SOUND_STAGE.PlaySound("COW_EXPLO_" + num , mDest.x);
		}
		
	}

}