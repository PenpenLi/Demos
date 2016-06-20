package com.common.util.fighting
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.themes.Tips;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   
   public class GotoChallenge
   {
      
      private static var preBagElfVec:Vector.<ElfVO>;
       
      public function GotoChallenge()
      {
         super();
      }
      
      public static function gotoChallenge(param1:String, param2:String, param3:Vector.<ElfVO>, param4:Boolean, param5:String = null, param6:int = 0, param7:Boolean = false) : void
      {
         NPCVO.useId = param5;
         NPCVO.name = param1;
         NPCVO.imageName = param2;
         NPCVO.isSpecial = param4;
         NPCVO.dialougBeforeFighting = [];
         NPCVO.dialougAfterFighting = [];
         if(param6 == 0)
         {
            getElfVec(cleanState(param3),true,param7);
         }
         else if(param6 == 1)
         {
            if(!PlayerVO.kingIsOpen)
            {
               cleanState(PlayerVO.bagElfVec);
            }
            getElfVec(param3,false,param7);
         }
         else if(param6 == 100)
         {
            FightingLogicFactor.isPVP = true;
            getElfVec(cleanState(param3),false,param7);
         }
         else if(param6 == 200)
         {
            getElfVec(param3,true,param7);
         }
         else
         {
            LogUtil("NPCVO=",NPCVO.bagElfVec);
            getElfVec(param3,false,param7);
         }
         LogUtil("NPCVO===",NPCVO.bagElfVec);
         FightingConfig.computerElfVO = null;
         LogUtil("NPCVO====",NPCVO.bagElfVec);
         if(NPCVO.bagElfVec.length == 0)
         {
            FightingConfig.reGetBagElf();
            if(param6 <= 15 && param6 > 0)
            {
               Tips.show("亲爱的玩家十分抱歉，由于游戏出现异常，请重置王者之路");
            }
            else
            {
               Tips.show("亲爱的玩家十分抱歉，游戏数据出现异常, 错误代码:" + param6);
            }
            return;
         }
         FightingConfig.computerElfVO = NPCVO.bagElfVec[0];
         Facade.getInstance().sendNotification("switch_page","load_fighting_page");
      }
      
      private static function getElfVec(param1:Vector.<ElfVO>, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:* = 0;
         NPCVO.bagElfVec = Vector.<ElfVO>([]);
         LogUtil(param1,param3,"==NPCVO.bagElfVec.length");
         if(param3)
         {
            preBagElfVec = PlayerVO.bagElfVec;
            PlayerVO.bagElfVec = copyElf(PlayerVO.bagElfVec);
         }
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_] != null && param1[_loc4_].currentHp != 0)
            {
               if(param2)
               {
                  if(Math.random() * 10 % 2 == 0)
                  {
                     NPCVO.bagElfVec.push(param1[_loc4_]);
                  }
                  else
                  {
                     NPCVO.bagElfVec.unshift(param1[_loc4_]);
                  }
               }
               else
               {
                  NPCVO.bagElfVec.push(param1[_loc4_]);
               }
            }
            _loc4_++;
         }
      }
      
      private static function copyElf(param1:Vector.<ElfVO>) : Vector.<ElfVO>
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc5_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] != null)
            {
               LogUtil("复制精灵 ---- ");
               _loc3_ = GetElfFromSever.copyElf(param1[_loc2_]);
               _loc5_.push(_loc3_);
               _loc5_[_loc2_].status = [];
               _loc5_[_loc2_].currentHp = _loc5_[_loc2_].totalHp;
               _loc4_ = 0;
               while(_loc4_ < _loc5_[_loc2_].currentSkillVec.length)
               {
                  _loc5_[_loc2_].currentSkillVec[_loc4_].currentPP = _loc5_[_loc2_].currentSkillVec[_loc4_].totalPP;
                  _loc4_++;
               }
            }
            else
            {
               _loc5_.push(null);
            }
            _loc2_++;
         }
         return _loc5_;
      }
      
      public static function cleanState(param1:Vector.<ElfVO>) : Vector.<ElfVO>
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] != null)
            {
               param1[_loc2_].status = [];
               param1[_loc2_].currentHp = param1[_loc2_].totalHp;
               _loc3_ = 0;
               while(_loc3_ < param1[_loc2_].currentSkillVec.length)
               {
                  param1[_loc2_].currentSkillVec[_loc3_].currentPP = param1[_loc2_].currentSkillVec[_loc3_].totalPP;
                  _loc3_++;
               }
            }
            _loc2_++;
         }
         return param1;
      }
      
      private static function selectCurrentSkillVec(param1:ElfVO, param2:Boolean = false) : void
      {
         var _loc3_:* = 0;
         if(!param2)
         {
            while(param1.currentSkillVec.length > 4)
            {
               _loc3_ = Math.random() * param1.currentSkillVec.length;
               param1.currentSkillVec.splice(_loc3_,1);
            }
         }
         else
         {
            while(param1.currentSkillVec.length > 4)
            {
               param1.currentSkillVec.splice(0,1);
            }
         }
      }
      
      public static function updateBagElfVecAfterPVP() : void
      {
         var _loc1_:* = 0;
         if(preBagElfVec == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               preBagElfVec[_loc1_].carryProp = PlayerVO.bagElfVec[_loc1_].carryProp;
               preBagElfVec[_loc1_].hagberryProp = PlayerVO.bagElfVec[_loc1_].hagberryProp;
               PlayerVO.bagElfVec[_loc1_] = preBagElfVec[_loc1_];
            }
            _loc1_++;
         }
         preBagElfVec = Vector.<ElfVO>([]);
         preBagElfVec = null;
      }
   }
}
