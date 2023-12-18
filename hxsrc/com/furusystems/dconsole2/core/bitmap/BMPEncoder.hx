package com.furusystems.dconsole2.core.bitmap ;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	 class BMPEncoder {
		public function new() {
		}
		
		public static function encode(data:BitmapData):ByteArray {
			var values= data.getVector(data.rect);
			
			var bitsPerPixel= 24;
			var w= data.width;
			var h= data.height;
			var rowSize= Std.int(Math.fceil((bitsPerPixel * w) / 32) * 4);
			var padding= Std.int(rowSize - bitsPerPixel / 8 * w);
			var arraySize= rowSize * h;
			
			//var offset:uint = 21;
			var offset:UInt = 54;
			var size= offset + arraySize;
			
			var bytes= new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeByte(0x42);
			bytes.writeByte(0x4D);
			bytes.writeUnsignedInt(size);
			bytes.writeUnsignedInt(0);
			bytes.writeUnsignedInt(offset);
			
			/*
			   // BITMAPCOREHEADER
			   bytes.writeByte(12);
			   bytes.writeShort(w);
			   bytes.writeShort(h);
			   bytes.writeByte(1);
			   bytes.writeByte(bitsPerPixel);
			 */
			
			// BITMAPINFOHEADER
			bytes.writeUnsignedInt(40);
			bytes.writeInt(w);
			bytes.writeInt(h);
			bytes.writeShort(1);
			bytes.writeShort(bitsPerPixel);
			bytes.writeUnsignedInt(0);
			bytes.writeUnsignedInt(arraySize);
			bytes.writeUnsignedInt(0x0B13);
			bytes.writeUnsignedInt(0x0B13);
			bytes.writeUnsignedInt(0);
			bytes.writeUnsignedInt(0);
			
			for (y in (0...h).reverse()) {
				for (x in 0...w) {
					var value= values[x + y * w];
					bytes.writeByte(value & 0xFF);
					bytes.writeByte((value >> 8) & 0xFF);
					bytes.writeByte((value >> 16) & 0xFF);
				}
				for (i in 0...padding) {
					bytes.writeByte(0);
				}
			}
			
			return bytes;
		}
	
	}

