package com.furusystems.dconsole2.plugins.mediatester
;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.Sprite;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class MediaTesterUtil extends Sprite implements IDConsolePlugin
	{
		var _videoPlayers:Vector<SimpleVideoPlayer>;
		@:allow(com.furusystems.dconsole2.plugins.mediatester) var _console:IConsole;
		
		function playVideo(url:String = "-1", application:String = "")
		{
			if (url == "-1") {
				throw new ArgumentError("No media url supplied");
			}
			var player= new SimpleVideoPlayer(this,url,application);
			_videoPlayers.push(player);
			addChild(player);
		}
		@:allow(com.furusystems.dconsole2.plugins.mediatester) function destroy(player:SimpleVideoPlayer) {
			player.close();
			removeChild(player);
			_videoPlayers.splice(_videoPlayers.indexOf(player), 1);
		}
		@:allow(com.furusystems.dconsole2.plugins.mediatester) function log(msg:String) {
			_console.print("MediaPlayer: " + msg);
		}
		function clearAllPlayers()
		{
			for (p in _videoPlayers) {
				destroy(p);
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager)
		{
			_videoPlayers = new Vector<SimpleVideoPlayer>();
			_console = pm.console;
			_console.createCommand("playVideo", playVideo, "Media", "Creates a rudimentary video player for testing a stream or url X");
			pm.topLayer.addChild(this);
		}
			
		public function shutdown(pm:PluginManager)
		{
			clearAllPlayers();
			pm.topLayer.removeChild(this);
			_console = null;
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Enables the creation of rudimentary media players for testing streamed/progressive content";
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
	}

