package com.mvc.views.mediator.fighting
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.dialogue.Dialogue;
   import com.mvc.GameFacade;
   import com.common.consts.ConfigConst;
   
   public class FeatureFactor
   {
       
      public function FeatureFactor()
      {
         super();
      }
      
      public static function pressureHandler(param1:ElfVO, param2:ElfVO) : void
      {
         if(param1.featureVO == null)
         {
            return;
         }
         if(param1.featureVO.id != 46)
         {
            return;
         }
         if(param2.currentSkill.currentPP > 0)
         {
            param2.currentSkill.currentPP = param2.currentSkill.currentPP - 1;
            if(param2.camp == "camp_of_player")
            {
               Dialogue.collectDialogue(param1.nickName + "气压特性\n" + param2.nickName + "掉多一点技能PP");
               GameFacade.getInstance().sendNotification(ConfigConst.UPDATA_SKILL_PP_SHOW);
            }
         }
      }
      
      public static function clearSpecialStatus(param1:ElfVO) : void
      {
         var _loc2_:* = false;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(param1.featureVO == null)
         {
            return;
         }
         if(param1.featureVO.id != 30)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < StatusFactor.specialStatus.length)
         {
            if(param1.status.indexOf(StatusFactor.specialStatus[_loc3_]) != -1)
            {
               _loc4_ = param1.status.indexOf(StatusFactor.specialStatus[_loc3_]);
               param1.status.splice(_loc4_,1);
               _loc2_ = true;
            }
            _loc3_++;
         }
         Dialogue.collectDialogue(param1.nickName + param1.featureVO.name + "特性\n解除一切异常状态");
      }
      
      public static function isFructifyImmunity(param1:ElfVO, param2:ElfVO) : Boolean
      {
         if(param1.featureVO == null)
         {
            return false;
         }
         if(param1.featureVO.id != 5)
         {
            return false;
         }
         if(param2.currentSkill.isKillArray[0] == 1)
         {
            Dialogue.collectDialogue(param1.nickName + "结石特性\n一击必杀技能无效");
            return true;
         }
         return false;
      }
      
      public static function isFructifyKeepHp(param1:ElfVO, param2:int) : Boolean
      {
         if(param1.featureVO == null)
         {
            return false;
         }
         if(param1.featureVO.id != 5)
         {
            return false;
         }
         if(param1.currentHp + param2 == param1.totalHp)
         {
            Dialogue.collectDialogue(param1.nickName + "结石特性\n保住了一点hp");
            param1.currentHp = "1";
            return true;
         }
         return false;
      }
      
      public static function isFloatImmunity(param1:ElfVO, param2:ElfVO) : Boolean
      {
         if(param1.featureVO == null)
         {
            return false;
         }
         if(param1.featureVO.id != 26)
         {
            return false;
         }
         if(param2.currentSkill.property == "地上")
         {
            Dialogue.collectDialogue(param1.nickName + "漂浮特性\n免疫地上系技能");
            return true;
         }
         return false;
      }
      
      public static function isFloatImmunityLandstar(param1:ElfVO) : Boolean
      {
         if(param1.featureVO == null)
         {
            return false;
         }
         if(param1.featureVO.id != 26)
         {
            return false;
         }
         Dialogue.collectDialogue(param1.nickName + "漂浮特性\n免疫满地星");
         return true;
      }
      
      public static function firmnessHandler(param1:ElfVO) : void
      {
         if(param1.featureVO == null)
         {
            return;
         }
         if(param1.featureVO.id != 62)
         {
            return;
         }
         if(param1.status.indexOf(1) != -1 || param1.status.indexOf(3) != -1 || param1.status.indexOf(4) != -1 || param1.status.indexOf(6) != -1)
         {
            LogUtil("特性前攻击力" + param1.attack);
            param1.attack = Math.round(param1.attack + param1.attack * 0.5);
            LogUtil("特性后攻击力" + param1.attack);
         }
      }
      
      public static function replyHandler(param1:ElfVO) : void
      {
         if(param1.featureVO == null)
         {
            return;
         }
         if(param1.featureVO.id != 144)
         {
            return;
         }
         if(param1.currentHp < param1.totalHp)
         {
            param1.currentHp = Math.round(param1.currentHp + param1.totalHp / 3);
         }
         if(param1.currentHp > param1.totalHp)
         {
            param1.currentHp = param1.totalHp;
         }
         if(param1.camp == "camp_of_player")
         {
            Dialogue.collectDialogue(param1.nickName + "在生力特性\n恢复了1/3HP");
         }
      }
      
      public static function technician(param1:ElfVO) : int
      {
         if(param1.featureVO == null)
         {
            return param1.currentSkill.power;
         }
         if(param1.featureVO.id != 101)
         {
            return param1.currentSkill.power;
         }
         if(param1.currentSkill.power <= 60)
         {
            return Math.round(param1.currentSkill.power * 1.5);
         }
         return param1.currentSkill.power;
      }
      
      public static function hugePower(param1:ElfVO) : Boolean
      {
         if(param1.featureVO == null)
         {
            return false;
         }
         if(param1.featureVO.id != 37)
         {
            return false;
         }
         LogUtil("技能类型：" + param1.currentSkill.sort);
         if(param1.currentSkill.sort == "物理")
         {
            Dialogue.collectDialogue(param1.nickName + "大力士特性\n物理伤害加倍");
            return true;
         }
         return false;
      }
      
      public static function unnerve(param1:ElfVO) : Boolean
      {
         if(param1.featureVO == null)
         {
            return false;
         }
         if(param1.featureVO.id != 127)
         {
            return false;
         }
         return true;
      }
      
      public static function steadfast(param1:ElfVO) : Boolean
      {
         if(param1.featureVO == null)
         {
            return false;
         }
         if(param1.featureVO.id != 80)
         {
            return false;
         }
         if(param1.ablilityAddLv[4] < 6)
         {
            var _loc2_:* = 4;
            var _loc3_:* = param1.ablilityAddLv[_loc2_] + 1;
            param1.ablilityAddLv[_loc2_] = _loc3_;
            Dialogue.collectDialogue(param1.nickName + "不屈服\n速度提升一级");
         }
         return true;
      }
      
      public static function insomnia(param1:ElfVO) : Boolean
      {
         if(param1.featureVO == null)
         {
            return false;
         }
         if(param1.featureVO.id != 15)
         {
            return false;
         }
         return true;
      }
      
      public static function shellarmor(param1:ElfVO) : Boolean
      {
         if(param1.featureVO == null)
         {
            return false;
         }
         if(param1.featureVO.id != 75)
         {
            return false;
         }
         return true;
      }
      
      public static function intimidate(param1:ElfVO, param2:ElfVO) : Boolean
      {
         if(param1.featureVO == null)
         {
            return false;
         }
         if(param1.featureVO.id != 22)
         {
            return false;
         }
         if(param2.ablilityAddLv[0] > -6)
         {
            param2.ablilityAddLv[0] = param2.ablilityAddLv[0] - 1;
            Dialogue.collectDialogue(param1.nickName + "威吓特性\n" + param2.nickName + "攻击等级降低一级");
         }
         return true;
      }
      
      public static function blaze(param1:ElfVO) : int
      {
         if(param1.featureVO == null)
         {
            return param1.currentSkill.power;
         }
         if(param1.featureVO.id != 66)
         {
            return param1.currentSkill.power;
         }
         if(param1.currentSkill.property == "火")
         {
            if(param1.currentHp <= param1.totalHp / 3)
            {
               return param1.currentSkill.power * 1.5;
            }
            if(param1.currentHp <= param1.totalHp / 4)
            {
               return param1.currentSkill.power * 2;
            }
         }
         return param1.currentSkill.power;
      }
   }
}
