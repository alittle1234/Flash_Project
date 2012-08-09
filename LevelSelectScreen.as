package
{
	/**
	 * ...
	 * @author AARON
	 */
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import XML;
	import XMLList;
	import flash.utils.getDefinitionByName;
	
	public class LevelSelectScreen
	{		
		// XML EMBED FOR LEVELS
		/*
		[Embed(source = "LEVEL_1.xml", mimeType="application/octet-stream")]
		public  static const LEVEL_1:Class;
		[Embed(source = "LEVEL_2.xml", mimeType="application/octet-stream")]
		public  static const LEVEL_2:Class;
		[Embed(source = "LEVEL_3.xml", mimeType="application/octet-stream")]
		public  static const LEVEL_3:Class;*/
		
		var mLevel:XML;
		
		var mMain:Main;
		var mGraphicsStage:MovieClip;
		var mSoundStage;
		var mMusicStage;
		var mPlayer:Player;
		
		var LEVEL_1_BUTTON;
		var LEVEL_2_BUTTON;
		var LEVEL_3_BUTTON;
		
		var LEVEL_4_BUTTON;
		var LEVEL_5_BUTTON;
		var LEVEL_6_BUTTON;
		
		var CANCEL_BUTTON;
		var PLAY_BUTTON;
		var LEVL_UP_BUT;
		
		var mLevelSelectStage:MovieClip;
		
		var mSelectedLevel;
		var mSelectionMC;
		
		var mBoard;
		
		public function LevelSelectScreen(PARNT:Main ) 
		{
			trace ("Level Select Screen Loaded");
			
			mMain = PARNT;
			mGraphicsStage = PARNT.GRAPHICS_STAGE;
			mSoundStage = PARNT.SOUND_STAGE;
			mMusicStage = PARNT.MUSIC_STAGE;
			mPlayer = PARNT.MAIN_PLAYER;
			
			LoadLevelsToScreen();		
			
		}
		
		function LoadLevelsToScreen()
		{
			/*
			 * GET AMOUNT OF MAPS
			 * ORDER MAPS INTO ROWS
			 * PASTE MAP THUMBNAILS IN ROW
			 * SELECT APPROPRIAT THUMBNAIL BASED ON PLAYER LEVEL AND MAP LEVEL
			 * SHOW PLAY BUTTON
			 * IF CANCEL, GO TO MENU
			 * */
			
			mLevelSelectStage =  new sLevelSelectStageMC( mMain );
			mGraphicsStage.addChild(mLevelSelectStage);
			
			LEVEL_1_BUTTON = mLevelSelectStage.getChildByName("L_1_BUTTON");			
			LEVEL_1_BUTTON.gotoAndStop(1);
			LEVEL_2_BUTTON = mLevelSelectStage.getChildByName("L_2_BUTTON");	
			LEVEL_2_BUTTON.gotoAndStop(2);	
			LEVEL_3_BUTTON = mLevelSelectStage.getChildByName("L_3_BUTTON");	
			LEVEL_3_BUTTON.gotoAndStop(3);	
			
			LEVEL_4_BUTTON = mLevelSelectStage.getChildByName("L_4_BUTTON");			
			LEVEL_4_BUTTON.gotoAndStop(4);
			LEVEL_5_BUTTON = mLevelSelectStage.getChildByName("L_5_BUTTON");	
			LEVEL_5_BUTTON.gotoAndStop(5);	
			LEVEL_6_BUTTON = mLevelSelectStage.getChildByName("L_6_BUTTON");	
			LEVEL_6_BUTTON.gotoAndStop(6);	
			
			CANCEL_BUTTON = mLevelSelectStage.getChildByName("cancelbutton");	
			CANCEL_BUTTON.gotoAndStop(1);
			PLAY_BUTTON = mLevelSelectStage.getChildByName("playbutton");	
			PLAY_BUTTON.gotoAndStop(1);
			LEVL_UP_BUT = mLevelSelectStage.getChildByName("lvl_up");	
			LEVL_UP_BUT.gotoAndStop(1);
			
			mSelectionMC = new bSelectionMC();
			
			mLevelSelectStage.addChild(mSelectionMC);
			mSelectionMC.visible = false;
			
			LEVEL_4_BUTTON.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			LEVEL_5_BUTTON.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			LEVEL_6_BUTTON.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			
			LEVEL_1_BUTTON.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			LEVEL_2_BUTTON.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			LEVEL_3_BUTTON.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			
			CANCEL_BUTTON.addEventListener(MouseEvent.MOUSE_UP, clickHandler, false, 0, true);
			PLAY_BUTTON.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			LEVL_UP_BUT.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			
			//------------------------------------------------------------------------------
		/*	LEVEL_4_BUTTON.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			LEVEL_5_BUTTON.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			LEVEL_6_BUTTON.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			
			LEVEL_1_BUTTON.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			LEVEL_2_BUTTON.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			LEVEL_3_BUTTON.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);*/
			
			CANCEL_BUTTON.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			PLAY_BUTTON.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			LEVL_UP_BUT.addEventListener(MouseEvent.ROLL_OVER, RollOver, false, 0, true);
			//------------------------------------------------------------------------------
			/*LEVEL_4_BUTTON.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			LEVEL_5_BUTTON.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			LEVEL_6_BUTTON.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			
			LEVEL_1_BUTTON.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			LEVEL_2_BUTTON.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			LEVEL_3_BUTTON.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);*/
			
			CANCEL_BUTTON.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			PLAY_BUTTON.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			LEVL_UP_BUT.addEventListener(MouseEvent.ROLL_OUT, RollOff, false, 0, true);
			//------------------------------------------------------------------------------
			
			
			PLAY_BUTTON.visible = false;
		}
		
		function LoadSelectedLevel()
		{
			/*
			 * ATTACH BOARD TO GRAPHICS
			 * PASS BOARD THE LEVEL TO PLAY
			 * UNLOAD THIS SCREEN
			 * 
			 * */
			
			// USING EMBED CLASS METHOD, THROUGH ANTHER CLASS: LEVEL CLASS
			// DEEP COPY TO MLEVEL, JUST IN CASE
			var cls:LevelClass = new LevelClass("LEVEL_" + mSelectedLevel);
			mLevel = new XML(cls.xml);
			
			mBoard = new GameBoard(mMain, mSelectedLevel, mLevel);
			mLevelSelectStage.mFadingOut = true;			
			
		}
		
		function RollOver( event:Event )
		{
			
			mMain.SOUND_STAGE.PlaySound("SOFT_HOVER" , 320);
			event.target.gotoAndStop( 2 );
			
		}
		
		function RollOff(event:MouseEvent):void 
		{
			event.target.gotoAndStop( 1 );
		}
		
		function clickHandler(event:MouseEvent):void 
		{
			trace ("Handeling Click " + event.currentTarget );	
			
			mMain.SOUND_STAGE.PlaySound("CLICK_BUTTON" , 320);
			
			if ((event.currentTarget == LEVEL_1_BUTTON ) || 
			(event.currentTarget == LEVEL_2_BUTTON ) ||
			(event.currentTarget == LEVEL_3_BUTTON ) ||
			(event.currentTarget == LEVEL_4_BUTTON ) ||
			(event.currentTarget == LEVEL_5_BUTTON ) ||
			(event.currentTarget == LEVEL_6_BUTTON ) )
			{
				
				var tempButton = event.currentTarget;
				mSelectedLevel = tempButton.currentFrame;	
				
				mSelectionMC.visible = true;
				mSelectionMC.x = tempButton.x;
				mSelectionMC.y = tempButton.y;
				
				PLAY_BUTTON.visible = true;
				
				trace ("MovieClip " + mSelectedLevel);
			}
			
			else if ((event.currentTarget == CANCEL_BUTTON ))
			{
				trace ("Cancelling Level Select");
				
				mLevelSelectStage.mFadingOut = true;	
			}
			
			else if ((event.currentTarget is b_LevelUpButton))
			{
				var lu:LevelUpScreen = new LevelUpScreen(mPlayer, mMain);
				
				mGraphicsStage.addChild(lu);
				
				//mMain.mMainMenu.mLevelSelect = 0;
			}
			
			else if ((event.currentTarget == PLAY_BUTTON ))
			{
				trace ("Play Button Clicked");
				if ( mSelectedLevel )
				{
					LoadSelectedLevel();
				}
				
			}
			
		}
		
	}

}