package com.mvc.views.mediator.fighting
{
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.fighting.FightingConfig;
   
   public class PVPHandler
   {
       
      public function PVPHandler()
      {
         super();
      }
      
      public static function PVPHandlerBeforeStart(param1:SkillVO, param2:ElfVO, param3:ElfVO) : void
      {
         if(param1 == null)
         {
            var param1:SkillVO = GetElfFactor.getSkillById(165);
         }
         isPalsyHandler(param2);
         isMull(param2);
         setAttackNum(param1);
         randomNum();
         isProtectNoDie(param3);
         hurtNum(param1,param2);
         effectForOther(param1,param3);
         attackAddEffectHandler(param1);
         getStatus(param1,param2);
         clearStatus(param2);
         continueSkillHandler(param1);
         leadSkillHandler(param1,param2,param3);
         talkingSleepHandler(param1,param2,param3);
         isTriggerSpeedProp(param2,param3);
      }
      
      private static function isTriggerSpeedProp(param1:ElfVO, param2:ElfVO) : void
      {
         FightingConfig.selfOrder.isFristAttack = 0;
         if(param1.carryProp && param1.carryProp.name == "先攻之爪" && param1.status.indexOf(39) == -1)
         {
            if(param2.carryProp == null || param2.carryProp.name != "先攻之爪")
            {
               if(Math.random() * 100 < 18.75)
               {
                  FightingConfig.selfOrder.isFristAttack = 1;
                  return;
               }
            }
         }
      }
      
      private static function talkingSleepHandler(param1:SkillVO, param2:ElfVO, param3:ElfVO) : void
      {
         var _loc5_:* = 0;
         var _loc4_:* = null;
         if(param1.name == "梦话")
         {
            _loc5_ = Math.random() * param2.currentSkillVec.length;
            while(_loc5_ == param2.currentSkillVec.indexOf(param1))
            {
               _loc5_ = Math.random() * param2.currentSkillVec.length;
            }
            FightingConfig.selfOrder.talkSleepUseIndex = _loc5_;
            _loc4_ = param2.currentSkillVec[_loc5_];
            if(_loc4_.name == "睡觉")
            {
               return;
            }
            if(_loc4_.id == 91 || _loc4_.id == 19 || _loc4_.id == 13 || _loc4_.id == 143 || _loc4_.id == 76 || _loc4_.id == 130 || _loc4_.id == 117 || _loc4_.id == 119 || _loc4_.id == 118)
            {
               return;
            }
            setAttackNum(param1);
            getStatus(_loc4_,param2);
            effectForOther(_loc4_,param3);
            attackAddEffectHandler(_loc4_);
            continueSkillHandler(_loc4_);
         }
      }
      
      private static function isProtectNoDie(param1:ElfVO) : void
      {
         if(param1.carryProp && param1.carryProp.name == "振奋精神的头布" && param1.status.indexOf(39) == -1)
         {
            if(Math.random() * 100 < 10)
            {
               FightingConfig.selfOrder.isProtectNoDie = 1;
            }
         }
      }
      
      private static function continueSkillHandler(param1:SkillVO) : void
      {
         var _loc2_:* = 0;
         if(param1 != null && (param1.name == "花之舞" || param1.name == "横冲直撞" || param1.name == "龙鳞之怒" || param1.name == "滚动" || param1.id == 301 || param1.id == 253))
         {
            _loc2_ = Math.round(Math.random() * 1 + 2);
            if(param1.name == "滚动" || param1.id == 301)
            {
               _loc2_ = 5;
            }
            if(param1.id == 253)
            {
               _loc2_ = 3;
            }
            FightingConfig.selfOrder.attackRoundNum = _loc2_;
         }
      }
      
      private static function setAttackNum(param1:SkillVO) : void
      {
         if(param1.attackNum.length == 1)
         {
            FightingConfig.selfOrder.attackNum = param1.attackNum[0];
         }
         else
         {
            FightingConfig.selfOrder.attackNum = Math.round(Math.random() * (param1.attackNum[1] - param1.attackNum[0]) + param1.attackNum[0]);
         }
      }
      
      private static function clearStatus(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         if(param1.status.indexOf(8) != -1)
         {
            if(param1.boundCount > Math.round(Math.random() * 1) + 5)
            {
               FightingConfig.selfOrder.clearStatus.push(8);
            }
         }
         if(param1.status.indexOf(7) != -1)
         {
            _loc2_ = Math.round(Math.random() * 3) + 1;
            if(param1.mullCount > _loc2_ - 1)
            {
               FightingConfig.selfOrder.clearStatus.push(7);
            }
         }
         if(param1.status.indexOf(6) != -1)
         {
            if(param1.sleepCount > Math.round(Math.random() * 2) + 1)
            {
               FightingConfig.selfOrder.clearStatus.push(6);
            }
         }
         if(param1.status.indexOf(2) != -1)
         {
            if(Math.random() * 4 < 1)
            {
               FightingConfig.selfOrder.clearStatus.push(2);
            }
         }
      }
      
      private static function getStatus(param1:SkillVO, param2:ElfVO) : void
      {
         var _loc3_:* = 0;
         if(param1.name == "三角攻击")
         {
            _loc3_ = Math.round(Math.random() * 2 + 1);
            FightingConfig.selfOrder.randomStatus = _loc3_;
         }
         if(param2.carryProp && param2.carryProp.name == "王者之证" && param2.status.indexOf(39) == -1)
         {
            if(param1.sort == "格斗" && param1.status[0] == 0)
            {
               if(Math.random() * 100 < 10)
               {
                  FightingConfig.selfOrder.isStatusHandler = 1;
               }
            }
         }
         if(Math.random() * 100 < param1.status[1])
         {
            FightingConfig.selfOrder.isStatusHandler = 1;
         }
      }
      
      private static function effectForOther(param1:SkillVO, param2:ElfVO) : void
      {
         LogUtil(param1.effectForOther[0] + "：负面效果百分比：" + param1.effectForOther[2]);
         if(Math.random() * 100 < param1.effectForOther[2])
         {
            if(param1.effectForOther[0] == 1 && param2.ablilityAddLv[3] > -6)
            {
               FightingConfig.selfOrder.isHasEffect = 1;
            }
            else if(param1.effectForOther[0] == 2 && param2.ablilityAddLv[4] > -6)
            {
               FightingConfig.selfOrder.isHasEffect = 1;
            }
            else if(param1.effectForOther[0] == 3 && param2.ablilityAddLv[0] > -6)
            {
               FightingConfig.selfOrder.isHasEffect = 1;
            }
            else if(param1.effectForOther[0] == 4 && param2.ablilityAddLv[5] > -6)
            {
               FightingConfig.selfOrder.isHasEffect = 1;
            }
            else if(param1.effectForOther[0] == 5 && param2.ablilityAddLv[1] > -6)
            {
               FightingConfig.selfOrder.isHasEffect = 1;
            }
            else if(param1.effectForOther[0] == 7 && param2.ablilityAddLv[6] > -6)
            {
               FightingConfig.selfOrder.isHasEffect = 1;
            }
         }
      }
      
      private static function attackAddEffectHandler(param1:SkillVO) : void
      {
         if(param1.effectForOther[0] == 1)
         {
            if(Math.random() * 10 < 1)
            {
               FightingConfig.selfOrder.isHasEffect = 1;
            }
         }
         else if(param1.effectForOther[0] == 2)
         {
            if(Math.random() * 10 < 1)
            {
               FightingConfig.selfOrder.isHasEffect = 1;
            }
         }
         else if(param1.effectForOther[0] == 3)
         {
            if(Math.random() * 10 < 1)
            {
               FightingConfig.selfOrder.isHasEffect = 1;
            }
         }
         if((param1.effectForAblilityLv[0] as Array).length > 0)
         {
            if(Math.random() * 100 < param1.effectForAblilityLv[2])
            {
               FightingConfig.selfOrder.isHasEffect = 1;
            }
         }
      }
      
      private static function hurtNum(param1:SkillVO, param2:ElfVO) : void
      {
         if(CalculatorFactor.isFocusHitHandler(param2,param1))
         {
            FightingConfig.selfOrder.isFocusHit = 1;
         }
         else
         {
            FightingConfig.selfOrder.isFocusHit = 0;
         }
         FightingConfig.selfOrder.randomNum = (Math.random() * 0.25 + 0.85).toFixed(10);
      }
      
      private static function leadSkillHandler(param1:SkillVO, param2:ElfVO, param3:ElfVO) : void
      {
         var _loc4_:* = 0;
         var _loc9_:* = null;
         var _loc6_:* = 0;
         var _loc5_:* = false;
         var _loc8_:* = 0;
         var _loc7_:* = null;
         if(param1.name == "挥指功")
         {
            _loc4_ = Math.round(Math.random() * 164 + 1);
            _loc9_ = [];
            _loc6_ = 0;
            while(_loc6_ < param2.currentSkillVec.length)
            {
               _loc9_.push(param2.currentSkillVec[_loc6_].id);
               _loc6_++;
            }
            _loc9_.push(119,165,102,68,182,194,197,203,214,243,80,37,200,205,301);
            while(!_loc5_)
            {
               _loc4_ = Math.round(Math.random() * 164 + 1);
               _loc5_ = true;
               _loc8_ = 0;
               while(_loc8_ < _loc9_.length)
               {
                  if(_loc9_[_loc8_] == _loc4_)
                  {
                     _loc5_ = false;
                     break;
                  }
                  _loc8_++;
               }
            }
            FightingConfig.selfOrder.leadSkillId = _loc4_;
            _loc7_ = GetElfFactor.getSkillById(_loc4_);
            setAttackNum(_loc7_);
            getStatus(_loc7_,param2);
            effectForOther(_loc7_,param3);
            attackAddEffectHandler(_loc7_);
            continueSkillHandler(_loc7_);
         }
      }
      
      private static function isMull(param1:ElfVO) : void
      {
         if(param1.status.indexOf(7) != -1)
         {
            if(Math.random() * 2 > 1)
            {
               FightingConfig.selfOrder.isMull = 1;
               return;
            }
         }
      }
      
      private static function randomNum() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < FightingConfig.selfOrder.attackNum)
         {
            _loc2_ = Math.random() * 100;
            (FightingConfig.selfOrder.hitRandomNum as Array).push(_loc2_);
            _loc1_++;
         }
      }
      
      private static function isPalsyHandler(param1:ElfVO) : void
      {
         if(param1.status.indexOf(3) != -1)
         {
            if(Math.random() * 4 < 1)
            {
               FightingConfig.selfOrder.isPalsy = 1;
            }
            else
            {
               FightingConfig.selfOrder.isPalsy = 0;
            }
         }
      }
   }
}
