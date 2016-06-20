package com.common.util.xmlVOHandler
{
   import com.common.managers.LoadOtherAssetsManager;
   
   public class GetVIPLvInfo
   {
       
      public function GetVIPLvInfo()
      {
         super();
      }
      
      public static function getVIPLvInfo() : Vector.<String>
      {
         var _loc4_:* = 0;
         var _loc5_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_vipLvInfo");
         var _loc1_:XMLList = _loc5_.sta_vipLvInfo;
         var _loc2_:int = _loc1_.length();
         var _loc3_:Vector.<String> = new Vector.<String>(0);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(_loc1_[_loc4_].attribute("lvInfo"));
            _loc4_++;
         }
         _loc5_ = null;
         _loc1_ = null;
         return _loc3_;
      }
   }
}
