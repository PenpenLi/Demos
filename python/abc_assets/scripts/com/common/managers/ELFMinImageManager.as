package com.common.managers
{
   import starling.display.Image;
   import lzm.starling.swf.Swf;
   
   public class ELFMinImageManager
   {
       
      public function ELFMinImageManager()
      {
         super();
      }
      
      public static function getElfM(param1:String, param2:Number = 1) : Image
      {
         var _loc3_:* = null;
         var _loc4_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elf_m");
         var _loc5_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elf_m2");
         var _loc6_:String = param1 + "_m";
         if(_loc4_.hasImage(_loc6_))
         {
            _loc3_ = _loc4_.createImage(_loc6_);
         }
         else if(_loc5_.hasImage(_loc6_))
         {
            _loc3_ = _loc5_.createImage(_loc6_);
         }
         else
         {
            _loc3_ = _loc4_.createImage("img_lv4mao2chong2_m");
         }
         var _loc7_:* = param2 * 1 / 0.9;
         _loc3_.scaleY = _loc7_;
         _loc3_.scaleX = _loc7_;
         _loc4_ = null;
         _loc5_ = null;
         return _loc3_;
      }
   }
}
