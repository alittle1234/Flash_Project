package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class m_leveled extends MovieClip
	{
		var mPlayer:Player;
		var mCancel;
		var mTextFeild:TextField;
		
		public function m_leveled( plyr:Player ) 
		{
			//mPlayer = plyr;
			mCancel = getChildByName("cancel");
			//gotoAndStop (plyr.mLevel);
			mTextFeild =  TextField(getChildByName("text"));
			
			mTextFeild.text = "You are now Level " + plyr.mLevel + "!";
			
			mCancel.addEventListener( MouseEvent.CLICK, mouseClick, false, 0, true  );
		}
		
		function mouseClick( e:Event )
		{
			
			if ( e.target == mCancel )
			{
				parent.removeChild(this);
			}
		}
	}

}