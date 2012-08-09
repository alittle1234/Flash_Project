package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author AARON
	 */
	public class b_DeletePrompt extends MovieClip
	{
		var mOk;
		var mCancel;
		var mMain:Main;
		
		public function b_DeletePrompt( main:Main ) 
		{
			mMain = main;
			
			mOk = getChildByName("ok");
			mCancel = getChildByName("cancel");
			
			mOk.addEventListener(MouseEvent.CLICK, MouseClick, false, 0, true  );
			mOk.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			mOk.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			mOk.gotoAndStop(1);
			
			mCancel.addEventListener(MouseEvent.CLICK, MouseClick, false, 0, true  );
			mCancel.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			mCancel.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			mCancel.gotoAndStop(1);
		}
		
		function MouseClick( e:MouseEvent )
		{
			if ( e.target == mOk )
			{
				mMain.SOUND_STAGE.PlaySound("CLICK_BUTTON" , 320);
				
				var obj:SharedObject = SharedObject.getLocal("player");
				obj.clear();
				var obj2:SharedObject = SharedObject.getLocal("level");
				obj2.clear();
			
				mMain.GetPlayerData();
				
				
				parent.removeChild(this);
			}
			else if ( e.target == mCancel )
			{
				mMain.SOUND_STAGE.PlaySound("CLICK_BUTTON" , 320);
				
				parent.removeChild(this);
			}
			
		}
		
		function RollOver( event:Event )
		{
			
			mMain.SOUND_STAGE.PlaySound("SOFT_HOVER" , 320);
			event.target.gotoAndStop( 2 );
			
		}
		
		function RollOff(event:MouseEvent):void 
		{
			event.target.gotoAndStop( 1 );
		}
		
	}

}