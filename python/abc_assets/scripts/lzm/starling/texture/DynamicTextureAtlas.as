package lzm.starling.texture
{
   import starling.textures.RenderTexture;
   import lzm.util.MaxRectsBinPack;
   import flash.utils.Dictionary;
   import flash.geom.Rectangle;
   import starling.textures.Texture;
   import starling.display.Image;
   import starling.display.DisplayObject;
   import lzm.starling.STLConstant;
   
   public class DynamicTextureAtlas extends RenderTexture
   {
       
      private var _maxRect:MaxRectsBinPack;
      
      private var _textureRegionArray:Array;
      
      private var _testureRegionDictionary:Dictionary;
      
      private var _padding:int = 1;
      
      public function DynamicTextureAtlas(param1:int, param2:int, param3:int = 1)
      {
         super(param1,param2,true,STLConstant.scale);
         _maxRect = new MaxRectsBinPack(512,512);
         _textureRegionArray = [];
         _testureRegionDictionary = new Dictionary();
         _padding = param3;
      }
      
      public function addTexture(param1:String, param2:Texture) : Rectangle
      {
         var _loc4_:Rectangle = _maxRect.insert(param2.width + _padding,param2.height + _padding,0);
         if(_loc4_.width == 0 || _loc4_.height == 0)
         {
            return null;
         }
         var _loc3_:Image = new Image(param2);
         _loc3_.x = _loc4_.x;
         _loc3_.y = _loc4_.y;
         _loc4_.width = _loc4_.width - _padding;
         _loc4_.height = _loc4_.height - _padding;
         _testureRegionDictionary[param1] = _loc4_;
         _textureRegionArray.push(param1);
         draw(_loc3_);
         return _loc4_;
      }
      
      public function addTextureFromDisplayobject(param1:String, param2:DisplayObject) : Rectangle
      {
         var _loc3_:Rectangle = _maxRect.insert(param2.width + _padding,param2.height + _padding,0);
         if(_loc3_.width == 0 || _loc3_.height == 0)
         {
            return null;
         }
         param2.x = _loc3_.x;
         param2.y = _loc3_.y;
         _loc3_.width = _loc3_.width - _padding;
         _loc3_.height = _loc3_.height - _padding;
         _testureRegionDictionary[param1] = _loc3_;
         _textureRegionArray.push(param1);
         draw(param2);
         return _loc3_;
      }
      
      public function getTexture(param1:String) : Texture
      {
         var _loc2_:Rectangle = _testureRegionDictionary[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         return Texture.fromTexture(this,_loc2_);
      }
      
      public function getTextures(param1:String) : Vector.<Texture>
      {
         var _loc3_:* = null;
         var _loc5_:* = 0;
         var _loc2_:Vector.<Texture> = new Vector.<Texture>();
         var _loc4_:int = _textureRegionArray.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _textureRegionArray[_loc5_];
            if(_loc3_.indexOf(param1) == 0)
            {
               _loc2_.push(getTexture(_loc3_));
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function getNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         if(param2 == null)
         {
            var param2:Vector.<String> = new Vector.<String>(0);
         }
         var _loc5_:* = 0;
         var _loc4_:* = _textureRegionArray;
         for each(var _loc3_ in _textureRegionArray)
         {
            if(_loc3_.indexOf(param1) == 0)
            {
               param2.push(_loc3_);
            }
         }
         param2.sort(1);
         return param2;
      }
   }
}
