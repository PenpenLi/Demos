package starling.textures
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import flash.display3D.Context3D;
   import starling.core.Starling;
   import starling.errors.MissingContextError;
   import starling.utils.Color;
   import starling.utils.getNextPowerOfTwo;
   import flash.display3D.textures.TextureBase;
   import flash.geom.Rectangle;
   import starling.utils.VertexData;
   import flash.system.Capabilities;
   import starling.errors.AbstractClassError;
   
   public class Texture
   {
       
      public function Texture()
      {
         super();
         if(Capabilities.isDebugger && getQualifiedClassName(this) == "starling.textures::Texture")
         {
            throw new AbstractClassError();
         }
      }
      
      public static function fromData(param1:Object, param2:TextureOptions = null) : starling.textures.Texture
      {
         var _loc3_:starling.textures.Texture = null;
         if(param1 is Bitmap)
         {
            var param1:Object = (param1 as Bitmap).bitmapData;
         }
         if(param2 == null)
         {
            var param2:TextureOptions = new TextureOptions();
         }
         if(param1 is Class)
         {
            _loc3_ = fromEmbeddedAsset(param1 as Class,param2.mipMapping,param2.optimizeForRenderToTexture,param2.scale,param2.format,param2.repeat);
         }
         else if(param1 is BitmapData)
         {
            _loc3_ = fromBitmapData(param1 as BitmapData,param2.mipMapping,param2.optimizeForRenderToTexture,param2.scale,param2.format,param2.repeat);
         }
         else if(param1 is ByteArray)
         {
            _loc3_ = fromAtfData(param1 as ByteArray,param2.scale,param2.mipMapping,param2.onReady,param2.repeat);
         }
         else
         {
            throw new ArgumentError("Unsupported \'data\' type: " + getQualifiedClassName(param1));
         }
         return _loc3_;
      }
      
      public static function fromEmbeddedAsset(param1:Class, param2:Boolean = true, param3:Boolean = false, param4:Number = 1, param5:String = "bgra", param6:Boolean = false) : starling.textures.Texture
      {
         assetClass = param1;
         mipMapping = param2;
         optimizeForRenderToTexture = param3;
         scale = param4;
         format = param5;
         repeat = param6;
         var asset:Object = new assetClass();
         if(asset is Bitmap)
         {
            var texture:starling.textures.Texture = starling.textures.Texture.fromBitmap(asset as Bitmap,mipMapping,false,scale,format,repeat);
            texture.root.onRestore = function():void
            {
               texture.root.uploadBitmap(new assetClass());
            };
         }
         else if(asset is ByteArray)
         {
            texture = starling.textures.Texture.fromAtfData(asset as ByteArray,scale,mipMapping,null,repeat);
            texture.root.onRestore = function():void
            {
               texture.root.uploadAtfData(new assetClass());
            };
         }
         else
         {
            throw new ArgumentError("Invalid asset type: " + getQualifiedClassName(asset));
         }
         asset = null;
         return texture;
      }
      
      public static function fromBitmap(param1:Bitmap, param2:Boolean = true, param3:Boolean = false, param4:Number = 1, param5:String = "bgra", param6:Boolean = false) : starling.textures.Texture
      {
         return fromBitmapData(param1.bitmapData,param2,param3,param4,param5,param6);
      }
      
      public static function fromBitmapData(param1:BitmapData, param2:Boolean = true, param3:Boolean = false, param4:Number = 1, param5:String = "bgra", param6:Boolean = false) : starling.textures.Texture
      {
         data = param1;
         generateMipMaps = param2;
         optimizeForRenderToTexture = param3;
         scale = param4;
         format = param5;
         repeat = param6;
         var texture:starling.textures.Texture = starling.textures.Texture.empty(data.width / scale,data.height / scale,true,generateMipMaps,optimizeForRenderToTexture,scale,format,repeat);
         texture.root.uploadBitmapData(data);
         texture.root.onRestore = function():void
         {
            texture.root.uploadBitmapData(data);
         };
         return texture;
      }
      
      public static function fromAtfData(param1:ByteArray, param2:Number = 1, param3:Boolean = true, param4:Function = null, param5:Boolean = false) : starling.textures.Texture
      {
         data = param1;
         scale = param2;
         useMipMaps = param3;
         async = param4;
         repeat = param5;
         var context:Context3D = Starling.context;
         if(context == null)
         {
            throw new MissingContextError();
         }
         var atfData:AtfData = new AtfData(data);
         var nativeTexture:flash.display3D.textures.Texture = context.createTexture(atfData.width,atfData.height,atfData.format,false);
         var concreteTexture:ConcreteTexture = new ConcreteTexture(nativeTexture,atfData.format,atfData.width,atfData.height,useMipMaps && atfData.numTextures > 1,false,false,scale,repeat);
         concreteTexture.uploadAtfData(data,0,async);
         concreteTexture.onRestore = function():void
         {
            concreteTexture.uploadAtfData(data,0);
         };
         return concreteTexture;
      }
      
      public static function fromColor(param1:Number, param2:Number, param3:uint = 4294967295, param4:Boolean = false, param5:Number = -1, param6:String = "bgra") : starling.textures.Texture
      {
         width = param1;
         height = param2;
         color = param3;
         optimizeForRenderToTexture = param4;
         scale = param5;
         format = param6;
         var texture:starling.textures.Texture = starling.textures.Texture.empty(width,height,true,false,optimizeForRenderToTexture,scale,format);
         texture.root.clear(color,Color.getAlpha(color) / 255);
         texture.root.onRestore = function():void
         {
            texture.root.clear(color,Color.getAlpha(color) / 255);
         };
         return texture;
      }
      
      public static function empty(param1:Number, param2:Number, param3:Boolean = true, param4:Boolean = true, param5:Boolean = false, param6:Number = -1, param7:String = "bgra", param8:Boolean = false) : starling.textures.Texture
      {
         var _loc11_:* = 0;
         var _loc16_:* = 0;
         var _loc14_:* = null;
         if(param6 <= 0)
         {
            var param6:Number = Starling.contentScaleFactor;
         }
         var _loc17_:Context3D = Starling.context;
         if(_loc17_ == null)
         {
            throw new MissingContextError();
         }
         var _loc13_:int = param1 * param6;
         var _loc12_:int = param2 * param6;
         var _loc18_:int = getNextPowerOfTwo(_loc13_);
         var _loc10_:int = getNextPowerOfTwo(_loc12_);
         var _loc9_:Boolean = _loc13_ == _loc18_ && _loc12_ == _loc10_;
         var _loc19_:Boolean = !param4 && !param8 && Starling.current.profile != "baselineConstrained" && "createRectangleTexture" in _loc17_ && param7.indexOf("compressed") == -1;
         if(_loc19_)
         {
            _loc16_ = _loc13_;
            _loc11_ = _loc12_;
            _loc14_ = §§dup(_loc17_)["createRectangleTexture"](_loc16_,_loc11_,param7,param5);
         }
         else
         {
            _loc16_ = _loc18_;
            _loc11_ = _loc10_;
            _loc14_ = _loc17_.createTexture(_loc16_,_loc11_,param7,param5);
         }
         var _loc15_:ConcreteTexture = new ConcreteTexture(_loc14_,param7,_loc16_,_loc11_,param4,param3,param5,param6,param8);
         _loc15_.onRestore = _loc15_.clear;
         if(_loc9_ || _loc19_)
         {
            return _loc15_;
         }
         return new SubTexture(_loc15_,new Rectangle(0,0,param1,param2),true);
      }
      
      public static function fromTexture(param1:starling.textures.Texture, param2:Rectangle = null, param3:Rectangle = null, param4:Boolean = false) : starling.textures.Texture
      {
         return new SubTexture(param1,param2,false,param3,param4);
      }
      
      public function dispose() : void
      {
      }
      
      public function adjustVertexData(param1:VertexData, param2:int, param3:int) : void
      {
      }
      
      public function adjustTexCoords(param1:Vector.<Number>, param2:int = 0, param3:int = 0, param4:int = -1) : void
      {
      }
      
      public function get frame() : Rectangle
      {
         return null;
      }
      
      public function get repeat() : Boolean
      {
         return false;
      }
      
      public function get width() : Number
      {
         return 0;
      }
      
      public function get height() : Number
      {
         return 0;
      }
      
      public function get nativeWidth() : Number
      {
         return 0;
      }
      
      public function get nativeHeight() : Number
      {
         return 0;
      }
      
      public function get scale() : Number
      {
         return 1;
      }
      
      public function get base() : TextureBase
      {
         return null;
      }
      
      public function get root() : ConcreteTexture
      {
         return null;
      }
      
      public function get format() : String
      {
         return "bgra";
      }
      
      public function get mipMapping() : Boolean
      {
         return false;
      }
      
      public function get premultipliedAlpha() : Boolean
      {
         return false;
      }
   }
}
