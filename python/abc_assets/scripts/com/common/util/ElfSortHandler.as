package com.common.util
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class ElfSortHandler
   {
      
      public static function sortLvIncrease(param1:ElfVO, param2:ElfVO):int
      {
         if(param1.lv < param2.lv)
         {
            return -1;
         }
         if(param1.lv > param2.lv)
         {
            return 1;
         }
         return 0;
      }
      public static function sortLvDecrease(param1:ElfVO, param2:ElfVO):int
      {
         if(param1.lv > param2.lv)
         {
            return -1;
         }
         if(param1.lv < param2.lv)
         {
            return 1;
         }
         return 0;
      }
      public static function sortRareDecrease(param1:ElfVO, param2:ElfVO):int
      {
         if(param1.rareValue > param2.rareValue)
         {
            return -1;
         }
         if(param1.rareValue < param2.rareValue)
         {
            return 1;
         }
         return 0;
      } 
      public function ElfSortHandler()
      {
         super();
      }
      
      public static function getPlayerELF(param1:Boolean = false, param2:Boolean = true, param3:Boolean = true) : Vector.<ElfVO>
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         if(param1)
         {
            _loc4_ = 0;
            while(_loc4_ < PlayerVO.bagElfVec.length)
            {
               if(PlayerVO.bagElfVec[_loc4_] != null)
               {
                  _loc6_.push(PlayerVO.bagElfVec[_loc4_]);
               }
               _loc4_++;
            }
         }
         _loc5_ = 0;
         while(_loc5_ < PlayerVO.comElfVec.length)
         {
            if(param3)
            {
               if(PlayerVO.comElfVec[_loc5_].rare == "稀有" || PlayerVO.comElfVec[_loc5_].rare == "史诗" || PlayerVO.comElfVec[_loc5_].rare == "传说")
               {
                  _loc6_.push(PlayerVO.comElfVec[_loc5_]);
               }
            }
            else
            {
               _loc6_.push(PlayerVO.comElfVec[_loc5_]);
            }
            _loc5_++;
         }
         if(param2)
         {
            return removeElfVec(_loc6_);
         }
         return _loc6_;
      }
      
      private static function removeElfVec(param1:Vector.<ElfVO>) : Vector.<ElfVO>
      {
         var _loc8_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         var _loc7_:* = 0;
         var _loc3_:* = 0;
         var _loc9_:* = 0;
         var _loc5_:* = 0;
         var _loc10_:* = 0;
         var _loc6_:* = 0;
         _loc8_ = 0;
         while(_loc8_ < PlayerVO.trainElfArr.length)
         {
            if(PlayerVO.trainElfArr[_loc8_])
            {
               _loc4_ = param1.length - 1;
               while(_loc4_ >= 0)
               {
                  if(PlayerVO.trainElfArr[_loc8_] == param1[_loc4_].id)
                  {
                     param1.splice(_loc4_,1);
                     break;
                  }
                  _loc4_--;
               }
            }
            _loc8_++;
         }
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.feedElfVec.length)
         {
            if(PlayerVO.feedElfVec[_loc2_])
            {
               _loc7_ = param1.length - 1;
               while(_loc7_ >= 0)
               {
                  if(PlayerVO.feedElfVec[_loc2_].id == param1[_loc7_].id)
                  {
                     param1.splice(_loc7_,1);
                     break;
                  }
                  _loc7_--;
               }
            }
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < PlayerVO.FormationElfVec.length)
         {
            if(PlayerVO.FormationElfVec[_loc3_])
            {
               _loc9_ = param1.length - 1;
               while(_loc9_ >= 0)
               {
                  if(PlayerVO.FormationElfVec[_loc3_].id == param1[_loc9_].id)
                  {
                     param1.splice(_loc9_,1);
                     break;
                  }
                  _loc9_--;
               }
            }
            _loc3_++;
         }
         _loc5_ = 0;
         while(_loc5_ < PlayerVO.miningDefendElfArr.length)
         {
            if(PlayerVO.miningDefendElfArr[_loc5_])
            {
               _loc10_ = param1.length - 1;
               while(_loc10_ >= 0)
               {
                  if(PlayerVO.miningDefendElfArr[_loc5_] == param1[_loc10_].id)
                  {
                     param1.splice(_loc10_,1);
                     break;
                  }
                  _loc10_--;
               }
            }
            _loc5_++;
         }
         _loc6_ = param1.length - 1;
         while(_loc6_ >= 0)
         {
            if(param1[_loc6_].isLock)
            {
               param1.splice(_loc6_,1);
            }
            _loc6_--;
         }
         return param1;
      }
      
      public static function getElfVecByRarity(param1:Vector.<ElfVO>, param2:String = "全稀有度") : Vector.<ElfVO>
      {
         var _loc4_:* = 0;
         if(param2 == "全稀有度")
         {
            return param1;
         }
         var _loc3_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].rare == param2)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_.sort(sortLvIncrease);
      }
   }
}
