package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class Preloader extends MovieClip 
	{
		var _MAIN:Main;
		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
			trace ("Calling progres");
			
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
			trace ("PRELOADFRAME");
			
			var perc:Number = e.bytesLoaded / e.bytesTotal;
			var percent = getChildByName("percent");
			percent.text = Math.ceil(perc*100).toString()+"%";
		}
		
		private function startup():void 
		{
			// hide loader
			//stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			//var mainClass:Class = getDefinitionByName("Main") as Class;
			//addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}