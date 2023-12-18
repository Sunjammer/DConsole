package com.furusystems.dconsole2.plugins.mediatester 
;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import com.furusystems.dconsole2.core.gui.Window;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class SimpleVideoPlayer extends Window
	{
		var _contents:Sprite = new Sprite();
		var _manager:MediaTesterUtil;
		var nc:NetConnection;
		var ns:NetStream;
		var _mediaURI:String;
		var _applicationURI:String;
		var _video:Video;
		var _firstPlay:Bool = true;
		
		public function new(manager:MediaTesterUtil,mediaURI:String,applicationURI:String = "") 
		{
			super(mediaURI, new Rectangle(0, 0, 100, 80), _contents, null, null, true, false);
			_contents.buttonMode = true;
			_manager = manager;
			_mediaURI = mediaURI;
			_applicationURI = applicationURI;
			nc = new NetConnection();
			nc.client = this;
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncerror, false, 0, true);
			nc.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
			switch(applicationURI) {
				case "":
				nc.connect(null);
				
				default:
				nc.connect(applicationURI);
			}
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			ns.client = this;
			_contents.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			_video = new Video();
			_contents.addChild(_video);
			_video.attachNetStream(ns);
			play();
		}
		
		function onClick(e:MouseEvent) 
		{
			play();
		}
		
		function onNetStatus(e:NetStatusEvent) 
		{
			switch(e.info.code) {
				case NetStatusEventCodes.PLAY_STREAM_NOT_FOUND:
				_manager.log("Stream not found");
				_manager.destroy(this);
				
			}
		}
		public function close() {
			ns.close();
			nc.close();
		}
		
		function onIOError(e:IOErrorEvent) 
		{
			_manager.log(e.text);
		}
		public function onMetaData(o:ASObject) {
			if (!_firstPlay) return;
			_firstPlay = false;
			_video.width = o.width;
			_video.height = o.height;
			scaleToContents();
		}
		
		function onAsyncerror(e:AsyncErrorEvent) 
		{
			
		}
		function onXMPData(o:ASObject) {
			
		}
		public function play() {
			ns.play(_mediaURI);
		}
		override function onClose(e:MouseEvent) 
		{
			_manager.destroy(this);
			super.onClose(e);
		}
		override function onResize() 
		{
			_video.width = viewRect.width;
			_video.height= viewRect.height;
		}
		
	}

