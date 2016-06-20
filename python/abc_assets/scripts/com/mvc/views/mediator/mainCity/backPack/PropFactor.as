package com.mvc.views.mediator.mainCity.backPack
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import com.common.util.dialogue.Dialogue;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.views.uis.mainCity.backPack.NewSkillAlert;
   import com.mvc.GameFacade;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mainCity.kingKwan.KingKwanUI;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   import com.mvc.views.uis.mainCity.trial.TrialUI;
   import com.mvc.views.mediator.fighting.FeatureFactor;
   import starling.core.Starling;
   
   public class PropFactor
   {
      
      private static var tempElf:ElfVO;
      
      private static var tempProp:PropVO;
       
      public function PropFactor()
      {
         super();
      }
      
      public static function sendPropNote(param1:PropVO, param2:ElfVO, param3:int = -1) : void
      {
         (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3005(param1.id,param2.id,param3);
      }
      
      public static function propEffectHandler(param1:PropVO, param2:ElfVO) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         if(!param1.isUsed)
         {
            if(param1.type == 1 || param1.type == 23)
            {
               _loc4_ = param2.carryProp;
            }
            else
            {
               _loc4_ = param2.hagberryProp;
            }
            LogUtil("propVo ================== ",_loc4_);
            if(_loc4_ == null)
            {
               (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3003(param1.id,param2.id);
            }
            else if(_loc4_.id == param1.id)
            {
               Tips.show(param2.nickName + "已经携带" + param1.name);
            }
            else
            {
               tempElf = param2;
               tempProp = param1;
               if(param1.type == 16 || param1.type == 17)
               {
                  _loc3_ = Alert.show(param2.nickName + "已经携带了" + _loc4_.name + ",是否交换？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc3_.addEventListener("close",sureChangeProp);
               }
               else
               {
                  (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3004(tempElf,tempElf.carryProp);
                  (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3003(tempProp.id,tempElf.id);
                  tempElf = null;
                  tempProp = null;
               }
            }
            return;
         }
         if(param1.type == 2 || param1.type == 17)
         {
            clearStatus(param1,param2);
         }
         else if(param1.type == 3 || param1.type == 16)
         {
            addHp(param1,param2);
         }
         else if(param1.type == 6)
         {
            learnSkill(param1,param2);
         }
         if(param1.type == 7)
         {
            changeElfValue(param1,param2);
         }
      }
      
      private static function sureChangeProp(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3004(tempElf,tempElf.hagberryProp);
            (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3003(tempProp.id,tempElf.id);
            tempElf = null;
            tempProp = null;
         }
         else
         {
            tempElf = null;
            tempProp = null;
         }
      }
      
      private static function learnSkill(param1:PropVO, param2:ElfVO) : void
      {
         var _loc3_:* = false;
         var _loc6_:* = 0;
         var _loc5_:* = 0;
         var _loc4_:* = null;
         _loc6_ = 0;
         while(_loc6_ < param1.validElf.length)
         {
            if(param2.elfId == param1.validElf[_loc6_])
            {
               _loc3_ = true;
               break;
            }
            _loc6_++;
         }
         if(!_loc3_)
         {
            Dialogue.updateDialogue(param2.nickName + "不能使用" + param1.name,true,"prop_no_effect");
            return;
         }
         _loc5_ = 0;
         while(_loc5_ < param2.currentSkillVec.length)
         {
            if(param2.currentSkillVec[_loc5_].id == param1.skillId)
            {
               Dialogue.updateDialogue(param2.nickName + "将技能\n" + param2.currentSkillVec[_loc5_].name + "记住了",true,"prop_no_effect");
               return;
            }
            _loc5_++;
         }
         if(param2.currentSkillVec.length < 4)
         {
            (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3013(param2.id,0,param2.currentSkillVec.length,param1,1,learnSkillComplete);
         }
         else
         {
            tempElf = param2;
            tempProp = param1;
            _loc4_ = GetElfFactor.getSkillById(tempProp.skillId);
            NewSkillAlert.getInstance().show(tempElf,_loc4_);
            tempElf = null;
            tempProp = null;
         }
      }
      
      private static function learnSkillComplete() : void
      {
         Facade.getInstance().sendNotification("learn_skill_complete_by_prop");
      }
      
      private static function changeElfValue(param1:PropVO, param2:ElfVO) : void
      {
         LogUtil(param2.effAry,param1.elfNature);
         if(effSum(param2) > 510 && param1.elfNature != "等级")
         {
            Dialogue.updateDialogue(param2.nickName + "的六项属性努力值已达到最大值",true,"prop_no_effect");
            return;
         }
         if(param2.effAry[0] >= 100 && param1.elfNature == "血量")
         {
            Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
            return;
         }
         if(param1.elfNature == "攻击")
         {
            if(checkEff(1,param2))
            {
               Dialogue.updateDialogue(param2.nickName + "的物攻已达到最大值",true,"prop_no_effect");
               return;
            }
         }
         if(param1.elfNature == "防守")
         {
            if(checkEff(2,param2))
            {
               Dialogue.updateDialogue(param2.nickName + "的物防已达到最大值",true,"prop_no_effect");
               return;
            }
         }
         if(param1.elfNature == "特攻|特防")
         {
            if(checkEff(3,param2))
            {
               Dialogue.updateDialogue(param2.nickName + "的特攻特防已达到最大值",true,"prop_no_effect");
               return;
            }
         }
         if(param1.elfNature == "速度")
         {
            if(checkEff(5,param2))
            {
               Dialogue.updateDialogue(param2.nickName + "的速度已达到最大值",true,"prop_no_effect");
               return;
            }
         }
         sendPropNote(param1,param2);
      }
      
      public static function getSkillPower(param1:PropVO, param2:SkillVO, param3:ElfVO) : Number
      {
         if(param3.status.indexOf(39) != -1)
         {
            return 1;
         }
         if(param1 == null)
         {
            return 1;
         }
         if(param1.type == 1)
         {
            if(param2.property == param1.validNature)
            {
               return param1.effectValue;
            }
         }
         return 1;
      }
      
      private static function clearStatus(param1:PropVO, param2:ElfVO) : void
      {
         if(param1.relieveState == "中毒")
         {
            if(param2.status.indexOf(4) == -1 && param2.status.indexOf(5) == -1)
            {
               Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
               return;
            }
         }
         else if(param1.relieveState == "灼伤")
         {
            if(param2.status.indexOf(1) == -1)
            {
               Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
               return;
            }
         }
         else if(param1.relieveState == "冰冻")
         {
            if(param2.status.indexOf(2) == -1)
            {
               Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
               return;
            }
         }
         else if(param1.relieveState == "睡眠")
         {
            if(param2.status.indexOf(6) == -1)
            {
               Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
               return;
            }
         }
         else if(param1.relieveState == "麻痹")
         {
            if(param2.status.indexOf(3) == -1)
            {
               Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
               return;
            }
         }
         else if(param1.relieveState == "混乱")
         {
            if(param2.status.indexOf(7) == -1)
            {
               Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
               return;
            }
         }
         else if(param2.status.indexOf(4) == -1 && param2.status.indexOf(1) == -1 && param2.status.indexOf(2) == -1 && param2.status.indexOf(5) == -1 && param2.status.indexOf(6) == -1 && param2.status.indexOf(3) == -1 && param2.status.indexOf(7) == -1)
         {
            Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
            return;
         }
         sendPropNote(param1,param2);
      }
      
      private static function addHp(param1:PropVO, param2:ElfVO) : void
      {
         var _loc3_:int = param2.currentHp;
         if(param1.replyType == "hp")
         {
            if(param2.currentHp == param2.totalHp)
            {
               Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
               return;
            }
         }
         else if(param1.replyType == "life")
         {
            if(param2.currentHp == param2.totalHp || param2.currentHp > 0)
            {
               Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
               return;
            }
         }
         else
         {
            addPP(param1,param2);
            return;
         }
         sendPropNote(param1,param2);
      }
      
      private static function addPP(param1:PropVO, param2:ElfVO) : void
      {
         var _loc3_:* = false;
         var _loc4_:* = 0;
         if(param1.actRole == "单个")
         {
            bombSkillSelectWin();
            GameFacade.getInstance().sendNotification("show_elf_skill",param2);
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < param2.currentSkillVec.length)
            {
               if(param2.currentSkillVec[_loc4_].currentPP != param2.currentSkillVec[_loc4_].totalPP)
               {
                  _loc3_ = true;
               }
               _loc4_++;
            }
            if(_loc3_)
            {
               sendPropNote(param1,param2);
            }
            else
            {
               Dialogue.updateDialogue("没有任何效果",true,"prop_no_effect");
            }
         }
      }
      
      public static function carryClearPropHandler(param1:ElfVO, param2:String, param3:ElfVO) : Boolean
      {
         if(LoadPageCmd.lastPage is KingKwanUI || LoadPageCmd.lastPage is ElfSeriesUI || LoadPageCmd.lastPage is TrialUI)
         {
            return false;
         }
         if(param1.status.indexOf(39) != -1)
         {
            return false;
         }
         if(param1.hagberryProp && param1.hagberryProp.type == 17 && param1.status.indexOf(39) == -1)
         {
            LogUtil(param1.hagberryProp.relieveState + "携带道具状态");
            if(param1.hagberryProp.relieveState.indexOf(param2) != -1)
            {
               if(FeatureFactor.unnerve(param3))
               {
                  Dialogue.collectDialogue(param3.nickName + "紧张感特性\n" + param1.nickName + "不能食用" + param1.hagberryProp.name);
                  return false;
               }
               Dialogue.collectDialogue(param1.nickName + "使用了携带的" + param1.hagberryProp.name + "\n解除了" + param2);
               param1.hagberryProp = null;
               return true;
            }
         }
         return false;
      }
      
      public static function carryReplyHpPropHandler(param1:ElfVO, param2:ElfVO) : void
      {
         if(LoadPageCmd.lastPage is ElfSeriesUI || LoadPageCmd.lastPage is TrialUI)
         {
            return;
         }
         if(param1.status.indexOf(39) != -1)
         {
            return;
         }
         if(param1.carryProp && param1.carryProp.name == "剩饭")
         {
            Dialogue.collectDialogue(param1.nickName + "携带了" + param1.carryProp.name + "\n血量回复" + param1.totalHp / 16 + "点");
            GameFacade.getInstance().sendNotification("hp_change",-(param1.totalHp / 16),param1.camp);
         }
         if(LoadPageCmd.lastPage is KingKwanUI)
         {
            return;
         }
         if(param1.currentHp <= param1.totalHp / 2 && param1.status.indexOf(39) == -1)
         {
            if(param1.hagberryProp && param1.hagberryProp.type == 16 && param1.hagberryProp.replyType == "hp")
            {
               if(FeatureFactor.unnerve(param2))
               {
                  Dialogue.collectDialogue(param2.nickName + "紧张感特性\n" + param1.nickName + "不能食用" + param1.hagberryProp.name);
                  return;
               }
               Dialogue.collectDialogue(param1.nickName + "使用了携带的" + param1.hagberryProp.name + "\n血量回复" + param1.hagberryProp.effectValue + "点");
               GameFacade.getInstance().sendNotification("hp_change",-param1.hagberryProp.effectValue,param1.camp);
               param1.hagberryProp = null;
            }
         }
      }
      
      public static function carryReplyPPropHandler(param1:ElfVO, param2:ElfVO) : void
      {
         if(LoadPageCmd.lastPage is KingKwanUI || LoadPageCmd.lastPage is ElfSeriesUI || LoadPageCmd.lastPage is TrialUI)
         {
            return;
         }
         if(param1.currentSkill && param1.currentSkill.currentPP <= 0 && param1.status.indexOf(39) == -1)
         {
            if(param1.hagberryProp && param1.hagberryProp.type == 16 && param1.hagberryProp.replyType == "pp")
            {
               if(FeatureFactor.unnerve(param2))
               {
                  Dialogue.collectDialogue(param2.nickName + "紧张感特性\n" + param1.nickName + "不能食用" + param1.hagberryProp.name);
                  return;
               }
               param1.currentSkill.currentPP = param1.currentSkill.currentPP + param1.hagberryProp.effectValue;
               if(param1.currentSkill.currentPP > param1.currentSkill.totalPP)
               {
                  param1.currentSkill.currentPP = param1.currentSkill.totalPP;
               }
               Dialogue.collectDialogue(param1.nickName + "使用了携带的" + param1.hagberryProp.name + "\n" + param1.currentSkill.name + "技能回复pp" + param1.hagberryProp.effectValue + "点");
               param1.hagberryProp = null;
            }
         }
      }
      
      public static function checkEff(param1:int, param2:ElfVO) : Boolean
      {
         LogUtil("playElfVO.effAry[index] =",param1,param2.effAry[param1],effSum(param2));
         if(param2.effAry[param1] >= 255 && effSum(param2) <= 510)
         {
            return true;
         }
         return false;
      }
      
      public static function effSum(param1:ElfVO) : int
      {
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.effAry.length)
         {
            _loc3_ = _loc3_ + param1.effAry[_loc2_];
            _loc2_++;
         }
         return _loc3_;
      }
      
      public static function isExclusiveElf(param1:ElfVO) : Boolean
      {
         var _loc2_:* = false;
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.carryProp.exclusiveElf.length)
         {
            if(param1.elfId == param1.carryProp.exclusiveElf[_loc3_])
            {
               _loc2_ = true;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function bombSkillSelectWin() : void
      {
         GameFacade.getInstance().sendNotification("switch_win",null,"LOAD_SKILL_WIN");
      }
      
      public static function effectForAblility(param1:ElfVO) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc6_:* = NaN;
         var _loc5_:PropVO = param1.carryProp;
         if(_loc5_.effectForAblility.length == 0)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc5_.effectForAblility.length)
         {
            _loc2_ = _loc5_.effectForAblility[_loc3_].split(",");
            _loc4_ = _loc2_[0];
            _loc6_ = _loc2_[1];
            LogUtil(_loc4_ + "原来的值" + param1[_loc4_]);
            param1[_loc4_] = Math.round(param1[_loc4_] * _loc6_ + param1[_loc4_]);
            LogUtil(_loc4_ + "后来的值" + param1[_loc4_]);
            _loc3_++;
         }
      }
      
      public static function carrySpecial(param1:ElfVO, param2:Number) : void
      {
         attacker = param1;
         hurtNum = param2;
         if(attacker.carryProp == null)
         {
            return;
         }
         if(attacker.carryProp.id == 856 && attacker.currentHp < attacker.totalHp)
         {
            var tellAddBoold:Function = function():*
            {
               var /*UnknownSlot*/:* = §§dup(function(param1:int):void
               {
                  GameFacade.getInstance().sendNotification("hp_change",-param1,attacker.camp);
               });
               return function(param1:int):void
               {
                  GameFacade.getInstance().sendNotification("hp_change",-param1,attacker.camp);
               };
            }();
            Starling.juggler.delayCall(tellAddBoold,Config.dialogueDelay / 1.5,hurtNum / 8);
            Dialogue.collectDialogue(attacker.nickName + "携带贝壳之铃\n回复了HP");
         }
      }
   }
}
