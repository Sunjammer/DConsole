package com.furusystems.dconsole2.core.introspection
;
	import com.furusystems.dconsole2.core.introspection.descriptions.*;
	import com.furusystems.dconsole2.core.text.autocomplete.AutocompleteDictionary;
	import flash.display.DisplayObjectContainer;
	import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class InspectionUtils
	{
		static var desc:compat.XML;
		static var _lastClassDescribed:String;
		public function new()
		{

		}
		public static function getAutoCompleteDictionary(o:ASAny):AutocompleteDictionary
		{
			desc = describeTypeCached(o);
			var dict= new AutocompleteDictionary();
			// get all methods
			var node:compat.XML;
			var list= desc.descendants("method");
			for (_tmp_ in list)
			{
node  = _tmp_;
				dict.addToDictionary(node.attribute("name"));
			}
			list = desc.descendants("variable");
			for (_tmp_ in list)
			{
node  = _tmp_;
				dict.addToDictionary(node.attribute("name"));
			}
			list = desc.descendants("method");
			for (_tmp_ in list)
			{
node  = _tmp_;
				dict.addToDictionary(node.attribute("name"));
			}
			list = desc.descendants("accessor");
			for (_tmp_ in list)
			{
node  = _tmp_;
				dict.addToDictionary(node.attribute("name"));
			}
			if (Std.is(o , DisplayObjectContainer))
			{
				var i:Int = o.numChildren;
				i > 0;while (i-- != 0)
				{
					dict.addToDictionary(o.getChildAt(i).name);
				}
			}

			return dict;
		}
		public static function getInheritanceChain(o:ASAny):Vector<String>
		{
			var out= new Vector<String>();
			desc = describeTypeCached(o);
			for (node in desc.descendants("extendsClass"))
			{
				out.push(node.attribute("type"));
			}
			return out;
		}
		public static function getInterfaces(o:ASAny):Vector<String>
		{
			var out= new Vector<String>();
			desc = describeTypeCached(o);
			for (node in desc.descendants("implementsInterface"))
			{
				out.push(node.attribute("type"));
			}
			return out;
		}
		static function describeTypeCached(target:ASAny):compat.XML
		{
			var _thisClassName= getQualifiedClassName(target);
			if (_lastClassDescribed != _thisClassName)
			{
				desc = ASCompat.describeType(target);
				_lastClassDescribed = _thisClassName;
			}
			return desc;
		}
		public static function getAccessors(o:ASAny):Vector<AccessorDesc>
		{
			desc = describeTypeCached(o);
			var vec= new Vector<AccessorDesc>();
			var node:compat.XML;
			var list= desc.descendants("accessor");
			for (_tmp_ in list)
			{
node  = _tmp_;
				vec.push(new AccessorDesc(node));
			}
			return vec;
		}
		public static function getMethods(o:ASAny):Vector<MethodDesc>
		{
			desc = describeTypeCached(o);
			var vec= new Vector<MethodDesc>();
			var node:compat.XML;
			var list= desc.descendants("method");
			for (_tmp_ in list)
			{
node  = _tmp_;
				vec.push(new MethodDesc(node));
			}
			return vec;
		}
		public static function getVariables(o:ASAny):Vector<VariableDesc>
		{
			desc = describeTypeCached(o);
			var vec= new Vector<VariableDesc>();
			var node:compat.XML;
			var list= desc.descendants("variable");
			for (_tmp_ in list)
			{
node  = _tmp_;
				vec.push(new VariableDesc(node));
			}
			return vec;
		}

		// thanks Paulo Fierro :)
		public static function getMethodTooltip(scope:ASObject, methodName:String):String
		{
			var tip= methodName + "( ";
			var desc:compat.XMLList = null;// = describeTypeCached(scope)..method.(attribute("name").toLowerCase() == methodName.toLowerCase());
			if (desc.length() == 0)
			{
				throw new Error("No description for method " + methodName);
			}
			// <parameter index="1" type="String" optional="false"/>
			var first= true;
			for (attrib in desc.descendants("parameter"))
			{
				if (!first)
					tip += ", ";
				tip += attrib.attribute("type").toString().toLowerCase();
				if (attrib.attribute("optional") == "true")
				{
					tip += "[optional]";
				}
				first = false;
			}
			tip += " ):" + desc.attribute("returnType");
			return tip;
		}
		public static function getAccessorTooltip(scope:ASObject, accessorName:String):String
		{
			var tip= accessorName;
			var desc:compat.XMLList = null;// = describeTypeCached(scope)..accessor.(attribute("name").toLowerCase() == accessorName.toLowerCase());
			if (desc.length() == 0)
			{
				desc;// = describeTypeCached(scope)..variable.(attribute("name").toLowerCase() == accessorName.toLowerCase());
				if (desc.length() == 0)
				{
					throw new Error("No description");
				}
			}
			tip += ":" + desc.attribute("type");
			if (desc.attribute("access") == "readonly")
			{
				tip += " (read only)";
			}
			return tip;
		}

		public static function getMethodArgs(func:ASObject):Array<ASAny>
		{
			var desc= describeTypeCached(func);
			var out:Array<ASAny> = [];
			for (attrib in desc.descendants("parameter"))
			{
				out.push(attrib);
			}
			return out;
		}

	}

