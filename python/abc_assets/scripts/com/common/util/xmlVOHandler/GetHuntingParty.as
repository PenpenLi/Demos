package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.huntingParty.HuntRewardVO;
   import com.mvc.models.vos.huntingParty.HuntNodeVO;
   import com.mvc.models.vos.huntingParty.BuffVO;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class GetHuntingParty
   {
      
      public static var rewardVec:Vector.<HuntRewardVO> = new Vector.<HuntRewardVO>([]);
      
      public static var nodeVec:Vector.<HuntNodeVO> = new Vector.<HuntNodeVO>([]);
      
      public static var buffVec:Vector.<BuffVO> = new Vector.<BuffVO>([]);
       
      public function GetHuntingParty()
      {
         super();
      }
      
      public static function GetHuntPartyReward() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc5_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_insectIntegral");
         var _loc7_:* = 0;
         var _loc6_:* = _loc5_.sta_insectIntegral;
         for each(var _loc4_ in _loc5_.sta_insectIntegral)
         {
            _loc1_ = new HuntRewardVO();
            _loc1_.rewardId = _loc4_.@id;
            _loc1_.needSorce = _loc4_.@interal;
            _loc2_ = _loc4_.@rewardJNS;
            _loc3_ = _loc2_.replace(new RegExp("\\\'|&apos;","g"),"\"");
            _loc1_.rewardObj = JSON.parse(_loc3_);
            rewardVec.push(_loc1_);
         }
      }
      
      public static function GetHuntPartyNode() : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_insectNode");
         var _loc6_:* = 0;
         var _loc5_:* = _loc4_.sta_insectNode;
         for each(var _loc1_ in _loc4_.sta_insectNode)
         {
            _loc2_ = new HuntNodeVO();
            _loc2_.id = _loc1_.@id;
            _loc2_.name = _loc1_.@name;
            _loc2_.type = _loc1_.@boss;
            _loc2_.scene = _loc1_.@background;
            _loc3_ = _loc1_.@attribute;
            _loc2_.elfPropertyArr = _loc3_.split("|");
            nodeVec.push(_loc2_);
         }
      }
      
      public static function getAllBuff() : void
      {
         var _loc1_:* = null;
         var _loc3_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_insectBuff");
         var _loc5_:* = 0;
         var _loc4_:* = _loc3_.sta_insectBuff;
         for each(var _loc2_ in _loc3_.sta_insectBuff)
         {
            _loc1_ = new BuffVO();
            _loc1_.id = _loc2_.@id;
            _loc1_.desc = _loc2_.@descr;
            _loc1_.type = _loc2_.@type;
            buffVec.push(_loc1_);
         }
      }
   }
}
