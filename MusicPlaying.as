package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import adobe.utils.CustomActions;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	public class MusicPlaying
	{
		var mSound:Sound;
		var mChannel1:SoundChannel;
		
		var mTransform1:SoundTransform;
		
		var mPlaying1;
		var mVolume;
		
		var mMstrVol;
		var mSndEng:SoundEngine;
		
		var mTransOut:Boolean;
		var mTransIn:Boolean;
		var mOver:Boolean;
		
		public function MusicPlaying( sound, trans1, se:SoundEngine) 
		{
			mTransform1 = trans1;
			mVolume = mTransform1.volume;
			mSndEng = se;
			mMstrVol = se.mMusicVolume;
			
			mChannel1 = new SoundChannel();
			
			mPlaying1 = false;
			
			mTransOut = false;
			mTransIn = false;
			mOver = false;
		
			var sndClass:Class = getDefinitionByName( sound ) as Class;	
			mSound = new sndClass();
			
			mChannel1.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  );
			
			//trace ("PLAYING: " + sound);
		}
		
		function soundPlay( )
		{
			mMstrVol = mSndEng.mMusicVolume;
			if ( !mPlaying1 )
			{
				mChannel1 = mSound.play();
				mTransform1.volume = mVolume * .03 * mMstrVol;
				//trace ("Vol: " + mTransform1.volume);
				mChannel1.soundTransform = mTransform1;
				mTransIn = true;
				mPlaying1 = true;
				mChannel1.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  );
			}
			
			if ( mTransOut )
			{
				mTransform1.volume -= .02 * mMstrVol;
				mChannel1.soundTransform = mTransform1;				
				mChannel1.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  );
				
				if ( mTransform1.volume < .02 )
				{
					mChannel1.stop();
					mOver = true;
				}
			}
			
			if ( mTransIn )
			{
				//trace ("traning in " + mTransform1.volume);
				mTransform1.volume += .005 * mMstrVol;
				mChannel1.soundTransform = mTransform1;				
				mChannel1.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  );
				
				if ( mTransform1.volume >= mVolume * mMstrVol )
				{
					mTransform1.volume = mVolume * mMstrVol;
					mChannel1.soundTransform = mTransform1;				
					mChannel1.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  );
					mTransIn = false;
					//trace ("traning in " + mTransform1.volume + mSndEng.mMusicList.length);
				}
			}
			
			if ( mPlaying1 && !mTransIn && !mTransOut)
			{
				//trace ("VOL: " + mTransform1.volume);
				mTransform1.volume = 1 * mMstrVol;
				mChannel1.soundTransform = mTransform1;				
				mChannel1.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  );
			}
			
		}
		
		function soundOver( e:Event )
		{
			mOver = true;
		}
		
		
	}

}