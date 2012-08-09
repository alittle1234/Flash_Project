/**
 *  @class         FPS
 *  @author        Wissarut Pimanmassuriya (wissar)
 *  @description   Create FPS Monitor
 *  @link	   http://www.area80.net, http://www.lifeztream.com
 *  @usage         import com.lifeztream.debug.FPS;
 *                 var fps:FPS = new FPS(iAlign:String = "left");
 * 				   addChild(fps);
 *                 //output: FPS : Current frame per second of the movie, TE : Time elapsed, in milli-second, amoung a single frame.
 * @version	   1.3	- Auto-start when added to stage and auto-stop when it's removed
 * 						- Fix Bug from StageAlignments
 * 						- Minor Improve Coding Speed
 * 		   1.2	- Dispose unused bitmapData and variables for garbage collector to free up ram.
 *  @language      Actionscript 3.0
*/
package com.lifeztream.debug {
	
	import flash.system.System;
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	
	public class FPS extends Sprite	{
		
		/**
		* Enables copyright information to be retrieved at runtime or when reviewing a decompiled swf.
		*/
		public static const AUTHOR  :String = '(c) 2006-2008 Copyright by Wissarut Pimanmassuriya | area80.net | lifeztream.com | wissarut@area80.net';
		public static const VERSION:String = "1.3";	
		
		public static const ALIGN_LEFT:String = "left";
		public static const ALIGN_RIGHT:String = "right";
		
		/**
		* Get current FPS
		*/
		public var currentFPS:Number;
		public var currentMemory:Number;
		/**
		* Get/Set box alignment on the screen, can be "left" or "right".
		*/
		public var align:String = FPS.ALIGN_LEFT;
		
		private const BORDER:uint = 2;
		private const INTERVALTIMES:uint = 4;
		private const MAX_MEMORIES:uint = 800;
		
		private var WIDTH:uint = 100;
		private var HEIGHT:uint = 60;
		private var _isExpand:Boolean = false;
		private var log:Array;
		private var intervalID:uint;
		private var IMAGE:Sprite;
		private var TEXTFIELD:TextField;
		private var count:uint;
		private var median:uint;
		private var timeElapsed:uint;
		private var cTime:uint;
		private var BITMAP:BitmapData;
		private var bmptoadd:Bitmap;
		private var rollOverText:Sprite;
		
		/**
		 * @param	iAlign	Alignment of the box on the screen, can be "left" or "right", default value is left.
		 */
		public function FPS (iAlign:String = "left"):void {
			addEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, kill);
			align = iAlign;
			reset();
		}
		
		public static function tostring ():String {
			return "com.lifeztream.debug.FPS, version:"+VERSION;
		}
			
		/****************************************************
		* PRIVATE FUNCTION
		****************************************************/
		
		private function added (e:Event):void {
				addEventListener(Event.ENTER_FRAME, onEnterFrame);	
				median = stage.frameRate;
				
				if(!IMAGE) {
					IMAGE = new Sprite();
					addChildAt(IMAGE, 0);
				}
					
				initMouseEvents();
				if(!TEXTFIELD) {
					TEXTFIELD = new TextField();
					TEXTFIELD.autoSize = TextFieldAutoSize.LEFT;
					var tf:TextFormat = new TextFormat("Georgia",10,0x9e9e9e);
					TEXTFIELD.x = BORDER;
					TEXTFIELD.y = BORDER;
					TEXTFIELD.defaultTextFormat =tf;
					TEXTFIELD.selectable = false;
	
					addChildAt(TEXTFIELD, 1);
				}
				intervalID = setInterval(update,1000/INTERVALTIMES);
		}

		private function kill (e:Event):void {
				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				BITMAP.dispose();
				clearInterval(intervalID);
		}
		
		private function createRollOverText ():void {
				rollOverText = new Sprite();
				var tf:TextFormat = new TextFormat("Georgia", 11, 0x2e2e2e);
				var tField:TextField = new TextField();
				tField.autoSize = TextFieldAutoSize.LEFT;
				tField.defaultTextFormat = tf;
				tField.background = true;
				tField.backgroundColor = 0x9e9e9e;
				tField.border = true;
				tField.borderColor = 0x000000;
				tField.selectable = false;
				tField.text = "FPS Monitor by Lifeztream.com";
				rollOverText.addChild(tField);
		}
		
		private function initMouseEvents ():void {
				
				createRollOverText();
				
				var mcEnterFrame = function (e:Event) {
						if(align == FPS.ALIGN_LEFT){
							e.target.x += (mouseX-e.target.x)*0.2;
						} else if (align == FPS.ALIGN_RIGHT) {
							e.target.x += (mouseX-e.target.x-160)*0.2;
						}
						e.target.y += (mouseY-20-e.target.y)*0.2;
				}
				
				
				
				var bOver = function (e:MouseEvent) {				
					if(align == "left"){
						rollOverText.x = mouseX;
					} else if (align == "right") {
						rollOverText.x = mouseX - 160;	
					}
					rollOverText.y = IMAGE.mouseY-20;
					addChild(rollOverText);
					rollOverText.addEventListener(Event.ENTER_FRAME, mcEnterFrame);
				};
				
				var bOut = function (e:Event) {
					removeChild(rollOverText);	
					rollOverText.removeEventListener(Event.ENTER_FRAME, mcEnterFrame);
				};
				var bClick = function (e:Event) {						isExpand = !isExpand;				}
				
				addEventListener(MouseEvent.MOUSE_OVER, bOver);
				addEventListener(MouseEvent.MOUSE_OUT,bOut);
				addEventListener(MouseEvent.CLICK,bClick);
		}
		
		private function update ():void {
				currentFPS = count*INTERVALTIMES;
				currentMemory = System.totalMemory;
				count = 0;
				createLog();
				drawData();
		}
		
		private function get isExpand ():Boolean {
				return _isExpand;
		}
		
		private function set isExpand (b:Boolean) {
				_isExpand = b;
				if(b){
					WIDTH = 200;
					HEIGHT = 120;
				} else {
					WIDTH = 100;
					HEIGHT = 60;
				}
		}
		
		private function reset ():void {
				count = 0;
				currentFPS = 0;
				currentMemory = System.totalMemory;
				log = new Array();
				timeElapsed = 0;
				cTime = 0;
		}
		
		private function onEnterFrame (e:Event):void {
			timeElapsed = getTimer()-cTime;
			cTime = getTimer();
			count++;	
		}
		
		private function drawData ():void {
			
			if (BITMAP) BITMAP.dispose();
			
			var m:Matrix = new Matrix();
			m.translate(BORDER, 20);
			BITMAP = null;
			BITMAP = new BitmapData(WIDTH, HEIGHT, false, 0x3e3e3e);
			var dbmp:BitmapData = new BitmapData(WIDTH - BORDER * 2, HEIGHT - BORDER - 20, false, 0x121212);
			var btodraw:Bitmap = new Bitmap(dbmp);
			BITMAP.draw(btodraw, m);
			
			dbmp.dispose();
			
			BITMAP.setPixel(BORDER - 1, (HEIGHT - BORDER) - getPointerHeight(stage.frameRate), 0x00FFFF);
			
			var c:int = 0;
			var i:int  = 0;
			var color:int;
			var clog:Array;
			if (log.length > (WIDTH - BORDER * 2) / 2)	i = log.length - ((WIDTH - BORDER * 2) / 2);
			
			for (i; i < log.length; i++, c++)
			{	
					clog = log[i] as Array;
					if(Number(clog[0]) > stage.frameRate*0.7){
						color = 0x007e00;
					} else if (Number(clog[0]) > stage.frameRate*0.5){
						color = 0xFFFF80;
					} else {
						color = 0xFF0000;
					}
					BITMAP.setPixel(BORDER+(c*2),(HEIGHT-BORDER)-getPointerHeight(Number(clog[0])),color);		
					BITMAP.setPixel(BORDER+(c*2)+1,(HEIGHT-BORDER)-getPointerMemoryHeight(Number(clog[1])),0x4E4E4E);	
			}

			bmptoadd = new Bitmap(BITMAP);

			if (IMAGE.numChildren > 0) IMAGE.removeChildAt(0);
			
			IMAGE.addChildAt(bmptoadd,0);
			
			if(isExpand){
				TEXTFIELD.text = "FPS : "+currentFPS+"/ TE : "+timeElapsed+" ms./ MemUse : "+Math.round(currentMemory*0.00001)+" mb.";
			} else {
				TEXTFIELD.text = "F.T.M   "+currentFPS+"/ "+timeElapsed+"/ "+Math.round(currentMemory*0.00001) ;
			}
			if(parent == root) {
				if (align == FPS.ALIGN_LEFT) {
						if (stage.align.indexOf("L") != -1) {
							x = 0;
						} else if (stage.align.indexOf("R") != -1) {
							x = (loaderInfo.width-stage.stageWidth);
						} else {
							x = (loaderInfo.width-stage.stageWidth)*0.5;
						}
				} else if (align == FPS.ALIGN_RIGHT) {
						if (stage.align.indexOf("L") != -1) {
							x = stage.stageWidth-WIDTH;
						} else if (stage.align.indexOf("R") != -1) {
							x = loaderInfo.width-WIDTH;
						} else {
							x = loaderInfo.width-WIDTH+(stage.stageWidth - loaderInfo.width)*0.5;
						}
				}
				if (stage.align.indexOf("T") != -1) {
						y = 0;
				} else if (stage.align.indexOf("B") != -1)  {
						y = (loaderInfo.height-stage.stageHeight);
				} else {
						y = (loaderInfo.height-stage.stageHeight)*0.5;
				}
			}
		}
		private function getPointerHeight (n:Number):uint {
				//var maxheight = HEIGHT-BORDER-20;
				//var maxfps = stage.frameRate+10;
				return Math.round((HEIGHT-BORDER-20)*(n/(stage.frameRate+10)));
		}
		private function getPointerMemoryHeight (n:Number):uint {
				//var mem = Math.round(n*0.00001);
				//var maxheight = HEIGHT-BORDER-20;
				return Math.round((HEIGHT-BORDER-20)*((Math.round(n*0.00001))/MAX_MEMORIES));
		}
		private function createLog ():void {
			if (log.length >= Math.floor((WIDTH - BORDER * 2) * 0.5)) 		log.shift();			
			log.push([currentFPS,currentMemory]);	
		}
	}
}