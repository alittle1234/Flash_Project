package  
{
	/**
	 * ...
	 * @author AARON
	 */
	
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	public class SoundEngine
	{
		var mSoundVolume;
		var mMusicVolume;
		
		//var mSoundList:DLinkedList;
		var mSoundList:Array;
		var mMusicList:Array;
		
		var mMain:Main;
		
		var mXLeft;
		var mXRight;
		
		public function SoundEngine() 
		{
			mSoundVolume = (1.0);
			mMusicVolume = (0.2);
			
			//mSoundList = new DLinkedList();
			mSoundList = new Array();
			mMusicList = new Array();
			
			mXLeft = 213;
			mXRight = 427;
		}
		
		function DoFrameEvents()
		{
			// search sound list for null, remove
			// else, .playsound()
			//
			
			for ( var i in mSoundList )
			{
				var s:SoundPlaying = mSoundList[i];
				if ( s.mOver )
				{
					mSoundList.splice(i, 1);
				}
				else
				{
					s.soundPlay();
				}
			}
			
			for ( var i in mMusicList )
			{
				var m:MusicPlaying = mMusicList[i];
				if ( m.mOver  )
				{
					if ( !m.mTransOut )
					{
						// music is over but did not fade out
						/*m.mOver = false;
						m.mPlaying1 = false;
						m.soundPlay();*/
						// continuos play if another music clip not added...
						//
						
						m.mTransOut = true;
					}
					else
					{	
						// music is over and faded out
						// tran out, over
						mMusicList.splice(i, 1);
					}
				}
				else
				{
					m.soundPlay();
				}
			}
			
			
		}
		
		function PlaySound( snd:String, xVal )
		{
			// determine right, left, center
			// create apropriate transform
			// transform by master volume
			// add to sound list
			if ( xVal < mXLeft )
			{
				// play left
				var t1:SoundTransform = new SoundTransform();
				t1.leftToLeft = 1;
				t1.rightToRight = 0;
				t1.volume = t1.volume * mSoundVolume;
				var t2:SoundTransform = new SoundTransform();
				t2.leftToLeft = 0;
				t2.leftToRight = 1;
				t2.volume = .05 * mSoundVolume;
				
				var sound:SoundPlaying = new SoundPlaying(snd, t1, t2 );
				//mSoundList.append(sound);
				mSoundList.push(sound);
				sound.soundPlay();
			
			}
			else if ( xVal > mXRight )
			{
				
				// play right
				var t1:SoundTransform = new SoundTransform();
				t1.leftToLeft = 0;
				t1.rightToRight = 1;
				t1.volume = t1.volume * mSoundVolume;
				var t2:SoundTransform = new SoundTransform();
				t2.rightToLeft = 1 ;
				t2.rightToRight = 0;
				t2.volume = .05 * mSoundVolume;
				
				var sound:SoundPlaying = new SoundPlaying(snd, t1, t2 );
				//mSoundList.append(sound);
				mSoundList.push(sound);
				sound.soundPlay();
			}
			else
			{
				// play center
				var t1:SoundTransform = new SoundTransform();
				t1.leftToLeft = 1;
				t1.rightToRight = 1;
				t1.volume *= mSoundVolume;
				
				var sound:SoundPlaying = new SoundPlaying(snd, t1 );
				//mSoundList.append(sound);
				mSoundList.push(sound);
				sound.soundPlay();
			}
		}
		
		function PlayMusic( snd:String )
		{
			var trnsfm:SoundTransform = new SoundTransform();
				trnsfm.leftToLeft = 1;
				trnsfm.rightToRight = 1;
				trnsfm.volume = 1;
				
			var mus:MusicPlaying = new MusicPlaying(snd, trnsfm, this );
			
			if ( mMusicList.length )
			{
				for ( var i in mMusicList )
				{
					mMusicList[i].mTransOut = true;
				}				
			}
			
			mMusicList.push( mus );
		}
		
	}

}