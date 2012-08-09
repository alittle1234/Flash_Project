package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_1Compact extends Enemy
	{
		
		public function e_1Compact( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_1Compact")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_compact());
			
			super.InitializeMovieClip();
			
			mMoneyValue = 3;
			mXpValue = 1;
			mLifeValue = 1;
			
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}