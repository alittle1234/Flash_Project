package  
{
	
			
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.xml.XMLDocument;
	import XML;
	import flash.display.StageQuality;
	import flash.utils.getTimer;
	import flash.events.Event;
	
	import flash.net.navigateToURL;
	import flash.ui.Mouse;
	
	import Player;
	
	import net.hires.debug.Stats;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;

	import mochi.as3.MochiEvents;

	
	
	/**
	 * ...
	 * @author AARON
	 */
	
	public class Main extends MovieClip
	{
		
		// You'll use this variable to access the API
		//   (make sure you can access it from wherever you will later call submitScore)
		var MindJoltAPI:Object;

		var MUSIC_TOGGLE_BUTTON;
		var SOUND_TOGGLE_BUTTON;
		var QUALITY_TOGGLE_BUTTON;
		//var SAVE_PLAYER_BUTTON;
		
		var mSmallLink;
		
		var opStage;
		var GRAPHICS_STAGE;
		var SOUND_STAGE:SoundEngine;
		var MUSIC_STAGE;
		
		var MAIN_PLAYER:Player;
		
		var MBOARD:GameBoard;
		
		var mMainMenu:MainMenu;
		
		var myCursor;
		var blk;
		var mTrack1;
		
		var VolumeSlider;		
		
		var statMonkey:Stats;
		
		// Kongregate API reference
		var kongregate:*;
		
		var URLF:TextField;
		
		public function Main() 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, Initialize, false, 0, true);
			
		}
		
		function Initialize( e )
		{
			trace ("Main Loaded " );
		
			stage.focus = stage;
			MBOARD = null;
			
			mTrack1 = 0;
			SOUND_STAGE = new SoundEngine();
			
			URLF = TextField(getChildByName("url") );
			
			GetPlayerData();
			LoadOptionsStage();
			LoadGraphicsStage();			
			LoadMainMenu();		
			
			LoadMindJolt();
			LoadKongregate();
			
			/*
			statMonkey = new Stats();
			opStage.addChild( statMonkey );			
			statMonkey.y = 390;
			statMonkey.x = 580;
			*/
			
			
			addEventListener(Event.ENTER_FRAME, DoFrameEvents, false, 0, true );
			
			//init();
		}
		
		
		function initNewMouse()
		{
			Mouse.hide();
		 
			// this creates an instance of the library MovieClip with the
			// name, "MyCursorClass".  this contains your mouse cursor art
			//
			myCursor = new CustomCursor();
			myCursor.mouseEnabled = false;
			myCursor.mouseChildren = false;
			myCursor.visible = false;
 
			
			// you'll want to make sure the child is added above everything
			// else, possibly in its own container
			//
			opStage.addChild(myCursor);
		 
			// respond to mouse move events
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
		}
		
		function mouseLeaveHandler(evt:Event):void
		{
			myCursor.visible = false;
		}
		
		function mouseMoveHandler(evt:MouseEvent):void
		{
			myCursor.visible = true;
			// whenever the mouse moves, place the cursor in the same spot
			myCursor.x = evt.stageX;
			myCursor.y = evt.stageY;
		}

		function DoFrameEvents( e:Event )
		{
			SOUND_STAGE.DoFrameEvents();
			
			if ( VolumeSlider )
			{
				if ( VolumeSlider.parent )
				{
					// volume slider not null and has no parent?
					SOUND_TOGGLE_BUTTON.visible = false;
					MUSIC_TOGGLE_BUTTON.visible = false;
					
				}
				else
				{
					// no parent
					SOUND_TOGGLE_BUTTON.visible = true;
					MUSIC_TOGGLE_BUTTON.visible = true;
				}
				
			}
			else
			{
				SOUND_TOGGLE_BUTTON.visible = true;
				MUSIC_TOGGLE_BUTTON.visible = true;
			}
			
		}
		
		
		/*
		 * ADD LISTENERS
		 * 
		 * ADD BUTTON FUNCTIONS
		 * 
		 * ADD START GAME CLASS
		 * 
		 * LEVEL SELECT CLASS
		 * 
		 * PLAYER SHOULD LOAD IN THIS MENU, BEFORE GOING TO LEVEL SELCECT
		 * 
		 * INITIALIZING IS LOOKING FOR OLD DATA, LOADING, IF NONE FOUND, LOAD DEFAULT
		 */
		
		function GetPlayerData()
		{
			trace("Getting Player Data");
			var so:SharedObject = SharedObject.getLocal("player")
			if ( so.data.level != null )
			{
				trace("FOUND PLAYER DATA");
				
				trace ("...............");
				trace (String( 
				encrypt(String( so.data.level + so.data.xp + so.data.strength
				+ so.data.wisdom + so.data.agility + so.data.points + so.data.pnts_spent + so.data.hi_scores )) ) );
				
				trace ( String(
					so.data.checksum ) );
				trace ("...............");
					
				if ( String( 
				encrypt(String( so.data.level + so.data.xp + so.data.strength
				+ so.data.wisdom + so.data.agility + so.data.points + so.data.pnts_spent + so.data.hi_scores )) )
					== String(
					so.data.checksum ) )
					{
						trace ("DATA SAVED AGREES WITH SAVED HASH");
						if ( so.data.checksum != undefined)
						{
							trace ("SAVED HASH NOT UNDF");
							trace ("HASH is EQUAL");
							// GET PLAYER DATA FROM SAVED OBJECT
							MAIN_PLAYER = new Player();
							
							MAIN_PLAYER.mLevel = so.data.level;
							MAIN_PLAYER.mXP = so.data.xp;
							MAIN_PLAYER.mStrength = so.data.strength;
							MAIN_PLAYER.mWisdom = so.data.wisdom;
							MAIN_PLAYER.mAgility = so.data.agility;
							MAIN_PLAYER.mPoints = so.data.points;
							MAIN_PLAYER.mPntsSpent = so.data.pnts_spent;
							MAIN_PLAYER.mLevelHiScores = so.data.hi_scores;
							
							MAIN_PLAYER.SetModifiers();
						}
						else
						{
							trace ("SAVED HASH UNDFINED!");
							MAIN_PLAYER = new Player();		
							MAIN_PLAYER.SetModifiers();
						}
						
						
					}
					else
					{
						trace ("DATA AND HASH ARE NOT THE SAME");				
						// CHECKSUM NOT THE SAME AS HASH
						trace ("HASH NOT EQUAL");
						MAIN_PLAYER = new Player();	
						trace ("...SAVING NEW PLAYER");
						MAIN_PLAYER.SetModifiers();
						SavePlayerData();
					}
					
			}
			else
			{
				trace ("DID NOT FIND PLAYER DATA");
				//mPlayer.//ATTRIBUTES = DEFAULT;
				MAIN_PLAYER = new Player();
				
				trace ("...SAVING NEW PLAYER");
				
				MAIN_PLAYER.SetModifiers();
				
				SavePlayerData();
			}
			
			
		}
		
		function SavePlayerData()
		{
			//trace("Saving Player Data");
			
			//if(Title.text!="" && Comments.text !="" && Image.text!=""){
			var so:SharedObject = SharedObject.getLocal("player")
			so.data.level = MAIN_PLAYER.mLevel;
			so.data.xp = MAIN_PLAYER.mXP;
			so.data.strength = MAIN_PLAYER.mStrength;
			so.data.wisdom = MAIN_PLAYER.mWisdom;
			so.data.agility = MAIN_PLAYER.mAgility;
			so.data.points = MAIN_PLAYER.mPoints;
			so.data.pnts_spent = MAIN_PLAYER.mPntsSpent;
			so.data.hi_scores = MAIN_PLAYER.mLevelHiScores;
			
			so.data.checksum = String( encrypt(String( so.data.level + so.data.xp + so.data.strength
			+ so.data.wisdom + so.data.agility + so.data.points + so.data.pnts_spent + so.data.hi_scores )) );
			
			var done = so.flush();
			if ( done )
			{
				//trace ("SAVED");
			}
			
		}
		
		function encrypt(string:String):String
		{
			var hash = new MD5Hash(string)
			hash.setText(string);
			return hash.getHash();
		}
		
		function ToggleMusic()
		{
			trace("Toggeling Music");
			
			if ( VolumeSlider )
			{
				if ( VolumeSlider.parent )
				{
					VolumeSlider.parent.removeChild( VolumeSlider );
				}
				
				VolumeSlider = null;
			}
			
			VolumeSlider = new SoundSlide( true, SOUND_STAGE, MUSIC_TOGGLE_BUTTON );
			VolumeSlider.x = MUSIC_TOGGLE_BUTTON.x;
			VolumeSlider.y = MUSIC_TOGGLE_BUTTON.y;
			opStage.addChild( VolumeSlider );
		}
		
		function ToggleSound()
		{
			trace("Toggeling Sound");
			// draw slide and nob
			// listen to clicks
			// get mouse y (local)
			// volume = abs(y) / height of slide
			// nob y = mouse y
			// soundSlide( volume, mc_anchor )
			
			if ( VolumeSlider )
			{
				if ( VolumeSlider.parent )
				{
					VolumeSlider.parent.removeChild( VolumeSlider );
				}
				
				VolumeSlider = null;
			}
			
			VolumeSlider = new SoundSlide( false, SOUND_STAGE, SOUND_TOGGLE_BUTTON );
			VolumeSlider.x = SOUND_TOGGLE_BUTTON.x;
			VolumeSlider.y = SOUND_TOGGLE_BUTTON.y;
			opStage.addChild( VolumeSlider );
			
		}
		
		function ToggleQuality()
		{
			trace("Toggeling Quality");
			
			//SOUND_STAGE.PlayMusic("Brandenburg");
			
			var stg:Stage = parent.stage;
			
			if ( stg.quality == "HIGH" )
			{
				stg.quality = "MEDIUM"
				QUALITY_TOGGLE_BUTTON.gotoAndStop(2);
			}
			
			else if ( stg.quality == "MEDIUM" )
			{
				stg.quality = "LOW"
				QUALITY_TOGGLE_BUTTON.gotoAndStop(3);
			}
			
			else if ( stg.quality == "LOW" )
			{
				stg.quality = "HIGH";
				QUALITY_TOGGLE_BUTTON.gotoAndStop(1);
			}
		}
		
		function LoadGraphicsStage()
		{
			if ( GRAPHICS_STAGE )
			{
				removeChild(GRAPHICS_STAGE);
				
				trace("GRAPHIC IS LOADED...OFFLOADING");
			}
			else 
			{
				trace("UNDEFINED GRAPHIC...");
			}
			trace("LOADING NEW GRAPHICS STAGE...");
			GRAPHICS_STAGE = new sGraphicsStage();
			addChild(GRAPHICS_STAGE);
			if ( opStage )
			{
				if ( getChildIndex(opStage) < getChildIndex(GRAPHICS_STAGE) )
				{
					swapChildren(opStage, GRAPHICS_STAGE);
				}				
				
			}
			
		}
		
		function LoadMainMenu()
		{
			mMainMenu = new MainMenu(this, true);
			
			mochi.as3.MochiEvents.endPlay();
			
		}
		
		function clickHandler(event:MouseEvent):void 
		{
			trace ("Handeling Click " + event.currentTarget );		
			
			if ((event.currentTarget == MUSIC_TOGGLE_BUTTON))
			{
				ToggleMusic();
			}
			
			else if ((event.currentTarget == SOUND_TOGGLE_BUTTON))
			{
				ToggleSound();
			}
			
			else if ((event.currentTarget == QUALITY_TOGGLE_BUTTON))
			{
				ToggleQuality();
			}
			
			else if ((event.currentTarget == mSmallLink))
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
		
		function LoadOptionsStage()
		{
			opStage = getChildByName("myOptionsStage");			
			
			MUSIC_TOGGLE_BUTTON = opStage.getChildByName("musicToggle");
			SOUND_TOGGLE_BUTTON = opStage.getChildByName("soundToggle");
			QUALITY_TOGGLE_BUTTON = opStage.getChildByName("qualityToggle");
			//mSmallLink = opStage.getChildByName("LINK");
			
			MUSIC_TOGGLE_BUTTON.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			SOUND_TOGGLE_BUTTON.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			QUALITY_TOGGLE_BUTTON.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			//mSmallLink.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			
			
		}

		function LoadAfterPlay()
		{
			// THIS FUNCTION CALLED BY CHILDREN AFTER A GAME HAS BEEN PLAYED
			LoadGraphicsStage();
			blk = new BLACK();
			opStage.addChildAt( blk, 1 );
			LoadMainMenu();
			mMainMenu.NewGame();
			//opStage.removeChild( blk );
		}
		
		function LoadMindJolt()
		{
						
			/*//////
			// All of this code should be executed at the very beginning of the game
			//
			
			
				// get the parameters passed into the game
				var gameParams:Object = LoaderInfo(root.loaderInfo).parameters;

				// manually load the API
				var urlLoader:Loader = new Loader();
				urlLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadFinished);
				urlLoader.load(new URLRequest(gameParams.mjPath || "http://static.mindjolt.com/api/as3/scoreapi_as3_local.swf"));
				stage.addChild(urlLoader);
				function loadFinished (e:Event):void 
				{
					MindJoltAPI = e.currentTarget.content;
					if (MindJoltAPI != null) 
					{
						MindJoltAPI.service.connect();
						//trace ("[MindJoltAPI] service manually loaded");
					}
					
				}
			
			////////////////////////////////////////////*/
			
			
			var wrapper:DisplayObjectContainer;

			//trace(root.parent)
			//trace(root.parent.parent);
			if (root.parent)
			{
				wrapper = root.parent;
				
				if (root.parent.parent)
				{
					wrapper = root.parent.parent;
				}
			}
			

			var api_url : String = wrapper.loaderInfo.parameters.mjPath;

			var request : flash.net.URLRequest = new flash.net.URLRequest(api_url);
			var loader : flash.display.Loader = new flash.display.Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,this.loadFinished);

			// "trick" here:
			wrapper.addChild(loader);

			//loader.load(request);
			loader.load(new URLRequest(api_url || "http://static.mindjolt.com/api/as3/scoreapi_as3_local.swf"));

		}

		public function loadFinished (e:Event):void 
		{

		//this.mindjolt = e.currentTarget.content;
		//this.mindjolt.service.connect();
			MindJoltAPI=e.currentTarget.content;
		trace(e.currentTarget)
		trace(e.currentTarget.content)
		trace(MindJoltAPI);
			MindJoltAPI.service.connect();
		trace(MindJoltAPI.service);
		trace ("[MindJoltAPI] service manually loaded");
		}

		function LoadKongregate()
		{
			var wrapper:DisplayObjectContainer;

			//trace(root.parent)
			//trace(root.parent.parent);
			if (root.parent)
			{
				wrapper = root.parent;
				
				if (root.parent.parent)
				{
					wrapper = root.parent.parent;
				}
			}
			
			
			
			
			//opStage.addChild(URLF);
			
			URLF.text = String(wrapper.loaderInfo.loaderURL);
			
			var pattern:RegExp = /documents/i;
			var str:String = String(wrapper.loaderInfo.loaderURL);
			//trace(str.search(pattern)); 
			
			trace( "search: " + str.search(pattern) );
			var index = str.search(pattern);
			
			if ( index >= 0)
			{
				URLF.text = "DOCUMENTS ";
			}
			
			pattern = /kongregate/i;
			index = str.search(pattern);
			if ( index >= 0)
			{
				URLF.text = "kongregate";
			}
			
			pattern = /mindjolt/i;
			index = str.search(pattern);
			if ( index >= 0)
			{
				URLF.text = "mindjolt";
			}
			
			pattern = /megaswf/i;
			index = str.search(pattern);
			if ( index >= 0)
			{
				URLF.text = "megaswf";
			}
			
			if ( URLF.text == "DOCUMENTS ")
			{
				trace("--URL CHECK WORKS--");
			}
			//trace("-URL-: " + String(wrapper.loaderInfo.loaderURL) );
			
			//trace("-URL-: " + String(wrapper.loaderInfo.applicationDomain.parentDomain) );
			
			// Pull the API path from the FlashVars
			var paramObj:Object = LoaderInfo(wrapper.loaderInfo).parameters;
			 
			// The API path. The "shadow" API will load if testing locally.
			var apiPath:String = paramObj.kongregate_api_path ||
			  "http://www.kongregate.com/flash/API_AS3_Local.swf";
			 
			// Allow the API access to this SWF
			Security.allowDomain(apiPath);
			 
			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteKong);
			loader.load(request);
			
			this.addChild(loader);
			
		}
		
		// This function is called when loading is complete
		function loadCompleteKong(event:Event):void
		{
				// Save Kongregate API reference
			kongregate = event.target.content;
			 
				// Connect to the back-end
			kongregate.services.connect();
			
			
			//URLF.text =  "kongregate";
				// You can now access the API via:
				// kongregate.services
				// kongregate.user
				// kongregate.scores
				// kongregate.stats
				// etc...
		}



	}

}