package  
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author AARON
	 */
	public class ColorObj
	{
		var BLACK:uint;
		var BLUE:uint;
		var BROWN:uint;
		var GREEN:uint;
		var ORANGE:uint;
		var RED:uint;
		var PURPLE:uint;
		var WHITE:uint;
		var YELLOW:uint;
		var NONE;
		var GREY;
		
		public function ColorObj() 
		{
			BLACK = 0x000000;
			BLUE = 0X000080;
			BROWN = 0X8B4513;
			GREEN = 0X008000;
			ORANGE = 0XFF8C00;
			RED = 0XFCD0000;
			PURPLE = 0X800080;
			WHITE = 0XFFFFFF;
			YELLOW = 0XFFD700;
			GREY = 0X545454;
		}
		
		function Whiten( colr_trans:ColorTransform):ColorTransform
		{
			var ct:ColorTransform = colr_trans;
			ct.greenOffset += 33;
			
			return ct;
			
			/*var value:uint;
			value = rgb_hex + (0x010101);
			return value;*/
		}
		
		function WhitenChild( movie:MovieClip )
		{
			var mov:MovieClip = MovieClip(movie.getChildAt(1));
			
			var myColor:ColorTransform = mov.transform.colorTransform;
			
			myColor = Whiten(myColor);
			
			mov.transform.colorTransform = myColor; 	
		}
		
		
		function Blacken( rgb_hex:uint ):uint
		{
			var value:uint;
			
			return value;
		}
		
		function GetColor( name:String )
		{
			var value;
			switch( name )
			{
				case "BLACK":
				{
					value = BLACK;
					break;
				}
				case "BLUE":
				{
					value = BLUE;
					break;
				}
				case "BROWN":
				{
					value = BROWN;
					break;
				}
				case "GREEN":
				{
					value = GREEN;
					break;
				}
				case "ORANGE":
				{
					value = ORANGE;
					break;
				}
				case "YELLOW":
				{
					value = YELLOW;
					break;
				}
				case "RED":
				{
					value = RED;
					break;
				}
				case "PURPLE":
				{
					value = PURPLE;
					break;
				}
				case "WHITE":
				{
					value = WHITE;
					break;
				}
				case "NONE":
				{
					value = GREY;
					break;
				}
				case "GREY":
				{
					value = GREY;
					break;
				}
			}
			
			return value;
		}
		
	}

}