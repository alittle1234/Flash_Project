package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	
	
	
	public class XP_BAR extends MovieClip 
	{
		var bar_mc:MovieClip;
		var text;
		var mPlayer:Player;
		
		function XP_BAR( player:Player )
		{
			mPlayer = player;
			bar_mc = MovieClip(getChildByName("bar"));
			
			addEventListener(Event.ENTER_FRAME, DoFrame, false, 0, true);
		}
		
		function DoFrame( e:Event )
		{
			if( parent )
			{	
				bar_mc.width =  640 * ( mPlayer.mXP / mPlayer.mXpNeeded[mPlayer.mLevel] );
				
			}
			
		}
		
	}
	
}