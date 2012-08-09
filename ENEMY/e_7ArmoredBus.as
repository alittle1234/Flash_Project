package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_7ArmoredBus extends Enemy
	{
		
		public function e_7ArmoredBus( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_7ArmoredBus")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_armorbus());
			
			super.InitializeMovieClip();
			
			mMoneyValue = 10;
			mXpValue = 8;
			mLifeValue = 8;
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}