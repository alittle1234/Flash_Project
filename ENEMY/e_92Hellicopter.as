package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_92Hellicopter extends Enemy
	{
		
		public function e_92Hellicopter( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_92Hellicopter")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_hellicopter());
			
			super.InitializeMovieClip();
			
			mMoneyValue = 12;
			mXpValue = 17;
			mLifeValue = 3;
			
			mFlying = true;
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}