package  
{
	/**
	 * ...
	 * @author AARON
	 */
	
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;

	public class Furniture
	{
		var mY;
		var mX;
		var mName;
		
		var mMovieClip;
		
		public function Furniture(y_pos, x_pos, name) 
		{
			mY = y_pos;
			mX = x_pos;
			mName = name;
			
			var tMC:Class = getDefinitionByName( name ) as Class;
			mMovieClip = new tMC() as MovieClip;
			mMovieClip.x = mX;
			mMovieClip.y = mY;
			
		}
		
	}

}