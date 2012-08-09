package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_3MiniVan extends Enemy
	{
		
		public function e_3MiniVan( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_3MiniVan")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_minivan());
			
			super.InitializeMovieClip();
			
			mMoneyValue = 5;
			mXpValue = 3;
			mLifeValue = 2;
			
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}