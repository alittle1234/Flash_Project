package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_5CityBus extends Enemy
	{
		
		public function e_5CityBus( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_5CityBus")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_citybus());
			
			super.InitializeMovieClip();
			
			mMoneyValue = 8;
			mXpValue = 5;
			mLifeValue = 4;
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}