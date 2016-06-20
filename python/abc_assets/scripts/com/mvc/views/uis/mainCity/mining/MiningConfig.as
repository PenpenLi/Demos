package com.mvc.views.uis.mainCity.mining
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.fighting.NPCVO;
   
   public class MiningConfig
   {
      
      public static const MININGMAINNAME:String = "复刻矿洞大门";
      
      public static const COINNAME1:String = "喵喵的小藏金库";
      
      public static const COINNAME2:String = "土狼犬的后花园";
      
      public static const COINNAME3:String = "猫老大的保险柜";
      
      public static const SWEETNAME1:String = "胖丁的零食铺";
      
      public static const SWEETNAME2:String = "伊布的糖果屋";
      
      public static const SWEETNAME3:String = "卡比的收藏室";
      
      public static const DOLLNAME1:String = "幸运蛋的饰品店";
      
      public static const DOLLNAME2:String = "毽子棉的手工坊";
      
      public static const DOLLNAME3:String = "海星星的玩偶城";
      
      public static var miningFightElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var miningNpcElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
       
      public function MiningConfig()
      {
         super();
      }
      
      public static function getName(param1:int = 0, param2:String = null) : String
      {
         if(param1 == 14400 && param2 == "1")
         {
            return "喵喵的小藏金库";
         }
         if(param1 == 28800 && param2 == "1")
         {
            return "土狼犬的后花园";
         }
         if(param1 == 43200 && param2 == "1")
         {
            return "猫老大的保险柜";
         }
         if(param1 == 14400 && param2 == "2")
         {
            return "胖丁的零食铺";
         }
         if(param1 == 28800 && param2 == "2")
         {
            return "伊布的糖果屋";
         }
         if(param1 == 43200 && param2 == "2")
         {
            return "卡比的收藏室";
         }
         if(param1 == 14400 && param2 == "3")
         {
            return "幸运蛋的饰品店";
         }
         if(param1 == 28800 && param2 == "3")
         {
            return "毽子棉的手工坊";
         }
         if(param1 == 43200 && param2 == "3")
         {
            return "海星星的玩偶城";
         }
         return "复刻矿洞大门";
      }
      
      public static function collectNpcElf(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         MiningConfig.miningNpcElfVec = Vector.<ElfVO>([]);
         var _loc2_:* = param1;
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            if(_loc2_[_loc3_] != null)
            {
               _loc4_ = GetElfFromSever.getElfInfo(_loc2_[_loc3_]);
               _loc4_.camp = "camp_of_computer";
               MiningConfig.miningNpcElfVec.push(_loc4_);
            }
            else
            {
               MiningConfig.miningNpcElfVec.push(null);
            }
            _loc3_++;
         }
      }
      
      public static function collectElfAfterFight(param1:Boolean = true) : Object
      {
         var _loc2_:* = null;
         var _loc8_:* = 0;
         var _loc3_:* = null;
         var _loc9_:* = 0;
         var _loc13_:* = null;
         var _loc5_:* = null;
         var _loc10_:* = 0;
         var _loc4_:* = null;
         var _loc6_:* = 0;
         var _loc12_:* = null;
         var _loc14_:Object = {};
         var _loc7_:Array = [];
         _loc8_ = 0;
         while(_loc8_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc8_] != null)
            {
               _loc2_ = {};
               _loc2_.id = PlayerVO.bagElfVec[_loc8_].id;
               _loc2_.hp = PlayerVO.bagElfVec[_loc8_].currentHp;
               _loc2_.exp = Math.round(PlayerVO.bagElfVec[_loc8_].currentExp);
               _loc2_.lv = PlayerVO.bagElfVec[_loc8_].lv;
               if(PlayerVO.bagElfVec[_loc8_].carryProp)
               {
                  _loc2_.cryPidAry = [PlayerVO.bagElfVec[_loc8_].carryProp.id];
               }
               else
               {
                  _loc2_.cryPidAry = [];
               }
               _loc2_.effAry = PlayerVO.bagElfVec[_loc8_].effAry;
               _loc3_ = [];
               _loc9_ = 0;
               while(_loc9_ < PlayerVO.bagElfVec[_loc8_].currentSkillVec.length)
               {
                  _loc13_ = {};
                  _loc13_.id = PlayerVO.bagElfVec[_loc8_].currentSkillVec[_loc9_].id;
                  _loc13_.pp = PlayerVO.bagElfVec[_loc8_].currentSkillVec[_loc9_].currentPP;
                  _loc3_.push(_loc13_);
                  _loc9_++;
               }
               _loc2_.skLst = _loc3_;
               if(param1)
               {
                  _loc2_.stateAry = PlayerVO.bagElfVec[_loc8_].status;
               }
               _loc7_.push(_loc2_);
               PlayerVO.bagElfVec[_loc8_].isHasFiging = false;
            }
            _loc8_++;
         }
         var _loc11_:Array = [];
         _loc10_ = 0;
         while(_loc10_ < NPCVO.bagElfVec.length)
         {
            _loc5_ = {};
            _loc5_.id = NPCVO.bagElfVec[_loc10_].id;
            _loc5_.hp = NPCVO.bagElfVec[_loc10_].currentHp;
            _loc5_.exp = Math.round(NPCVO.bagElfVec[_loc10_].currentExp);
            _loc5_.lv = NPCVO.bagElfVec[_loc10_].lv;
            if(NPCVO.bagElfVec[_loc10_].carryProp)
            {
               _loc5_.cryPidAry = [NPCVO.bagElfVec[_loc10_].carryProp.id];
            }
            else
            {
               _loc5_.cryPidAry = [];
            }
            _loc5_.effAry = NPCVO.bagElfVec[_loc10_].effAry;
            _loc4_ = [];
            _loc6_ = 0;
            while(_loc6_ < NPCVO.bagElfVec[_loc10_].currentSkillVec.length)
            {
               _loc12_ = {};
               _loc12_.id = NPCVO.bagElfVec[_loc10_].currentSkillVec[_loc6_].id;
               _loc12_.pp = NPCVO.bagElfVec[_loc10_].currentSkillVec[_loc6_].currentPP;
               _loc4_.push(_loc12_);
               _loc6_++;
            }
            _loc5_.skLst = _loc4_;
            if(param1)
            {
               _loc5_.stateAry = NPCVO.bagElfVec[_loc10_].status;
            }
            _loc11_.push(_loc5_);
            NPCVO.bagElfVec[_loc10_].isHasFiging = false;
            _loc10_++;
         }
         _loc14_.elfInfoArr = _loc7_;
         _loc14_.enemyArr = _loc11_;
         return _loc14_;
      }
      
      public static function collectSpiritIdArr(param1:Vector.<ElfVO>) : Array
      {
         var _loc2_:* = 0;
         var _loc3_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] != null)
            {
               _loc3_.push(param1[_loc2_].id);
            }
            _loc2_++;
         }
         return _loc3_;
      }
   }
}
