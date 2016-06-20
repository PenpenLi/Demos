package com.common.util.xmlVOHandler
{
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import com.common.managers.ELFMinImageManager;
   
   public class GetPlayerRelatedPicFactor
   {
      
      public static const FORMPICNAME:String = "formPicName";
      
      public static const PICNAME:String = "picName";
      
      public static const BADGEBLACKNAME:String = "badgeBlackName";
      
      public static const BADGENAME:String = "badgeName";
       
      public function GetPlayerRelatedPicFactor()
      {
         super();
      }
      
      public static function getHeadPic(param1:int, param2:Number = 1, param3:Boolean = true) : Image
      {
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         if(param1 > 100000)
         {
            var param1:int = param1 - 100000;
            _loc4_ = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
            if(param3)
            {
               _loc5_ = "img_formHeadPic" + param1;
            }
            else
            {
               _loc5_ = "img_headPic" + param1;
            }
            _loc6_ = _loc4_.createImage(_loc5_);
            var _loc7_:* = param2;
            _loc6_.scaleY = _loc7_;
            _loc6_.scaleX = _loc7_;
            _loc4_ = null;
         }
         else
         {
            _loc6_ = ELFMinImageManager.getElfM(GetElfFactor.getElfVO(param1,false).imgName,param2);
         }
         return _loc6_;
      }
      
      public static function getBadgePic(param1:int, param2:Number = 1, param3:Boolean = true) : Image
      {
         var _loc6_:* = null;
         var _loc4_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         if(param3)
         {
            _loc6_ = "img_badgeBlack" + param1;
         }
         else
         {
            _loc6_ = "img_badge" + param1;
         }
         var _loc5_:Image = _loc4_.createImage(_loc6_);
         var _loc7_:* = param2;
         _loc5_.scaleY = _loc7_;
         _loc5_.scaleX = _loc7_;
         _loc4_ = null;
         return _loc5_;
      }
   }
}
