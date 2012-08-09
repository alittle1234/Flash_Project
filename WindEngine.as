package  
{
	/**
	 * ...
	 * @author AARON
	 */
	public class WindEngine
	{
		var mSlow;	// Fast
		var mPetal;	// Fire
		
		var mIntervl;
		var mLastSpwn;
		
		var mSpawnY_T
		var mSpawnY_B;
		
		var mSpawnX_L;
		var mSpawnX_R;
		
		var mBoard:GameBoard;
		
		public function WindEngine( board:GameBoard, slow, petal ) 
		{
			mBoard = board;
			mSlow = slow;
			mPetal = petal;
			
			mIntervl = 0;
			mLastSpwn = 0;
			
			if ( mSlow )
			{
				mSpawnY_T = -20;
				mSpawnY_B = -5;
				
				mSpawnX_L = -5;
				mSpawnX_R = 645;
			}
			else
			{
				mSpawnY_T = 0;
				mSpawnY_B = 480;
				
				mSpawnX_L = -80;
				mSpawnX_R = -5;
			}
		}
		
		// PLEASE CALL FROM CLASS THAT HOLDS THIS
		function DoFrameEvents()
		{
			// GET INTERVAL, RAND BETWEEN HIGH / LOW
			// CHECK LAST SPAWN
			// SPAWN AT RAND Y HIGH / LOW
			//		 AT RAND X HIGH / LOW
			// MOVEMENT SPEED CALC BY OBJ.  FAST OR SLOW <-- MOV.CLIP
			// SET INTERVAL TO ZERO
			
			if ( mIntervl )
			{
				// INTERVAL IS SET
				// if time now - last spwn > intrvl
				if ( mBoard.mGlobalTimer - mLastSpwn > mIntervl )
				{
					//trace ("SPAWNING.DEB");
					// SPAWN A DEBRI
					
					var y_val;
					var x_val;
					
					if ( mSlow )
					{
						y_val =  Math.floor( (Math.random() * mSpawnY_T) + mSpawnY_B );
						x_val =  Math.floor( (Math.random() * mSpawnX_R) + mSpawnX_L );
					}
					else 
					{
						y_val =  Math.floor( (Math.random() * mSpawnY_B) + mSpawnY_T );
						x_val =  Math.floor( (Math.random() * mSpawnX_L) + mSpawnX_R );
					}
					
					var deb:Debris = new Debris( mSlow, mPetal, x_val, y_val );
					
					mBoard.mMapSet.addChild(deb);
					
					mLastSpwn = mBoard.mGlobalTimer;
					mIntervl = 0;
				}
			}
			else
			{
				// SET THE INTERVAL
				mIntervl = ( Math.floor( (Math.random() * 500) + 100 ) );
				if ( !mSlow )
				{
					mIntervl = mIntervl / 2;
				}
			}
		}
	}

}