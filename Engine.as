package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Engine extends MovieClip
	{
		
		private var preloader:ThePreloader;
		
		public function Engine() 
		{
			preloader = new ThePreloader(474, this.loaderInfo);
			stage.addChild(preloader);
			trace("ADDED PRELOADER");
			preloader.addEventListener("loadComplete", loadAssets);
			preloader.addEventListener("preloaderFinished", showSponsors);
			
			//addEventListener(Event.ENTER_FRAME, FrameEvent, false, 0, true);
		}
		
		private function loadAssets(e:Event) : void
		{
			this.play();
		}
		
		private function showSponsors(e:Event) : void
		{
			stage.removeChild(preloader);
			trace("show sponsors");
			
		}
		
		/*function FrameEvent( e:Event )
		{
			/*if ( currentFrame == 2 )
			{
				stage.removeChildAt( 1 );
			}
			
		}*/
	}
	
}