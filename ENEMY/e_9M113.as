package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_9M113 extends Enemy
	{
		
		public function e_9M113( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_9M113")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_m113());
			
			super.InitializeMovieClip();
			
			mMoneyValue = 13;
			mXpValue = 12;
			mLifeValue = 6;
			
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}