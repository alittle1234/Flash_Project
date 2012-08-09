package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_2HatchBack extends Enemy
	{
		
		public function e_2HatchBack( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_2HatchBack")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_hatchback());
			
			super.InitializeMovieClip();
			
			mMoneyValue = 3;
			mXpValue = 2;
			mLifeValue = 1;
			
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}