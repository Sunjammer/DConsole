package com.furusystems.dconsole2.plugins
;
	import com.furusystems.dconsole2.IConsole;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import com.furusystems.dconsole2.core.output.ConsoleMessageTypes;
	import com.furusystems.dconsole2.core.plugins.IDConsolePlugin;
	import com.furusystems.dconsole2.core.plugins.PluginManager;
	
	/**
	 * Parse the ProductInfo tag from the root object's SWF.
	 * 
	 * c.f. http://wahlers.com.br/claus/blog/undocumented-swf-tags-written-by-mxmlc/
	 *
	 */
	 class ProductInfoUtil implements IDConsolePlugin
	{

		var _root:DisplayObject;
		var _isParsed:Bool = false;
		var _tagData:ByteArray;
		var _console:IConsole;
				
				
		public function new()
		{
		}
		
				
		@:flash.property public var root(get,set):DisplayObject;
function  set_root(value:DisplayObject):DisplayObject{
			if (_root != null) {
				_isParsed = false;
				_tagData = null;
			}
			_root = value;	
			parseBytes();		
return value;
		}
function  get_root():DisplayObject {
			return _root;
		}
			
		@:flash.property public var available(get,never):Bool;
function  get_available():Bool {
			return _isParsed && _tagData != null;
		}	
			
		@:flash.property public var productID(get,never):UInt;
function  get_productID():UInt {
			if (!available) { return Std.int(Math.NaN); }
			_tagData.position = 0;
			return _tagData.readUnsignedInt();
		}	
				
		@:flash.property public var edition(get,never):UInt;
function  get_edition():UInt {
			if (!available) { return Std.int(Math.NaN); }
			_tagData.position = 4;
			return _tagData.readUnsignedInt();
		}		
		
		@:flash.property public var sdkVersion(get,never):String;
function  get_sdkVersion():String {
			if (!available) { return ""; }
			_tagData.position = 8;
			var major:UInt, minor:UInt, build:Float;
			major = _tagData.readUnsignedByte();
			minor = _tagData.readUnsignedByte();
			build = _tagData.readUnsignedInt() +
			_tagData.readUnsignedInt() * (ASCompat.MAX_INT + 1);
			return major + '.' + minor + '.0.' + build;
		}
		
		@:flash.property public var compilationDate(get,never):Date;
function  get_compilationDate():Date {
			if (!available) { return null; }
			 var date= Date.now();
			_tagData.position = 18;
			date.setTime(_tagData.readUnsignedInt() +
			_tagData.readUnsignedInt() * (ASCompat.MAX_INT + 1)) ;
			return date;
		}
		
		function parseBytes() {
			
			var loaderInfo:LoaderInfo;
			var bytes:ByteArray;
			var ub:UInt = 5, sb:UInt, frameRectSize:UInt;
			var packedTag:UInt, code:UInt, len:UInt;

			_isParsed = true;
			
			try {
				loaderInfo = _root.loaderInfo;
				bytes = loaderInfo.bytes;
			}
			catch(e:Error) {	
				return;
			}
	
			bytes.endian = Endian.LITTLE_ENDIAN;

			// Skip the header
			bytes.position = 8;
			
			// Read the size of and skip the frame rectangle
			sb = bytes.readUnsignedByte() >> (8 - ub);
			frameRectSize = Math.ceil((ub + (sb * 4)) / 8);
			bytes.position += (frameRectSize - 1);

			// Skip the frame rate and frame count
			bytes.position += 4;			
			
			// Search for the productInfo tag
			while(bytes.bytesAvailable != 0) {
				packedTag = bytes.readUnsignedShort();
				code = packedTag >> 6;
				len = packedTag & 0x3f;
				if (len == 0x3f) {
					len = bytes.readInt();
				}
				if (code == 0x29) {	// ProductInfo tag
					_tagData = new ByteArray();
					_tagData.endian = Endian.LITTLE_ENDIAN;
					bytes.readBytes(_tagData, 0, len);
					_isParsed = true;
					return;
				}
				bytes.position += len;
			}
			
			// SWFs without productInfo tags will reach here without
			// having set the _tagData property.  This is okay.
		}
		
		
		public function getProductInfo()
		{
			root = _console.view.root;
			_console.print("Product info:", ConsoleMessageTypes.SYSTEM);
			if (available) {
				_console.print(" ProductID : " + productID);
				_console.print(" Edition : " + edition);
				_console.print(" Version : " + sdkVersion);
				_console.print(" Compilation Date : " + compilationDate);
			}
			else {
				_console.print(" Product info not available for this SWF (tag not found).");
			}
		}
		
		/* INTERFACE com.furusystems.dconsole2.core.plugins.IDConsolePlugin */
		
		public function initialize(pm:PluginManager)
		{
			_console = pm.console;
			_console.createCommand("productInfo", getProductInfo, "ProductInfoUtil", "Displays the contents of Flex ProductInfo tag (Flex SWFs only)");
		}
		
		public function shutdown(pm:PluginManager)
		{
			_console.removeCommand("productInfo");
		}
		
		@:flash.property public var descriptionText(get,never):String;
function  get_descriptionText():String
		{
			return "Displays the contents of Flex ProductInfo tag (Flex SWFs only)";
		}
		
				
		@:flash.property public var dependencies(get,never):Vector<Class<Dynamic>>;
function  get_dependencies():Vector<Class<Dynamic>> 
		{
			return null;
		}

	}
