package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class bPoisonButton extends MovieClip
	{
		var mLevReq;	
		var mCost;		
		var mType;
		var mText;
		
		public function bPoisonButton( )
		{
			//trace ("Poison BUTTON");
			mLevReq = 1;
			mCost = 50;
			mType = "tWarp_tower";
			mText = "BLANK";
		}
		
	}

}