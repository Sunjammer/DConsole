package com.furusystems.dconsole2.plugins.inspectorviews.treeview.buttons 
;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.furusystems.dconsole2.core.gui.AbstractButton;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	 class EyeDropperButton extends AbstractButton
	{
		static var bitmap:Class<Dynamic>;
		static final ICON:BitmapData = cast(Type.createInstance(bitmap, []), Bitmap).bitmapData;
		public function new()
		{
			super(ICON.width, ICON.height);
			setIcon(ICON);
			updateAppearance();
			_toggleSwitch = true;
		}
		
	}

