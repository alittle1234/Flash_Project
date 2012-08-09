package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class e_91CropDuster extends Enemy
	{
		
		public function e_91CropDuster( BOARD, y_pos, x_pos, route:Number, destin:Number, timer,
		color = "NONE", speed = 2, health = 100, attack = 10,  type = "e_91CropDuster")  
		{
			super(y_pos, x_pos, type, speed, route, destin,
					timer, health, attack, color, BOARD );
			
			super.mMovieClip = MovieClip(new e_cropduster());
			
			super.InitializeMovieClip();			
			
			mMoneyValue = 12;
			mXpValue = 15;
			mLifeValue = 3;
			
			mFlying = true;
		}
		
		override function InitializePersPoints()
		{
			
		}
	}

}