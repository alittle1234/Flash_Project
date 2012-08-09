
package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class eBird_enemy extends Enemy
	{
		
		public function eBird_enemy( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "eBird_enemy")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_bird_enemy());
			
			super.InitializeMovieClip();
			
			mValue = 1;
			
		}
		
		override function InitializePersPoints()
		{
			mFirePnt = new Point(5, 5);
			mFlshPnt = new Point(5, 5);
			mPoisPnt = new Point(5, 5);
			mSmkePnt = new Point(5, 5);
		}
	}

}