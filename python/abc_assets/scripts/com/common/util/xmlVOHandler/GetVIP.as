package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.mainCity.playerInfo.VIPInfoVO;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class GetVIP
   {
      
      private static var vipInfoVO:VIPInfoVO;
       
      public function GetVIP()
      {
         super();
      }
      
      public static function getVIP(param1:int) : VIPInfoVO
      {
         var _loc4_:* = 0;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_vip");
         var _loc5_:XML = _loc2_.sta_vip[param1] as XML;
         var _loc3_:int = (_loc2_.sta_vip as XMLList).length();
         vipInfoVO = new VIPInfoVO();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            vipInfoVO.diamondVec.push(_loc2_.sta_vip[_loc4_].@diamond);
            if(_loc2_.sta_vip[_loc4_].@id == param1)
            {
               vipInfoVO.vipLv = _loc5_.attribute("vipLv");
               vipInfoVO.sweep = _loc5_.attribute("sweep");
               vipInfoVO.buyAcFr = _loc5_.attribute("buyAcFr");
               vipInfoVO.goldFinger = _loc5_.attribute("goldFinger");
               vipInfoVO.alliance = _loc5_.attribute("alliance");
               vipInfoVO.kingRoad = _loc5_.attribute("kingRoad");
               vipInfoVO.pmCenter = _loc5_.attribute("pmCenter");
               vipInfoVO.flash = _loc5_.attribute("flash");
               vipInfoVO.friendLimit = _loc5_.attribute("friendLimit");
               vipInfoVO.locked = _loc5_.attribute("locked");
               vipInfoVO.acFrVec = calculateAcFr();
               vipInfoVO.remainAlliance = vipInfoVO.alliance;
               vipInfoVO.remainBuyAcFr = vipInfoVO.buyAcFr;
               vipInfoVO.remainGoldFinger = vipInfoVO.goldFinger;
               vipInfoVO.remainKingRoad = vipInfoVO.kingRoad;
               vipInfoVO.remainPmCenter = vipInfoVO.pmCenter;
            }
            _loc4_++;
         }
         _loc2_ = null;
         _loc5_ = null;
         return vipInfoVO;
      }
      
      public static function calculateAcFr() : Vector.<int>
      {
         var _loc1_:* = 0;
         var _loc2_:Vector.<int> = new Vector.<int>(vipInfoVO.buyAcFr + 1);
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            if(_loc1_ < 2)
            {
               _loc2_[_loc1_] = 50;
            }
            if(_loc1_ >= 2 && _loc1_ < 6)
            {
               _loc2_[_loc1_] = 100;
            }
            if(_loc1_ >= 6 && _loc1_ < 10)
            {
               _loc2_[_loc1_] = 200;
            }
            if(_loc1_ >= 10)
            {
               _loc2_[_loc1_] = 300;
            }
            _loc1_++;
         }
         return _loc2_;
      }
   }
}
