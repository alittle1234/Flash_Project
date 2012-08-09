package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_4SUV extends Enemy
	{
		
		public function e_4SUV( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_4SUV")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_suv());
			
			super.InitializeMovieClip();
			
			mMoneyValue = 6;
			mXpValue = 4;
			mLifeValue = 3;
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}