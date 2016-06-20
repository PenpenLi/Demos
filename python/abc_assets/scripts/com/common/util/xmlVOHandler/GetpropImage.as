package com.common.util.xmlVOHandler
{
   import lzm.starling.swf.Swf;
   import starling.display.Sprite;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.ELFMinImageManager;
   import starling.display.Image;
   import starling.display.DisplayObject;
   
   public class GetpropImage
   {
      
      private static var swf:Swf;
      
      private static var npcMinSwf:Swf;
       
      public function GetpropImage()
      {
         super();
      }
      
      public static function getPropSpr(param1:PropVO, param2:Boolean = true, param3:Number = 1) : Sprite
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         npcMinSwf = LoadSwfAssetsManager.getInstance().assets.getSwf("npcMin");
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("prop");
         var _loc4_:Sprite = new Sprite();
         if(param1.type == 25 && param1.name.search("狩猎") == -1)
         {
            _loc5_ = ELFMinImageManager.getElfM(param1.imgName);
            _loc4_.addChild(_loc5_);
            _loc6_ = swf.createImage("img_hornIcon");
            _loc6_.x = _loc5_.width - _loc6_.width;
            _loc6_.y = _loc5_.height - _loc6_.height - 5;
            _loc4_.addChild(_loc6_);
            var _loc7_:* = param3;
            _loc4_.scaleY = _loc7_;
            _loc4_.scaleX = _loc7_;
            return _loc4_;
         }
         if(swf.hasImage(param1.imgName))
         {
            _loc5_ = swf.createImage(param1.imgName);
         }
         if(npcMinSwf.hasImage(param1.imgName))
         {
            _loc5_ = npcMinSwf.createImage(param1.imgName);
         }
         if(!_loc5_)
         {
            _loc5_ = swf.createImage("img_xin1xian1shui3");
         }
         if(param1.type == 10 || param1.type == 11 || param1.type == 12 || param1.type == 13 || param1.type == 22 || param1.type == 26)
         {
            if(param2)
            {
               _loc4_.addChild(npcMinSwf.createImage("img_broken" + param1.quality));
               _loc5_.x = _loc4_.width - _loc5_.width >> 1;
               _loc5_.y = _loc4_.height - _loc5_.height >> 1;
            }
            _loc4_.addChild(_loc5_);
            _loc4_.addChild(swf.createImage("img_brokenIcon"));
         }
         else
         {
            if(param2)
            {
               _loc4_.addChild(npcMinSwf.createImage("img_quality" + param1.quality));
               _loc5_.x = _loc4_.width - _loc5_.width >> 1;
               _loc5_.y = _loc4_.height - _loc5_.height >> 1;
            }
            _loc4_.addChild(_loc5_);
         }
         _loc7_ = param3;
         _loc4_.scaleY = _loc7_;
         _loc4_.scaleX = _loc7_;
         return _loc4_;
      }
      
      public static function getOtherSpr(param1:String, param2:Number = 1) : Sprite
      {
         npcMinSwf = LoadSwfAssetsManager.getInstance().assets.getSwf("npcMin");
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Image = npcMinSwf.createImage(param1);
         _loc3_.addChild(npcMinSwf.createImage("img_quality1"));
         _loc4_.x = _loc3_.width - _loc4_.width >> 1;
         _loc4_.y = _loc3_.height - _loc4_.height >> 1;
         _loc3_.addChild(_loc4_);
         return _loc3_;
      }
      
      public static function clean(param1:DisplayObject) : void
      {
         if(param1)
         {
            param1.removeFromParent(true);
            var param1:DisplayObject = null;
         }
      }
   }
}
