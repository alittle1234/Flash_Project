package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class Debris extends MovieClip
	{
		var mSlow;
		var mPetal;
		
		var mSpeed;
		var mAngle;
		
		var mX;
		var mY;
		
		public function Debris( slow:Boolean, petal:Boolean, xV, yV ) 
		{
			mAngle = 0; 
			
			mSlow = slow;
			mPetal = petal;
			
			mX = xV;
			mY = yV;
			
			var scale = Math.floor( Math.random() * (100 - (75) + 1) + (75) );
			var scale = scale / 100;
			
			//trace ("SCALE "  + scale);
			scaleX = scale;
			scaleY = scale;
			
			if ( mSlow )
			{
				mSpeed = Math.random() * 6 + 2;
			}
			else 
			{
				mSpeed = Math.random() * 15 + 7;
			}
			
			addEventListener(Event.ENTER_FRAME, DoFrameStuff );
			
			gotoAndPlay (21);
			
			
		}
		
		function DoFrameStuff( e )
		{
			mAngle += .05;
			if ( mSlow )
			{
				if ( y >= 540 )
				{
					if ( parent )
					{
						parent.removeChild( this );
					}
				}
				
				x = (Math.sin(mAngle) * 60) + mX;
				y = (Math.cos(mAngle) * 70) + mY;	
				
				mY += mSpeed;
			}
			else 
			{
				// FAST
				if ( x >= 680 )
				{
					if ( parent )
					{
						parent.removeChild( this );
					}
				}
				
				x = (Math.sin(mAngle) * 60) + mX;
				y = (Math.cos(mAngle) * 70) + mY;	
				
				mX += mSpeed;
			}
			
			
			//trace ("DEB.X.Y " + x + " " + y);
			
			rotation +=  mSpeed * .8;
		}
		
	}

}