package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.geom.Point;
	import flash.sampler.Sample;
	
	public class AOE_Warp_tower extends AreaOfEffect
	{
		var mWarpFrame;
		
		public function AOE_Warp_tower( twr:Tower, pos:Point) 
		{
			//(Twr:Tower,Pos, Speed = 0, Attack = 10, Range = 10, LifeSpan = 10	) 
			super( twr, twr.mBoard, pos, 1, 0, twr.mRange, 25 )
			
			mWarpFrame = 10;
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new warp_tower_mc();
		}
		
		override function ApplyDamage( enm:Enemy )
		{
			// CALLED AT SPEED INTERVAL FOR DURATION if a target is located
			//trace ("APPLYING dAMAGE");
			if ( enm )
			{
				if ( !enm.mDead )
				{
					enm.mX = mBoard.mPathsWaypnts[enm.mRoute][3].value2;
					enm.mY = mBoard.mPathsWaypnts[enm.mRoute][3].value1;
					
					enm.mDestin = 4;
					
					enm.mWarping = 40;
					
					var warp = new warp_clip();
					
					enm.mMovieClip.addChild( warp );
					
					mLifeSpan -= 1;
					
					mMovieClip.gotoAndPlay( mWarpFrame );
					
					mBoard.mMain.SOUND_STAGE.PlaySound("WARP_FINAL" , mPos.x);
					
					//trace ("APPLY DMG " + mTower.mType );
				}
			}
			
		}
		
		override function TempFrameFunc()
		{
			mSpawnTime = mBoard.mGlobalTimer;
			
			if ( mLifeSpan <= 0 )
			{
				mSpawnTime = 0;
			}
			
		}
		
		
	}

}