package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import Tower;
	/**
	 * ...
	 * @author AARON
	 */
	public class tBomb_tower extends Tower
	{
		
		public function tBomb_tower(BOARD, y_pos = 0, x_pos = 0, type = "tBomb_tower", speed = 2000,
			level = 0, health = 80, attack = 65, range = 90, color = "NONE" )
		{
			var t = "t_bomb_tower";
			
			var upgd:Array = [185, 155, 200, 1];		
			
			super(y_pos, x_pos, t, type, speed, level, health, attack, range, color, upgd, BOARD);
			
			mBeingAdded = false;
			
			mMaxHealth = 80;
			
			prjSpwnFrame = 2;
			mAttackFrames = 7;
			atkFrame = 2;
			upFrame = 11;
			
			mProjSpwnArry =  new Point(0, -28) ;
			
			mMaxUpgLevl = 2;
			
			mLevelReqrmnt = 4;
			
			mUpgradeText = ["BOMB", "RANGE DAMAGE SPEED", "ADD POISON", "INCREASE ALL STATS"];
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
					
					mHeadClip.gotoAndPlay( (mLevel * upFrame) + atkFrame);
					
					mProjDestn = new Point(mMyTarget.mX, mMyTarget.mY);
					
				}
			}
			
		}
		
		override function SpawnProjectile()
		{
			mProjectiles.push( new p_Bomb_proj(this) );
			
			var num = Math.round( Math.random() * 2 ) + 1;
			if ( num == 2 )
			{
				mBoard.mMain.SOUND_STAGE.PlaySound("COW_MOO_FINAL" , mX);
			}
			
			mBoard.mMain.SOUND_STAGE.PlaySound("COW_SPRING_FINAL" , mX);
			
		}
		
		override function UpdateStats()
		{
			// AFTER UPGRADE
			mSpeed -= mSpeed * (0.013);
			
			mRange += mRange * (0.25);
			mRangeClip.width = mRange * 2;
			mRangeClip.height = mRange * 2;
			
			mAttack += mAttack * (0.03);
			
		}
		
		
	}

}