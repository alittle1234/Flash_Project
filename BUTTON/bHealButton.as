package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class bHealButton extends MovieClip
	{
		var mLevReq;	
		var mCost;		
		var mType;
		var mText;
		
		public function bHealButton( )
		{
			//trace ("Healing BUTTON");
			mLevReq = 1;
			mCost = 50;
			mType = "tHealing_tower";
			mText = "BLANK";
		}
		
	}

}