////////////////////////////////////////////////////////////////////////////////////
//  Class to easily monitor Framerate
//  Just create a new instance of this class, and pass your desired update interval.
//  then you can access the current framerate of your movie by getting the 'framerate' property.
///////////////////////////////////////////////////////////////////////////////////

package com.shawnblais.utils {

	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	import flash.events.Event;

	public class FramerateMonitor extends MovieClip{

		private var _timer:Timer;
		private var _frameCount:Number = 1;
		private var _currentFPS;
		private var _previousTimer;
		public function get framerate() { return _currentFPS; }

		public var refreshRate:Number;

		public function FramerateMonitor(_refreshRate:Number = .2) {

			if (_refreshRate < .05) refreshRate = .05;
			else refreshRate = _refreshRate;

			//Because the Timer class will not fire exactly on the intervals specified by the refresh rate, we'll manually
			//save the current time, so each time we calulate the framerate we can get the exact amount of time elapsed;
			_previousTimer = getTimer();

			_timer = new Timer(refreshRate*1000);
			_timer.addEventListener(TimerEvent.TIMER, calculateFramerate);
			_timer.start();

			addEventListener(Event.ENTER_FRAME, incrementCount );
		}

		public function getFramerate():Number {
			return _currentFPS;
		}

		private function calculateFramerate(e:TimerEvent) {
			_currentFPS = Math.floor(_frameCount / ((getTimer() - _previousTimer) / 1000));
			_frameCount = 0;
			_previousTimer = getTimer();
		}

		private function incrementCount(e:Event) {
			_frameCount++;
		}

		public function Destroy() {
			_currentFPS = 0;
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, calculateFramerate);
			removeEventListener(Event.ENTER_FRAME, incrementCount );

			if (this.parent)
				this.parent.removeChild(this);
		}
	}

}