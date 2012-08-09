package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import Tower;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author AARON
	 */
	public class tWarp_tower extends Tower
	{
		var mTimeSmash;
		
		public function tWarp_tower(BOARD, y_pos = 0, x_pos = 0, type = "tWarp_tower", speed = 4000,
			level = 0, health = 100, attack = 10, range = 30, color = "NONE" )
		{
			var t = "t_warp_tower";
			
			var upgd:Array = [220, 100, 200, 300];		
			
			super(y_pos, x_pos, t, type, speed, level, health, attack, range, color, upgd, BOARD);
			
			mBeingAdded = false;
			
			mMaxHealth = 100;
			
			
			mTimeSmash = mBoard.mGlobalTimer;
			
			mLevelReqrmnt = 8;
			
			mUpgradeText = ["TELEPORT 25 CARS", "TELEPORT 25 CARS", "TELEPORT 25 CARS", "TELEPORT 25 CARS"];
		}
		
		override function SpawnProjectile()
		{
			
		}
		
		override function FreqCallJunkFunc()
		{
			
			// SLOWING 
			if ( mMovieClip )
			{
				if ( (1 / mPlayer.mSpeed) < (mBoard.mGlobalTimer - mTimeSmash) )
				{
					mTimeSmash = mBoard.mGlobalTimer;
					var aoe:AreaOfEffect = new AOE_Warp_tower( this, new Point(mX, mY) );
					mLevel = 1;
					RemoveMe();	
				}
			}
			
			//trace ("JUNK BEING CALLED");
		}
		
		override function HitTestForSpawn()
		{
			var notHit = true;
			
			var hm:MovieClip = MovieClip( mActualTowerClip.getChildByName("hitmask") );
			
			var mapHM:MovieClip = MovieClip( mBoard.mMapHM );
			var onRoad = false;
			for ( var c = 0; c < mapHM.numChildren; c++ )
			{
				var movHT = mapHM.getChildAt(c);
				if ( hm.hitTestObject(movHT) )
				{
					//trace ("Hit a something!!!");
					onRoad = true;
					mSpawnable = true;
					c = mapHM.numChildren;
					break;
					
				}
				else
				{
					onRoad = false;
					mSpawnable = false;
				}
				
			}
			
			if ( !onRoad )
			{
				mSpawnable = false;
				notHit = false;
			}
			
			var Ledges:MovieClip = MovieClip( mBoard.mMapHM_A );
			
			for ( var g = 0; g < Ledges.numChildren; g++ )
			{
				var LedgChild = Ledges.getChildAt(g);
				if ( hm.hitTestObject(LedgChild) )
				{
					//trace ("Hit a something!!!");
					notHit = false;
					mSpawnable = false;
					g = Ledges.numChildren;
					break;
					
				}
				
			}
			
			
			if ( notHit )
			{
				mSpawnable = true;
			}
			
			var furnL:Array = mBoard.mFurnOnBrd;	
			var mc:MovieClip;
			for ( var j = 0; j < furnL.length; ++j )
			{
				mc = furnL[j].mMovieClip.getChildByName("hitmask");
				
				if ( hm.hitTestObject(mc) )
				{
					//trace ("Hit Furniture");
					mSpawnable = false;
				}
				
			}
		}
		
		
	}

}