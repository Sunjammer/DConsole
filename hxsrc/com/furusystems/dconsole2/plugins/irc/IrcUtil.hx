package com.furusystems.dconsole2.plugins.irc
;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	 class IrcUtil implements IDConsolePlugin 
	{
		var nc:Socket;
		var USER:String = "USER DoomsdayIRC 8 * :DoomsdayIdent";
		var NICK:String = "ddIRC";
		var HOST:String = "irc.homelien.no";
		var PORT:Int = 6667;
		var CHANNEL:String;
		
		var pingTimer:Timer = new Timer(20000);
		var _pm:PluginManager;
		
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String 
		{
			return "Adds a simple one-channel IRC client";
		}
		
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}
		
		public function initialize(pm:PluginManager) 
		{
			_pm = pm;
			pingTimer.addEventListener(TimerEvent.TIMER, ping);
			
			nc = new Socket();
			nc.addEventListener(Event.CONNECT, onConnect);
			nc.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			nc.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			pm.console.defaultInputCallback = tellChannel;
			pm.console.createCommand("ircsend", send, "IRC", "Sends a message to the current IRC channel.");
			pm.console.createCommand("ircjoin", join,"IRC","Joins an IRC channel.");
			pm.console.createCommand("ircpart", part,"IRC","Parts the designated IRC channel.");
			pm.console.createCommand("ircconnect", connect, "IRC", "Initializes the IRC client and connects to the given server");
		}
		
		function onIOError(e:IOErrorEvent) 
		{
			_pm.console.print("IRC couldn't connect: "+e.text, ConsoleMessageTypes.ERROR, "IRC");
		}
		
		public function shutdown(pm:PluginManager) 
		{
			nc.close();
			nc.removeEventListener(Event.CONNECT, onConnect);
			nc.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			nc = null;
			
			pm.console.defaultInputCallback = null;
			pm.console.removeCommand("ircsend");
			pm.console.removeCommand("ircjoin");
			pm.console.removeCommand("ircpart");
			pm.console.removeCommand("ircconnect");
			
			_pm = null;
		}
		function connect(nick:String, host:String = "irc.homelien.no", port:Int = 6669) {
			HOST = host;
			NICK = nick;
			PORT = port;
			_pm.console.print("Connecting to " + host + ":" + port);
			nc.connect(host, PORT);
		}
		function send(str:String) {
			nc.writeUTFBytes(str+"\n");
			nc.flush();
		}
		function tellChannel(str:String) {
			send("PRIVMSG " + CHANNEL + " :" + str);
			ircOutput(NICK + ": " + str);
		}
		function join(channel:String) {
			part();
			send("JOIN " + channel);
			CHANNEL = channel;
		}
		function part() {
			send("PART " + CHANNEL);
		}
		
		function onSocketData(e:ProgressEvent) 
		{
			// :Lost!lost@isplink.org PRIVMSG #actionscript :
			var out= "";
			var split:Array<ASAny>;
			var message= nc.readUTFBytes(nc.bytesAvailable);
			ircOutput(message);
			return;
			if (nc.bytesAvailable != 0&&nc.bytesAvailable>20) {
				var message= nc.readUTFBytes(nc.bytesAvailable);
				if (message.indexOf("PONG") > -1) return; //we ignore ping returns				
				if (message.indexOf("PRIVMSG") > -1) {
					split = (cast message.split(":"));
					out += split[1].split("!").shift();
					out += ": " + split[2];
				}else if (message.indexOf("JOIN") > -1) {
					split = (cast message.split(":"));
					out += split[1].split("!").shift() + " has joined "+CHANNEL;
				}else if (message.indexOf("PART") > -1) {
					split = (cast message.split(":"));
					out += split[1].split("!").shift() + " has left "+CHANNEL;
				}else {
					out += message;
				}
				ircOutput(out);
			}
		}
		
		function ircOutput(out:String) 
		{
			_pm.console.print(out, ConsoleMessageTypes.DEBUG, "IRC");
		}
		
		function onConnect(e:Event) 
		{
			send(USER);
			send("NICK " + NICK);
			pingTimer.start();
		}
		function ping(e:TimerEvent) {
			send("PING " + HOST);
		}
		
	}
	
