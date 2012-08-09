package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import Tower;
	/**
	 * ...
	 * @author AARON
	 */
	public class tArrow_sniper extends Tower
	{
		
		public function tArrow_sniper(BOARD, y_pos = 0, x_pos = 0, type = "tArrow_sniper", speed = 2000,
			level = 0, health = 100, attack = 95, range = 80, color = "NONE" )
		{
			var t = "t_arrow_sniper";
			
			var upgd:Array = [150, 115, 165, 195];		
			
			super(y_pos, x_pos, t, type, speed, level, health, attack, range, color, upgd, BOARD);
			
			mBeingAdded = false;
			
			mMaxHealth = 100;
			
			prjSpwnFrame = 2;
			mAttackFrames = 5;
			atkFrame = 2;
			upFrame = 10;
			
			mProjSpwnPnt = new Point( 0, -15);
			
			mMaxUpgLevl = 3;
			
			mLevelReqrmnt = 1;
			
			mUpgradeText = ["SNIPER", "RANGE DAMAGE SPEED", "RANGE DAMAGE SPEED", "RANGE DAMAGE SPEED"];
		}
		
		override function SpawnProjectile()
		{
			
			mProjectiles.push( new p_Arrow_proj(this) );
			
			if( mMyTarget)
			{
				if( mMyTarget.mDead != true )
				{
					var hit = new snipe_hit_mc();
					mBoard.mMapSet.addChild(hit);
					hit.x = mMyTarget.mX;
					hit.y = mMyTarget.mY;
				}
			}
				
			mBoard.mMain.SOUND_STAGE.PlaySound("LONG_LASER" , mX);
		}
		
		override function UpdateStats()
		{
			// AFTER UPGRADE
			mSpeed -= mSpeed * (0.02);
			
			mRange += mRange * (0.50);
			mRangeClip.width = mRange * 2;
			mRangeClip.height = mRange * 2;
			
			mAttack += mAttack * (0.025);
			
			
		}
		
		
		
	}

}