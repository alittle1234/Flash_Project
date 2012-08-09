package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import mochi.as3.MochiEvents;
	/**
	 * ...
	 * @author AARON
	 */
	public class MainMenuHeavy extends MovieClip
	{
		
		var mMain:Main;
		
		
		public function MainMenuHeavy( main:Main ) 
		{
			mMain =  main;
			
			
			addEventListener(Event.ENTER_FRAME, FRAME_EVENT, false, 0, true);
			
			if ( mMain.URLF.text == "kongregate" )
			{
				SubmitKongregate();
			}
			
		}
		
		function FRAME_EVENT( event:Event )
		{
			
			//mMain.SOUND_STAGE.PlayMusic("ENTERTAINER_FINAL");
			
			if ( mMain.SOUND_STAGE.mMusicList.length == 0 )
			{
				trace ("----NO MUSIC----");
				
				if ( mMain.mTrack1 == 0 )
				{
					mMain.SOUND_STAGE.PlayMusic("ENTERTAINER_FINAL");
					mMain.mTrack1 = 0;
				}
				
				/*
				else if ( mMain.mTrack1 == 1 )
				{
					mMain.SOUND_STAGE.PlayMusic("HALL_MOUNTIAN");
					mMain.mTrack1 = 2;
				}

				else 
				{
					mMain.SOUND_STAGE.PlayMusic("DANCE");
					mMain.mTrack1 = 0;
				}*/
				
				//mMain.SOUND_STAGE.PlayMusic("NUKE_FULL_1");
			}
			
		}
		
		function SubmitKongregate()
		{
			trace ("_SUBMIT KONG_");
			
			var names:Array = [ "EasyCITY", "MediumSAND", "HardSHORE", "EasySUBURBS", "MediumFOREST", "HardPORTAL" ];
			
			var level_compl = true;
			
			for ( var i = 0; i < mMain.MAIN_PLAYER.mLevelHiScores.length; ++i )
			{
				if ( mMain.MAIN_PLAYER.mLevelHiScores[i] <= 0 )
				{
					level_compl = false;
				}
				else
				{
					// greater than zero
					mMain.kongregate.stats.submit(String(names[i]) + "_Complete",1); //level complete
					
				}
			}
			
			if ( level_compl )
			{
				mMain.kongregate.stats.submit("Game_Complete",1); //game complete
			}
			
			if ( mMain.MAIN_PLAYER.mLevelHiScores[0] > 0 &&
					mMain.MAIN_PLAYER.mLevelHiScores[3] > 0)
			{
				mMain.kongregate.stats.submit("EasyLevels_Complete",1); // complete
			}
			
			if ( mMain.MAIN_PLAYER.mLevelHiScores[1] > 0 &&
					mMain.MAIN_PLAYER.mLevelHiScores[4] > 0)
			{
				mMain.kongregate.stats.submit("MediumLevels_Complete",1); // complete
			}
			
			if ( mMain.MAIN_PLAYER.mLevelHiScores[2] > 0 &&
					mMain.MAIN_PLAYER.mLevelHiScores[5] > 0)
			{
				mMain.kongregate.stats.submit("HardLevels_Complete",1); // complete
			}
			
		}
		
	}

}