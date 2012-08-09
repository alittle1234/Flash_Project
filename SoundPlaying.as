package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	public class SoundPlaying
	{
		var mSound:Sound;
		var mChannel1:SoundChannel;
		var mChannel2:SoundChannel;
		
		var mTransform1:SoundTransform;
		var mTransform2:SoundTransform;
		
		var mPlaying1:Boolean;
		var mPlaying2:Boolean;
		
		var timer;
		var timePlay;
		
		var mOver:Boolean;
		
		public function SoundPlaying( sound, trans1, trans2 = null) 
		{
			mTransform1 = trans1;
			mTransform2 = trans2;
			//trace ("Vol " + trans2.volume);
			mChannel1 = new SoundChannel();
			mChannel2 = new SoundChannel();
			mPlaying1 = false;
			mPlaying2 = false;
			mOver = false;
			
			timer = 0;
			timePlay = 50;
		
			var sndClass:Class = getDefinitionByName( sound ) as Class;	
			mSound = new sndClass();
			
			mChannel1.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  );
			
			if ( sound == null )
			{
				trace ("NULL SOUND ARGUMENT");
			}
			
			if ( trans1 == null )
			{
				trace ("NULL TRANS ARGUMENT");
			}
			
			if ( !mSound )
			{
				trace ("SOUND CLASS NOT CREATED");
			}
			
		}
		
		function soundPlay( )
		{
			// CALLED BY SOUND ENGINE EVERY FRAME FOR EACH SOUND
			
			// IF HAS 2 TRANSFORMS(RIGHT AND LEFT)
			if ( mTransform2 )
			{
				if ( !mPlaying1 )
				{
					mChannel1 = mSound.play( 0, 0, mTransform1);					
					mPlaying1 = true;
					timer = getTimer();
					if ( mChannel1 )
					{
						mChannel1.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  );
					}
					
				}
				
				else if ( !mPlaying2 && ( timePlay < getTimer() - timer ) )
				{
					// IF SOUND IS NOT OVER YET
					if ( !mOver )
					{
						// CHECK IF CHAN 1 STILL EXIST AND HAS POSITION
						if ( mChannel1 )
						{
							if ( mChannel1.position )
							{
								mChannel2 = mSound.play( mChannel1.position, 0, mTransform2 );
								
								//trace ("Vol " + mTransform2.volume);
								mPlaying2 = true;
							}
						}
						
					}
				}
				
			}
			// ONLY ONE TRANSFORM (R&L)
			else
			{
				if ( !mPlaying1 )
				{
					// has not been played yet
					mChannel1 = mSound.play(0, 0, mTransform1);
					//mChannel1.soundTransform = mTransform1;
					mPlaying1 = true;
					if ( mChannel1 )
					{
						mChannel1.addEventListener(Event.SOUND_COMPLETE, soundOver, false, 0, true  );
					}
					
				}
			}
			
			
		}
		
		function soundOver( e:Event )
		{
			mOver = true;
		}
	}

}