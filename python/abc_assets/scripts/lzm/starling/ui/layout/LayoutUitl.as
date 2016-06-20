package lzm.starling.ui.layout
{
   import starling.utils.AssetManager;
   import starling.display.Sprite;
   import starling.display.DisplayObject;
   import lzm.starling.display.Button;
   import starling.display.QuadBatch;
   import starling.display.Image;
   import starling.textures.Texture;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.text.TextField;
   
   public class LayoutUitl
   {
      
      public static const ANGLE_TO_RADIAN:Number = 0.017453292519943295;
       
      public var imagesData:Object;
      
      public var layoutsData:Object;
      
      public var asset:AssetManager;
      
      public function LayoutUitl(param1:Object, param2:AssetManager)
      {
         super();
         this.imagesData = param1["images"];
         this.layoutsData = param1["layout"];
         this.asset = param2;
      }
      
      public function buildLayout(param1:String, param2:Sprite) : void
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc3_:Array = layoutsData[param1];
         var _loc4_:int = _loc3_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc7_];
            if(_loc5_.type == "sprite")
            {
               _loc6_ = createSprite(_loc5_.cname);
            }
            else if(_loc5_.type == "image")
            {
               _loc6_ = createImage(_loc5_.cname);
            }
            else if(_loc5_.type == "s9image")
            {
               _loc6_ = createS9Image(_loc5_.cname);
            }
            else if(_loc5_.type == "batch")
            {
               _loc6_ = createBatch(_loc5_.cname);
            }
            else if(_loc5_.type == "btn")
            {
               _loc6_ = createButton(_loc5_.cname);
            }
            else if(_loc5_.type == "text")
            {
               _loc6_ = createTextField(_loc5_);
            }
            _loc6_.x = _loc5_.x;
            _loc6_.y = _loc5_.y;
            if(_loc5_.type == "s9image")
            {
               _loc6_.width = _loc5_.w;
               _loc6_.height = _loc5_.h;
            }
            else
            {
               _loc6_.scaleX = _loc5_.sx;
               _loc6_.scaleY = _loc5_.sy;
            }
            _loc6_.skewX = _loc5_.skx * 0.017453292519943295;
            _loc6_.skewY = _loc5_.sky * 0.017453292519943295;
            if(_loc5_.name)
            {
               _loc6_.name = _loc5_.name;
            }
            param2.addChild(_loc6_);
            _loc7_++;
         }
      }
      
      public function createSprite(param1:String) : Sprite
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Array = layoutsData[param1];
         var _loc4_:int = _loc3_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc7_];
            if(_loc5_.type == "sprite")
            {
               _loc6_ = createSprite(_loc5_.cname);
            }
            else if(_loc5_.type == "image")
            {
               _loc6_ = createImage(_loc5_.cname);
            }
            else if(_loc5_.type == "s9image")
            {
               _loc6_ = createS9Image(_loc5_.cname);
            }
            else if(_loc5_.type == "batch")
            {
               _loc6_ = createBatch(_loc5_.cname);
            }
            else if(_loc5_.type == "btn")
            {
               _loc6_ = createButton(_loc5_.cname);
            }
            else if(_loc5_.type == "text")
            {
               _loc6_ = createTextField(_loc5_);
            }
            _loc6_.x = _loc5_.x;
            _loc6_.y = _loc5_.y;
            if(_loc5_.type == "s9image")
            {
               _loc6_.width = _loc5_.w;
               _loc6_.height = _loc5_.h;
            }
            else
            {
               _loc6_.scaleX = _loc5_.sx;
               _loc6_.scaleY = _loc5_.sy;
            }
            _loc6_.skewX = _loc5_.skx * 0.017453292519943295;
            _loc6_.skewY = _loc5_.sky * 0.017453292519943295;
            if(_loc5_.name)
            {
               _loc6_.name = _loc5_.name;
            }
            _loc2_.addChild(_loc6_);
            _loc7_++;
         }
         return _loc2_;
      }
      
      public function createButton(param1:String) : Button
      {
         var _loc2_:Sprite = new Sprite();
         buildLayout(param1,_loc2_);
         return new Button(_loc2_);
      }
      
      public function createBatch(param1:String) : QuadBatch
      {
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc7_:* = 0;
         var _loc5_:QuadBatch = new QuadBatch();
         var _loc2_:Array = layoutsData[param1];
         var _loc3_:int = _loc2_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc3_)
         {
            _loc4_ = _loc2_[_loc7_];
            _loc6_ = createImage(_loc4_.cname);
            _loc6_.x = _loc4_.x;
            _loc6_.y = _loc4_.y;
            _loc6_.scaleX = _loc4_.sx;
            _loc6_.scaleY = _loc4_.sy;
            _loc6_.skewX = _loc4_.skx * 0.017453292519943295;
            _loc6_.skewY = _loc4_.sky * 0.017453292519943295;
            _loc5_.addImage(_loc6_);
            _loc7_++;
         }
         return _loc5_;
      }
      
      public function createImage(param1:String) : Image
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         try
         {
            _loc2_ = imagesData[param1];
            _loc3_ = asset.getTexture(param1);
            _loc4_ = new Image(_loc3_);
            _loc4_.pivotX = -_loc2_.x;
            _loc4_.pivotY = -_loc2_.y;
            var _loc6_:* = _loc4_;
            return _loc6_;
         }
         catch(error:Error)
         {
            LogUtil(param1);
         }
         return null;
      }
      
      public function createS9Image(param1:String) : Scale9Image
      {
         var _loc2_:Object = imagesData[param1];
         var _loc3_:Texture = asset.getTexture(param1);
         var _loc5_:Scale9Textures = new Scale9Textures(_loc3_,new Rectangle(_loc2_.s9gw,_loc2_.s9gw,1,1));
         var _loc4_:Scale9Image = new Scale9Image(_loc5_,asset.scaleFactor);
         return _loc4_;
      }
      
      public function createTextField(param1:Object) : TextField
      {
         var _loc2_:TextField = new TextField(param1.w,param1.h,param1.text,param1.font,param1.size,param1.color,param1.bold);
         _loc2_.italic = param1.italic;
         _loc2_.vAlign = "center";
         _loc2_.hAlign = param1.align;
         _loc2_.touchable = false;
         return _loc2_;
      }
      
      public function addLayout(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc3_:Object = param1["images"];
         var _loc2_:Object = param1["layout"];
         var _loc6_:* = 0;
         var _loc5_:* = _loc3_;
         for(_loc4_ in _loc3_)
         {
            this.imagesData[_loc4_] = _loc3_[_loc4_];
         }
         var _loc8_:* = 0;
         var _loc7_:* = _loc2_;
         for(_loc4_ in _loc2_)
         {
            this.layoutsData[_loc4_] = _loc2_[_loc4_];
         }
      }
   }
}
