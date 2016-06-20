package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.mainCity.playerInfo.DiamondGiftItemVO;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class GetRechargeInfo
   {
      
      public static function sortWeightIncrease(param1:DiamondGiftItemVO, param2:DiamondGiftItemVO):int
      {
         if(param1.weight < param2.weight)
         {
            return -1;
         }
         if(param1.weight > param2.weight)
         {
            return 1;
         }
         return 0;
      } 
      public function GetRechargeInfo()
      {
         super();
      }
      
      public static function getRechargeInfo() : Vector.<DiamondGiftItemVO>
      {
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc1_:Vector.<DiamondGiftItemVO> = new Vector.<DiamondGiftItemVO>([]);
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         var _loc3_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_rechargeInfo");
         var _loc4_:int = (_loc3_.sta_rechargeInfo as XMLList).length();
         _loc5_ = _loc4_ - 1;
         while(_loc5_ >= 0)
         {
            _loc6_ = new DiamondGiftItemVO();
            _loc6_.id = _loc3_.sta_rechargeInfo[_loc5_].@id;
            _loc6_.rechargeExplain = _loc3_.sta_rechargeInfo[_loc5_].@rechargeExplain;
            _loc6_.picture = _loc2_.createImage("img_" + _loc3_.sta_rechargeInfo[_loc5_].@picture);
            _loc6_.rmb = _loc3_.sta_rechargeInfo[_loc5_].@rmb;
            _loc6_.title = _loc3_.sta_rechargeInfo[_loc5_].@title;
            _loc6_.rechargeExplain = _loc3_.sta_rechargeInfo[_loc5_].@rechargeExplain;
            _loc6_.recommend = _loc3_.sta_rechargeInfo[_loc5_].@recommend;
            _loc6_.getDiamond = _loc3_.sta_rechargeInfo[_loc5_].@diamond;
            _loc6_.present = _loc3_.sta_rechargeInfo[_loc5_].@present;
            _loc6_.weight = _loc3_.sta_rechargeInfo[_loc5_].@weight;
            if(_loc3_.sta_rechargeInfo[_loc5_].@times > 0)
            {
               _loc6_.isLimit = true;
               _loc6_.limit = _loc3_.sta_rechargeInfo[_loc5_].@times;
            }
            _loc1_.push(_loc6_);
            _loc5_--;
         }
         _loc2_ = null;
         _loc3_ = null;
         return _loc1_.sort(GetRechargeInfo.sortWeightIncrease);
      }
   }
}
