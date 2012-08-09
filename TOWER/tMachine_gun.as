package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import Tower;
	/**
	 * ...
	 * @author AARON
	 */
	public class tMachine_gun extends Tower
	{
		
		public function tMachine_gun(BOARD, y_pos = 0, x_pos = 0, type = "tMachine_gun", speed = 500,
			level = 0, health = 100, attack = 25, range = 80, color = "NONE" )
		{
			var t = "t_machine_gunMC";
			
			var upgd:Array = [100, 80, 120, 165];		
			
			super(y_pos, x_pos, t, type, speed, level, health, attack, range, color, upgd, BOARD);
			
			mBeingAdded = false;
			
			mMaxHealth = 100;
			
			prjSpwnFrame = 4;
			mAttackFrames = 5;
			atkFrame = 2;
			upFrame = 10;
			
			mProjSpwnPnt = new Point( 0, -15);
			
			mMaxUpgLevl = 3;
			
			mLevelReqrmnt = 1;
			
			mUpgradeText = ["RAPID FIRE", "RANGE DAMAGE SPEED", "RANGE DAMAGE SPEED", "RANGE DAMAGE SPEED"];
		}
		
		override function SpawnProjectile()
		{			
			mProjectiles.push( new p_Throwing_Star_proj(this) );
			
			var num = Math.round( Math.random() * 1 ) + 1;
			mBoard.mMain.SOUND_STAGE.PlaySound("SHORT_LASER_" + num , mX);
		}
		
		override function UpdateStats()
		{
			// AFTER UPGRADE
			mSpeed -= mSpeed * (0.015);
			
			mRange += mRange * (0.50);
			mRangeClip.width = mRange * 2;
			mRangeClip.height = mRange * 2;
			
			mAttack += mAttack * (0.02);
			
		}
		
	}

}