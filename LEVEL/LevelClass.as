package  
{
	/**
	 * ...
	 * @author AARON
	 */
	import XML;
	
	public class LevelClass
	{
		
		[Embed(source = "LEVEL_1.xml", mimeType="application/octet-stream")]
		public  static var LEVEL_1:Class;
		[Embed(source = "LEVEL_2.xml", mimeType="application/octet-stream")]
		public  static var LEVEL_2:Class;
		[Embed(source = "LEVEL_3.xml", mimeType="application/octet-stream")]
		public  static var LEVEL_3:Class;
		[Embed(source = "LEVEL_4.xml", mimeType="application/octet-stream")]
		public  static var LEVEL_4:Class;
		[Embed(source = "LEVEL_5.xml", mimeType="application/octet-stream")]
		public  static var LEVEL_5:Class;
		[Embed(source = "LEVEL_6.xml", mimeType="application/octet-stream")]
		public  static var LEVEL_6:Class;
		
		var xml:XML;
		
		public function LevelClass(name:String)
		{
			var ClassDef:Class = LevelClass[name] as Class;
		
			xml = XML( new ClassDef() );
		}
		
	}
	
}