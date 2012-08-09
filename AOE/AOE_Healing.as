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
	
	public class AOE_Healing extends AreaOfEffect
	{
		
		public function AOE_Healing( twr:Tower, pos:Point) 
		{
			//(Tower, Board, Pos, Speed, Attack , Range , LifeSpan 	) 
			super( twr, twr.mBoard, pos, 1, twr.mAttack, twr.mRange, 1 );
			
			mPos = new Point(pos.x, pos.y);
			mTargets = new DLinkedList();
			
			MIN_X = mPos.x - mRange - 60;
			MAX_X = mPos.x + mRange + 60;
		}
		
		override function CreateMovieClip()
		{
			mMovieClip = new healing_aoe_mc();
		}
		
		function ApplyDamageT( tgt:Tower )
		{
			// CALLED AT SPEED INTERVAL FOR DURATION
			//trace ("APPLYING dAMAGE ");
			
			if ( tgt.mHealth < tgt.mMaxHealth )
			{
				//trace ("APPLYING dAMAGE " + tgt.mHealth + " AT: " + mAttack);
				tgt.mHealth += mAttack;
				var tmpHlth = new temp_health();
				tgt.mMovieClip.addChild(tmpHlth);
				
				//trace ("APPLIED dAMAGE " + tgt.mHealth );
			}
		}
		
		override function GetEnemys()
		{
			var list:DLinkedList = mBoard.mTwrsOnBrd;
			var iter:DListIterator = list.getListIterator();
			
			mTargets.clear();
			
			//trace ("AOE:GET.ENM: " + mTargets.size );
			for ( var i = 0; i < list.size; ++i )			
			{
				if ( iter.valid() )
				{
						
					var ENM:Tower = Tower(iter.data);
					var ePnt:Point = new Point( ENM.mX, ENM.mY );
					
					//var halfWidth = ENM.mMovieClip.width / 2;
					
					// LIST OF POSSIBLES TO CHECK VECTOR
					if ( ePnt.x >= MIN_X && ePnt.x <= MAX_X )
					{
						// GET VECTOR
						var eDist = Point.distance(ePnt, mPos);
						//trace ("DIST: " + i + " "  + eDist + " "  + mRange);
						if ( (eDist) <= mRange )
						{
							
							mTargets.append(ENM);
						}
					}
				}
				iter.forth();
			}
			
			//trace ("MTRGT.S: " + mTargets.size);
		}
		
		override function Attack()
		{
			//trace ("ATTACKING FROM AOE HEAL");
			if ( mTargets )
			{
				if ( ! mTargets.isEmpty() )
				{
					// CALLED ON ATTACK SPEED
					if ( (mSpeed) < mBoard.mGlobalTimer - mLstAtkTime )
					{
						mLstAtkTime = mBoard.mGlobalTimer;
						
						var iter:DListIterator = mTargets.getListIterator();
						
						for ( var i = 0; i < mTargets.size; ++i )			
						{
							if ( iter.valid() )
							{
								var ENM:Tower = Tower(iter.data);
								
								ApplyDamageT( ENM );
								
							}
							iter.forth();
						}
						
					}
				}
			}
		}
		
	}

}