package com.common.util.xmlVOHandler
{
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.display.DisplayObjectContainer;
   import com.mvc.views.uis.union.unionMedal.MedalUnitUI;
   
   public class GetUnionMedal
   {
      
      private static var unionMedalExp:Array = [];
      
      public static var medalNameArr:Array = [];
      
      public static var medalLvArr:Array = [];
      
      public static var medalLvRewardArr:Array = [];
       
      public function GetUnionMedal()
      {
         super();
      }
      
      public static function getAllInfo() : void
      {
         var _loc1_:* = null;
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc4_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_guildTitle");
         var _loc8_:* = 0;
         var _loc7_:* = _loc4_.sta_guildTitle;
         for each(var _loc6_ in _loc4_.sta_guildTitle)
         {
            unionMedalExp.push(_loc6_.@titleExp);
            if(medalNameArr.indexOf(_loc6_.@name) == -1)
            {
               medalNameArr.push(_loc6_.@name);
               if(_loc6_.@rewardJNS != "")
               {
                  _loc1_ = _loc6_.@rewardJNS;
                  _loc3_ = _loc1_.replace(new RegExp("\\\'|&apos;","g"),"\"");
                  _loc5_ = JSON.parse(_loc3_);
                  medalLvRewardArr.push(rewardHandle(_loc5_));
               }
               _loc2_ = [];
               _loc2_.push(_loc6_.@id);
               medalLvArr.push(_loc2_);
            }
            else
            {
               medalLvArr[medalLvArr.length - 1].push(_loc6_.@id);
            }
         }
         LoadOtherAssetsManager.getInstance().assets.removeXml("sta_guildTitle");
      }
      
      public static function GetMedalLvExp(param1:int) : Number
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0.0;
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            _loc3_ = _loc3_ + unionMedalExp[_loc2_];
            _loc2_++;
         }
         return _loc3_;
      }
      
      public static function getBigLv(param1:int) : int
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < medalLvArr.length)
         {
            if(medalLvArr[_loc2_].indexOf(param1) != -1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      private static function rewardHandle(param1:Object) : Array
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc2_:Array = [];
         if(param1.silver)
         {
            _loc2_.push("奖励金币×" + param1.silver.num);
         }
         if(param1.diamond)
         {
            _loc2_.push("奖励钻石×" + param1.diamond.num);
         }
         if(param1.prop)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.prop.length)
            {
               _loc3_ = GetPropFactor.getPropVO(param1.prop[_loc4_].pId);
               _loc3_.rewardCount = param1.prop[_loc4_].num;
               _loc2_.push(_loc3_);
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public static function getMedalIcon(param1:int, param2:int, param3:int, param4:DisplayObjectContainer, param5:int = 18, param6:Boolean = false, param7:Boolean = true) : void
      {
         var _loc8_:MedalUnitUI = new MedalUnitUI(param6,param7,param5);
         _loc8_.setLv = param3;
         _loc8_.x = param1;
         _loc8_.y = param2;
         param4.addChild(_loc8_);
      }
   }
}
