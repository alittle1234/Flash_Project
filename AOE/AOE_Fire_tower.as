package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.geom.Point;
	import flash.sampler.Sample;
	
	public class AOE_Fire_tower extends AreaOfEffect
	{
		var mOldFacing;
		var mFacing;
		var mTurnSpeed;
		
		public function AOE_Fire_tower( twr:Tower, pos:Point) 
		{
			//(Twr:Tower,Pos, Speed = 0, Attack = 10, Range = 10, LifeSpan = 10	) 
			super( twr, twr.mBoard, pos, 1, 0, twr.mRange, 25 )
			
			mFacing = 0;
			mOldFacing = mFacing;
			mTurnSpeed = 180;
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new monster_mouth_head();
		}
		
		override function ApplyDamage( enm:Enemy )
		{
			// CALLED AT SPEED INTERVAL FOR DURATION if a target is located
			//trace ("APPLYING dAMAGE");
			if ( enm )
			{
				if ( !enm.mDead )
				{
					var dmg = enm.mHealth;
					enm.TakeDamage(dmg);
					
					mLifeSpan -= 1;
					
					GetDirection();
					CheckFacing();
					
					mBoard.mMain.SOUND_STAGE.PlaySound("YUM_YUM_FINAL" , mPos.x);
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
		
		function GetDirection()
		{
			
				
				var pY = mPos.y
				var pX = mPos.x;
				
				var theX:int = mTargets.head.data.mX - pX;
				var theY:int = (mTargets.head.data - pY) * -1;
				var angle = Math.atan(theY / theX) / (Math.PI / 180);				
				
				if (theX<0) {
					angle += 180;
				}
				if (theX>=0 && theY<0) {
					angle += 360;
				}
				
				mFacing = 90 - angle;   // <--- DEGREES OUT OF 360, 0* FACES NORTH(UP)
				
		}
		
		
		function CheckFacing()
		{
			
			if ( mOldFacing != mFacing )
			{
				
				// convert the difference between the two angles to radians
				var diff:Number = (mFacing - mOldFacing) * (Math.PI / 180);
				
				// find the rotation of the vector created by the sin and cos of the difference
				var rotationDifference:Number = Math.atan2( Math.sin(diff), Math.cos(diff) );
				
				// rotate the clip accordingly
				// TURN OBJECT -----
				mOldFacing += Math.max( Math.min( (180 / Math.PI) * rotationDifference, mTurnSpeed ) , -mTurnSpeed );
				
				// STOP TURNING IF CLOSE ---
				if ( Math.abs(mOldFacing - mFacing) <= mTurnSpeed )
				{
					mOldFacing = mFacing;
				}
				
			}
			
			// CONVERT FROM 360 T0 180/-180
			if ( mOldFacing > 180 )
			{
				mMovieClip.rotation = -1 * (360 - mOldFacing);
			}
			else
			{
				mMovieClip.rotation = mOldFacing;				
			}
			
		}
		
	}

}