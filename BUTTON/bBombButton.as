package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class bBombButton extends MovieClip
	{
		var mLevReq;	
		var mCost;		
		var mType;
		var mText;
		
		public function bBombButton( )
		{
			//trace ("Bomb BUTTON");
			mLevReq = 1;
			mCost = 100;
			mType = "tBomb_tower";
			mText = "BLANK";
		}
		
	}

}