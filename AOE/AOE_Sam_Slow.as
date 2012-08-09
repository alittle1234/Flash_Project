package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.geom.Point;
	import flash.sampler.Sample;
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import flash.display.MovieClip;
	
	public class AOE_Sam_Slow extends AreaOfEffect
	{
		
		public function AOE_Sam_Slow( twr:Tower, pos:Point) 
		{
			//(Twr:Tower,Pos, Speed = 0, Attack = 10, Range = 10, LifeSpan = 10	) 
			super( twr, twr.mBoard, pos, 500, 0, twr.mRange, 4000 )
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new sam_slow_mc();
			mMovieClip.width = mRange * 2;
			mMovieClip.height = mRange * 2;
		}
		
		override function ApplyDamage( enm:Enemy )
		{
			// CALLED AT SPEED INTERVAL FOR DURATION
			
			if ( ! enm.mOnPoison )
			{		//					( twr:Tower, enm:Enemy, dmg, rate, lfspn ) 
			//trace ("APPLYING dAMAGE");
				var psn =  new PFX_Poison( mTower, enm, mTower.mAttack, 500, 5000);
			}
			
		}
		
		override function SpawnCheckForSwap()
		{
			
			if ( mMovieClip )
			{
				// TWRS
				var list:DLinkedList = mBoard.mTwrsOnBrd;
				var iter:DListIterator = list.getListIterator();	
				
				for ( var i = 0; i < list.size; ++i )
				{
					if ( iter.valid() )
					{
						var xValu = iter.data.mX;
						if ( xValu >= MIN_X && xValu <= MAX_X )
						{
							var actT:MovieClip = iter.data.mActualTowerClip;
							var twr:MovieClip = iter.data.mMovieClip;
							if ( mMovieClip.hitTestObject(actT) )
							{
								
									if (  mBoard.mMapSet.getChildIndex(mMovieClip) > mBoard.mMapSet.getChildIndex(twr) )							
									{
										mBoard.mMapSet.swapChildren(mMovieClip, twr);
									}
								
							}
						}
						
						iter.forth();
					}
					
					
				}
				
				
				// ENM
				EnmCheckForSwap();
			
			}
			
		}
		
		override function EnmCheckForSwap()
		{
			// ENM
			var list:DLinkedList = mBoard.mEnemiesVisibleList;
			var iter:DListIterator = list.getListIterator();			
			
			if ( mMovieClip )
			{
				if ( mMovieClip.parent )
				{
					for ( var i = 0; i < list.size; ++i )
						{
							if ( iter.valid() )
							{
								var xValu = iter.data.mX;
								
								if ( xValu >= MIN_X && xValu <= MAX_X )
								{
									var mc:MovieClip = iter.data.mMovieClip;
									
									if ( mc ) 
									{
										if ( mc.parent )
										{
											if ( mMovieClip.hitTestObject(mc) )
											{
												
													if (  mBoard.mMapSet.getChildIndex(mMovieClip) > mBoard.mMapSet.getChildIndex(mc) )							
													{
														mBoard.mMapSet.swapChildren(mMovieClip, mc);
													}
												
											}
										}
									
									}
									
								}
								
								iter.forth();
							}
						}
						
				}
				
			}
			
			
		}
		
	}
	

}