//var mySound:Sound = new Sample();
//mySound.play();
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.utils.getTimer;

var mySound:Sound = new Death();

var myChannel:SoundChannel = new SoundChannel();
var myChannel2:SoundChannel = new SoundChannel();

var myTransform:SoundTransform = new SoundTransform();
var myMixer:SoundMixer = new SoundMixer();
var lastPosition:Number = 0;
var Over:Boolean;

var left = 1;
var right = .9;
var playing = false ;
var playingSecond = false;
var timer = 0;
var timePlay = 50;
			SoundMixer.soundTransform.volume = .1;
			//myChannel = mySound.play();
			//myTransform.volume = 0.5;
			//myTransform.leftToLeft = 0;
			//myTransform.rightToRight = 1;
			//myTransform.pan = -1;
			myChannel.soundTransform = myTransform;
			
			myChannel.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  )
			
			addEventListener(Event.ENTER_FRAME, soundPlay, false, 0, true  )
			
			function soundOver( e:Event )
			{
				trace ("SOUNDOVER");
				lastPosition = 0;
				Over = true;
			}

			pause_btn.addEventListener(MouseEvent.CLICK, onClickPause, false, 0, true );

			function onClickPause(e:MouseEvent):void
			{
				if( ! Over )
				{
					lastPosition = myChannel.position;
					myChannel.stop();
				}
			}

			play_btn.addEventListener(MouseEvent.CLICK, onClickPlay, false, 0, true );

			function onClickPlay(e:MouseEvent):void
			{
				
				if( lastPosition )
				{
					myChannel = mySound.play(lastPosition);
					Over = false;
				}
				else
				{
					myChannel = mySound.play();
					Over = false;
				}				
				myChannel.soundTransform = myTransform;
				myChannel.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  );
			}
			
			function soundPlay( e:Event )
			{
				
				if ( left > right )
				{
					if ( !playing )
					{
						myChannel = mySound.play()
						myTransform.leftToLeft = left;
						myTransform.rightToRight = 0;
						myChannel.soundTransform = myTransform;
						playing = true;
						timer = getTimer();
					}
					
					if ( !playingSecond && ( timePlay < getTimer() - timer ) )
					{
						trace("PLAY SECOND");
						myChannel2 = mySound.play( myChannel.position )
						myTransform.leftToLeft = 0;
						myTransform.leftToRight = right;
						myChannel2.soundTransform = myTransform;
						playingSecond = true;
					}
					
				}
			}