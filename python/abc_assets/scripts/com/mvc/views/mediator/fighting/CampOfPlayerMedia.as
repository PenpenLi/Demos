package com.mvc.views.mediator.fighting
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.fighting.CampOfPlayerUI;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.views.uis.fighting.CampBaseUI;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.dialogue.Dialogue;
   import extend.SoundEvent;
   import starling.events.EnterFrameEvent;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.views.mediator.mainCity.backPack.PlayElfMedia;
   import com.mvc.models.vos.fighting.NPCVO;
   import starling.core.Starling;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.consts.ConfigConst;
   import starling.animation.Tween;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import com.mvc.GameFacade;
   import com.mvc.models.proxy.fighting.FightingPro;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import lzm.util.LSOManager;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import com.mvc.views.uis.mainCity.hunting.HuntingUI;
   import com.mvc.views.uis.mainCity.kingKwan.KingKwanUI;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.mvc.views.uis.mainCity.trial.TrialUI;
   import com.mvc.views.uis.mainCity.mining.MiningFrameUI;
   import com.mvc.views.uis.login.startChat.StartChatUI;
   import com.mvc.views.uis.huntingParty.HuntingPartyUI;
   import com.common.util.ShowElfAbility;
   import com.mvc.views.mediator.mainCity.backPack.PropFactor;
   import com.mvc.views.uis.fighting.FightingUI;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import starling.display.DisplayObject;
   
   public class CampOfPlayerMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "CampOfPlayerMedia";
      
      private static var campUI:CampOfPlayerUI;
      
      private static var fightingElf:ElfVO;
      
      public static var catchResult:Object;
      
      public static var isRelay:Boolean;
       
      private var shareRange:int = 30;
      
      private var shareSpeed:Number = 0.4;
      
      private var rangeCount:Number = 0;
      
      private var isShare:Boolean;
      
      private var markIsWillChangeElf:Boolean;
      
      private var markIsFirAtkOfPlay:Boolean;
      
      private var lessBooldNum:int;
      
      private var statusMark:int;
      
      private var hasSureFightContinue:Boolean;
      
      private var isTellNextAfterSelf:Boolean;
      
      private var isChangeElfFromSkill:Boolean;
      
      private var prayAddHp:int = 0;
      
      private var shareExpNum:int;
      
      private var lessShareExpNum:int;
      
      public function CampOfPlayerMedia(param1:Object = null)
      {
         super("CampOfPlayerMedia",param1);
         campUI = param1 as CampOfPlayerUI;
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
         if(campUI.myVO != null)
         {
            return campUI.myVO.isWillDie;
         }
         return false;
      }
      
      public static function get isAllElfDie() : Boolean
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null && PlayerVO.bagElfVec[_loc1_].currentHp > 0)
            {
               LogUtil(PlayerVO.bagElfVec[_loc1_].nickName + "的当前血量：" + PlayerVO.bagElfVec[_loc1_].currentHp);
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function tellEndElfFight() : void
      {
         LogUtil("替身结束后当前技能2" + fightingElf.currentSkill);
         Dialogue.playCollectDialogue(function():void
         {
            if(FightingMedia.isFighting == false)
            {
               return;
            }
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + fightingElf.sound);
            FightingLogicFactor.endElfFightHandler(campUI);
         });
      }
      
      private function tellBadEffectAtEndFight() : void
      {
         if(fightingElf == null)
         {
            return;
         }
         FightingLogicFactor.tellBadEffect();
         afterCurIsDie();
      }
      
      private function shakeHandler(param1:EnterFrameEvent) : void
      {
         if(!isShare)
         {
            return;
         }
         if(campUI.elf == null || campUI.statusBar == null)
         {
            return;
         }
         if(shareRange > rangeCount)
         {
            rangeCount = §§dup().rangeCount + 1;
            campUI.elf.y = campUI.elf.y + shareSpeed;
            campUI.statusBar.y = campUI.statusBar.y - shareSpeed;
         }
         else
         {
            rangeCount = 0;
            shareSpeed = -shareSpeed;
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         notification = param1;
         var _loc4_:* = notification.getName();
         if("update_fighting_ele" !== _loc4_)
         {
            if("start_avatars" !== _loc4_)
            {
               if("avatars_end" !== _loc4_)
               {
                  if("ready_skill" !== _loc4_)
                  {
                     if("camp_be_attack" !== _loc4_)
                     {
                        if("next_dialogue" !== _loc4_)
                        {
                           if("start_skill" !== _loc4_)
                           {
                              if("open_opera" !== _loc4_)
                              {
                                 if("tell_after_self_act" !== _loc4_)
                                 {
                                    if("hp_change" !== _loc4_)
                                    {
                                       if("can_not_action" !== _loc4_)
                                       {
                                          if("use_elf_ball" !== _loc4_)
                                          {
                                             if("catch_elf_result" !== _loc4_)
                                             {
                                                if("update_status_show" !== _loc4_)
                                                {
                                                   if("change_elf" !== _loc4_)
                                                   {
                                                      if("change_elf_on_play_back" !== _loc4_)
                                                      {
                                                         if("no_hp" !== _loc4_)
                                                         {
                                                            if("end_hpbar_ani" !== _loc4_)
                                                            {
                                                               if("reply_count_time" !== _loc4_)
                                                               {
                                                                  if(ConfigConst.INIT_ALL_ELF === _loc4_)
                                                                  {
                                                                     LogUtil("初始化了所有精灵");
                                                                     initAllElfVo();
                                                                  }
                                                               }
                                                               else if(!isShare)
                                                               {
                                                                  openPlayerOpera();
                                                               }
                                                            }
                                                            else
                                                            {
                                                               if(fightingElf == null)
                                                               {
                                                                  return;
                                                               }
                                                               if(notification.getType() == fightingElf.camp)
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
                                                            if(notification.getType() == fightingElf.camp)
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
                                                         if(notification.getType() == fightingElf.camp)
                                                         {
                                                            PlayElfMedia.isChangeElf = true;
                                                            FightingLogicFactor.replyChange(fightingElf);
                                                            sendNotification("update_fighting_ele",getTargetElf(FightingConfig.selfOrder.selectElf),"camp_of_player");
                                                         }
                                                      }
                                                   }
                                                   else
                                                   {
                                                      if(fightingElf == null)
                                                      {
                                                         return;
                                                      }
                                                      if(notification.getType() == fightingElf.camp)
                                                      {
                                                         isChangeElfFromSkill = true;
                                                         fightingElf.isPlay = false;
                                                         FightingConfig.initSelfOrder();
                                                         FightingLogicFactor.replyChange(fightingElf);
                                                         LogUtil("在背包中的索引2" + PlayerVO.bagElfVec.indexOf(fightingElf));
                                                         sendNotification("update_fighting_ele",FightingAI.getNextElf(PlayerVO.bagElfVec,fightingElf),"camp_of_player");
                                                      }
                                                   }
                                                }
                                                else if(notification.getType() == "camp_of_player")
                                                {
                                                   if(notification.getBody() == "clear_anger_status")
                                                   {
                                                      clearAnger();
                                                   }
                                                   else
                                                   {
                                                      campUI.upDateStatusShow();
                                                   }
                                                }
                                             }
                                             else
                                             {
                                                catchResult = notification.getBody();
                                                if(catchResult.res == 1)
                                                {
                                                   LogUtil(catchResult.isCri + "会心咩");
                                                   if(catchResult.isCri)
                                                   {
                                                      campUI.ballShareAni(1,campUI.catchSuccessAni);
                                                   }
                                                   else
                                                   {
                                                      campUI.ballShareAni(3,campUI.catchSuccessAni);
                                                   }
                                                }
                                                else if(catchResult.res == 2)
                                                {
                                                   campUI.catchFailedAni();
                                                }
                                                else if(catchResult.res == 3)
                                                {
                                                   campUI.ballShareAni(1,campUI.catchFailedAni);
                                                }
                                                else if(catchResult.res == 4)
                                                {
                                                   campUI.ballShareAni(2,campUI.catchFailedAni);
                                                }
                                                else
                                                {
                                                   campUI.catchFailedAni();
                                                }
                                             }
                                          }
                                          else
                                          {
                                             var ballVO:PropVO = notification.getBody() as PropVO;
                                             if(NPCVO.name == null)
                                             {
                                                campUI.catchAni(ballVO.id);
                                                Starling.juggler.delayCall(function():void
                                                {
                                                   sendNotification("load_elf_of_be_catch");
                                                },0.8);
                                                Starling.juggler.delayCall(function():void
                                                {
                                                   sendNotification("request_catch",notification.getBody());
                                                },3);
                                             }
                                             else
                                             {
                                                GetPropFactor.addOrLessProp(ballVO,true);
                                                Dialogue.collectDialogue("训练师挡下了精灵球，不要做贼\n（野外遇到的精灵才可捕捉）");
                                                Dialogue.playCollectDialogue(FightingLogicFactor.computerActHandler);
                                             }
                                          }
                                       }
                                       else
                                       {
                                          if(fightingElf == null)
                                          {
                                             return;
                                          }
                                          if(notification.getType() == "camp_of_player")
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
                                       if(notification.getType() == "camp_of_player")
                                       {
                                          if(fightingElf == null || fightingElf.currentHp == "0")
                                          {
                                             return;
                                          }
                                          if(notification.getBody().hasOwnProperty("status"))
                                          {
                                             lessBooldNum = notification.getBody().lessNum;
                                             statusMark = notification.getBody().status;
                                          }
                                          else
                                          {
                                             lessBooldNum = notification.getBody() as int;
                                             statusMark = 0;
                                          }
                                          LogUtil(fightingElf.currentHp + "我方" + fightingElf.nickName + "Hp改变" + lessBooldNum + "：是否有状态：" + notification.getBody().hasOwnProperty("status"));
                                          FightingLogicFactor.hpChangeHandler(lessBooldNum,fightingElf);
                                          Dialogue.playCollectDialogue(hpChange);
                                       }
                                    }
                                 }
                                 else
                                 {
                                    if(CampOfComputerMedia.isCurrentElfDie || isCurrentElfDie)
                                    {
                                       return;
                                    }
                                    if(notification.getType() == "camp_of_player")
                                    {
                                       attackFailed(notification.getBody() as String);
                                    }
                                 }
                              }
                              else
                              {
                                 if(isCurrentElfDie || CampOfComputerMedia.isCurrentElfDie)
                                 {
                                    return;
                                 }
                                 LogUtil("开启操作面板");
                                 sendNotification("end_round");
                                 Dialogue.playCollectDialogue(openPlayerOpera);
                              }
                           }
                           else if(notification.getType() == "camp_of_player")
                           {
                              if(CampOfComputerMedia.isCurrentElfDie || isCurrentElfDie)
                              {
                                 return;
                              }
                              LogUtil("我方释放技能 ");
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
                           if(FightingMedia.isFighting == false)
                           {
                              return;
                           }
                           if(notification.getBody() == "call_my_elf")
                           {
                              callMyElfHandler();
                           }
                           else if(notification.getBody() == "END_FIGHTING")
                           {
                              leaveFighting();
                           }
                           else if(notification.getBody() == "get_exp")
                           {
                              LogUtil("获得经验");
                              if(isAllElfDie)
                              {
                                 leaveFighting();
                                 return;
                              }
                              LogUtil("开始获得经验");
                              Dialogue.playCollectDialogue(getExpHadnler);
                           }
                           else if(notification.getBody() == "LOAD_PLAYELF_WIN")
                           {
                              if(hasSureFightContinue)
                              {
                                 hasSureFightContinue = false;
                                 sendNotification("switch_win",campUI.parent,"LOAD_PLAYELF_WIN");
                              }
                              else
                              {
                                 sureContinueFighting();
                              }
                           }
                           else if(notification.getBody() == "prop_be_used" && campUI.parent.parent && fightingElf != null)
                           {
                              campUI.updateHpShow(false);
                              campUI.updateExpBar(0);
                              sendNotification("update_skill_btns",fightingElf.currentSkillVec);
                           }
                           else if(notification.getBody() == "share_exp")
                           {
                              if(lessShareExpNum <= 0)
                              {
                                 sendNotification("next_dialogue","get_exp_complete");
                                 return;
                              }
                              shareExpHandler();
                           }
                        }
                     }
                     else
                     {
                        if(fightingElf == null)
                        {
                           return;
                        }
                        if(notification.getType() == "camp_of_player")
                        {
                           if(fightingElf.currentSkill != null && fightingElf.status.indexOf(13) == -1 && fightingElf.currentSkill.name == "愤怒")
                           {
                              var _loc3_:* = 0;
                              _loc4_ = fightingElf.ablilityAddLv[_loc3_] + 1;
                              fightingElf.ablilityAddLv[_loc3_] = _loc4_;
                              Dialogue.collectDialogue(fightingElf.nickName + "\n愤怒了");
                              fightingElf.status.push(16);
                           }
                           FightingLogicFactor.hpChangeHandler(notification.getBody() as int,fightingElf);
                           AniFactor.beAttackAni(campUI.elf);
                        }
                     }
                  }
                  else
                  {
                     if(FightingMedia.isFighting == false)
                     {
                        return;
                     }
                     if(notification.getType() == "camp_of_player")
                     {
                        markIsFirAtkOfPlay = false;
                        isShare = false;
                        var index:int = notification.getBody() as int;
                        if(!FightingLogicFactor.isPlayBack && !fightingElf.isStoreGas)
                        {
                           FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].selectSkill = index;
                        }
                        if(index == -1)
                        {
                           if(fightingElf.currentSkillVec.indexOf(fightingElf.currentSkill) != -1 && !fightingElf.isStoreGas)
                           {
                              fightingElf.currentSkill = null;
                           }
                        }
                        else
                        {
                           SkillFactor.readySkill(fightingElf,index,CampOfComputerMedia._currentCamp.myVO);
                        }
                     }
                  }
               }
               else if(notification.getType() == "camp_of_player")
               {
                  Dialogue.playCollectDialogue(avatarEnd);
               }
            }
            else if(notification.getType() == "camp_of_player")
            {
               campUI.starAvatar();
               addEvent();
            }
         }
         else if(notification.getType() == "camp_of_player")
         {
            rangeCount = 0;
            var myVO:ElfVO = notification.getBody() as ElfVO;
            if(!FightingLogicFactor.isPlayBack && FightingConfig.selfOrderVec.length > 0)
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].selectElf = myVO.id;
               LogUtil("玩家方换精灵命令" + JSON.stringify(FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1]));
            }
            if(isRelay)
            {
               PlayElfMedia.isChangeElf = false;
               FightingLogicFactor.relayHandler(myVO,fightingElf);
               if(FightingLogicFactor.isFirstOfOurs)
               {
                  isTellNextAfterSelf = true;
               }
               else
               {
                  isTellNextAfterSelf = false;
               }
            }
            CalculatorFactor.calculatorElf(myVO);
            if(myVO.status.indexOf(18) != -1)
            {
               Dialogue.updateDialogue(myVO.nickName + "变身!");
            }
            else
            {
               initElfOfOut();
               SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","throwElf");
               Dialogue.updateDialogue("就决定是你了!" + myVO.nickName + "!");
            }
            myVO.camp = "camp_of_player";
            myVO.isHasFiging = true;
            myVO.isShareExp = true;
            campUI.myVO = myVO;
            fightingElf = myVO;
            fightingElf.isWillDie = true;
            fightingElf.skillOfLast = null;
            comeOutAni();
            addEvent();
            setPlayStatus();
            LogUtil(fightingElf.currentSkillVec + "技能长度");
            sendNotification("update_skill_btns",fightingElf.currentSkillVec);
         }
         else
         {
            if(campUI.myVO == null)
            {
               campUI.playerImageComeAni();
               campUI.addEventListener("enterFrame",shakeHandler);
            }
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
      
      override public function listNotificationInterests() : Array
      {
         return ["update_fighting_ele","ready_skill","update_status_show","camp_be_attack","next_dialogue","avatars_end","no_hp","start_skill","open_opera","use_elf_ball","end_hpbar_ani","tell_after_self_act","hp_change","start_avatars","reply_count_time","can_not_action","catch_elf_result","change_elf",ConfigConst.INIT_ALL_ELF,"change_elf_on_play_back"];
      }
      
      private function avatarEnd() : void
      {
         if(fightingElf == null)
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
         t.delay = 0.5;
         Starling.juggler.add(t);
         t.animate("scaleX",1);
         t.onComplete = function():void
         {
            if(FightingLogicFactor.isRounding == false)
            {
               openPlayerOpera();
               return;
            }
            if(fightingElf.currentSkill != null && fightingElf.currentSkill.id == 174)
            {
               if(!FightingLogicFactor.isFirstOfOurs)
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
         LogUtil("喂喂，掉血咯");
         if(fightingElf == null)
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
      
      private function initAllElfVo() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               initElfVo(PlayerVO.bagElfVec[_loc1_]);
               PlayerVO.bagElfVec[_loc1_].isPlay = false;
            }
            _loc1_++;
         }
      }
      
      private function initElfVo(param1:ElfVO) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         FightingLogicFactor.replyChange(param1);
         param1.ablilityAddLv = [0,0,0,0,0,0,0];
         if(param1.status.indexOf(13) != -1)
         {
            CalculatorFactor.calculatorElf(param1);
            param1.currentHp = param1.hpBeforeAvatars;
            param1.status.splice(param1.status.indexOf(13));
         }
         if(param1.status.indexOf(29) != -1)
         {
            param1.status.splice(fightingElf.status.indexOf(29),1);
            if(param1.currentSkill != null && param1.currentSkill.name == "连切")
            {
               _loc2_ = GetElfFactor.getSkillById(param1.currentSkill.id);
               param1.currentSkill.power = _loc2_.power;
               _loc2_ = null;
            }
         }
         _loc3_ = 7;
         while(_loc3_ < 44)
         {
            if(param1.status.indexOf(_loc3_) != -1)
            {
               _loc4_ = param1.status.indexOf(_loc3_);
               param1.status.splice(_loc4_,1);
            }
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
            param1.currentSkill.successRate = 100;
            param1.currentSkill.continueSkillCount = 0;
         }
         param1.currentSkill = null;
         param1.isShareExp = false;
         param1.skillBeforeStrone = null;
         param1.skillFinalUseId = 0;
         param1.tolerHurt = 0;
         param1.lastHurtOfPhysics = 0;
         param1.lastHurtOfSpecial = 0;
         param1.isReleaseAnger = false;
         param1.hasUseDefense = false;
         param1.eyeCount = 0;
         param1.hurtNum = 0;
         param1.sleepCount = "0";
         param1.mullCount = 0;
         param1.boundCount = 0;
         param1.stoneCount = 0;
         param1.fogCount = 0;
         param1.tolerCount = 0;
         param1.lessHurtCount = 0;
         param1.protectCount = 0;
         param1.powerCount = 0;
         param1.inciteCount = 0;
         param1.prayCount = 0;
         param1.yawnCount = 0;
         param1.blightCount = 0;
         param1.blightHurt = 0;
         param1.storeNum = "0";
         param1.isUsedPropOfBandage = false;
         param1.skillOfFirstSelect = null;
         CalculatorFactor.calculatorElf(param1);
      }
      
      private function initElfOfOut() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(fightingElf)
         {
            fightingElf.isCannotActStatus = false;
            if(fightingElf.status.indexOf(13) != -1)
            {
               CalculatorFactor.calculatorElf(fightingElf);
               LogUtil("替身前血量" + fightingElf.hpBeforeAvatars);
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
                  _loc1_ = GetElfFactor.getSkillById(fightingElf.currentSkill.id);
                  fightingElf.currentSkill.power = _loc1_.power;
                  _loc1_ = null;
               }
            }
            _loc2_ = 0;
            while(_loc2_ < StatusFactor.statusClearOnOut.length)
            {
               if(fightingElf.status.indexOf(StatusFactor.statusClearOnOut[_loc2_]) != -1)
               {
                  _loc3_ = fightingElf.status.indexOf(StatusFactor.statusClearOnOut[_loc2_]);
                  fightingElf.status.splice(_loc3_,1);
               }
               _loc2_++;
            }
            if(fightingElf.copykillIndex != -1)
            {
               fightingElf.currentSkillVec[fightingElf.copykillIndex] = null;
               fightingElf.currentSkillVec[fightingElf.copykillIndex] = fightingElf.recordSkBeforeCopy;
               fightingElf.copykillIndex = -1;
            }
            LogUtil(fightingElf.status + "精灵状态" + fightingElf.currentSkill);
            fightingElf.ablilityAddLv = [0,0,0,0,0,0,0];
            if(fightingElf.currentSkill)
            {
               fightingElf.currentSkill.continueSkillCount = 0;
               fightingElf.currentSkill.successRate = 100;
            }
            FeatureFactor.clearSpecialStatus(fightingElf);
            FeatureFactor.replyHandler(fightingElf);
            fightingElf.currentSkill = null;
            fightingElf.isStoreGas = false;
            fightingElf.skillBeforeStrone = null;
            fightingElf.tolerHurt = 0;
            fightingElf.isReleaseAnger = false;
            fightingElf.hasUseDefense = false;
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
         }
      }
      
      private function setPlayStatus() : void
      {
         var _loc1_:* = 0;
         fightingElf.isPlay = true;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null && PlayerVO.bagElfVec[_loc1_].id != fightingElf.id)
            {
               PlayerVO.bagElfVec[_loc1_].isPlay = false;
            }
            _loc1_++;
         }
      }
      
      private function addEvent() : void
      {
         if(!campUI.elf.hasEventListener("end_attack_ani"))
         {
            campUI.elf.addEventListener("end_attack_ani",endAttackHandler);
            campUI.elf.addEventListener("end_help_skill_ani",tellNextAfterSelfAct);
            campUI.elf.addEventListener("end_hurt_ani",endHurtAni);
            campUI.elf.addEventListener("ELF_WILL_DIE",elfWillDieHandler);
         }
      }
      
      private function elfWillDieHandler() : void
      {
         initElfVo(fightingElf);
         sendNotification("update_skill_btns",null);
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
      
      private function afterCurIsDie() : void
      {
         if(selectElf())
         {
            return;
         }
         if(fightingElf == null)
         {
            return;
         }
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            FightingLogicFactor.dialogueAndNext(fightingElf.nickName + "倒下了!","END_FIGHTING");
         }
         else
         {
            Dialogue.updateDialogue(fightingElf.nickName + "倒下了!",true,"END_FIGHTING");
         }
      }
      
      private function selectElf() : Boolean
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null && PlayerVO.bagElfVec[_loc1_].currentHp > 0)
            {
               if(CampOfComputerMedia.isCurrentElfDie && !FightingLogicFactor.isPVP && !FightingLogicFactor.isPlayBackFromPvp)
               {
                  markIsWillChangeElf = true;
                  return true;
               }
               if(!Config.isAutoFighting && !FightingLogicFactor.isPlayBack)
               {
                  if(markIsWillChangeElf)
                  {
                     sureContinueFighting();
                  }
                  else
                  {
                     FightingLogicFactor.dialogueAndNext(fightingElf.nickName + "倒下了!","LOAD_PLAYELF_WIN");
                  }
                  FightingConfig.initSelfOrder();
               }
               else if(FightingLogicFactor.isPlayBack)
               {
                  markIsFirAtkOfPlay = true;
                  FightingConfig.initSelfOrder();
                  FightingLogicFactor.replyChange(fightingElf);
                  sendNotification("update_fighting_ele",getTargetElf(FightingConfig.selfOrder.selectElf),"camp_of_player");
               }
               else
               {
                  FightingConfig.initSelfOrder();
                  FightingLogicFactor.replyChange(fightingElf);
                  _loc2_ = FightingAI.getElfOfSuitable(PlayerVO.bagElfVec,CampOfComputerMedia._currentCamp.myVO);
                  if(_loc2_ == null)
                  {
                     _loc2_ = PlayerVO.bagElfVec[_loc1_];
                  }
                  sendNotification("update_fighting_ele",_loc2_,"camp_of_player");
               }
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function sureContinueFighting() : void
      {
         var _loc1_:* = null;
         if(CampOfComputerMedia.isCurrentElfDie && FightingLogicFactor.isPVP)
         {
            markIsFirAtkOfPlay = false;
         }
         else
         {
            markIsFirAtkOfPlay = true;
         }
         LogUtil("是否我方先出手：" + markIsFirAtkOfPlay);
         if(NPCVO.name != null)
         {
            if(FightingLogicFactor.isPVP)
            {
               sendNotification("pvp_timer_start");
            }
            sendNotification("switch_win",campUI.parent,"LOAD_PLAYELF_WIN");
         }
         else
         {
            _loc1_ = Alert.show("是否继续战斗?","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc1_.addEventListener("close",continueFightingHandler);
         }
      }
      
      private function sureIsChangeElf() : void
      {
         if(!FightingLogicFactor.isPVP && !FightingLogicFactor.isPlayBackFromPvp)
         {
            markIsFirAtkOfPlay = true;
         }
         openPlayerOpera();
      }
      
      private function continueFightingHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            sendNotification("switch_win",campUI.parent,"LOAD_PLAYELF_WIN");
         }
         else
         {
            hasSureFightContinue = true;
            sendNotification("no_fighting_continue");
         }
      }
      
      private function changeElfHandler(param1:Event, param2:Object) : void
      {
         if(fightingElf == null)
         {
            return;
         }
         if(param2.label == "确定")
         {
            fightingElf.isShareExp = false;
            markIsFirAtkOfPlay = true;
            sendNotification("switch_win",campUI.parent,"LOAD_PLAYELF_WIN");
         }
         else
         {
            openPlayerOpera();
         }
      }
      
      private function comeOutAni() : void
      {
         isShare = false;
         var delay:Number = 0.0;
         if(fightingElf.status.indexOf(18) == -1)
         {
            campUI.playerImageOutAni();
            delay = 0.9;
         }
         var t:Tween = new Tween(campUI.elf,1.1,"easeOutElastic");
         Starling.juggler.add(t);
         t.delay = delay;
         t.animate("scaleX",1,0);
         t.animate("scaleY",1,0);
         campUI.statusBar.alpha = 1;
         var t2:Tween = new Tween(campUI.statusBar,0.5,"easeOut");
         Starling.juggler.add(t2);
         t2.animate("x",campUI.statusX);
         t2.delay = delay + 0.3;
         t.onComplete = function():void
         {
            if(prayAddHp > 0)
            {
               Dialogue.collectDialogue(fightingElf.nickName + "因为伙伴的祈求\n回复了HP");
               sendNotification("hp_change",-prayAddHp,fightingElf.camp);
               prayAddHp = 0;
            }
            FightingLogicFactor.handLandStar(campUI);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + fightingElf.sound);
            fightingElf.isWillDie = false;
            if(fightingElf.status.indexOf(18) != -1)
            {
               tellNextAfterSelfAct();
               return;
            }
            if(isRelay)
            {
               isRelay = false;
               if(FightingLogicFactor.isPVP)
               {
                  (GameFacade.getInstance().retrieveProxy("FightingPro") as FightingPro).write6002(fightingElf.id,false);
               }
               if(isTellNextAfterSelf)
               {
                  tellNextAfterSelfAct();
               }
               else
               {
                  sendNotification("open_opera");
               }
               campUI.currentHpTf.text = fightingElf.currentHp;
               return;
            }
            if(PlayElfMedia.isChangeElf && FightingLogicFactor.isPVP && !isChangeElfFromSkill)
            {
               LogUtil("是否加载netLoading：" + !markIsFirAtkOfPlay);
               (GameFacade.getInstance().retrieveProxy("FightingPro") as FightingPro).write6002(fightingElf.id,!markIsFirAtkOfPlay);
            }
            LogUtil(":isChangeElf：" + PlayElfMedia.isChangeElf + ":isCurrentElfDie:" + CampOfComputerMedia.isCurrentElfDie + ":markIsFirAtkOfPlay:" + markIsFirAtkOfPlay + ":isChangeElfFromSkill:" + isChangeElfFromSkill);
            if(PlayElfMedia.isChangeElf && !CampOfComputerMedia.isCurrentElfDie && !markIsFirAtkOfPlay && !isChangeElfFromSkill)
            {
               PlayElfMedia.isChangeElf = false;
               FightingLogicFactor.computerActHandler();
            }
            else
            {
               PlayElfMedia.isChangeElf = false;
               markIsFirAtkOfPlay = false;
               if(isChangeElfFromSkill)
               {
                  sendNotification("end_round");
               }
               isChangeElfFromSkill = false;
               if(CampOfComputerMedia.isWaitChangeElf)
               {
                  FightingConfig.initSelfOrder();
                  sendNotification("change_elf_on_play_back",false,"camp_of_computer");
               }
               else
               {
                  openPlayerOpera();
               }
            }
            campUI.currentHpTf.text = fightingElf.currentHp;
         };
      }
      
      private function startSkill() : void
      {
         var _loc1_:* = null;
         if(CampOfComputerMedia.isCurrentElfDie || isCurrentElfDie)
         {
            return;
         }
         if(fightingElf == null)
         {
            return;
         }
         FightingLogicFactor.isRounding = true;
         if(PlayerVO.isUseProp)
         {
            PlayerVO.isUseProp = false;
            if(autoUseAddHpProp())
            {
               clearAnger();
               return;
            }
         }
         if(fightingElf.isCannotActStatus)
         {
            canNotActHandler();
            return;
         }
         if(fightingElf.status.indexOf(17) != -1)
         {
            tolerHandler();
            return;
         }
         if(fightingElf.isReleaseAnger)
         {
            AngerHandler();
            return;
         }
         if(fightingElf.currentSkill == null)
         {
            clearAnger();
            if(!autoUseAddPPProp())
            {
               fightingElf.currentSkill = GetElfFactor.getSkillById(165);
               if(StatusFactor.statusHandlerBeforeSkillStart(campUI,"camp_of_computer") == false)
               {
                  SkillFactor.startSkill(campUI,CampOfComputerMedia._currentCamp);
               }
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
         if(StatusFactor.statusHandlerBeforeSkillStart(campUI,"camp_of_computer") == false)
         {
            if(fightingElf.currentSkill.name == "接棒")
            {
               if(GetElfFactor.bagElfNum(true) == 1)
               {
                  attackFailed(fightingElf.nickName + "使用接棒失败！");
               }
               else if(Config.isAutoFighting)
               {
                  _loc1_ = getNextElf();
                  isRelay = true;
                  FightingLogicFactor.replyChange(fightingElf);
                  sendNotification("update_fighting_ele",_loc1_,"camp_of_player");
               }
               else if(FightingLogicFactor.isPlayBack)
               {
                  isRelay = true;
                  FightingLogicFactor.replyChange(fightingElf);
                  sendNotification("update_fighting_ele",getTargetElf(FightingConfig.selfOrder.selectElf),"camp_of_player");
               }
               else
               {
                  isRelay = true;
                  sendNotification("switch_win",null,"LOAD_PLAYELF_WIN");
                  sendNotification("pvp_timer_start");
               }
               return;
            }
            SkillFactor.startSkill(campUI,CampOfComputerMedia._currentCamp);
         }
      }
      
      private function getTargetElf(param1:int) : ElfVO
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         LogUtil(PlayerVO.bagElfVec.length + "精灵个数");
         _loc3_ = 0;
         while(_loc3_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc3_] != null)
            {
               LogUtil(PlayerVO.bagElfVec[_loc3_].id + "寻找精灵");
               if(PlayerVO.bagElfVec[_loc3_].id == param1)
               {
                  return PlayerVO.bagElfVec[_loc3_];
               }
            }
            _loc3_++;
         }
         var _loc2_:String = "";
         _loc4_ = 0;
         while(_loc4_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc4_] != null)
            {
               _loc2_ = _loc2_ + ("|" + PlayerVO.bagElfVec[_loc4_].id);
            }
            _loc4_++;
         }
         LogUtil("找不到精灵:" + param1 + ":对方的精灵id:" + _loc2_);
         return null;
      }
      
      private function getNextElf() : ElfVO
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_].currentHp > 0 && PlayerVO.bagElfVec[_loc1_] != fightingElf)
            {
               return PlayerVO.bagElfVec[_loc1_];
            }
            _loc1_++;
         }
         return null;
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
      
      private function autoUseAddPPProp() : Boolean
      {
         var _loc4_:* = null;
         var _loc2_:* = 0;
         var _loc1_:* = null;
         var _loc3_:* = 0;
         if(!Config.isAutoFighting || LoadPageCmd.lastPage is ElfSeriesUI || !Config.isAutoFightingUseProp)
         {
            return false;
         }
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.medicineVec.length)
         {
            if(PlayerVO.medicineVec[_loc2_].type == 3 || PlayerVO.medicineVec[_loc2_].type == 16 && PlayerVO.medicineVec[_loc2_].replyType == "pp")
            {
               _loc1_ = PlayerVO.medicineVec[_loc2_];
               if(PlayerVO.medicineVec[_loc2_].actRole == "单个")
               {
                  _loc4_ = fightingElf.currentSkillVec[0].currentPP + _loc1_.effectValue;
                  if(_loc4_ > fightingElf.currentSkillVec[0].totalPP)
                  {
                     _loc4_ = fightingElf.currentSkillVec[0].totalPP;
                  }
                  fightingElf.currentSkillVec[0].currentPP = _loc4_;
               }
               else
               {
                  _loc3_ = 0;
                  while(_loc3_ < fightingElf.currentSkillVec.length)
                  {
                     _loc4_ = fightingElf.currentSkillVec[_loc3_].currentPP + _loc1_.effectValue;
                     if(_loc4_ > fightingElf.currentSkillVec[_loc3_].totalPP)
                     {
                        _loc4_ = fightingElf.currentSkillVec[_loc3_].totalPP;
                     }
                     fightingElf.currentSkillVec[_loc3_].currentPP = _loc4_;
                     _loc3_++;
                  }
               }
               attackFailed("您使用了" + _loc1_.name);
               propLess(_loc1_);
               sendNotification("update_skill_btns",fightingElf.currentSkillVec);
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function autoUseAddHpProp() : Boolean
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.medicineVec.length)
         {
            if(PlayerVO.medicineVec[_loc1_].type == 3 || PlayerVO.medicineVec[_loc1_].type == 16 && PlayerVO.medicineVec[_loc1_].replyType != "pp" && PlayerVO.medicineVec[_loc1_].replyType != "life")
            {
               _loc2_ = PlayerVO.medicineVec[_loc1_];
               sendNotification("hp_change",-_loc2_.effectValue,fightingElf.camp);
               attackFailed("您使用了" + _loc2_.name);
               propLess(_loc2_);
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function propLess(param1:PropVO) : void
      {
         param1.useNum = param1.useNum + 1;
         if(PlayerVO.usePropVec.indexOf(param1) == -1)
         {
            PlayerVO.usePropVec.push(param1);
         }
         param1.count = param1.count - 1;
         if(param1.count <= 0)
         {
            PlayerVO.medicineVec.splice(PlayerVO.medicineVec.indexOf(param1),1);
         }
      }
      
      private function openPlayerOpera() : void
      {
         var _loc1_:* = 0;
         LogUtil("喂喂，有开启吗" + fightingElf);
         if(CampOfComputerMedia.isCurrentElfDie || fightingElf == null)
         {
            return;
         }
         if(fightingElf.currentHp == "0")
         {
            return;
         }
         if(fightingElf.currentSkill != null && fightingElf.currentSkill.continueSkillCount > 0)
         {
            FightingConfig.initSelfOrder(true,false);
            sendNotification("auto_select_skill",fightingElf.currentSkillVec.indexOf(fightingElf.currentSkill));
            return;
         }
         if(fightingElf.isCannotActStatus)
         {
            FightingConfig.initSelfOrder(true,false);
            if(FightingLogicFactor.isPVP)
            {
               if(isOtherAuto())
               {
                  canNotActHandler();
                  FightingLogicFactor.isFirstOfOurs = true;
               }
               else
               {
                  (facade.retrieveProxy("FightingPro") as FightingPro).write6001(FightingConfig.recordSkillIndex);
               }
            }
            else
            {
               canNotActHandler();
               FightingLogicFactor.isFirstOfOurs = true;
            }
         }
         else
         {
            if(fightingElf.status.indexOf(17) != -1)
            {
               FightingConfig.initSelfOrder(true,false);
               if(FightingLogicFactor.isPVP)
               {
                  if(isOtherAuto())
                  {
                     tolerHandler();
                     FightingLogicFactor.isFirstOfOurs = true;
                     return;
                  }
                  (facade.retrieveProxy("FightingPro") as FightingPro).write6001(FightingConfig.recordSkillIndex);
               }
               else
               {
                  tolerHandler();
                  FightingLogicFactor.isFirstOfOurs = true;
               }
               return;
            }
            if(fightingElf.isReleaseAnger)
            {
               FightingConfig.initSelfOrder(true,false);
               if(FightingLogicFactor.isPVP)
               {
                  if(isOtherAuto())
                  {
                     AngerHandler();
                     FightingLogicFactor.isFirstOfOurs = true;
                     return;
                  }
                  (facade.retrieveProxy("FightingPro") as FightingPro).write6001(FightingConfig.recordSkillIndex);
               }
               else
               {
                  AngerHandler();
                  FightingLogicFactor.isFirstOfOurs = true;
               }
               return;
            }
            if(!Config.isAutoFighting && !FightingLogicFactor.isPlayBack)
            {
               if(fightingElf.isStoreGas)
               {
                  FightingConfig.initSelfOrder(true,false);
                  if(FightingLogicFactor.isPVP)
                  {
                     _loc1_ = FightingConfig.recordSkillIndex;
                     FightingConfig.recordSkillIndex = -1;
                     if(!FightingLogicFactor.isPlayBack)
                     {
                        FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].selectSkill = _loc1_;
                     }
                     (facade.retrieveProxy("FightingPro") as FightingPro).write6001(_loc1_);
                  }
                  else
                  {
                     sendNotification("ready_skill",-1,"camp_of_computer");
                     sendNotification("start_round");
                  }
                  return;
               }
               FightingConfig.initSelfOrder();
               sendNotification("pvp_timer_start");
               isShare = true;
               LogUtil("自动开启");
               Dialogue.removeFormParent();
               sendNotification("open_skill_select");
               sendNotification("elf_of_play_come");
               if(!FightingLogicFactor.isPVP && !FightingLogicFactor.isPlayBack)
               {
                  BeginnerGuide.playBeginnerGuide();
               }
               if(FightingMedia.isHasRestrain && LSOManager.get("isGudieRestrain") == false)
               {
                  FightingMedia.isHasRestrain = false;
                  BeginnerGuide.playRestrainGudie();
               }
               else if(NPCVO.name == null && PlayerVO.elfBallVec.length > 0)
               {
                  LogUtil("呵呵呵" + LoadPageCmd.lastPage);
                  if(LoadPageCmd.lastPage is CityMapUI || LoadPageCmd.lastPage is HuntingUI)
                  {
                     BeginnerGuide.playCatchGuideOrChangeElf();
                  }
               }
            }
            else
            {
               FightingConfig.initSelfOrder();
               FightingAI.selectAction(fightingElf,CampOfComputerMedia._currentCamp.myVO,PlayerVO.bagElfVec);
            }
         }
      }
      
      private function isOtherAuto() : Boolean
      {
         var _loc1_:ElfVO = CampOfComputerMedia.campUI.myVO;
         if(_loc1_ != null && (_loc1_.status.indexOf(17) != -1 || _loc1_.isReleaseAnger || _loc1_.isCannotActStatus))
         {
            return true;
         }
         return false;
      }
      
      private function AngerHandler() : void
      {
         var skill:SkillVO = GetElfFactor.getSkillById(117);
         var callBack:Function = function():void
         {
            skill = null;
            sendNotification("tell_after_self_act",fightingElf.nickName + "解放它的怒气",fightingElf.camp);
            sendNotification("hp_change",fightingElf.tolerHurt * 2,"camp_of_computer");
            fightingElf.tolerHurt = 0;
            fightingElf.isReleaseAnger = false;
         };
         SkillFactor.playSkillEffect(skill,campUI,false,callBack);
      }
      
      private function tolerHandler() : void
      {
         sendNotification("tell_after_self_act",fightingElf.nickName + "在忍耐",fightingElf.camp);
      }
      
      private function canNotActHandler() : void
      {
         attackFailed(fightingElf.nickName + "不能行动");
         fightingElf.isCannotActStatus = false;
      }
      
      private function endAttackHandler() : void
      {
         sendNotification("attack_handler",0,"camp_of_player");
      }
      
      private function attackFailed(param1:String) : void
      {
         Dialogue.collectDialogue(param1);
         Dialogue.playCollectDialogue(null);
         Starling.juggler.delayCall(tellNextAfterSelfAct,Config.dialogueDelay);
      }
      
      private function tellNextAfterSelfAct() : void
      {
         LogUtil("自身行动后的下一步");
         FightingLogicFactor.tellNextAfterSelfAct(fightingElf,!FightingLogicFactor.isFirstOfOurs,"camp_of_computer");
      }
      
      private function tellNextAfterOtherAct() : void
      {
         FightingLogicFactor.tellNextAfterOtherAct(campUI,!FightingLogicFactor.isFirstOfOurs,"camp_of_computer");
      }
      
      private function playBooldBarAni(param1:Boolean) : void
      {
         if(fightingElf == null)
         {
            return;
         }
         campUI.updateHpShow(true,param1);
      }
      
      private function endHurtAni() : void
      {
         playBooldBarAni(true);
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
         if(fightingElf == null)
         {
            return;
         }
         FightingLogicFactor.tellBadEffect();
         tellNextAfterOtherAct();
      }
      
      private function getExpHadnler() : void
      {
         var _loc3_:* = null;
         LogUtil("进入获得经验函数");
         if(LoadPageCmd.lastPage is ElfSeriesUI || LoadPageCmd.lastPage is KingKwanUI || LoadPageCmd.lastPage is PVPBgUI || LoadPageCmd.lastPage is TrialUI || LoadPageCmd.lastPage is HuntingUI || LoadPageCmd.lastPage is MiningFrameUI || LoadPageCmd.lastPage is StartChatUI || LoadPageCmd.lastPage is HuntingPartyUI)
         {
            sendNotification("next_dialogue","get_exp_complete");
            return;
         }
         if(fightingElf == null)
         {
            return;
         }
         if(fightingElf.isWillDie)
         {
            sendNotification("next_dialogue","get_exp_complete");
            return;
         }
         getEffort();
         var _loc2_:int = fightingElf.lv;
         FightingConfig.isShareExp = isShareExp();
         if(FightingConfig.isShareExp)
         {
            LogUtil("分享经验的精灵数目" + shareExpNum);
            lessShareExpNum = shareExpNum - 1;
            _loc3_ = Math.round(FightingLogicFactor.getExp / shareExpNum);
         }
         else
         {
            _loc3_ = FightingLogicFactor.getExp;
         }
         if(_loc2_ == 100)
         {
            if(!FightingConfig.isShareExp)
            {
               sendNotification("next_dialogue","get_exp_complete");
            }
            else
            {
               sendNotification("next_dialogue","share_exp");
            }
            return;
         }
         if(isCarryPropAddExp(fightingElf))
         {
            _loc3_ = _loc3_ + _loc3_ / 2;
         }
         var _loc1_:int = fightingElf.currentExp;
         fightingElf.currentExp = fightingElf.currentExp + _loc3_;
         CalculatorFactor.calculatorElfLv(fightingElf);
         GameFacade.getInstance().sendNotification("update_skill_btns",fightingElf.currentSkillVec);
         campUI.updateExpBar(fightingElf.lv - _loc2_);
         if(fightingElf.lv - _loc2_ == 0)
         {
            if(!FightingConfig.isShareExp)
            {
               FightingLogicFactor.dialogueAndNext(fightingElf.nickName + "获得了\n" + (fightingElf.currentExp - _loc1_) + "点经验值","get_exp_complete");
            }
            else
            {
               FightingLogicFactor.dialogueAndNext(fightingElf.nickName + "获得了\n" + (fightingElf.currentExp - _loc1_) + "点经验值","share_exp");
            }
         }
         else
         {
            Dialogue.updateDialogue(fightingElf.nickName + "获得了\n" + (fightingElf.currentExp - _loc1_) + "点经验值");
         }
         return;
         §§push(LogUtil("获取经验完毕"));
      }
      
      private function isCarryPropAddExp(param1:ElfVO) : Boolean
      {
         if(param1.carryProp && param1.carryProp.name == "幸运蛋" && param1.status.indexOf(39) == -1)
         {
            return true;
         }
         return false;
      }
      
      private function isShareExp() : Boolean
      {
         var _loc1_:* = 0;
         shareExpNum = 1;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null && PlayerVO.bagElfVec[_loc1_].id != fightingElf.id)
            {
               if(PlayerVO.bagElfVec[_loc1_].currentHp <= 0)
               {
                  PlayerVO.bagElfVec[_loc1_].isShareExp = false;
               }
               else
               {
                  if(PlayerVO.bagElfVec[_loc1_].isShareExp)
                  {
                     shareExpNum = shareExpNum + 1;
                  }
                  if(!PlayerVO.bagElfVec[_loc1_].isShareExp && PlayerVO.bagElfVec[_loc1_].carryProp != null && PlayerVO.bagElfVec[_loc1_].carryProp.name == "学习装置" && PlayerVO.bagElfVec[_loc1_].status.indexOf(39) == -1)
                  {
                     shareExpNum = shareExpNum + 1;
                     PlayerVO.bagElfVec[_loc1_].isShareExp = true;
                     PlayerVO.bagElfVec[_loc1_].isHasFiging = true;
                  }
               }
            }
            _loc1_++;
         }
         if(shareExpNum > 1)
         {
            return true;
         }
         return false;
      }
      
      private function shareExpHandler() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null && PlayerVO.bagElfVec[_loc1_].isShareExp && PlayerVO.bagElfVec[_loc1_].id != fightingElf.id)
            {
               elfGetExp(PlayerVO.bagElfVec[_loc1_]);
               break;
            }
            _loc1_++;
         }
      }
      
      private function elfGetExp(param1:ElfVO) : void
      {
         var _loc2_:* = null;
         lessShareExpNum = lessShareExpNum - 1;
         param1.isShareExp = false;
         var _loc4_:int = param1.lv;
         var _loc5_:String = Math.round(FightingLogicFactor.getExp / shareExpNum);
         if(isCarryPropAddExp(param1))
         {
            _loc5_ = _loc5_ + _loc5_ / 2;
         }
         var _loc3_:int = param1.currentExp;
         param1.currentExp = param1.currentExp + _loc5_;
         CalculatorFactor.calculatorElfLv(param1);
         if(lessShareExpNum <= 0)
         {
            _loc2_ = "get_exp_complete";
         }
         else
         {
            _loc2_ = "share_exp";
         }
         if(param1.lv - _loc4_ == 0)
         {
            FightingLogicFactor.dialogueAndNext(param1.nickName + "获得了\n" + (param1.currentExp - _loc3_) + "点经验值",_loc2_);
         }
         else
         {
            ShowElfAbility.getInstance().show(param1,param1.lv - _loc4_);
            if(CalculatorFactor.learnSkillHandler(param1))
            {
               Dialogue.updateDialogue(param1.nickName + "获得了\n" + (param1.currentExp - _loc3_) + "点经验值,等级上升到" + param1.lv + "级",true,_loc2_);
            }
            else
            {
               FightingLogicFactor.dialogueAndNext(param1.nickName + "获得了\n" + (param1.currentExp - _loc3_) + "点经验值,等级上升到" + param1.lv + "级",_loc2_);
            }
         }
      }
      
      private function getEffort() : void
      {
         var _loc1_:* = 0;
         LogUtil(fightingElf.effAry + "战斗前努力值" + FightingLogicFactor.getEffort);
         if(PropFactor.effSum(fightingElf) > 510)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < fightingElf.effAry.length)
         {
            var _loc2_:* = _loc1_;
            var _loc3_:* = fightingElf.effAry[_loc2_] + FightingLogicFactor.getEffort[_loc1_];
            fightingElf.effAry[_loc2_] = _loc3_;
            if(fightingElf.effAry[_loc1_] > 255)
            {
               fightingElf.effAry[_loc1_] = 255;
            }
            _loc1_++;
         }
         return;
         §§push(LogUtil(fightingElf.effAry + "战斗后努力值"));
      }
      
      private function leaveFighting() : void
      {
         LogUtil("==离开战斗==");
         if(FightingMedia.isFighting == false)
         {
            return;
         }
         campUI.elf.removeEventListener("end_attack_ani",endAttackHandler);
         campUI.elf.removeEventListener("end_help_skill_ani",tellNextAfterSelfAct);
         campUI.elf.removeEventListener("end_hurt_ani",endHurtAni);
         campUI.elf.removeEventListener("ELF_WILL_DIE",elfWillDieHandler);
         campUI.removeEventListener("enterFrame",shakeHandler);
         FightingMedia.isFighting = false;
         markIsWillChangeElf = false;
         campUI.elf.visible = false;
         Starling.juggler.removeTweens(campUI.elf);
         campUI.statusBar.visible = false;
         initAllElfVo();
         (campUI.parent as FightingUI).btnBars.removeFromParent(true);
         (campUI.parent as FightingUI).handFBtn.removeFromParent(true);
         if((campUI.parent as FightingUI).speedBtnSpr != null)
         {
            (campUI.parent as FightingUI).speedBtnSpr.removeFromParent(true);
         }
         if(!(LoadPageCmd.lastPage is KingKwanUI) && !(LoadPageCmd.lastPage is ElfSeriesUI) && !(LoadPageCmd.lastPage is PVPBgUI) && !(LoadPageCmd.lastPage is TrialUI) && !(LoadPageCmd.lastPage is MiningFrameUI) && !FightingLogicFactor.isPlayBack)
         {
            (facade.retrieveProxy("FightingPro") as FightingPro).write1601();
         }
         if(!FightingConfig.isGoOut)
         {
            if(isAllElfDie)
            {
               FightingConfig.isWin = false;
               sendNotification("adventure_result",0,"adventure_failed");
            }
            else if(CampOfComputerMedia.isAllElfDie)
            {
               FightingConfig.isWin = true;
               sendNotification("adventure_result",0,"adventure_pass");
            }
         }
         if(FightingConfig.moneyFromFighting > 0 && FightingConfig.selectMap != null)
         {
            if(FightingConfig.isWin)
            {
               Dialogue.collectDialogue("战斗胜利\n您回收了" + FightingConfig.moneyFromFighting + "金币");
               Dialogue.playCollectDialogue(function():void
               {
                  (facade.retrieveProxy("MapPro") as MapPro).write1702(FightingConfig.selectMap);
               });
               PlayerVO.silver = PlayerVO.silver + FightingConfig.moneyFromFighting;
               sendNotification("update_play_money_info",PlayerVO.silver);
               (facade.retrieveProxy("FightingPro") as FightingPro).write1603();
            }
            else
            {
               Dialogue.collectDialogue("战斗失败\n无法回收投掷出的" + FightingConfig.moneyFromFighting + "金币");
               Dialogue.playCollectDialogue(function():void
               {
                  (facade.retrieveProxy("MapPro") as MapPro).write1702(FightingConfig.selectMap);
               });
            }
         }
         else
         {
            (facade.retrieveProxy("MapPro") as MapPro).write1702(FightingConfig.selectMap);
         }
         fightingElf = null;
         GetElfFactor.bagElfEvolve();
      }
      
      private function callMyElfHandler() : void
      {
         var _loc1_:* = null;
         if(FightingConfig.isPlayerActAfterChangeElf)
         {
            FightingConfig.isPlayerActAfterChangeElf = false;
            FightingLogicFactor.playerActHandler();
            return;
         }
         if(fightingElf != null && fightingElf.isWillDie == false)
         {
            if(!Config.isAutoFighting)
            {
               if(GetElfFactor.bagElfNum() > 1)
               {
                  if(fightingElf.currentSkill && fightingElf.currentSkill.continueSkillCount > 0)
                  {
                     openPlayerOpera();
                  }
                  else
                  {
                     sureIsChangeElf();
                  }
               }
               else
               {
                  openPlayerOpera();
               }
            }
            else
            {
               openPlayerOpera();
            }
            return;
         }
         if(markIsWillChangeElf)
         {
            selectElf();
            markIsWillChangeElf = false;
         }
         else
         {
            _loc1_ = FightingAI.getNextElf(PlayerVO.bagElfVec,fightingElf);
            LogUtil("什么情况啊 ");
            sendNotification("update_fighting_ele",_loc1_,"camp_of_player");
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         markIsFirAtkOfPlay = false;
         markIsWillChangeElf = false;
         hasSureFightContinue = false;
         PlayElfMedia.isChangeElf = false;
         if(campUI.elf != null)
         {
            Starling.juggler.removeTweens(campUI.elf);
            campUI.elf.texture.dispose();
         }
         campUI.disposeMc();
         facade.removeMediator("CampOfPlayerMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         campUI = null;
         fightingElf = null;
         catchResult = null;
         isRelay = false;
      }
   }
}
