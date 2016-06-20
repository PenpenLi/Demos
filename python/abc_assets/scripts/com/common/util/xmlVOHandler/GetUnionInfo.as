package com.common.util.xmlVOHandler
{
   import com.common.managers.LoadOtherAssetsManager;
   
   public class GetUnionInfo
   {
      
      public static var studyDecArr:Array = [["公会的基础建造，象征\n着公会的等级和身份。\n会长和副会长可以在此\n管理会员 ","升级科技可以增加公会\n人数上限 "],["训练所使提供公会会员\n之间互相为对方加速训\n练的场所 ","升级科技能够增加训练\n的效率和帮助他人的报\n酬 "],["公会会员可以通过战斗\n基地强化自身精灵的属\n性 ","升级科技可以有效提升\n精灵在战斗中的属性 "]];
      
      public static var trainDecArr:Array = ["加速训练时，给\n他人增加的经验\n提高","加速训练时，自\n己获得的金币\n增加"];
      
      public static var hallDecArr:Array = ["公会人数上限\n增加"];
      
      public static var seriesDecArr:Array = ["精灵物攻、特攻\n增加","精灵物防、特防\n增加"];
      
      public static var trainTitleArr:Array = ["经验加成","金币滚滚"];
      
      public static var hallTitleArr:Array = ["人员增加"];
      
      public static var seriesTitleArr:Array = ["远古之力","精灵守护"];
      
      public static var trainIconArr:Array = ["img_addExp","img_addSilver"];
      
      public static var hallIconArr:Array = ["img_addPeople"];
      
      public static var seriesIconArr:Array = ["img_addAttack","img_addDefense"];
      
      public static var hallTypeArr:Array = [10];
      
      public static var trainTypeArr:Array = [20,21];
      
      public static var seriesTypeArr:Array = [30,31];
      
      public static var unionExp:Array = [];
      
      public static var addExp:Array = [];
      
      public static var addPeopleExp:Array = [];
      
      public static var addSilverExp:Array = [];
      
      public static var addAttackExp:Array = [];
      
      public static var addDefenseExp:Array = [];
       
      public function GetUnionInfo()
      {
         super();
      }
      
      private static function getAllExp() : void
      {
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_guildLv");
         var _loc4_:* = 0;
         var _loc3_:* = _loc1_.sta_guildLv;
         for each(var _loc2_ in _loc1_.sta_guildLv)
         {
            unionExp.push(_loc2_.@guildLv);
            LogUtil("unionExp",unionExp.length);
            addPeopleExp.push(_loc2_.@scienceLv);
            addExp.push(_loc2_.@expLv);
            addSilverExp.push(_loc2_.@goldLv);
            addAttackExp.push(_loc2_.@attackLv);
            addDefenseExp.push(_loc2_.@defenseLv);
         }
      }
      
      public static function GetUnionLvExp(param1:int) : Number
      {
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_guildLv");
         if(unionExp.length == 0)
         {
            getAllExp();
         }
         var _loc5_:* = 0;
         var _loc4_:* = _loc2_.sta_guildLv;
         for each(var _loc3_ in _loc2_.sta_guildLv)
         {
            if(_loc3_.@id == param1)
            {
               return calculatorExp(param1,unionExp);
            }
         }
         return 0;
      }
      
      public static function GetMarkUpExp(param1:int, param2:int) : Number
      {
         var _loc3_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_guildLv");
         if(addPeopleExp.length == 0)
         {
            getAllExp();
         }
         var _loc4_:* = param2;
         if(10 !== _loc4_)
         {
            if(20 !== _loc4_)
            {
               if(21 !== _loc4_)
               {
                  if(30 !== _loc4_)
                  {
                     if(31 !== _loc4_)
                     {
                        return 0;
                     }
                     return calculatorExp(param1,addDefenseExp);
                  }
                  return calculatorExp(param1,addAttackExp);
               }
               return calculatorExp(param1,addSilverExp);
            }
            return calculatorExp(param1,addExp);
         }
         return calculatorExp(param1,addPeopleExp);
      }
      
      private static function calculatorExp(param1:int, param2:Array) : Number
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0.0;
         _loc3_ = 0;
         while(_loc3_ < param1)
         {
            _loc4_ = _loc4_ + param2[_loc3_];
            _loc3_++;
         }
         return _loc4_;
      }
   }
}
