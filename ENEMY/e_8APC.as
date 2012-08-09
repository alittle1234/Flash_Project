package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_8APC extends Enemy
	{
		
		public function e_8APC( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_8APC")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_apc());
			
			super.InitializeMovieClip();
			
			mMoneyValue = 10;
			mXpValue = 10;
			mLifeValue = 8;
			
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}