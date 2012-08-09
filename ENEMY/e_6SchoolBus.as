package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_6SchoolBus extends Enemy
	{
		
		public function e_6SchoolBus( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_6SchoolBus")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_schoolbus());
			
			super.InitializeMovieClip();
			
			mMoneyValue = 9;
			mXpValue = 7;
			mLifeValue = 6;
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}