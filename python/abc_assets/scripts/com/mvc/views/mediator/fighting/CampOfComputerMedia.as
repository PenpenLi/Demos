package com.mvc.views.mediator.fighting
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.fighting.CampOfComputerUI;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.views.uis.fighting.CampBaseUI;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.common.util.dialogue.Dialogue;
   import extend.SoundEvent;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.IsAllElfDie;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.common.util.loading.PVPLoading;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.huntingParty.HuntingPartyUI;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   import com.mvc.models.proxy.fighting.FightingPro;
   import com.common.util.RewardHandle;
   import com.common.themes.Tips;
   import com.mvc.GameFacade;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.events.Event;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import lzm.util.HttpClient;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetElfQuality;
   import starling.display.DisplayObject;
   
   public class CampOfComputerMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "CampOfComputerMedia";
      
      public static var campUI:CampOfComputerUI;
      
      private static var fightingElf:ElfVO;
      
      private static var _isWaitChangeElf:Boolean;
       
      private var lessBooldNum:int;
      
      private var statusMark:int;
      
      private var isRelay:Boolean;
      
      private var isTellNextAfterSelf:Boolean;
      
      private var isChangeElfFromSkill:Boolean;
      
      private var prayAddHp:int;
      
      public function CampOfComputerMedia(param1:Object = null)
      {
         super("CampOfComputerMedia",param1);
         campUI = param1 as CampOfComputerUI;
      }
      
      public static function get _currentSkillVO() : SkillVO
      {
         return fightingElf.currentSkill;
      }
      
      public static function get _currentCamp() : CampBaseUI
      {
         return campUI;
      }
      
      public static function get isCurrentElfDie() : Boolean
      {
         if(campUI == null)
         {
            return true;
         }
         if(campUI.myVO != null)
         {
            return campUI.myVO.isWillDie;
         }
         return true;
      }
      
      public static function get isAllElfDie() : Boolean
      {
         var _loc2_:* = false;
         var _loc1_:* = 0;
         if(NPCVO.bagElfVec.length == 0)
         {
            return fightingElf.isWillDie;
         }
         _loc2_ = true;
         _loc1_ = 0;
         while(_loc1_ < NPCVO.bagElfVec.length)
         {
            LogUtil(NPCVO.bagElfVec[_loc1_].nickName + "的当前血量：" + NPCVO.bagElfVec[_loc1_].currentHp);
            if(NPCVO.bagElfVec[_loc1_].currentHp > 0)
            {
               _loc2_ = false;
               break;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public static function get lessElfNum() : int
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < NPCVO.bagElfVec.length)
         {
            if(NPCVO.bagElfVec[_loc2_].currentHp > 0)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function get isWaitChangeElf() : Boolean
      {
         return _isWaitChangeElf;
      }
      
      private function tellBadEffectAtEndFight() : void
      {
         if(FightingMedia.isFighting == false)
         {
            return;
         }
         FightingLogicFactor.tellBadEffect();
         afterCurIsDie();
      }
      
      private function tellEndElfFight() : void
      {
         Dialogue.playCollectDialogue(function():void
         {
            if(FightingMedia.isFighting == false)
            {
               return;
            }
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + fightingElf.sound);
            campUI.shadow.scaleX = 0;
            FightingLogicFactor.endElfFightHandler(campUI);
         });
      }
      
      private function afterCurIsDie() : void
      {
         LogUtil("倒下啦大佬！！！");
         FightingLogicFactor.dialogueAndNext(fightingElf.nickName + "倒下了!","get_exp");
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc5_:* = null;
         var _loc3_:* = NaN;
         var _loc9_:* = 0;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = false;
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc11_:* = param1.getName();
         if("ready_skill" !== _loc11_)
         {
            if("update_fighting_ele" !== _loc11_)
            {
               if("start_avatars" !== _loc11_)
               {
                  if("avatars_end" !== _loc11_)
                  {
                     if("camp_be_attack" !== _loc11_)
                     {
                        if("start_skill" !== _loc11_)
                        {
                           if("tell_after_self_act" !== _loc11_)
                           {
                              if("hp_change" !== _loc11_)
                              {
                                 if("can_not_action" !== _loc11_)
                                 {
                                    if("next_dialogue" !== _loc11_)
                                    {
                                       if("load_elf_of_be_catch" !== _loc11_)
                                       {
                                          if("request_catch" !== _loc11_)
                                          {
                                             if("catch_elf_end" !== _loc11_)
                                             {
                                                if("elf_set_name_complete" !== _loc11_)
                                                {
                                                   if("save_catch_elf_result" !== _loc11_)
                                                   {
                                                      if("update_status_show" !== _loc11_)
                                                      {
                                                         if("change_elf" !== _loc11_)
                                                         {
                                                            if("no_hp" !== _loc11_)
                                                            {
                                                               if("end_hpbar_ani" !== _loc11_)
                                                               {
                                                                  if("ready_skill_from_sever" !== _loc11_)
                                                                  {
                                                                     if("receive_elf_id" !== _loc11_)
                                                                     {
                                                                        if("change_elf_on_play_back" === _loc11_)
                                                                        {
                                                                           if(fightingElf == null)
                                                                           {
                                                                              return;
                                                                           }
                                                                           if(param1.getType() == fightingElf.camp)
                                                                           {
                                                                              FightingConfig.isPlayerActAfterChangeElf = param1.getBody();
                                                                              LogUtil("换精灵后是否玩家方行动" + FightingConfig.isPlayerActAfterChangeElf);
                                                                              NPCVO.isChangeElf = true;
                                                                              GameFacade.getInstance().sendNotification("update_fighting_ele",getTargetElf(FightingConfig.otherOrder.selectElf),fightingElf.camp);
                                                                           }
                                                                        }
                                                                     }
                                                                     else
                                                                     {
                                                                        LogUtil("PVP换精灵" + param1.getBody() as int);
                                                                        if(!FightingLogicFactor.isPVP)
                                                                        {
                                                                           return;
                                                                        }
                                                                        if(!FightingLogicFactor.isPVP)
                                                                        {
                                                                           return;
                                                                        }
                                                                        if(FightingConfig.pvpSwitch == 2)
                                                                        {
                                                                           FightingLogicFactor.isRounding = true;
                                                                        }
                                                                        NPCVO.isChangeElf = true;
                                                                        FightingLogicFactor.replyChange(fightingElf);
                                                                        sendNotification("update_fighting_ele",getTargetElf(param1.getBody() as int),"camp_of_computer");
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     if(FightingMedia.isFighting == false)
                                                                     {
                                                                        return;
                                                                     }
                                                                     if(param1.getBody() == -1)
                                                                     {
                                                                        return;
                                                                     }
                                                                     if(param1.getBody() == 165)
                                                                     {
                                                                        fightingElf.currentSkill = null;
                                                                     }
                                                                     else
                                                                     {
                                                                        SkillFactor.readySkill(fightingElf,param1.getBody() as int,CampOfPlayerMedia._currentCamp.myVO);
                                                                     }
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  if(fightingElf == null)
                                                                  {
                                                                     return;
                                                                  }
                                                                  if(param1.getType() == fightingElf.camp)
                                                                  {
                                                                     endHpbarAniHandler();
                                                                  }
                                                               }
                                                            }
                                                            else
                                                            {
                                                               if(fightingElf == null)
                                                               {
                                                                  return;
                                                               }
                                                               if(param1.getType() == fightingElf.camp)
                                                               {
                                                                  tellEndElfFight();
                                                               }
                                                            }
                                                         }
                                                         else
                                                         {
                                                            if(fightingElf == null)
                                                            {
                                                               return;
                                                            }
                                                            if(param1.getType() == fightingElf.camp)
                                                            {
                                                               FightingConfig.initSelfOrder();
                                                               NPCVO.isChangeElf = true;
                                                               isChangeElfFromSkill = true;
                                                               FightingLogicFactor.replyChange(fightingElf);
                                                               sendNotification("update_fighting_ele",FightingAI.getNextElf(NPCVO.bagElfVec,fightingElf),"camp_of_computer");
                                                            }
                                                         }
                                                      }
                                                      else if(param1.getType() == "camp_of_computer")
                                                      {
                                                         campUI.upDateStatusShow();
                                                      }
                                                   }
                                                   else
                                                   {
                                                      _loc4_ = param1.getBody();
                                                      if(_loc4_.pos == 1)
                                                      {
                                                         sendNotification("UPDATE_BAG_ELF");
                                                      }
                                                      else
                                                      {
                                                         sendNotification("UPDATE_COM_ELF");
                                                      }
                                                      FightingConfig.isWin = true;
                                                      sendNotification("adventure_result",0,"catch_elf_success");
                                                      sendNotification("next_dialogue","END_FIGHTING");
                                                   }
                                                }
                                                else
                                                {
                                                   saveElfOfCatch();
                                                }
                                             }
                                             else
                                             {
                                                if(fightingElf == null)
                                                {
                                                   return;
                                                }
                                                _loc2_ = CampOfPlayerMedia.catchResult;
                                                if(_loc2_.res == 1)
                                                {
                                                   campUI.elf.visible = false;
                                                   campUI.statusBar.visible = false;
                                                   if(LoadPageCmd.lastPage is HuntingPartyUI)
                                                   {
                                                      RewardHandle.Reward(HuntingPartyPro.reward);
                                                      Tips.show("捕捉成功，获得" + HuntingPartyPro.reward.catchScore + "捕虫大会积分");
                                                      return;
                                                   }
                                                   fightingElf.nickName = fightingElf.name;
                                                   initElfVo(fightingElf);
                                                   Dialogue.updateDialogue("咣当!" + fightingElf.name + "被收服了\n可在图鉴看到" + fightingElf.name + "的详细信息",true,"catch_elf_success");
                                                }
                                                else if(_loc2_.res == 5)
                                                {
                                                   Dialogue.collectDialogue("训练师挡下了精灵球\n不要做贼。（野外遇到的精灵可捕捉）");
                                                   Dialogue.playCollectDialogue(FightingLogicFactor.computerActHandler);
                                                }
                                                else
                                                {
                                                   campUI.elfAwayFromElfBallAni();
                                                   Dialogue.collectDialogue("真遗憾\n" + fightingElf.name + "从精灵球里跳了出来!");
                                                   Dialogue.playCollectDialogue(FightingLogicFactor.computerActHandler);
                                                }
                                             }
                                          }
                                          else
                                          {
                                             _loc7_ = param1.getBody() as PropVO;
                                             if(NPCVO.name == null)
                                             {
                                                _loc8_ = false;
                                             }
                                             else
                                             {
                                                _loc8_ = true;
                                             }
                                             if(LoadPageCmd.lastPage is HuntingPartyUI)
                                             {
                                                (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4120(fightingElf,_loc7_);
                                                return;
                                             }
                                             (facade.retrieveProxy("FightingPro") as FightingPro).write1501(fightingElf,_loc7_,_loc8_);
                                          }
                                       }
                                       else
                                       {
                                          campUI.elfBeCatchAni();
                                       }
                                    }
                                    else if(param1.getBody() == "npc_use_elf")
                                    {
                                       campUI.npcImageOutAni();
                                       Dialogue.updateDialogue("精灵训练师" + NPCVO.name + "\n使用了" + fightingElf.name);
                                       npcElfCome();
                                    }
                                    else if(param1.getBody() == "get_exp_complete")
                                    {
                                       if(isAllElfDie)
                                       {
                                          sendNotification("next_dialogue","END_FIGHTING");
                                       }
                                       else if(!CampOfPlayerMedia.isAllElfDie)
                                       {
                                          if(FightingLogicFactor.isPVP)
                                          {
                                             FightingConfig.initSelfOrder();
                                             if(!CampOfPlayerMedia.isCurrentElfDie)
                                             {
                                                LogUtil("电脑倒下了");
                                                if(FightingConfig.otherSelectElfAfterDie == -1)
                                                {
                                                   sendNotification("pvp_timer_stop");
                                                   PVPLoading.addLoading(true,true);
                                                   FightingConfig.pvpSwitch = 5;
                                                }
                                                else
                                                {
                                                   if(Config.configInfo.hasOwnProperty("isPvpSetNull"))
                                                   {
                                                      FightingConfig.otherOrder = null;
                                                   }
                                                   _loc9_ = FightingConfig.otherSelectElfAfterDie;
                                                   FightingConfig.otherSelectElfAfterDie = -1;
                                                   sendNotification("receive_elf_id",_loc9_);
                                                }
                                             }
                                          }
                                          else if(FightingLogicFactor.isPlayBack)
                                          {
                                             if(FightingLogicFactor.isPlayBackFromPvp && CampOfPlayerMedia.isCurrentElfDie)
                                             {
                                                _isWaitChangeElf = true;
                                                return;
                                             }
                                             FightingConfig.initSelfOrder();
                                             sendNotification("receive_elf_id",FightingConfig.otherOrder.selectElf);
                                          }
                                          else
                                          {
                                             FightingConfig.initSelfOrder();
                                             NPCVO.isChangeElf = true;
                                             sendNotification("update_fighting_ele",FightingAI.getNextElf(NPCVO.bagElfVec,fightingElf),"camp_of_computer");
                                          }
                                       }
                                    }
                                    else if(param1.getBody() == "catch_elf_success")
                                    {
                                       _loc6_ = Alert.show("给" + fightingElf.name + "取一个名称么？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                                       _loc6_.addEventListener("close",changeNameHandler);
                                    }
                                 }
                                 else
                                 {
                                    if(fightingElf == null)
                                    {
                                       return;
                                    }
                                    if(param1.getType() == "camp_of_computer")
                                    {
                                       fightingElf.isCannotActStatus = true;
                                    }
                                 }
                              }
                              else
                              {
                                 if(fightingElf == null || !FightingMedia.isFighting)
                                 {
                                    return;
                                 }
                                 if(param1.getType() == "camp_of_computer")
                                 {
                                    if(fightingElf.currentHp == "0")
                                    {
                                       return;
                                    }
                                    if(param1.getBody().hasOwnProperty("status"))
                                    {
                                       lessBooldNum = param1.getBody().lessNum;
                                       statusMark = param1.getBody().status;
                                    }
                                    else
                                    {
                                       lessBooldNum = param1.getBody() as int;
                                       statusMark = 0;
                                    }
                                    LogUtil("电脑方改变Hp" + lessBooldNum + "：是否有状态：" + param1.getBody().hasOwnProperty("status"));
                                    FightingLogicFactor.hpChangeHandler(lessBooldNum,fightingElf);
                                    Dialogue.playCollectDialogue(hpChange);
                                 }
                              }
                           }
                           else
                           {
                              if(CampOfPlayerMedia.isCurrentElfDie || isCurrentElfDie)
                              {
                                 return;
                              }
                              if(param1.getType() == "camp_of_computer")
                              {
                                 attackFailed(param1.getBody() as String);
                              }
                           }
                        }
                        else if(param1.getType() == "camp_of_computer")
                        {
                           if(CampOfPlayerMedia.isCurrentElfDie || isCurrentElfDie)
                           {
                              return;
                           }
                           _loc3_ = Math.random() * 8;
                           LogUtil(fightingElf.isSpecial + "是否神兽" + FightingConfig.cannotGoAwayRount + "随机数" + _loc3_);
                           if(NPCVO.name == null && fightingElf.isSpecial && _loc3_ < 1 && FightingConfig.cannotGoAwayRount <= 0 && fightingElf.status.indexOf(6) == -1 && fightingElf.status.indexOf(8) == -1)
                           {
                              fightingElf.isGoOut = true;
                           }
                           LogUtil("电脑方释放技能");
                           if(fightingElf.currentSkill == null)
                           {
                              selectSkill();
                           }
                           if(fightingElf.status.indexOf(41) != -1)
                           {
                              fightingElf.status.splice(fightingElf.status.indexOf(41),1);
                           }
                           Dialogue.playCollectDialogue(startSkill);
                        }
                        else if(fightingElf && fightingElf.status.indexOf(28) != -1)
                        {
                           fightingElf.status.splice(fightingElf.status.indexOf(28),1);
                           campUI.upDateStatusShow();
                        }
                     }
                     else
                     {
                        if(fightingElf == null)
                        {
                           return;
                        }
                        if(param1.getType() == "camp_of_computer")
                        {
                           if(fightingElf.currentSkill != null && fightingElf.status.indexOf(13) == -1 && fightingElf.currentSkill.name == "愤怒")
                           {
                              var _loc10_:* = 0;
                              _loc11_ = fightingElf.ablilityAddLv[_loc10_] + 1;
                              fightingElf.ablilityAddLv[_loc10_] = _loc11_;
                              Dialogue.collectDialogue(fightingElf.name + "陷入了愤怒状态\n攻击力提升了");
                              fightingElf.status.push(16);
                           }
                           FightingLogicFactor.hpChangeHandler(param1.getBody() as int,fightingElf);
                           AniFactor.beAttackAni(campUI.elf);
                        }
                     }
                  }
                  else if(param1.getType() == "camp_of_computer")
                  {
                     Dialogue.playCollectDialogue(avatarEnd);
                  }
               }
               else if(param1.getType() == "camp_of_computer")
               {
                  campUI.starAvatar();
                  addEvent();
               }
            }
            else
            {
               if(IsAllElfDie.isAllElfDie())
               {
                  return;
               }
               if(param1.getType() == "camp_of_computer")
               {
                  _isWaitChangeElf = false;
                  _loc5_ = param1.getBody() as ElfVO;
                  if(!FightingLogicFactor.isPlayBack && FightingConfig.otherOrderVec.length > 0)
                  {
                     FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].selectElf = _loc5_.id;
                     LogUtil("换精灵命令" + JSON.stringify(FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1]));
                  }
                  if(isRelay)
                  {
                     FightingLogicFactor.relayHandler(_loc5_,fightingElf);
                     if(FightingLogicFactor.isFirstOfOurs)
                     {
                        isTellNextAfterSelf = false;
                     }
                     else
                     {
                        isTellNextAfterSelf = true;
                     }
                  }
                  (facade.retrieveProxy("IllustrationsPro") as IllustrationsPro).write1302(_loc5_.elfId);
                  _loc5_.camp = "camp_of_computer";
                  _loc5_.nickName = "对手" + _loc5_.nickName;
                  if(_loc5_.status.indexOf(18) == -1)
                  {
                     CalculatorFactor.calculatorElf(_loc5_);
                     initElfOfOut();
                     if(isChangeElfFromSkill || isRelay)
                     {
                        Dialogue.updateDialogue(NPCVO.name + "交换出" + _loc5_.name);
                     }
                     else
                     {
                        Dialogue.updateDialogue("......");
                     }
                  }
                  else
                  {
                     fightingElf.nickName = fightingElf.nickName.substr(2);
                     Dialogue.updateDialogue(_loc5_.name + "变身");
                  }
                  campUI.myVO = _loc5_;
                  fightingElf = _loc5_;
                  addEvent();
                  fightingElf.isWillDie = true;
                  fightingElf.skillOfLast = null;
                  startAni();
                  if(NPCVO.name == null && fightingElf.isSpecial && _loc5_.status.indexOf(18) == -1)
                  {
                     FightingConfig.cannotGoAwayRount = "3";
                  }
               }
               else
               {
                  if(fightingElf && fightingElf.status.indexOf(8) != -1)
                  {
                     fightingElf.status.splice(fightingElf.status.indexOf(8),1);
                     campUI.upDateStatusShow();
                  }
                  if(fightingElf && fightingElf.status.indexOf(28) != -1)
                  {
                     fightingElf.status.splice(fightingElf.status.indexOf(28),1);
                     campUI.upDateStatusShow();
                  }
               }
            }
         }
         else if(param1.getType() == "camp_of_computer")
         {
            if(fightingElf.currentSkill != null && fightingElf.currentSkill.continueSkillCount > 0)
            {
               return;
            }
            if(fightingElf.currentSkill != null && fightingElf.isStoreGas)
            {
               return;
            }
            selectSkill();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["camp_be_attack","update_fighting_ele","start_avatars","change_elf","ready_skill","start_skill","elf_set_name_complete","end_hpbar_ani","tell_after_self_act","hp_change","save_catch_elf_result","no_hp","request_catch","catch_elf_end","load_elf_of_be_catch","ready_skill_from_sever","receive_elf_id","change_elf_on_play_back","can_not_action","next_dialogue","avatars_end","update_status_show"];
      }
      
      private function avatarEnd() : void
      {
         if(FightingMedia.isFighting == false)
         {
            return;
         }
         if(FightingLogicFactor.badEffectNum > 0)
         {
            FightingLogicFactor.tellBadEffect();
         }
         fightingElf.isWillDie = false;
         Dialogue.updateDialogue(fightingElf.nickName + "替身结束");
         campUI.avatarsEnd();
         addEvent();
         campUI.elf.scaleX = 0;
         var t:Tween = new Tween(campUI.elf,1,"easeOutElastic");
         Starling.juggler.add(t);
         t.delay = 0.5;
         t.animate("scaleX",1);
         t.onComplete = function():void
         {
            if(FightingLogicFactor.isRounding == false)
            {
               Dialogue.removeFormParent();
               return;
            }
            if(fightingElf.currentSkill != null && fightingElf.currentSkill.id == 174)
            {
               if(FightingLogicFactor.isFirstOfOurs)
               {
                  if(fightingElf.skillOfLast != null && fightingElf.currentSkill.id == fightingElf.skillOfLast.id)
                  {
                     sendNotification("open_opera");
                  }
                  else
                  {
                     tellNextAfterOtherAct();
                  }
               }
               return;
            }
            if(fightingElf.currentSkill != null && fightingElf.currentSkill.id == 164)
            {
               sendNotification("open_opera");
               return;
            }
            if(fightingElf.currentSkill != null)
            {
               tellNextAfterOtherAct();
            }
            else
            {
               sendNotification("open_opera");
            }
         };
         campUI.upDateStatusShow();
      }
      
      private function hpChange() : void
      {
         if(fightingElf == null || !FightingMedia.isFighting)
         {
            return;
         }
         if(lessBooldNum > 0 && fightingElf.status.indexOf(19) == -1 && fightingElf.status.indexOf(20) == -1)
         {
            AniFactor.hurtSelfAni(campUI.elf);
         }
         if(fightingElf.status.indexOf(19) == -1 && fightingElf.status.indexOf(20) == -1)
         {
            SkillFactor.playStatusEffect(statusMark,campUI);
         }
         playBooldBarAni(false);
      }
      
      private function changeNameHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            sendNotification("switch_win",campUI.parent,"LOAD_ELFNAME_WIN");
            sendNotification("SEND_SETNAME_ELF",fightingElf);
         }
         else
         {
            saveElfOfCatch();
         }
      }
      
      private function saveElfOfCatch() : void
      {
         initElfOfOut(false);
         (facade.retrieveProxy("FightingPro") as FightingPro as FightingPro).write1502(fightingElf);
      }
      
      private function startAni() : void
      {
         if(fightingElf.status.indexOf(18) != -1)
         {
            npcElfCome();
            return;
         }
         if(NPCVO.name == null)
         {
            campUI.elf.x = -130;
            outSideElfCome();
         }
         else
         {
            campUI.elf.scaleX = 0;
            LogUtil("是否交换精灵" + NPCVO.isChangeElf);
            if(!NPCVO.isChangeElf)
            {
               campUI.npcImageComeAni();
               FightingLogicFactor.dialogueAndNext("精灵训练师" + NPCVO.name + "\n比试胜负来了","npc_use_elf");
            }
            else
            {
               NPCVO.isChangeElf = false;
               npcElfCome();
            }
         }
      }
      
      private function addEvent() : void
      {
         if(!campUI.elf.hasEventListener("end_attack_ani"))
         {
            campUI.elf.addEventListener("end_attack_ani",endAttackAniHandler);
            campUI.elf.addEventListener("end_hurt_ani",endHurtAni);
            campUI.elf.addEventListener("end_help_skill_ani",tellNextAfterSelfAct);
            campUI.elf.addEventListener("ELF_WILL_DIE",elfWillDieHandler);
         }
      }
      
      private function selectSkill() : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         if((fightingElf.isSpecial || NPCVO.isSpecial) && fightingElf.currentHp <= fightingElf.totalHp * 0.1)
         {
            if(Math.random() * 100 < 15)
            {
               _loc3_ = 0;
               while(_loc3_ < fightingElf.currentSkillVec.length)
               {
                  if(fightingElf.currentSkillVec[_loc3_].effectForSelf[0] == 7 && fightingElf.currentSkillVec[_loc3_].currentPP > 0)
                  {
                     SkillFactor.readySkill(fightingElf,_loc3_,CampOfPlayerMedia._currentCamp.myVO);
                     return;
                  }
                  _loc3_++;
               }
            }
         }
         var _loc1_:int = FightingAI.selectSkillAI(fightingElf,CampOfPlayerMedia._currentCamp.myVO);
         if(!FightingLogicFactor.isPlayBack)
         {
            FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].selectSkill = _loc1_;
         }
         LogUtil(_loc1_ + "电脑使用第几个技能");
         if(fightingElf.currentSkillVec[_loc1_].currentPP == 0)
         {
            _loc2_ = 0;
            while(_loc2_ < fightingElf.currentSkillVec.length)
            {
               if(fightingElf.currentSkillVec[_loc2_].currentPP > 0)
               {
                  SkillFactor.readySkill(fightingElf,_loc2_,CampOfPlayerMedia._currentCamp.myVO);
                  return;
               }
               _loc2_++;
            }
            fightingElf.currentSkill = null;
            return;
         }
         SkillFactor.readySkill(fightingElf,_loc1_,CampOfPlayerMedia._currentCamp.myVO);
      }
      
      private function elfWillDieHandler() : void
      {
         if(FightingLogicFactor.badEffectNum > 0)
         {
            Dialogue.collectDialogue(FightingLogicFactor.attacker.name + "受到自己技能的伤害");
            Dialogue.playCollectDialogue(tellBadEffectAtEndFight);
         }
         else
         {
            afterCurIsDie();
         }
      }
      
      private function outSideElfCome() : void
      {
         if(IllustrationsPro.markStr[campUI.myVO.elfId - 1] == 2)
         {
            campUI.elfBall.visible = true;
         }
         else
         {
            campUI.elfBall.visible = false;
         }
         var t:Tween = new Tween(campUI.elf,1,"easeOut");
         Starling.juggler.add(t);
         t.animate("x",870);
         t.delay = 0.2;
         t.onComplete = function():void
         {
            campUI.shadow.scaleX = 1;
            campUI.shadow.scaleY = 1;
            campUI.shadow.alpha = 0;
            var _loc1_:Tween = new Tween(campUI.shadow,0.3,"easeOut");
            Starling.juggler.add(_loc1_);
            _loc1_.animate("alpha",0.7,0);
         };
         var t2:Tween = new Tween(campUI.statusBar,0.5,"easeOut");
         t2.animate("x",campUI.statusX);
         t.nextTween = t2;
         t2.onComplete = function():void
         {
            fightingElf.isWillDie = false;
            var _loc1_:String = "野生的" + fightingElf.name + "跳了出来!";
            FightingLogicFactor.dialogueAndNext(_loc1_,"call_my_elf");
         };
      }
      
      private function npcElfCome() : void
      {
         var delay:Number = 0.0;
         if(fightingElf.status.indexOf(18) == -1)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","throwElf");
            campUI.throwBallAni();
            delay = 1.0;
         }
         campUI.elf.scaleY = 0;
         campUI.shadow.scaleY = 0;
         var t:Tween = new Tween(campUI.elf,1.1,"easeOutElastic");
         Starling.juggler.add(t);
         t.animate("scaleX",1);
         t.animate("scaleY",1);
         t.delay = delay;
         var t3:Tween = new Tween(campUI.shadow,1.1,"easeOutElastic");
         Starling.juggler.add(t3);
         t3.animate("scaleX",1);
         t3.animate("scaleY",1);
         t3.delay = delay;
         var t2:Tween = new Tween(campUI.statusBar,0.5,"easeOut");
         Starling.juggler.add(t2);
         t2.animate("x",campUI.statusX);
         t2.delay = delay + 0.3;
         t.onComplete = function():void
         {
            var _loc1_:* = null;
            if(prayAddHp > 0)
            {
               Dialogue.collectDialogue(fightingElf.nickName + "因为伙伴的祈求\n回复了HP");
               sendNotification("hp_change",-prayAddHp,fightingElf.camp);
               prayAddHp = 0;
            }
            FightingLogicFactor.handLandStar(campUI);
            campUI.shadow.scaleY = 1;
            fightingElf.isWillDie = false;
            if(fightingElf.status.indexOf(18) != -1)
            {
               tellNextAfterSelfAct();
               return;
            }
            if(isRelay)
            {
               isRelay = false;
               if(isTellNextAfterSelf)
               {
                  tellNextAfterSelfAct();
               }
               else
               {
                  sendNotification("open_opera");
               }
               return;
            }
            if(isChangeElfFromSkill)
            {
               isChangeElfFromSkill = false;
               sendNotification("open_opera");
            }
            else
            {
               SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + fightingElf.sound);
               _loc1_ = NPCVO.name + "派出了" + fightingElf.name;
               if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
               {
                  FightingLogicFactor.dialogueAndNext(_loc1_,"change_elf_on_pvp");
               }
               else
               {
                  FightingLogicFactor.dialogueAndNext(_loc1_,"call_my_elf");
               }
            }
         };
      }
      
      private function startSkill() : void
      {
         if(FightingMedia.isFighting == false)
         {
            return;
         }
         if(CampOfPlayerMedia.isCurrentElfDie || isCurrentElfDie)
         {
            clearAnger();
            return;
         }
         FightingLogicFactor.isRounding = true;
         if(fightingElf.isGoOut)
         {
            FightingConfig.isWin = false;
            clearAnger();
            fightingElf.isGoOut = false;
            Dialogue.updateDialogue(fightingElf.name + "逃跑了!",true,"END_FIGHTING");
            var str:String = fightingElf.name + "逃跑了!" + "\n<font color=\'#1c6b04\' size=\'21\'>( 亲, 使用喷雾剂能防止神兽逃跑哦 )</font>";
            Alert.show(str,"",new ListCollection([{"label":"确定"}]));
            return;
         }
         if(NPCVO.isUseProp)
         {
            clearAnger();
            NPCVO.isUseProp = false;
            sendNotification("hp_change",-fightingElf.totalHp,fightingElf.camp);
            attackFailed(NPCVO.name + "使用了最大补血剂");
            return;
         }
         if(fightingElf.isCannotActStatus)
         {
            clearAnger();
            attackFailed(fightingElf.name + "不能行动");
            fightingElf.isCannotActStatus = false;
            return;
         }
         if(fightingElf.currentSkill == null)
         {
            clearAnger();
            var random:int = Math.random() * 100;
            if(FightingLogicFactor.isPlayBack)
            {
               if(FightingConfig.otherOrder.isUseProp == 1)
               {
                  random = 0;
               }
               else
               {
                  random = 100;
               }
            }
            if(random > 50 || NPCVO.name == null || FightingLogicFactor.isPVP)
            {
               if(!FightingLogicFactor.isPlayBack)
               {
                  FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isUseProp = 0;
               }
               fightingElf.currentSkill = GetElfFactor.getSkillById(165);
               if(StatusFactor.statusHandlerBeforeSkillStart(campUI,"camp_of_player") == false)
               {
                  SkillFactor.startSkill(campUI,CampOfPlayerMedia._currentCamp);
               }
            }
            else
            {
               if(!FightingLogicFactor.isPlayBack)
               {
                  FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isUseProp = 1;
               }
               var j:int = 0;
               while(j < fightingElf.currentSkillVec.length)
               {
                  fightingElf.currentSkillVec[j].currentPP = fightingElf.currentSkillVec[j].totalPP;
                  j = j + 1;
               }
               GameFacade.getInstance().sendNotification("tell_after_self_act",NPCVO.name + "使用了pp全补剂",fightingElf.camp);
            }
            return;
         }
         if(fightingElf.status.indexOf(16) != -1 && fightingElf.currentSkill.name != "愤怒")
         {
            var _loc2_:* = 0;
            var _loc3_:* = fightingElf.ablilityAddLv[_loc2_] - 1;
            fightingElf.ablilityAddLv[_loc2_] = _loc3_;
            fightingElf.status.splice(fightingElf.status.indexOf(16),1);
            campUI.upDateStatusShow();
         }
         if(fightingElf.status.indexOf(17) != -1)
         {
            sendNotification("tell_after_self_act",fightingElf.nickName + "在忍耐",fightingElf.camp);
            return;
         }
         if(fightingElf.isReleaseAnger)
         {
            var skill:SkillVO = GetElfFactor.getSkillById(117);
            var callBack:Function = function():void
            {
               skill = null;
               sendNotification("tell_after_self_act",fightingElf.nickName + "解放它的怒气",fightingElf.camp);
               sendNotification("hp_change",fightingElf.tolerHurt * 2,"camp_of_player");
               fightingElf.tolerHurt = 0;
               fightingElf.isReleaseAnger = false;
            };
            SkillFactor.playSkillEffect(skill,campUI,false,callBack);
            return;
         }
         if(StatusFactor.statusHandlerBeforeSkillStart(campUI,"camp_of_player") == false)
         {
            if(fightingElf.currentSkill.name == "接棒")
            {
               if(NPCVO.name == null || GetElfFactor.bagElfNum(true,false,NPCVO.bagElfVec) == 1)
               {
                  attackFailed(fightingElf.nickName + "使用接棒失败！");
               }
               else
               {
                  NPCVO.isChangeElf = true;
                  isRelay = true;
                  if(!FightingLogicFactor.isPVP && !FightingLogicFactor.isPlayBack)
                  {
                     var targetElf:ElfVO = FightingAI.getNextElf(NPCVO.bagElfVec,fightingElf);
                     FightingLogicFactor.replyChange(fightingElf);
                     sendNotification("update_fighting_ele",targetElf,"camp_of_computer");
                  }
                  else if(FightingConfig.otherSelectElfAfterDie == -1)
                  {
                     sendNotification("pvp_timer_stop");
                     FightingConfig.pvpSwitch = 5;
                     PVPLoading.addLoading(true,true);
                  }
                  else
                  {
                     FightingConfig.otherOrder = null;
                     var elfId:int = FightingConfig.otherSelectElfAfterDie;
                     FightingConfig.otherSelectElfAfterDie = -1;
                     sendNotification("receive_elf_id",elfId);
                  }
               }
               return;
            }
            SkillFactor.startSkill(campUI,CampOfPlayerMedia._currentCamp);
         }
      }
      
      private function clearAnger() : void
      {
         if(fightingElf.status.indexOf(16) != -1)
         {
            var _loc1_:* = 0;
            var _loc2_:* = fightingElf.ablilityAddLv[_loc1_] - 1;
            fightingElf.ablilityAddLv[_loc1_] = _loc2_;
            fightingElf.status.splice(fightingElf.status.indexOf(16),1);
            campUI.upDateStatusShow();
         }
      }
      
      private function endAttackAniHandler() : void
      {
         sendNotification("attack_handler",0,"camp_of_computer");
      }
      
      private function attackFailed(param1:String) : void
      {
         Dialogue.collectDialogue(param1);
         Dialogue.playCollectDialogue(null);
         Starling.juggler.delayCall(tellNextAfterSelfAct,Config.dialogueDelay);
      }
      
      private function tellNextAfterSelfAct() : void
      {
         FightingLogicFactor.tellNextAfterSelfAct(fightingElf,FightingLogicFactor.isFirstOfOurs,"camp_of_player");
      }
      
      private function tellNextAfterOtherAct() : void
      {
         if(FightingMedia.isFighting == false)
         {
            return;
         }
         FightingLogicFactor.tellNextAfterOtherAct(campUI,FightingLogicFactor.isFirstOfOurs,"camp_of_player");
      }
      
      private function endHurtAni() : void
      {
         playBooldBarAni(true);
      }
      
      private function playBooldBarAni(param1:Boolean) : void
      {
         if(fightingElf == null)
         {
            return;
         }
         LogUtil("发生了什么");
         campUI.updateHpShow(param1);
      }
      
      private function endHpbarAniHandler() : void
      {
         if(FightingLogicFactor.endHpbarAniHandler(campUI))
         {
            if(FightingLogicFactor.badEffectNum > 0)
            {
               Dialogue.collectDialogue(FightingLogicFactor.attacker.name + "受到自己技能的伤害");
               Dialogue.playCollectDialogue(tellBadEffectAtNext);
            }
            else
            {
               tellNextAfterOtherAct();
            }
         }
      }
      
      private function tellBadEffectAtNext() : void
      {
         if(FightingMedia.isFighting == false)
         {
            return;
         }
         FightingLogicFactor.tellBadEffect();
         tellNextAfterOtherAct();
      }
      
      private function getTargetElf(param1:int) : ElfVO
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         LogUtil(NPCVO.bagElfVec.length + "精灵个数");
         _loc3_ = 0;
         while(_loc3_ < NPCVO.bagElfVec.length)
         {
            if(NPCVO.bagElfVec[_loc3_] != null)
            {
               LogUtil(NPCVO.bagElfVec[_loc3_].id + "寻找精灵");
               if(NPCVO.bagElfVec[_loc3_].id == param1)
               {
                  return NPCVO.bagElfVec[_loc3_];
               }
            }
            _loc3_++;
         }
         var _loc2_:String = "";
         _loc4_ = 0;
         while(_loc4_ < NPCVO.bagElfVec.length)
         {
            if(NPCVO.bagElfVec[_loc4_] != null)
            {
               _loc2_ = _loc2_ + ("|" + NPCVO.bagElfVec[_loc4_].id);
            }
            _loc4_++;
         }
         HttpClient.send(Game.upLoadUrl,{
            "custom":Game.system,
            "message":NPCVO.useId + "找不到精灵:" + param1 + ":对方的精灵id:" + _loc2_,
            "token":Game.token,
            "userId":PlayerVO.userId,
            "swfVersion":Pocketmon.swfVersion,
            "description":Pocketmon._description
         },null,null,"post");
         return null;
      }
      
      private function initElfOfOut(param1:Boolean = true) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(fightingElf)
         {
            fightingElf.isCannotActStatus = false;
            if(fightingElf.status.indexOf(13) != -1)
            {
               CalculatorFactor.calculatorElf(fightingElf);
               fightingElf.currentHp = fightingElf.hpBeforeAvatars;
               fightingElf.status.splice(fightingElf.status.indexOf(13));
            }
            prayAddHp = 0;
            if(fightingElf.status.indexOf(35) != -1 && !isChangeElfFromSkill)
            {
               prayAddHp = fightingElf.totalHp * 0.5;
            }
            if(fightingElf.status.indexOf(29) != -1)
            {
               fightingElf.status.splice(fightingElf.status.indexOf(29),1);
               if(fightingElf.currentSkill != null && fightingElf.currentSkill.name == "连切")
               {
                  _loc2_ = GetElfFactor.getSkillById(fightingElf.currentSkill.id);
                  fightingElf.currentSkill.power = _loc2_.power;
                  _loc2_ = null;
               }
            }
            _loc3_ = 0;
            while(_loc3_ < StatusFactor.statusClearOnOut.length)
            {
               if(fightingElf.status.indexOf(StatusFactor.statusClearOnOut[_loc3_]) != -1)
               {
                  _loc4_ = fightingElf.status.indexOf(StatusFactor.statusClearOnOut[_loc3_]);
                  fightingElf.status.splice(_loc4_,1);
               }
               _loc3_++;
            }
            if(fightingElf.copykillIndex != -1)
            {
               fightingElf.currentSkillVec[fightingElf.copykillIndex] = null;
               fightingElf.currentSkillVec[fightingElf.copykillIndex] = fightingElf.recordSkBeforeCopy;
               fightingElf.copykillIndex = -1;
            }
            if(fightingElf.currentSkill)
            {
               fightingElf.currentSkill.successRate = 100;
               fightingElf.currentSkill.continueSkillCount = 0;
               fightingElf.currentSkill = null;
            }
            FeatureFactor.clearSpecialStatus(fightingElf);
            FeatureFactor.replyHandler(fightingElf);
            fightingElf.ablilityAddLv = [0,0,0,0,0,0,0];
            fightingElf.isStoreGas = false;
            fightingElf.skillBeforeStrone = null;
            fightingElf.tolerHurt = 0;
            fightingElf.isReleaseAnger = false;
            fightingElf.isHasFiging = false;
            fightingElf.lastHurtOfPhysics = 0;
            fightingElf.lastHurtOfSpecial = 0;
            fightingElf.storeNum = "0";
            fightingElf.mullCount = 0;
            fightingElf.stoneCount = 0;
            fightingElf.tolerCount = 0;
            fightingElf.lessHurtCount = 0;
            fightingElf.protectCount = 0;
            fightingElf.eyeCount = 0;
            fightingElf.powerCount = 0;
            fightingElf.inciteCount = 0;
            fightingElf.prayCount = 0;
            fightingElf.yawnCount = 0;
            fightingElf.blightCount = 0;
            fightingElf.blightHurt = 0;
            fightingElf.skillOfFirstSelect = null;
            if(param1)
            {
               fightingElf.nickName = fightingElf.nickName.substr(2);
            }
         }
      }
      
      private function initElfVo(param1:ElfVO) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         FightingLogicFactor.replyChange(param1);
         if(param1.status.indexOf(13) != -1)
         {
            CalculatorFactor.calculatorElf(param1);
            param1.currentHp = param1.hpBeforeAvatars;
            param1.status.splice(param1.status.indexOf(13));
         }
         if(param1.status.indexOf(29) != -1)
         {
            param1.status.splice(param1.status.indexOf(29),1);
            if(param1.currentSkill != null && param1.currentSkill.name == "连切")
            {
               _loc2_ = GetElfFactor.getSkillById(param1.currentSkill.id);
               param1.currentSkill.power = _loc2_.power;
               _loc2_ = null;
            }
         }
         param1.ablilityAddLv = [0,0,0,0,0,0,0];
         fightingElf.sleepCount = "0";
         fightingElf.status = [];
         fightingElf.brokenLv = "0";
         fightingElf.camp = "camp_of_player";
         fightingElf.starts = fightingElf.originStarts;
         var _loc4_:String = fightingElf.totalHp;
         var _loc5_:String = fightingElf.currentHp;
         if(fightingElf.lv > GetElfQuality.GetelfMaxLv(fightingElf))
         {
            fightingElf.lv = GetElfQuality.GetelfMaxLv(fightingElf);
            fightingElf.currentExp = CalculatorFactor.calculatorLvNeedExp(fightingElf,fightingElf.lv - 1);
         }
         CalculatorFactor.calculatorElf(fightingElf);
         LogUtil(fightingElf.currentExp,fightingElf.lv," (int(fightingElf.totalHp) / int(temTotalHP))",fightingElf.totalHp / _loc4_);
         fightingElf.currentHp = Math.round(fightingElf.totalHp / _loc4_ * _loc5_);
         if(fightingElf.currentHp <= 0)
         {
            fightingElf.currentHp = "1";
         }
         LogUtil("fightingElf.currentHp===",fightingElf.currentHp);
         _loc3_ = 0;
         while(_loc3_ < fightingElf.currentSkillVec.length)
         {
            fightingElf.currentSkillVec[_loc3_].lv = "0";
            _loc3_++;
         }
         if(param1.copykillIndex != -1)
         {
            param1.currentSkillVec[param1.copykillIndex] = null;
            param1.currentSkillVec[param1.copykillIndex] = param1.recordSkBeforeCopy;
            param1.copykillIndex = -1;
         }
         param1.isCannotActStatus = false;
         param1.isStoreGas = false;
         if(param1.currentSkill)
         {
            param1.currentSkill.continueSkillCount = 0;
         }
         param1.currentSkill = null;
         param1.isShareExp = false;
         param1.skillBeforeStrone = null;
         param1.tolerHurt = 0;
         param1.isReleaseAnger = false;
         param1.isHasFiging = false;
         param1.lastHurtOfPhysics = 0;
         param1.lastHurtOfSpecial = 0;
         CalculatorFactor.calculatorElf(param1);
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(campUI.elf != null)
         {
            Starling.juggler.removeTweens(campUI.elf);
            campUI.elf.texture.dispose();
         }
         campUI.disposeMc();
         facade.removeMediator("CampOfComputerMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         campUI = null;
         fightingElf = null;
      }
   }
}
