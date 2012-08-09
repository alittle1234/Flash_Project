package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import Tower;
	/**
	 * ...
	 * @author AARON
	 */
	public class tSmoke_tower extends Tower
	{
		
		public function tSmoke_tower(BOARD, y_pos = 0, x_pos = 0, type = "tSmoke_tower", speed = 5000,
			level = 0, health = 80, attack = (0.20), range = 90, color = "NONE" )
		{
			var t = "t_smoke_tower";
			
			var upgd:Array = [90, 70, 125, 175];		
			
			super(y_pos, x_pos, t, type, speed, level, health, attack, range, color, upgd, BOARD);
			
			mBeingAdded = false;
			
			mMaxHealth = 80;
			
			mAttackFrames = 15;
			prjSpwnFrame = 14;
			
			atkFrame = 5;
			upFrame = 14;
			
			mProjSpwnPnt = new Point( 0, -50);
			
			mMaxUpgLevl = 3;
			
			mTrgDesgPri = 2;
			
			mLevelReqrmnt = 2;
			
			mUpgradeText = ["SLOW", "INCREASE RANGE", "INCREASE RANGE", "INCREASE RANGE"];
		}
		
		override function Attack()
		{
			
			if ( mMyTarget )
			{
				mLastTimeCalled = mBoard.mGlobalTimer;
				
				// CALLED ON ATTACK SPEED
				if ( (mSpeed / mPlayer.mSpeed) < mBoard.mGlobalTimer - mLstAtkTime )
				{
					mLstAtkTime = mBoard.mGlobalTimer;
					
					mAttkFrmTime = mAttackFrames;
					
					mHeadClip.gotoAndPlay( (mLevel * atkFrame) + atkFrame );
					
					mProjDestn = new Point(mMyTarget.mX, mMyTarget.mY);
					if ( ! mMyTarget.mOnSmoke )
					{
												//	( twr:Tower, enm:Enemy, dmg, rate, lfspn ) 
						var smk =  new PFX_Smoke( this, mMyTarget, mAttack, 0, 4000 + (4000 * mPlayer.mAgiMod) );
					}
				}
			}
			
		}
		
		override function SpawnProjectile()
		{
			
			mProjectiles.push( new p_Smoke_proj(this) );
			
			mBoard.mMain.SOUND_STAGE.PlaySound("TRACTOR_FINAL" , mX);
		}
		
		override function UpdateStats()
		{
			// AFTER UPGRADE
			mSpeed -= mSpeed * (0.035);
			
			mRange += mRange * (0.25);
			mRangeClip.width = mRange * 2;
			mRangeClip.height = mRange * 2;
			
			mAttack += mAttack * (0.05);
			
		}
		
	}

}