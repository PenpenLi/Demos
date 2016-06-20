package com.mvc.views.mediator.fighting
{
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.fighting.CampBaseUI;
   import com.mvc.GameFacade;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import com.mvc.views.uis.login.startChat.StartChatUI;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.models.proxy.fighting.FightingPro;
   import com.common.util.dialogue.Dialogue;
   import extend.SoundEvent;
   import starling.core.Starling;
   import com.common.consts.ConfigConst;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.fighting.CampOfPlayerUI;
   import com.mvc.views.uis.fighting.CampOfComputerUI;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.views.mediator.mainCity.backPack.PropFactor;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   
   public class FightingLogicFactor
   {
      
      private static var hurtNum:Number;
      
      private static var usedSkill:SkillVO;
      
      public static var attacker:ElfVO;
      
      private static var beAttackeder:ElfVO;
      
      private static var beAttackedType:String;
      
      private static var attackType:String;
      
      private static var beAttackedCamp:CampBaseUI;
      
      private static var _attackNum:int;
      
      private static var _attackSuccessNum:int;
      
      private static var _isFirstOfOurs:Boolean;
      
      private static var _getExp:String;
      
      private static var _getEffort:Array;
      
      public static var badEffectNum:int;
      
      public static var isPVP:Boolean;
      
      public static var isPlayBack:Boolean;
      
      public static var isRounding:Boolean;
      
      public static var isFightingOfFirst:Boolean;
      
      public static var isNoisy:int = 0;
      
      public static var isPlayBackFromPvp:Boolean;
       
      public function FightingLogicFactor()
      {
         super();
      }
      
      public static function firstAttckHandler(param1:ElfVO, param2:ElfVO) : void
      {
         if(!FightingMedia.isFighting)
         {
            return;
         }
         if(CalculatorFactor.isFirstAttackOfOur(param1,param2,CampOfPlayerMedia._currentSkillVO,CampOfComputerMedia._currentSkillVO))
         {
            LogUtil(param2.isWillDie + "我方先");
            if(param2.isWillDie)
            {
               return;
            }
            _isFirstOfOurs = true;
            GameFacade.getInstance().sendNotification("start_skill",false,"camp_of_player");
         }
         else
         {
            LogUtil(param1.isWillDie + "敌方先");
            if(param1.isWillDie)
            {
               return;
            }
            _isFirstOfOurs = false;
            GameFacade.getInstance().sendNotification("start_skill",false,"camp_of_computer");
         }
      }
      
      public static function goOutHandler(param1:ElfVO, param2:ElfVO, param3:int, param4:Boolean) : Boolean
      {
         var _loc5_:* = null;
         LogUtil(LoadPageCmd.lastPage + "dsss" + (!(LoadPageCmd.lastPage is CityMapUI) && !(LoadPageCmd.lastPage is StartChatUI)));
         if(!(LoadPageCmd.lastPage is CityMapUI) && !(LoadPageCmd.lastPage is StartChatUI) || CalculatorFactor.calculatorIsGoOutSuccess(param1,param2,param3))
         {
            _loc5_ = "成功地逃跑了!";
            FightingConfig.isWin = false;
            FightingConfig.isGoOut = true;
            if(FightingLogicFactor.isPVP)
            {
               (GameFacade.getInstance().retrieveProxy("FightingPro") as FightingPro).write6001(-1,true);
               GameFacade.getInstance().sendNotification("pvp_timer_stop");
            }
            GameFacade.getInstance().sendNotification("adventure_result",0,"adventure_failed");
            if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
            {
               FightingLogicFactor.dialogueAndNext(_loc5_,"END_FIGHTING");
            }
            else
            {
               Dialogue.updateDialogue(_loc5_,true,"END_FIGHTING");
            }
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","flee");
            return true;
         }
         if(param4)
         {
            Dialogue.updateDialogue("逃跑失败了!",true,"LOAD_PLAYELF_WIN");
         }
         else
         {
            _loc5_ = "逃跑失败了!";
            Dialogue.updateDialogue(_loc5_);
            Starling.juggler.delayCall(computerActHandler,Config.dialogueDelay);
         }
         return false;
      }
      
      public static function computerActHandler() : void
      {
         if(!FightingLogicFactor.isPVP)
         {
            if(CampOfComputerMedia.campUI.myVO.status.indexOf(28) != -1)
            {
               CampOfComputerMedia.campUI.myVO.status.splice(CampOfComputerMedia.campUI.myVO.status.indexOf(28),1);
            }
            GameFacade.getInstance().sendNotification("update_status_show","clear_anger_status","camp_of_computer");
            _isFirstOfOurs = true;
            if(FightingLogicFactor.isPlayBack)
            {
               if(FightingConfig.otherOrder.selectElf != -1)
               {
                  GameFacade.getInstance().sendNotification("change_elf_on_play_back",false,"camp_of_computer");
                  return;
               }
            }
            GameFacade.getInstance().sendNotification("ready_skill",0,"camp_of_computer");
            GameFacade.getInstance().sendNotification("start_skill",false,"camp_of_computer");
         }
      }
      
      public static function playerActHandler() : void
      {
         _isFirstOfOurs = false;
         GameFacade.getInstance().sendNotification("ready_skill",FightingConfig.recordSkillIndex,"camp_of_player");
         GameFacade.getInstance().sendNotification(ConfigConst.UPDATA_SKILL_PP_SHOW,FightingConfig.recordSkillIndex);
         GameFacade.getInstance().sendNotification("start_skill",false,"camp_of_player");
      }
      
      public static function attackHandler(param1:INotification, param2:ElfVO, param3:ElfVO, param4:CampOfPlayerUI, param5:CampOfComputerUI) : void
      {
         if(param1.getType() == "camp_of_player")
         {
            usedSkill = CampOfPlayerMedia._currentSkillVO;
            LogUtil(usedSkill.power + "使用的技能名称" + usedSkill.name);
            attacker = param2;
            beAttackeder = param3;
            beAttackedType = "camp_of_computer";
            attackType = "camp_of_player";
            beAttackedCamp = param5;
         }
         else
         {
            usedSkill = CampOfComputerMedia._currentSkillVO;
            attacker = param3;
            beAttackeder = param2;
            beAttackedType = "camp_of_player";
            attackType = "camp_of_computer";
            beAttackedCamp = param4;
         }
         if(usedSkill.attackNum.length == 1)
         {
            _attackNum = usedSkill.attackNum[0];
         }
         else if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(attacker.camp == "camp_of_player")
            {
               _attackNum = FightingConfig.selfOrder.attackNum;
            }
            else
            {
               _attackNum = FightingConfig.otherOrder.attackNum;
            }
         }
         else
         {
            _attackNum = Math.round(Math.random() * (usedSkill.attackNum[1] - usedSkill.attackNum[0]) + usedSkill.attackNum[0]);
         }
         if(!FightingLogicFactor.isPlayBack)
         {
            if(attacker.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].attackNum = _attackNum;
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].attackNum = _attackNum;
            }
         }
         _attackSuccessNum = 0;
         calculatorAttack();
      }
      
      public static function calculatorAttack() : void
      {
         if(FightingMedia.isFighting == false)
         {
            return;
         }
         _attackNum = _attackNum - 1;
         if(CalculatorFactor.isHit(usedSkill,attacker,beAttackeder))
         {
            if(usedSkill.sort == "变化" && beAttackeder.status.indexOf(37) != -1)
            {
               Dialogue.collectDialogue(beAttackeder.nickName + "穿着魔术外衣\n反弹效果");
               beAttackeder = attacker;
            }
            if(usedSkill.effectForOther[0] != 0)
            {
               effectForOther();
            }
            if(usedSkill.sort == "变化")
            {
               FightingConfig.attackEffect = 0;
               skillOfChange();
               return;
            }
            hurtNum = CalculatorFactor.hurtCalculator(attacker,beAttackeder,usedSkill);
            if(BeginnerGuide.mark == "sta_catchElf")
            {
               if(beAttackeder.camp == "camp_of_computer")
               {
                  hurtNum = beAttackeder.currentHp - 1;
               }
            }
            if(Config.isOpenBeginner)
            {
               if(beAttackeder.camp == "camp_of_player")
               {
                  hurtNum = 0;
               }
            }
            badEffectHandler();
            if(hurtNum == 0)
            {
               FightingConfig.attackEffect = 0;
               noAttackEffectHandler();
               badEffectHandler(true);
               return;
            }
            var callBack:Function = function():void
            {
               _attackSuccessNum = _attackSuccessNum + 1;
               attackAddEffectHandler();
               StatusFactor.getStatus(beAttackeder,usedSkill,attacker);
               effectForAblilityLv();
               PropFactor.carrySpecial(attacker,hurtNum);
               if(beAttackeder.status.indexOf(16) != -1)
               {
                  var _loc1_:* = 0;
                  var _loc2_:* = beAttackeder.ablilityAddLv[_loc1_] + 1;
                  beAttackeder.ablilityAddLv[_loc1_] = _loc2_;
               }
               if(beAttackeder.status.indexOf(17) != -1)
               {
                  beAttackeder.tolerHurt = beAttackeder.tolerHurt + hurtNum;
               }
               if(Config.isOpenFightingAni)
               {
                  SoundEvent.addEventListener("PLAY_ONCE_COMPLETE",playEffectMusic);
                  SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","skillM" + usedSkill.soundName);
               }
               else
               {
                  playEffectMusic();
               }
            };
            SkillFactor.playSkillEffect(usedSkill,beAttackedCamp,false,callBack);
         }
         else
         {
            FightingConfig.attackEffect = 0;
            noAttackCorrectHandler();
            badEffectHandler(true);
         }
         if(_attackNum == 0 && usedSkill.attackNum[0] != 1 && _attackSuccessNum > 1)
         {
            Dialogue.collectDialogue("连续命中" + _attackSuccessNum + "次");
         }
      }
      
      private static function effectForAblilityLv() : void
      {
         var _loc1_:* = NaN;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         LogUtil("能力效果变化" + usedSkill.effectForAblilityLv);
         if((usedSkill.effectForAblilityLv[0] as Array).length == 0)
         {
            return;
         }
         var _loc2_:* = 0;
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(attacker.camp == "camp_of_player")
            {
               _loc2_ = FightingConfig.selfOrder.isHasEffect;
            }
            else if(FightingConfig.otherOrder.hasOwnProperty("isHasEffect") && FightingConfig.otherOrder.isHasEffect == 1)
            {
               _loc2_ = 1;
            }
            else
            {
               _loc2_ = 0;
            }
         }
         else
         {
            _loc1_ = Math.random() * 100;
            LogUtil("随机数" + _loc1_);
            if(_loc1_ < usedSkill.effectForAblilityLv[2])
            {
               _loc2_ = 1;
            }
         }
         if(!FightingLogicFactor.isPlayBack)
         {
            if(attacker.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isHasEffect = _loc2_;
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isHasEffect = _loc2_;
            }
         }
         if(_loc2_)
         {
            LogUtil("能力效果等级前:" + attacker.ablilityAddLv);
            _loc3_ = 0;
            while(_loc3_ < (usedSkill.effectForAblilityLv[0] as Array).length)
            {
               _loc4_ = usedSkill.effectForAblilityLv[0][_loc3_];
               var _loc5_:* = _loc4_;
               var _loc6_:* = attacker.ablilityAddLv[_loc5_] + usedSkill.effectForAblilityLv[1];
               attacker.ablilityAddLv[_loc5_] = _loc6_;
               _loc3_++;
            }
            LogUtil("能力效果等级后:" + attacker.ablilityAddLv);
            if(usedSkill.effectForAblilityLv[1] > 0)
            {
               Dialogue.collectDialogue(attacker.nickName + "\n提升了能力等级");
            }
            else
            {
               Dialogue.collectDialogue(attacker.nickName + "\n降低了能力等级");
            }
         }
      }
      
      private static function changeHandler() : void
      {
         var _loc4_:* = 0;
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(attacker.status.indexOf(11) != -1)
         {
            attacker.status.splice(attacker.status.indexOf(11),1);
         }
         attacker.imgName = beAttackeder.imgName;
         attacker.color = beAttackeder.color;
         attacker.recordSkillVec = Vector.<SkillVO>([]);
         _loc4_ = 0;
         while(_loc4_ < attacker.currentSkillVec.length)
         {
            attacker.recordSkillVec.push(attacker.currentSkillVec[_loc4_]);
            _loc4_++;
         }
         attacker.currentSkillVec = Vector.<SkillVO>([]);
         _loc1_ = 0;
         while(_loc1_ < beAttackeder.currentSkillVec.length)
         {
            LogUtil("技能名称" + beAttackeder.currentSkillVec[_loc1_].name);
            attacker.currentSkillVec.push(GetElfFactor.getSkillById(beAttackeder.currentSkillVec[_loc1_].id));
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            attacker.ablilityAddLv[_loc2_] = beAttackeder.ablilityAddLv[_loc2_];
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < attacker.currentSkillVec.length)
         {
            attacker.currentSkillVec[_loc3_].totalPP = 5;
            attacker.currentSkillVec[_loc3_].currentPP = "5";
            _loc3_++;
         }
         attacker.nature = beAttackeder.nature;
         attacker.attack = beAttackeder.attack;
         attacker.defense = beAttackeder.defense;
         attacker.super_attack = beAttackeder.super_attack;
         attacker.super_defense = beAttackeder.super_defense;
         attacker.speed = beAttackeder.speed;
         attacker.status.push(18);
         GameFacade.getInstance().sendNotification("update_fighting_ele",attacker,attacker.camp);
         GameFacade.getInstance().sendNotification("update_status_show",0,attacker.camp);
      }
      
      public static function replyChange(param1:ElfVO) : void
      {
         var _loc3_:* = null;
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = 0;
         if(param1.status.indexOf(18) != -1)
         {
            _loc3_ = GetElfFactor.getElfVO(param1.elfId);
            param1.imgName = _loc3_.imgName;
            param1.color = _loc3_.color;
            param1.currentSkillVec = Vector.<SkillVO>([]);
            _loc5_ = 0;
            while(_loc5_ < param1.recordSkillVec.length)
            {
               param1.currentSkillVec.push(param1.recordSkillVec[_loc5_]);
               _loc5_++;
            }
            param1.recordSkillVec = Vector.<SkillVO>([]);
            param1.nature = _loc3_.nature;
            _loc4_ = param1.status.indexOf(18);
            param1.status.splice(_loc4_,1);
            _loc2_ = param1.currentHp;
            CalculatorFactor.calculatorElf(param1);
            param1.currentHp = _loc2_;
         }
      }
      
      private static function skillOfChange() : void
      {
         var callBack:Function = function():void
         {
            if(Config.isOpenFightingAni)
            {
               SoundEvent.addEventListener("PLAY_ONCE_COMPLETE",playEffectMusic);
               SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","skillM" + usedSkill.soundName);
            }
            else
            {
               playEffectMusic();
            }
            if(usedSkill.id == 262)
            {
               var _loc1_:* = 0;
               var _loc2_:* = beAttackeder.ablilityAddLv[_loc1_] - 2;
               beAttackeder.ablilityAddLv[_loc1_] = _loc2_;
               _loc2_ = 2;
               _loc1_ = beAttackeder.ablilityAddLv[_loc2_] - 2;
               beAttackeder.ablilityAddLv[_loc2_] = _loc1_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n攻击和特攻大幅降低");
               badEffectHandler();
               Starling.juggler.delayCall(function():void
               {
                  SkillFactor.playOtherEffect("mc_badEffectBuff",beAttackedCamp);
               },0.6);
               return;
            }
            if(usedSkill.id == 260)
            {
               if(beAttackeder.ablilityAddLv[2] < 6)
               {
                  _loc1_ = 2;
                  _loc2_ = beAttackeder.ablilityAddLv[_loc1_] + 1;
                  beAttackeder.ablilityAddLv[_loc1_] = _loc2_;
                  Dialogue.collectDialogue(beAttackeder.nickName + "\n特攻提升");
               }
            }
            if(usedSkill.name == "变身")
            {
               if(beAttackeder.status.indexOf(18) == -1 && beAttackeder.status.indexOf(13) == -1 && attacker.status.indexOf(18) == -1 && attacker.status.indexOf(13) == -1)
               {
                  changeHandler();
               }
               else
               {
                  GameFacade.getInstance().sendNotification("tell_after_self_act",attacker.name + "变身失败",attackType);
               }
               return;
            }
            if(usedSkill.status[0] != 0)
            {
               StatusFactor.getStatus(beAttackeder,usedSkill,attacker);
            }
         };
         SkillFactor.playSkillEffect(usedSkill,beAttackedCamp,false,callBack);
      }
      
      private static function effectForOther() : void
      {
         if(beAttackeder.status.indexOf(13) != -1 && usedSkill.effectForOther[0] != 4)
         {
            return;
         }
         if(isItching())
         {
            return;
         }
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            pvpHandlerSkillEffect(usedSkill.effectForOther[1]);
            return;
         }
         if(usedSkill.effectForOther[0] == 1 && beAttackeder.status.indexOf(14) == -1 && beAttackeder.ablilityAddLv[3] > -6)
         {
            if(Math.random() * 100 < usedSkill.effectForOther[2])
            {
               var isHasEffecf:int = 1;
               setPlayBackOrder(isHasEffecf);
               var _loc2_:* = 3;
               var _loc3_:* = beAttackeder.ablilityAddLv[_loc2_] - usedSkill.effectForOther[1];
               beAttackeder.ablilityAddLv[_loc2_] = _loc3_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n特殊防御力降低了");
               Starling.juggler.delayCall(function():void
               {
                  SkillFactor.playOtherEffect("mc_badEffectBuff",beAttackedCamp);
               },0.6);
            }
         }
         else if(usedSkill.effectForOther[0] == 2 && beAttackeder.status.indexOf(14) == -1 && beAttackeder.ablilityAddLv[4] > -6)
         {
            if(Math.random() * 100 < usedSkill.effectForOther[2])
            {
               isHasEffecf = 1;
               setPlayBackOrder(isHasEffecf);
               _loc3_ = 4;
               _loc2_ = beAttackeder.ablilityAddLv[_loc3_] - usedSkill.effectForOther[1];
               beAttackeder.ablilityAddLv[_loc3_] = _loc2_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n速度降低了");
               Starling.juggler.delayCall(function():void
               {
                  SkillFactor.playOtherEffect("mc_badEffectBuff",beAttackedCamp);
               },0.6);
            }
         }
         else if(usedSkill.effectForOther[0] == 3 && beAttackeder.status.indexOf(14) == -1 && beAttackeder.ablilityAddLv[0] > -6)
         {
            if(Math.random() * 100 < usedSkill.effectForOther[2])
            {
               isHasEffecf = 1;
               setPlayBackOrder(isHasEffecf);
               _loc2_ = 0;
               _loc3_ = beAttackeder.ablilityAddLv[_loc2_] - usedSkill.effectForOther[1];
               beAttackeder.ablilityAddLv[_loc2_] = _loc3_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n攻击力降低了");
               Starling.juggler.delayCall(function():void
               {
                  SkillFactor.playOtherEffect("mc_badEffectBuff",beAttackedCamp);
               },0.6);
            }
         }
         else if(usedSkill.effectForOther[0] == 4 && beAttackeder.ablilityAddLv[5] > -6)
         {
            if(Math.random() * 100 < usedSkill.effectForOther[2])
            {
               isHasEffecf = 1;
               setPlayBackOrder(isHasEffecf);
               _loc3_ = 5;
               _loc2_ = beAttackeder.ablilityAddLv[_loc3_] - usedSkill.effectForOther[1];
               beAttackeder.ablilityAddLv[_loc3_] = _loc2_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n命中率降低了");
               Starling.juggler.delayCall(function():void
               {
                  SkillFactor.playOtherEffect("mc_badEffectBuff",beAttackedCamp);
               },0.6);
            }
         }
         else if(usedSkill.effectForOther[0] == 5 && beAttackeder.status.indexOf(14) == -1 && beAttackeder.ablilityAddLv[1] > -6)
         {
            if(Math.random() * 100 < usedSkill.effectForOther[2])
            {
               isHasEffecf = 1;
               setPlayBackOrder(isHasEffecf);
               _loc2_ = 1;
               _loc3_ = beAttackeder.ablilityAddLv[_loc2_] - usedSkill.effectForOther[1];
               beAttackeder.ablilityAddLv[_loc2_] = _loc3_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n防御力降低了");
               Starling.juggler.delayCall(function():void
               {
                  SkillFactor.playOtherEffect("mc_badEffectBuff",beAttackedCamp);
               },0.6);
            }
         }
         else if(usedSkill.effectForOther[0] == 7 && beAttackeder.status.indexOf(14) == -1 && beAttackeder.ablilityAddLv[6] > -6)
         {
            if(Math.random() * 100 < usedSkill.effectForOther[2])
            {
               isHasEffecf = 1;
               setPlayBackOrder(isHasEffecf);
               _loc3_ = 6;
               _loc2_ = beAttackeder.ablilityAddLv[_loc3_] - usedSkill.effectForOther[1];
               beAttackeder.ablilityAddLv[_loc3_] = _loc2_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n回避降低了");
               Starling.juggler.delayCall(function():void
               {
                  SkillFactor.playOtherEffect("mc_badEffectBuff",beAttackedCamp);
               },0.6);
            }
         }
         if(usedSkill.effectForOther[0] == 6 && hurtNum > 0)
         {
            LogUtil("伤害的血量" + hurtNum);
            isHasEffecf = 1;
            var getHp:int = Math.round(hurtNum * 0.5);
            Starling.juggler.delayCall(tellAddBoold,Config.dialogueDelay / 1.5,getHp);
            Dialogue.collectDialogue(attacker.nickName + "吸收了" + beAttackeder.nickName + "的HP");
            LogUtil("吸收的血量" + getHp);
         }
      }
      
      private static function setPlayBackOrder(param1:int) : void
      {
         LogUtil("是否有附加效果" + param1);
         if(!FightingLogicFactor.isPlayBack)
         {
            if(attacker.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isHasEffect = param1;
               LogUtil("是否有附加效果" + JSON.stringify(FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1]));
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isHasEffect = param1;
               LogUtil("是否有附加效果" + JSON.stringify(FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1]));
            }
         }
      }
      
      private static function isItching() : Boolean
      {
         if(usedSkill.id == 321)
         {
            var _loc1_:* = 0;
            var _loc2_:* = beAttackeder.ablilityAddLv[_loc1_] - 1;
            beAttackeder.ablilityAddLv[_loc1_] = _loc2_;
            _loc2_ = 1;
            _loc1_ = beAttackeder.ablilityAddLv[_loc2_] - 1;
            beAttackeder.ablilityAddLv[_loc2_] = _loc1_;
            Dialogue.collectDialogue(beAttackeder.nickName + "\n攻击和防御降低了");
            Starling.juggler.delayCall(function():void
            {
               SkillFactor.playOtherEffect("mc_badEffectBuff",beAttackedCamp);
            },0.6);
            return true;
         }
         return false;
      }
      
      private static function pvpHandlerSkillEffect(param1:int) : void
      {
         effectValue = param1;
         if(attacker.camp == "camp_of_player")
         {
            var isHasEffecf:int = FightingConfig.selfOrder.isHasEffect;
         }
         else if(FightingConfig.otherOrder.hasOwnProperty("isHasEffect") && FightingConfig.otherOrder.isHasEffect == 1)
         {
            isHasEffecf = 1;
         }
         else
         {
            isHasEffecf = 0;
         }
         if(beAttackeder.status.indexOf(14) != -1 && usedSkill.effectForOther[0] != 4)
         {
            isHasEffecf = 0;
         }
         if(isHasEffecf == 1)
         {
            Starling.juggler.delayCall(function():void
            {
               SkillFactor.playOtherEffect("mc_badEffectBuff",beAttackedCamp);
            },0.6);
            if(usedSkill.effectForOther[0] == 1)
            {
               var _loc3_:* = 3;
               var _loc4_:* = beAttackeder.ablilityAddLv[_loc3_] - effectValue;
               beAttackeder.ablilityAddLv[_loc3_] = _loc4_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n特殊防御力降低了");
               setPlayBackOrder(isHasEffecf);
            }
            else if(usedSkill.effectForOther[0] == 2)
            {
               _loc4_ = 4;
               _loc3_ = beAttackeder.ablilityAddLv[_loc4_] - effectValue;
               beAttackeder.ablilityAddLv[_loc4_] = _loc3_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n速度降低了");
               setPlayBackOrder(isHasEffecf);
            }
            else if(usedSkill.effectForOther[0] == 3)
            {
               _loc3_ = 0;
               _loc4_ = beAttackeder.ablilityAddLv[_loc3_] - effectValue;
               beAttackeder.ablilityAddLv[_loc3_] = _loc4_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n攻击力降低了");
               setPlayBackOrder(isHasEffecf);
            }
            else if(usedSkill.effectForOther[0] == 4)
            {
               _loc4_ = 5;
               _loc3_ = beAttackeder.ablilityAddLv[_loc4_] - effectValue;
               beAttackeder.ablilityAddLv[_loc4_] = _loc3_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n命中率降低了");
               setPlayBackOrder(isHasEffecf);
            }
            else if(usedSkill.effectForOther[0] == 5)
            {
               _loc3_ = 1;
               _loc4_ = beAttackeder.ablilityAddLv[_loc3_] - effectValue;
               beAttackeder.ablilityAddLv[_loc3_] = _loc4_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n防御力降低了");
               setPlayBackOrder(isHasEffecf);
            }
            else if(usedSkill.effectForOther[0] == 7)
            {
               _loc4_ = 6;
               _loc3_ = beAttackeder.ablilityAddLv[_loc4_] - effectValue;
               beAttackeder.ablilityAddLv[_loc4_] = _loc3_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n回避降低了");
               setPlayBackOrder(isHasEffecf);
            }
         }
         if(usedSkill.effectForOther[0] == 6 && hurtNum > 0)
         {
            LogUtil("伤害的血量" + hurtNum);
            var getHp:int = Math.round(hurtNum * 0.5);
            Starling.juggler.delayCall(tellAddBoold,Config.dialogueDelay / 1.5,getHp);
            Dialogue.collectDialogue(attacker.nickName + "吸收了" + beAttackeder.nickName + "的HP");
            LogUtil("吸收的血量" + getHp);
         }
      }
      
      private static function attackAddEffectHandler() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         if(beAttackeder.status.indexOf(13) != -1 && usedSkill.effectForOther[0] != 6)
         {
            return;
         }
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            pvpHandlerSkillEffect(1);
            return;
         }
         if(usedSkill.effectForOther[0] == 1)
         {
            if(Math.random() * 10 < 1 && beAttackeder.status.indexOf(14) == -1)
            {
               _loc2_ = 1;
               var _loc3_:* = 3;
               var _loc4_:* = beAttackeder.ablilityAddLv[_loc3_] - 1;
               beAttackeder.ablilityAddLv[_loc3_] = _loc4_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n特殊防御力降低了");
               setPlayBackOrder(_loc2_);
            }
         }
         else if(usedSkill.effectForOther[0] == 2)
         {
            if(Math.random() * 10 < 1 && beAttackeder.status.indexOf(14) == -1)
            {
               _loc2_ = 1;
               _loc4_ = 4;
               _loc3_ = beAttackeder.ablilityAddLv[_loc4_] - 1;
               beAttackeder.ablilityAddLv[_loc4_] = _loc3_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n速度降低了");
               setPlayBackOrder(_loc2_);
            }
         }
         else if(usedSkill.effectForOther[0] == 3)
         {
            if(Math.random() * 10 < 1 && beAttackeder.status.indexOf(14) == -1)
            {
               _loc2_ = 1;
               _loc3_ = 0;
               _loc4_ = beAttackeder.ablilityAddLv[_loc3_] - 1;
               beAttackeder.ablilityAddLv[_loc3_] = _loc4_;
               Dialogue.collectDialogue(beAttackeder.nickName + "\n攻击力降低了");
               setPlayBackOrder(_loc2_);
            }
         }
         else if(usedSkill.effectForOther[0] == 6 && hurtNum > 0)
         {
            LogUtil("伤害的血量" + hurtNum);
            _loc1_ = Math.round(hurtNum * 0.5);
            Starling.juggler.delayCall(tellAddBoold,Config.dialogueDelay / 1.5,_loc1_);
            Dialogue.collectDialogue(attacker.nickName + "吸收了" + beAttackeder.nickName + "的HP");
            LogUtil("吸收的血量" + _loc1_);
         }
      }
      
      private static function tellAddBoold(param1:int) : void
      {
         GameFacade.getInstance().sendNotification("hp_change",-param1,attackType);
      }
      
      private static function badEffectHandler(param1:Boolean = false) : void
      {
         if(!param1)
         {
            if(usedSkill.badEffect[0] == 1)
            {
               badEffectNum = Math.round(attacker.totalHp * usedSkill.badEffect[1]);
            }
            if(usedSkill.badEffect[0] == 2)
            {
               badEffectNum = Math.round(hurtNum * usedSkill.badEffect[1]);
            }
            if(usedSkill.badEffect[0] == 3)
            {
               GameFacade.getInstance().sendNotification("can_not_action",0,attackType);
            }
         }
         else if(usedSkill.badEffect[0] == 4)
         {
            badEffectNum = attacker.totalHp * usedSkill.badEffect[1];
         }
      }
      
      public static function tellBadEffect() : void
      {
         GameFacade.getInstance().sendNotification("hp_change",badEffectNum,attackType);
         badEffectNum = 0;
      }
      
      private static function noAttackCorrectHandler() : void
      {
         if(usedSkill.attackNum[0] == 1)
         {
            Starling.juggler.delayCall(tellAttackFailed,Config.dialogueDelay,"但没有击中");
         }
         else if(_attackNum > 0)
         {
            calculatorAttack();
         }
         else if(_attackNum == 0)
         {
            if(_attackSuccessNum > 0)
            {
               tellAttackFailed("连续命中" + _attackSuccessNum + "次");
            }
            else
            {
               Starling.juggler.delayCall(tellAttackFailed,Config.dialogueDelay,"但没有击中");
            }
         }
      }
      
      private static function noAttackEffectHandler() : void
      {
         if(usedSkill.attackNum[0] == 1)
         {
            if(usedSkill.badEffect[0] == 4)
            {
               Starling.juggler.delayCall(tellAttackFailed,Config.dialogueDelay,"");
            }
            else
            {
               Starling.juggler.delayCall(tellAttackFailed,Config.dialogueDelay,"没有效果");
            }
         }
         else if(_attackNum > 0)
         {
            calculatorAttack();
         }
         else if(_attackNum == 0)
         {
            if(_attackSuccessNum > 0)
            {
               tellAttackFailed("连续命中" + _attackSuccessNum + "次");
            }
            else
            {
               Starling.juggler.delayCall(tellAttackFailed,Config.dialogueDelay,"没有效果");
            }
         }
      }
      
      private static function tellAttackFailed(param1:String) : void
      {
         if(badEffectNum > 0)
         {
            Dialogue.collectDialogue(param1);
            Dialogue.collectDialogue(attacker.name + "受到自己技能的伤害");
            tellBadEffect();
            var param1:String = "";
         }
         GameFacade.getInstance().sendNotification("tell_after_self_act",param1,attackType);
      }
      
      public static function hpChangeHandler(param1:int, param2:ElfVO) : void
      {
         var _loc3_:* = false;
         var _loc4_:* = null;
         LogUtil(param2.nickName + "当前hp：" + param2.currentHp);
         if(param1 < 0 && param2.status.indexOf(13) != -1)
         {
            param2.hpBeforeAvatars = param2.hpBeforeAvatars - param1;
            if(param2.hpBeforeAvatars >= param2.totalHp)
            {
               param2.hpBeforeAvatars = param2.totalHp;
               Dialogue.collectDialogue(param2.nickName + "本体HP满了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "回复了本体HP");
            }
            return;
         }
         param2.currentHp = param2.currentHp - param1;
         if(param2.currentHp <= 0)
         {
            if(FeatureFactor.isFructifyKeepHp(param2,param1))
            {
               return;
            }
            _loc3_ = true;
            if(param2.currentSkill)
            {
               if(param2.currentSkill.id == 120 || param2.currentSkill.id == 153 || param2.currentSkill.id == 262)
               {
                  _loc3_ = false;
               }
            }
            if(_loc3_)
            {
               if(param2.status.indexOf(31) != -1)
               {
                  param2.currentHp = "1";
                  return;
               }
               if(param2.carryProp && param2.carryProp.name == "振奋精神的头布" && param2.status.indexOf(39) == -1)
               {
                  if(isAffectCarryPropOfNoDie(param2))
                  {
                     return;
                  }
               }
               if(param2.carryProp && param2.carryProp.name == "振奋精神的绑带")
               {
                  if(param2.isUsedPropOfBandage == false)
                  {
                     if(param2.currentHp + param1 == param2.totalHp)
                     {
                        Dialogue.collectDialogue(param2.nickName + "佩戴了振奋精神的绑带\n保住了一点hp");
                        param2.currentHp = "1";
                        param2.isUsedPropOfBandage = true;
                        return;
                     }
                  }
               }
            }
            param2.currentHp = "0";
            if(param2.status.indexOf(13) == -1)
            {
               param2.isWillDie = true;
            }
            if(param2.camp == "camp_of_player")
            {
               _loc4_ = CampOfComputerMedia._currentCamp.myVO;
            }
            else
            {
               _loc4_ = CampOfPlayerMedia._currentCamp.myVO;
            }
            if(_loc4_.status.indexOf(28) != -1)
            {
               _loc4_.status.splice(_loc4_.status.indexOf(28),1);
               if(_loc4_.status.indexOf(13) != -1)
               {
                  _loc4_.status.splice(_loc4_.status.indexOf(13),1);
               }
               GameFacade.getInstance().sendNotification("hp_change",_loc4_.currentHp,_loc4_.camp);
            }
            if(param2.status.indexOf(41) != -1)
            {
               _loc4_.skillOfLast.currentPP = "0";
            }
            return;
         }
         if(param2.currentHp > param2.totalHp)
         {
            param2.currentHp = param2.totalHp;
         }
         return;
         §§push(LogUtil(param2.nickName + "变化后当前hp：" + param2.currentHp));
      }
      
      private static function isAffectCarryPropOfNoDie(param1:ElfVO) : Boolean
      {
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(attacker.camp == "camp_of_player")
            {
               if(FightingConfig.selfOrder.isProtectNoDie == 1)
               {
                  Dialogue.collectDialogue(param1.nickName + "佩戴了振奋精神的头布\n保住了一点hp");
                  param1.currentHp = "1";
                  if(!FightingLogicFactor.isPlayBack)
                  {
                     FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isProtectNoDie = 1;
                  }
                  return true;
               }
            }
            else if(FightingConfig.otherOrder.hasOwnProperty("isProtectNoDie") && FightingConfig.otherOrder.isProtectNoDie == 1)
            {
               Dialogue.collectDialogue(param1.nickName + "佩戴了振奋精神的头布\n保住了一点hp");
               param1.currentHp = "1";
               if(!FightingLogicFactor.isPlayBack)
               {
                  FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isProtectNoDie = 1;
               }
               return true;
            }
         }
         else if(Math.random() * 100 < 10)
         {
            Dialogue.collectDialogue(param1.nickName + "佩戴了振奋精神的头布\n保住了一点hp");
            param1.currentHp = "1";
            if(!FightingLogicFactor.isPlayBack)
            {
               if(attacker.camp == "camp_of_player")
               {
                  FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isProtectNoDie = 1;
               }
               else
               {
                  FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isProtectNoDie = 1;
               }
            }
            return true;
         }
         return false;
      }
      
      public static function tellNextAfterSelfAct(param1:ElfVO, param2:Boolean, param3:String) : void
      {
         if(!FightingMedia.isFighting)
         {
            return;
         }
         GameFacade.getInstance().sendNotification("update_status_show",0,param1.camp);
         GameFacade.getInstance().sendNotification("update_status_show",0,param3);
         if(param2)
         {
            if(param1.isCannotActStatus)
            {
               param1.isCannotActStatus = false;
               LogUtil("结束2");
               GameFacade.getInstance().sendNotification("open_opera");
               return;
            }
            LogUtil("结束3");
            GameFacade.getInstance().sendNotification("open_opera");
         }
         else
         {
            if(param1.isCannotActStatus)
            {
               param1.isCannotActStatus = false;
            }
            GameFacade.getInstance().sendNotification("start_skill",0,param3);
         }
      }
      
      public static function tellNextAfterOtherAct(param1:CampBaseUI, param2:Boolean, param3:String) : void
      {
         var _loc4_:ElfVO = param1.myVO;
         GameFacade.getInstance().sendNotification("update_status_show",0,_loc4_.camp);
         GameFacade.getInstance().sendNotification("update_status_show",0,param3);
         if(param2)
         {
            if(!SkillFactor.storeGasHandler(param1))
            {
               GameFacade.getInstance().sendNotification("start_skill",0,_loc4_.camp);
            }
         }
         else
         {
            GameFacade.getInstance().sendNotification("open_opera");
         }
      }
      
      public static function endHpbarAniHandler(param1:CampBaseUI) : Boolean
      {
         var _loc2_:ElfVO = param1.myVO;
         if(_loc2_.currentHp == 0)
         {
            return false;
         }
         if(FightingLogicFactor.attackNum > 0)
         {
            GameFacade.getInstance().sendNotification("continue_beattacked");
            return false;
         }
         return true;
      }
      
      public static function endElfFightHandler(param1:CampBaseUI) : void
      {
         var _loc2_:ElfVO = param1.myVO;
         if(_loc2_.status.indexOf(13) != -1)
         {
            CalculatorFactor.calculatorElf(_loc2_);
            _loc2_.currentHp = _loc2_.hpBeforeAvatars;
            _loc2_.status.splice(_loc2_.status.indexOf(13));
            GameFacade.getInstance().sendNotification("avatars_end",0,_loc2_.camp);
         }
         else
         {
            GameFacade.getInstance().sendNotification("end_round");
            if(_loc2_.camp == "camp_of_computer")
            {
               _getExp = CalculatorFactor.getExpCalculator(_loc2_);
               _getEffort = _loc2_.dropEffort;
            }
            AniFactor.endEleFightAni(param1.elf,param1.statusBar);
         }
      }
      
      public static function playEffectMusic() : void
      {
         LogUtil("效果音" + FightingConfig.attackEffect);
         SoundEvent.removeEventListener("PLAY_ONCE_COMPLETE",playEffectMusic);
         if(FightingConfig.attackEffect == 2)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","goodEffect");
         }
         else if(FightingConfig.attackEffect == 1)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","normalEffect");
         }
         else if(FightingConfig.attackEffect == 3)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","noEffect");
         }
         FightingConfig.attackEffect = 0;
         if(usedSkill.name != "变身")
         {
            GameFacade.getInstance().sendNotification("camp_be_attack",hurtNum,beAttackedType);
         }
         hurtNum = 0;
      }
      
      public static function dialogueAndNext(param1:String, param2:String) : void
      {
         if(Config.isAutoFighting || FightingLogicFactor.isPVP || LoadPageCmd.lastPage is ElfSeriesUI || FightingLogicFactor.isPlayBack)
         {
            Dialogue.updateDialogue(param1);
            Starling.juggler.delayCall(autoNext,Config.dialogueDelay,param2);
            return;
         }
         Dialogue.updateDialogue(param1,true,param2);
      }
      
      private static function autoNext(param1:String) : void
      {
         LogUtil("自动下一步啦大佬" + param1);
         Dialogue.removeFormParent();
         Dialogue.playCallBack();
         GameFacade.getInstance().sendNotification("next_dialogue",param1);
      }
      
      public static function get attackNum() : int
      {
         return _attackNum;
      }
      
      public static function get attackSuccessNum() : int
      {
         return _attackSuccessNum;
      }
      
      public static function get isFirstOfOurs() : Boolean
      {
         return _isFirstOfOurs;
      }
      
      public static function set isFirstOfOurs(param1:Boolean) : void
      {
         _isFirstOfOurs = param1;
      }
      
      public static function get getExp() : String
      {
         return _getExp;
      }
      
      public static function get getEffort() : Array
      {
         return _getEffort;
      }
      
      public static function handLandStar(param1:CampBaseUI) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         LogUtil("什么情况啊 " + param1.landStar);
         if(param1.landStar > 0)
         {
            if(FeatureFactor.isFloatImmunityLandstar(param1.myVO))
            {
               return;
            }
            _loc2_ = param1.myVO;
            if(param1.landStar == 1)
            {
               _loc3_ = _loc2_.totalHp / 8;
            }
            if(param1.landStar == 2)
            {
               _loc3_ = _loc2_.totalHp / 6;
            }
            if(param1.landStar == 3)
            {
               _loc3_ = _loc2_.totalHp / 4;
            }
            LogUtil("什么情况啊 ssssssss" + _loc3_);
            Dialogue.collectDialogue(_loc2_.nickName + "因为满地星\n损失了" + _loc3_ + "点HP");
            GameFacade.getInstance().sendNotification("hp_change",_loc3_,_loc2_.camp);
         }
      }
      
      public static function relayHandler(param1:ElfVO, param2:ElfVO) : void
      {
         param1.ablilityAddLv = param2.ablilityAddLv;
         if(param2.status.indexOf(7) != -1)
         {
            param1.status.push(7);
            param1.mullCount = param2.mullCount;
         }
         if(param2.status.indexOf(25) != -1)
         {
            param1.status.push(25);
         }
         if(param2.status.indexOf(12) != -1)
         {
            param1.status.push(12);
         }
         if(param2.status.indexOf(10) != -1)
         {
            param1.status.push(10);
         }
         if(param2.status.indexOf(23) != -1)
         {
            param1.status.push(23);
         }
      }
   }
}
