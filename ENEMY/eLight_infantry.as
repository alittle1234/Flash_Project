package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class eLight_infantry extends Enemy
	{
		
		public function eLight_infantry( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "eLight_infantry")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_light_infantry());
			
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