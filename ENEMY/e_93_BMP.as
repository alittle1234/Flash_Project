package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_93_BMP extends Enemy
	{
		
		public function e_93_BMP( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_93_BMP")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_bmp());
			
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