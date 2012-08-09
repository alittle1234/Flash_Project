package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author AARON
	 */
	public class  SoundSlide extends MovieClip
	{
		var mStage:SoundEngine;
		var mMusic:Boolean;
		var mButton:MovieClip;
		var mNob:MovieClip;
		var mVolume;
		var mMouseOver:Boolean;
		
		function SoundSlide( mus_sound:Boolean, snd_stag:SoundEngine, anchor:MovieClip)
		{
			mStage = snd_stag;
			mMusic = mus_sound;
			mButton = anchor;
			
			GetVolume();
			mNob = new Nob();
			mNob.x  = 10;
			mNob.y = -1 * (height * mVolume);
			addChild( mNob );
			
			addEventListener(Event.ENTER_FRAME, FrameEvents, false, 0, true);
			
			addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, LooseFocus, false, 0, true);
			addEventListener(FocusEvent.FOCUS_OUT, LooseFocus, false, 0, true);
			addEventListener(MouseEvent.CLICK, LooseFocus, false, 0, true);
			mNob.addEventListener(MouseEvent.CLICK, LooseFocus, false, 0, true);
			
			addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, RollOut, false, 0, true);
			
			
		}
		
		function RollOver( event:Event )
		{
			mMouseOver = true;
		}
		
		function RollOut( event:Event )
		{
			mMouseOver = false;
			
		}
		
		function FrameEvents( event:Event )
		{
			
			stage.stageFocusRect = false;
			focusRect = false;
			
			stage.focus = this;
			
			if ( mMouseOver )
			{
				
				if ( mouseY < 0 && mouseY > -175 )
				{
					mNob.y = mouseY;
					
					mVolume = Math.abs( mNob.y ) / height;
					SetVolume( );
				}
				
			}
		}
		
		function LooseFocus( event:Event )
		{
			// only looses focus if another 'button' listens
			// this is probably a click
			
			if ( parent )
			{
				parent.removeChild( this );
				removeEventListener(Event.ENTER_FRAME, FrameEvents);
				removeEventListener(FocusEvent.FOCUS_OUT, LooseFocus);
				removeEventListener(MouseEvent.CLICK, LooseFocus);
				mNob.removeEventListener(MouseEvent.CLICK, LooseFocus);
				removeEventListener(MouseEvent.ROLL_OVER, RollOver);
				removeEventListener(MouseEvent.ROLL_OUT, RollOut);
			}
		}
		
		function GetVolume()
		{
			if ( mMusic )
			{
				mVolume = mStage.mMusicVolume;
			}
			else
			{
				mVolume = mStage.mSoundVolume;
			}
		}
		
		function SetVolume()
		{
			if ( mVolume < (0.06) )
			{
				mVolume = 0;
			}
			
			if ( mMusic )
			{
				mStage.mMusicVolume = mVolume;
			}
			else
			{
				mStage.mSoundVolume = mVolume;
			}
		}
		
	}
	
}