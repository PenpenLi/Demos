package starling.textures
{
   import flash.utils.Dictionary;
   import flash.geom.Rectangle;
   
   public class TextureAtlas
   {
      
      private static var sNames:Vector.<String> = new Vector.<String>(0);
       
      private var mAtlasTexture:starling.textures.Texture;
      
      private var mTextureInfos:Dictionary;
      
      public function TextureAtlas(param1:starling.textures.Texture, param2:XML = null)
      {
         super();
         mTextureInfos = new Dictionary();
         mAtlasTexture = param1;
         if(param2)
         {
            parseAtlasXml(param2);
         }
      }
      
      private static function parseBool(param1:String) : Boolean
      {
         return param1.toLowerCase() == "true";
      }
      
      public function dispose() : void
      {
         mAtlasTexture.dispose();
      }
      
      protected function parseAtlasXml(param1:XML) : void
      {
         var _loc7_:* = null;
         var _loc13_:* = NaN;
         var _loc11_:* = NaN;
         var _loc4_:* = NaN;
         var _loc6_:* = NaN;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc8_:* = NaN;
         var _loc14_:* = NaN;
         var _loc15_:* = false;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc3_:Number = mAtlasTexture.scale;
         var _loc17_:* = 0;
         var _loc16_:* = param1.SubTexture;
         for each(var _loc12_ in param1.SubTexture)
         {
            _loc7_ = _loc12_.attribute("name");
            _loc13_ = parseFloat(_loc12_.attribute("x")) / _loc3_;
            _loc11_ = parseFloat(_loc12_.attribute("y")) / _loc3_;
            _loc4_ = parseFloat(_loc12_.attribute("width")) / _loc3_;
            _loc6_ = parseFloat(_loc12_.attribute("height")) / _loc3_;
            _loc9_ = parseFloat(_loc12_.attribute("frameX")) / _loc3_;
            _loc10_ = parseFloat(_loc12_.attribute("frameY")) / _loc3_;
            _loc8_ = parseFloat(_loc12_.attribute("frameWidth")) / _loc3_;
            _loc14_ = parseFloat(_loc12_.attribute("frameHeight")) / _loc3_;
            _loc15_ = parseBool(_loc12_.attribute("rotated"));
            _loc2_ = new Rectangle(_loc13_,_loc11_,_loc4_,_loc6_);
            _loc5_ = _loc8_ > 0 && _loc14_ > 0?new Rectangle(_loc9_,_loc10_,_loc8_,_loc14_):null;
            addRegion(_loc7_,_loc2_,_loc5_,_loc15_);
         }
      }
      
      public function getTexture(param1:String) : starling.textures.Texture
      {
         var _loc2_:TextureInfo = mTextureInfos[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         return starling.textures.Texture.fromTexture(mAtlasTexture,_loc2_.region,_loc2_.frame,_loc2_.rotated);
      }
      
      public function getTextures(param1:String = "", param2:Vector.<starling.textures.Texture> = null) : Vector.<starling.textures.Texture>
      {
         if(param2 == null)
         {
            var param2:Vector.<starling.textures.Texture> = new Vector.<starling.textures.Texture>(0);
         }
         var _loc5_:* = 0;
         var _loc4_:* = getNames(param1,sNames);
         for each(var _loc3_ in getNames(param1,sNames))
         {
            param2.push(getTexture(_loc3_));
         }
         sNames.length = 0;
         return param2;
      }
      
      public function getNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         if(param2 == null)
         {
            var param2:Vector.<String> = new Vector.<String>(0);
         }
         var _loc5_:* = 0;
         var _loc4_:* = mTextureInfos;
         for(var _loc3_ in mTextureInfos)
         {
            if(_loc3_.indexOf(param1) == 0)
            {
               param2.push(_loc3_);
            }
         }
         param2.sort(1);
         return param2;
      }
      
      public function getRegion(param1:String) : Rectangle
      {
         var _loc2_:TextureInfo = mTextureInfos[param1];
         return _loc2_?_loc2_.region:null;
      }
      
      public function getFrame(param1:String) : Rectangle
      {
         var _loc2_:TextureInfo = mTextureInfos[param1];
         return _loc2_?_loc2_.frame:null;
      }
      
      public function getRotation(param1:String) : Boolean
      {
         var _loc2_:TextureInfo = mTextureInfos[param1];
         return _loc2_?_loc2_.rotated:false;
      }
      
      public function addRegion(param1:String, param2:Rectangle, param3:Rectangle = null, param4:Boolean = false) : void
      {
         mTextureInfos[param1] = new TextureInfo(param2,param3,param4);
      }
      
      public function removeRegion(param1:String) : void
      {
      }
      
      public function get texture() : starling.textures.Texture
      {
         return mAtlasTexture;
      }
   }
}

import flash.geom.Rectangle;

class TextureInfo
{
    
   public var region:Rectangle;
   
   public var frame:Rectangle;
   
   public var rotated:Boolean;
   
   function TextureInfo(param1:Rectangle, param2:Rectangle, param3:Boolean)
   {
      super();
      this.region = param1;
      this.frame = param2;
      this.rotated = param3;
   }
}
