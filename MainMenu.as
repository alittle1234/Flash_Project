package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class MainMenu
	{
		var NEW_GAME_BUTTON;
		var CONTINUE_BUTTON;
		var CREDITS_BUTTON;
		var DELETE_SAVED_DATA_BUTTON;
		var CANCEL_BUTTON;
		
		var mBig_Link;
		
		var mHeavy;
		var mMainMenu;
		
		var mMain:Main;
		var mGraphicsStage;
		var mSoundStage;
		var mMusicStage;
		var mPlayer:Player;
		
		var mLevelSelect;
		
		public function MainMenu( PARNT:Main, HEAVY:Boolean ) 
		{
			mMain = PARNT;
			mGraphicsStage = PARNT.GRAPHICS_STAGE;
			mSoundStage = PARNT.SOUND_STAGE;
			mMusicStage = PARNT.MUSIC_STAGE;
			mPlayer = PARNT.MAIN_PLAYER;
			
			mHeavy = HEAVY;
			
			/*
			NEW_GAME_BUTTON = new bNewGameButton();
			
			CREDITS_BUTTON = new bCreditsButton();
			DELETE_SAVED_DATA_BUTTON = new bDeleteSaveButton();
			CANCEL_BUTTON = new bCancelButton();
			*/
			
			MainMenuDraw();
			
			trace (" CALLING GET_PLAYER FROM MAIN_MENU");
			mMain.GetPlayerData();
		}
		
		function mouseOver(event:MouseEvent):void 
		{
			//trace ("Rolling Over" );
			mMain.SOUND_STAGE.PlaySound("SOFT_HOVER" , 320);
			event.target.gotoAndPlay( 10 );
			
		}
		
		function mouseOff(event:MouseEvent):void 
		{
			//trace ("ROLLING OFF ");
			//mMain.SOUND_STAGE.PlaySound("roll_over_sound" , event.target.x);
			event.target.gotoAndPlay( 20 );
		}
		
		
		function MouseClick_Handler(event:MouseEvent):void 
		{
			trace ("Handeling Click " + event.currentTarget );		
			
			mMain.SOUND_STAGE.PlaySound("CLICK_BUTTON" , 320);
			
			if ( event.currentTarget == NEW_GAME_BUTTON )
			{
				trace ("Calling NewGame");
				NewGame();
			}
			
				
			else if ((event.currentTarget ==  CREDITS_BUTTON))
			{
				trace ("Calling CreditsShow");
				CreditsShow();
			}
			
			else if (event.currentTarget == DELETE_SAVED_DATA_BUTTON )
			{
				trace ("Calling DeleteSavedData");
				DeleteSavedData();
			}
			
			else if (event.currentTarget == mBig_Link )
			{
				var url:String = "http://site";
				var request:URLRequest = new URLRequest(url);
				
				try 
				{
					navigateToURL(request, '_blank'); // second argument is target
				} 
				
				catch (e:Error) 
				{
					trace("Error occurred!");
				}
			}
			
			
		}
		
		
		function NewGame()
		{
			if ( mHeavy )
			{
				mLevelSelect = new LevelSelectScreen( mMain );
				//mLevelSelect = null;
			}
			else
			{
				// PROMPT CONFIRM BEFORE LOADING !!!
			}
		}
		
		function ContinueGame()
		{
			var so:SharedObject = SharedObject.getLocal("level");
			if ( so.data.level != null )
			{
				var lvl:Number = Number(so.data.level);
				var cls:LevelClass = new LevelClass("LEVEL_" + lvl);
				var lvlXML:XML = new XML(cls.xml);
				
				var mBoard = new GameBoard(mMain, lvl, lvlXML);
				mBoard.ContinueLevel( so );
			}
			else
			{
				trace ("NO SAVED LEVEL!");
			}
		}
		
		function CreditsShow()
		{
			var cred = new Credits_Menu();
			mGraphicsStage.addChild(cred);
		}
		
		function DeleteSavedData()
		{
			var deleteProm:b_DeletePrompt = new b_DeletePrompt( mMain );
			
			mGraphicsStage.addChild(deleteProm);
		}
		
		function CancelMenu()
		{
			
			mGraphicsStage.removeChild(mMainMenu);
			
			mPlayer.mPaused = false;
		}
		
		function MainMenuDraw()
		{
			if ( mHeavy )
			{
				// clear graphics board
				mMain.LoadGraphicsStage();
				mGraphicsStage = mMain.GRAPHICS_STAGE;
				// attach main menu background, possibly player character
				
				mMainMenu = new MainMenuHeavy( mMain )
				mGraphicsStage.addChild(mMainMenu);
				
				NEW_GAME_BUTTON = mMainMenu.getChildByName("newgame");				
				CREDITS_BUTTON = mMainMenu.getChildByName("credits");
				DELETE_SAVED_DATA_BUTTON = mMainMenu.getChildByName("deletesave");
				//mBig_Link = mMainMenu.getChildByName("LINK");
				
				NEW_GAME_BUTTON.addEventListener(MouseEvent.CLICK, MouseClick_Handler, false, 0, true);				
				CREDITS_BUTTON.addEventListener(MouseEvent.CLICK, MouseClick_Handler, false, 0, true);
				DELETE_SAVED_DATA_BUTTON.addEventListener(MouseEvent.CLICK, MouseClick_Handler, false, 0, true);
				//mBig_Link.addEventListener(MouseEvent.CLICK, MouseClick_Handler, false, 0, true);
				
				NEW_GAME_BUTTON.addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);				
				CREDITS_BUTTON.addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);
				DELETE_SAVED_DATA_BUTTON.addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);
				//mBig_Link.addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);
				
				NEW_GAME_BUTTON.addEventListener(MouseEvent.ROLL_OUT, mouseOff, false, 0, true);				
				CREDITS_BUTTON.addEventListener(MouseEvent.ROLL_OUT, mouseOff, false, 0, true);
				DELETE_SAVED_DATA_BUTTON.addEventListener(MouseEvent.ROLL_OUT, mouseOff, false, 0, true);
				//mBig_Link.addEventListener(MouseEvent.ROLL_OUT, mouseOff, false, 0, true);
				
				mSoundStage.PlayMusic("ENTERTAINER_FINAL");
			}
			else
			{
				// dont clear
				// attach translucent grey
				mGraphicsStage.addChild(NEW_GAME_BUTTON);
				//mGraphicsStage.addChild(CONTINUE_BUTTON);
				mGraphicsStage.addChild(CREDITS_BUTTON);
				mGraphicsStage.addChild(CANCEL_BUTTON);
				
			}
		}
		
	}

}