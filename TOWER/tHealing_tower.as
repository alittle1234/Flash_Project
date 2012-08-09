package  
{
	import de.polygonal.ds.DLinkedList;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import Tower;
	/**
	 * ...
	 * @author AARON
	 */
	public class tHealing_tower extends Tower
	{
		var mTimeHeal;
		
		public function tHealing_tower(BOARD, y_pos = 0, x_pos = 0, type = "tHealing_tower",
		speed = 1000,
			level = 0,
			health = 100,
			attack = 9.5,	// atk * 2 = dps for  4 sec  => 76 
			range = 50,
			color = "NONE" )
		{
			var t = "t_healing_tower";
			
			var upgd:Array = [195, 160, 210, 240];		
			
			super(y_pos, x_pos, t, type, speed, level, health, attack, range, color, upgd, BOARD);
			
			mBeingAdded = false;
			
			mMaxHealth = 100;
			
			mTimeHeal = mBoard.mGlobalTimer;
			
			mAttackFrames = 10;
			
			mProjSpwnPnt = new Point( 0, -50);
			
			upFrame = 26;
			
			mLevelReqrmnt = 6;
			
			mMaxUpgLevl = 3;
			
			mUpgradeText = ["DAMAGE OVER TIME", "RANGE AND DAMAGE", "RANGE AND DAMAGE", "RANGE AND DAMAGE"];
		}
		
		override function SpawnProjectile()
		{
			
			//trace ("SPAWNIN PROJ");
		}
		
		override function FreqCallJunkFunc()
		{
			
			// SLOWING 
			if ( mMovieClip )
			{
				if ( (mSpeed / mPlayer.mSpeed) < (mBoard.mGlobalTimer - mTimeHeal) )
				{
					//trace ("SPAWNIN PROJ");
					mTimeHeal = mBoard.mGlobalTimer;
					var aoe = new AOE_Sam_Slow( this, mHeadClip.localToGlobal(mProjSpwnPnt) );
				}
			}
		}
		
		override function SearchForTarget()
		{
			
		}
		
		override function CheckFacing()
		{
			mFacing += 3;
			
			if ( mFacing > 180 )
			{
				mFacing = -180;
			}
			
			mHeadClip.rotation = mFacing;
		}
		
		override function UpdateStats()
		{
			// AFTER UPGRADE
			//mSpeed -= mSpeed * (0.05);
			
			mRange += mRange * (0.10);
			mRangeClip.width = mRange * 2;
			mRangeClip.height = mRange * 2;
			
			// range applies only to the aoe poison effect... could increase
			
			mAttack += mAttack * (0.025);
			mActualTowerClip.gotoAndStop( mLevel + 1 );
			
		}
		
	}

}