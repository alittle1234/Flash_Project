package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	
	
	
	public class MONEY_AWARD_FLOAT extends MovieClip 
	{
		var textFld;
		var text;
		
		function MONEY_AWARD_FLOAT()
		{
			textFld = getChildByName("TXT");
			
			addEventListener(Event.ENTER_FRAME, DoFrame, false, 0, true);
		}
		
		function DoFrame( e:Event )
		{
			if( parent )
			{	
				alpha -= .03;
				y -= .2;
				if( alpha <= 0 )
				{
					parent.removeChild( this );
				}
				
				textFld.text = text;
			}
			
		}
		
	}
	
}