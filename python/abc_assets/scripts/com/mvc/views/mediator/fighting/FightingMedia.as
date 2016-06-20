package com.mvc.views.mediator.fighting
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.fighting.FightingUI;
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.models.vos.elf.ElfVO;
   import flash.utils.Timer;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import flash.events.TimerEvent;
   import lzm.util.TimeUtil;
   import com.mvc.controllers.LoadWindowsCmd;
   import com.common.util.dialogue.Dialogue;
   import com.mvc.models.vos.fighting.FightingConfig;
   import lzm.util.LSOManager;
   import starling.events.Event;
   import com.common.util.loading.PVPLoading;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import com.mvc.views.uis.mainCity.hunting.HuntingUI;
   import com.mvc.views.uis.huntingParty.HuntingPartyUI;
   import com.mvc.views.uis.login.startChat.StartChatUI;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.models.proxy.fighting.FightingPro;
   import com.mvc.models.vos.fighting.NPCVO;
   import lzm.starling.display.Button;
   import starling.display.Sprite;
   import starling.text.TextField;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.mvc.views.uis.mainCity.mining.MiningFrameUI;
   import com.mvc.views.uis.mainCity.kingKwan.KingKwanUI;
   import com.mvc.views.mediator.mainCity.backPack.PropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.consts.ConfigConst;
   
   public class FightingMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "FightingMedia";
      
      public static var isFighting:Boolean;
      
      public static var isHasRestrain:Boolean;
       
      private var fighting:FightingUI;
      
      private var currentCampOfPlayerSkill:Vector.<SkillVO>;
      
      private var elfOfPlayer:ElfVO;
      
      private var elfOfComputer:ElfVO;
      
      private var goOutNum:int;
      
      private var timer:Timer;
      
      private var countdownTime:int = 300;
      
      private const pvpTime:int = 10;
      
      public function FightingMedia(param1:Object = null)
      {
         super("FightingMedia",param1);
         fighting = param1 as FightingUI;
         fighting.addEventListener("triggered",clickHandler);
         fighting.autoFBtn.addEventListener("triggered",autoFighting);
         fighting.handFBtn.addEventListener("triggered",handlerFighting);
         if(fighting.speedBtn)
         {
            fighting.speedBtn.addEventListener("triggered",speedHadler);
         }
         if((Config.isAutoFighting || FightingLogicFactor.isPlayBack) && !(LoadPageCmd.lastPage is KingKwanUI || LoadPageCmd.lastPage is PVPBgUI || LoadPageCmd.lastPage is ElfSeriesUI))
         {
            fighting.btnBars.touchable = false;
            Config.stage.addChild(fighting.handFBtn);
         }
         FightingLogicFactor.isRounding = false;
         FightingLogicFactor.isFightingOfFirst = true;
      }
      
      private function speedHadler() : void
      {
         if(PlayerVO.lv < 5)
         {
            Tips.show("5级开启加速X1");
            return;
         }
         if(Config.dialogueDelay == 1.5)
         {
            Config.dialogueDelay = 1;
            fighting.speedTF.text = "X1";
         }
         else if(Config.dialogueDelay == 1)
         {
            if(PlayerVO.lv < 15)
            {
               Tips.show("15级开启加速X2");
               Config.dialogueDelay = 1.5;
               fighting.speedTF.text = "X0";
               return;
            }
            Config.dialogueDelay = 0.5;
            fighting.speedTF.text = "X2";
         }
         else if(Config.dialogueDelay == 0.5)
         {
            Config.dialogueDelay = 1.5;
            fighting.speedTF.text = "X0";
         }
      }
      
      protected function timerHanler(param1:TimerEvent) : void
      {
         countdownTime = countdownTime - 1;
         fighting.timeTF.text = TimeUtil.convertStringToDate(countdownTime).substr(3);
         if(countdownTime <= 0)
         {
            if(!FightingLogicFactor.isPVP)
            {
               endCountTime();
            }
            else
            {
               endPvpCountCalculatorTime();
            }
            return;
         }
      }
      
      private function endPvpCountCalculatorTime() : void
      {
         var _loc1_:* = 0;
         countdownTime = 10;
         fighting.timeTF.text = TimeUtil.convertStringToDate(countdownTime).substr(3);
         timer.stop();
         if(isFighting == false)
         {
            return;
         }
         if(LoadWindowsCmd.currentPage == "PlayElfMedia")
         {
            sendNotification("auto_select_elf");
         }
         else
         {
            _loc1_ = FightingAI.selectSkillAI(elfOfPlayer,elfOfComputer);
            selectSkillHanler(_loc1_);
         }
      }
      
      private function endCountTime() : void
      {
         if(timer != null)
         {
            timer.stop();
            fighting.closeCountdown();
            timer.removeEventListener("timer",timerHanler);
            timer = null;
            if(!FightingLogicFactor.isPVP && countdownTime == 0)
            {
               Tips.show("很抱歉，您未能在限定时间内击败对手，请再接再厉！");
               Dialogue.collectDialogue("战斗结束\n您没能在比赛时间内赢得战斗");
               if(!FightingLogicFactor.isPlayBack)
               {
                  FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isTimeOut = 1;
               }
               Dialogue.playCollectDialogue(function():void
               {
                  currentCampOfPlayerSkill = null;
                  sendNotification("next_dialogue","END_FIGHTING");
               });
            }
         }
      }
      
      private function autoFighting() : void
      {
         if(PlayerVO.vipRank < 1)
         {
            Tips.show("要拥有VIP等级1才能开启自动战斗哦");
            return;
         }
         if(PlayerVO.lv < 6)
         {
            Tips.show("等级到达6级才能开启自动战斗哦");
            return;
         }
         Config.isAutoFighting = true;
         LSOManager.put("isAutoFightSave",true);
         FightingAI.selectAction(elfOfPlayer,elfOfComputer,PlayerVO.bagElfVec);
         fighting.autoFBtn.removeFromParent();
         Config.stage.addChild(fighting.handFBtn);
         fighting.btnBars.touchable = false;
      }
      
      private function handlerFighting() : void
      {
         Config.isAutoFighting = false;
         LSOManager.put("isAutoFightSave",false);
         fighting.handFBtn.removeFromParent();
         fighting.btnBars.touchable = true;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc4_:* = false;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         if(elfOfPlayer != null && elfOfPlayer.currentHp == "0")
         {
            return;
         }
         if(elfOfComputer == null)
         {
            return;
         }
         if(elfOfComputer != null && elfOfComputer.currentHp == "0")
         {
            return;
         }
         if(PVPLoading.isPvpLoading)
         {
            return;
         }
         var _loc5_:* = (param1.target as DisplayObject).name;
         if(fighting.eleBtn.name !== _loc5_)
         {
            if(fighting.backPackBtn.name !== _loc5_)
            {
               if(fighting.goOutBtn.name !== _loc5_)
               {
                  if("skill0" !== _loc5_)
                  {
                     if("skill1" !== _loc5_)
                     {
                        if("skill2" !== _loc5_)
                        {
                           if("skill3" !== _loc5_)
                           {
                              if("nullSkill" === _loc5_)
                              {
                                 Tips.show("技能为空");
                              }
                           }
                           else
                           {
                              selectSkillHanler(3);
                           }
                        }
                        else
                        {
                           selectSkillHanler(2);
                        }
                     }
                     else
                     {
                        if(BeginnerGuide.mark == "sta_catchElf")
                        {
                           return;
                        }
                        selectSkillHanler(1);
                     }
                  }
                  else
                  {
                     selectSkillHanler(0);
                     if(BeginnerGuide.mark == "sta_catchElf")
                     {
                        BeginnerGuide.playBeginnerGuide();
                     }
                  }
               }
               else
               {
                  _loc2_ = Alert.show("你确定要临阵脱逃么？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc2_.addEventListener("close",goOutSureHandler);
               }
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < BackPackPro.bagPropVecArr.length)
               {
                  if(BackPackPro.bagPropVecArr[_loc3_].length > 0)
                  {
                     _loc4_ = true;
                     break;
                  }
                  _loc3_++;
               }
               if(!_loc4_)
               {
                  Tips.show("暂时还没有道具可用哦");
                  return;
               }
               if(LoadPageCmd.lastPage is CityMapUI || LoadPageCmd.lastPage is HuntingUI || LoadPageCmd.lastPage is HuntingPartyUI || LoadPageCmd.lastPage is StartChatUI)
               {
                  if(fighting.speedBtnSpr)
                  {
                     fighting.speedBtnSpr.removeFromParent();
                  }
                  sendNotification("switch_win",null,"LOAD_BACKPACK_WIN");
               }
               else
               {
                  Tips.show("当前不能使用道具");
               }
            }
         }
         else
         {
            if(!elfOfPlayer.isWillDie && elfOfPlayer.status.indexOf(8) != -1)
            {
               Dialogue.collectDialogue(elfOfPlayer.name + "当前被束缚,无法更换精灵");
               Dialogue.playCollectDialogue(null);
               return;
            }
            if(!elfOfPlayer.isWillDie && elfOfPlayer.status.indexOf(36) != -1)
            {
               Dialogue.collectDialogue(elfOfPlayer.name + "当前扎根,无法更换精灵");
               Dialogue.playCollectDialogue(null);
               return;
            }
            sendNotification("switch_win",fighting,"LOAD_PLAYELF_WIN");
         }
      }
      
      private function goOutSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            goOutHandler();
         }
      }
      
      private function goOutHandler(param1:Boolean = false) : void
      {
         if(Config.isOpenBeginner)
         {
            if(param1)
            {
               Dialogue.updateDialogue("现在是新手教学哦，不能逃课的!",true,"LOAD_PLAYELF_WIN");
            }
            else
            {
               Dialogue.collectDialogue("现在是新手教学哦，不能逃课的!");
               Dialogue.playCollectDialogue(null);
            }
            return;
         }
         if(!elfOfPlayer.isWillDie && elfOfPlayer.status.indexOf(8) != -1)
         {
            Dialogue.collectDialogue(elfOfPlayer.nickName + "当前被束缚,不能逃跑");
            Dialogue.playCollectDialogue(FightingLogicFactor.computerActHandler);
            return;
         }
         if(!elfOfPlayer.isWillDie && elfOfPlayer.status.indexOf(36) != -1)
         {
            Dialogue.collectDialogue(elfOfPlayer.nickName + "当前扎根,不能逃跑");
            Dialogue.playCollectDialogue(FightingLogicFactor.computerActHandler);
            return;
         }
         goOutNum = goOutNum + 1;
         if(!FightingLogicFactor.isPlayBack)
         {
            FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isGoOut = 1;
         }
         FightingLogicFactor.goOutHandler(elfOfPlayer,elfOfComputer,goOutNum,param1);
      }
      
      private function selectSkillHanler(param1:int) : void
      {
         var _loc2_:* = 0;
         if(param1 == -1)
         {
            readySkill(param1);
            return;
         }
         if(currentCampOfPlayerSkill[param1].currentPP == 0 && currentCampOfPlayerSkill[param1].continueSkillCount == 0)
         {
            if(!Config.isAutoFighting)
            {
               if(!isAllSkillCannotUse())
               {
                  Tips.show("当前技能没有足够pp");
               }
               else
               {
                  readySkill(-1);
               }
               return;
            }
            _loc2_ = 0;
            while(_loc2_ < currentCampOfPlayerSkill.length)
            {
               if(currentCampOfPlayerSkill[_loc2_].currentPP > 0)
               {
                  var param1:* = _loc2_;
                  readySkill(param1);
                  return;
               }
               _loc2_++;
            }
            readySkill(-1);
            return;
         }
         readySkill(param1);
      }
      
      private function isAllSkillCannotUse() : Boolean
      {
         var _loc1_:* = 0;
         var _loc2_:* = true;
         _loc1_ = 0;
         while(_loc1_ < currentCampOfPlayerSkill.length)
         {
            if(currentCampOfPlayerSkill[_loc1_].currentPP > 0)
            {
               _loc2_ = false;
               break;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      private function readySkill(param1:int) : void
      {
         skillIndex = param1;
         LogUtil(skillIndex + "技能索引");
         if(FightingLogicFactor.isPVP)
         {
            FightingConfig.recordSkillIndex = skillIndex;
            if(skillIndex != -1)
            {
               PVPHandler.PVPHandlerBeforeStart(currentCampOfPlayerSkill[skillIndex],elfOfPlayer,elfOfComputer);
            }
            else
            {
               PVPHandler.PVPHandlerBeforeStart(null,elfOfPlayer,elfOfComputer);
            }
            sendNotification("pvp_timer_stop");
            (facade.retrieveProxy("FightingPro") as FightingPro).write6001(skillIndex);
         }
         else
         {
            elfOfComputer.camp = "camp_of_computer";
            if(FightingAI.selectAction(elfOfComputer,elfOfPlayer,NPCVO.bagElfVec))
            {
               FightingConfig.recordSkillIndex = skillIndex;
            }
            else
            {
               sendNotification("ready_skill",skillIndex,"camp_of_player");
               sendNotification("ready_skill",-1,"camp_of_computer");
               upDatePPShow(skillIndex);
               Dialogue.playCollectDialogue(function():void
               {
                  FightingLogicFactor.firstAttckHandler(elfOfPlayer,elfOfComputer);
               });
            }
         }
         fighting.btnBars.touchable = false;
      }
      
      private function upDatePPShow(param1:int) : void
      {
         if(param1 == -1)
         {
            return;
         }
         var _loc3_:Button = fighting.skillBtnContainer.getChildByName("skill" + param1) as Button;
         var _loc2_:Sprite = _loc3_.skin as Sprite;
         if(_loc2_ == null)
         {
            return;
         }
         LogUtil("当前PP222" + currentCampOfPlayerSkill[param1].currentPP);
         (_loc2_.getChildByName("ppTf") as TextField).text = "PP " + currentCampOfPlayerSkill[param1].currentPP + "/" + currentCampOfPlayerSkill[param1].totalPP;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         notification = param1;
         var _loc3_:* = notification.getName();
         if("update_skill_btns" !== _loc3_)
         {
            if("bomb_dialogue" !== _loc3_)
            {
               if("remove_dialogue" !== _loc3_)
               {
                  if("elf_of_play_come" !== _loc3_)
                  {
                     if("update_fighting_ele" !== _loc3_)
                     {
                        if("load_fighting_page" !== _loc3_)
                        {
                           if("attack_handler" !== _loc3_)
                           {
                              if("continue_beattacked" !== _loc3_)
                              {
                                 if("end_round" !== _loc3_)
                                 {
                                    if("auto_select_skill" !== _loc3_)
                                    {
                                       if("no_fighting_continue" !== _loc3_)
                                       {
                                          if("change_environment" !== _loc3_)
                                          {
                                             if("good_Effect_Show" !== _loc3_)
                                             {
                                                if("init_fighting_value" !== _loc3_)
                                                {
                                                   if("start_round" !== _loc3_)
                                                   {
                                                      if("update_status_show" !== _loc3_)
                                                      {
                                                         if("show_prop_info" !== _loc3_)
                                                         {
                                                            if("receive_skill_index" !== _loc3_)
                                                            {
                                                               if("next_dialogue" !== _loc3_)
                                                               {
                                                                  if("pvp_timer_start" !== _loc3_)
                                                                  {
                                                                     if("pvp_timer_stop" !== _loc3_)
                                                                     {
                                                                        if("open_skill_select" !== _loc3_)
                                                                        {
                                                                           if(ConfigConst.CLOSE_BACKPACK !== _loc3_)
                                                                           {
                                                                              if(ConfigConst.UPDATA_SKILL_PP_SHOW === _loc3_)
                                                                              {
                                                                                 upDatePPShow(notification.getBody() as int);
                                                                              }
                                                                           }
                                                                           else if(fighting.speedBtnSpr)
                                                                           {
                                                                              Config.stage.addChild(fighting.speedBtnSpr);
                                                                           }
                                                                        }
                                                                        else
                                                                        {
                                                                           fighting.btnBars.touchable = true;
                                                                        }
                                                                     }
                                                                     else if(timer != null)
                                                                     {
                                                                        countdownTime = 10;
                                                                        fighting.timeTF.text = TimeUtil.convertStringToDate(countdownTime).substr(3);
                                                                        timer.stop();
                                                                     }
                                                                  }
                                                                  else if(timer != null && FightingLogicFactor.isPVP)
                                                                  {
                                                                     timer.start();
                                                                  }
                                                               }
                                                               else if(notification.getBody() == "change_elf_on_pvp")
                                                               {
                                                                  LogUtil(FightingConfig.pvpSwitch + "pvp的几种情况FM");
                                                                  if(FightingConfig.pvpSwitch == 4)
                                                                  {
                                                                     FightingConfig.pvpSwitch = -1;
                                                                     FightingLogicFactor.playerActHandler();
                                                                  }
                                                                  else
                                                                  {
                                                                     if(FightingConfig.pvpSwitch == 2)
                                                                     {
                                                                        FightingConfig.pvpSwitch = -1;
                                                                        sendNotification("end_round");
                                                                     }
                                                                     sendNotification("next_dialogue","call_my_elf");
                                                                  }
                                                               }
                                                               else if(notification.getBody() == "END_FIGHTING")
                                                               {
                                                                  if(timer)
                                                                  {
                                                                     timer.stop();
                                                                  }
                                                               }
                                                            }
                                                            else
                                                            {
                                                               LogUtil(FightingConfig.pvpSwitch + "执行操作咯、、、、、");
                                                               if(!FightingLogicFactor.isPVP)
                                                               {
                                                                  return;
                                                               }
                                                               var otherSkillIndex:int = notification.getBody() as int;
                                                               if(!FightingLogicFactor.isPlayBack)
                                                               {
                                                                  FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].selectSkill = otherSkillIndex;
                                                               }
                                                               if(FightingConfig.pvpSwitch == 1)
                                                               {
                                                                  FightingConfig.pvpSwitch = -1;
                                                                  LogUtil("什么东西学啊  " + FightingConfig.otherOrder);
                                                                  if(elfOfPlayer.isStoreGas)
                                                                  {
                                                                     FightingConfig.recordSkillIndex = -1;
                                                                  }
                                                                  if(otherSkillIndex == -1)
                                                                  {
                                                                     otherSkillIndex = 165;
                                                                  }
                                                                  if(elfOfComputer.isStoreGas)
                                                                  {
                                                                     otherSkillIndex = -1;
                                                                  }
                                                                  sendNotification("ready_skill",FightingConfig.recordSkillIndex,"camp_of_player");
                                                                  sendNotification("ready_skill_from_sever",otherSkillIndex);
                                                                  upDatePPShow(FightingConfig.recordSkillIndex);
                                                                  Dialogue.playCollectDialogue(function():void
                                                                  {
                                                                     FightingLogicFactor.firstAttckHandler(elfOfPlayer,elfOfComputer);
                                                                  });
                                                               }
                                                               if(FightingConfig.pvpSwitch == 3)
                                                               {
                                                                  FightingConfig.pvpSwitch = -1;
                                                                  sendNotification("update_status_show","clear_anger_status","camp_of_computer");
                                                                  FightingLogicFactor.isFirstOfOurs = true;
                                                                  if(elfOfComputer.isStoreGas)
                                                                  {
                                                                     otherSkillIndex = -1;
                                                                  }
                                                                  sendNotification("ready_skill_from_sever",otherSkillIndex);
                                                                  sendNotification("start_skill",false,"camp_of_computer");
                                                               }
                                                            }
                                                         }
                                                         else
                                                         {
                                                            fighting.showPropInfoSpr(notification.getBody() as PropVO);
                                                         }
                                                      }
                                                      else
                                                      {
                                                         sendNotification("update_skill_btns",currentCampOfPlayerSkill);
                                                      }
                                                   }
                                                   else
                                                   {
                                                      FightingLogicFactor.firstAttckHandler(elfOfPlayer,elfOfComputer);
                                                   }
                                                }
                                                else
                                                {
                                                   LogUtil("初始化能力等级提升");
                                                   initElfFightValue(elfOfPlayer);
                                                   initElfFightValue(elfOfComputer);
                                                }
                                             }
                                             else
                                             {
                                                fighting.goodEffectShow();
                                             }
                                          }
                                          else
                                          {
                                             fighting.showSkillChangeScene(notification.getBody().color,notification.getBody().alpha,notification.getBody().time);
                                          }
                                       }
                                       else
                                       {
                                          goOutHandler(true);
                                       }
                                    }
                                    else
                                    {
                                       if(notification.getBody() != null)
                                       {
                                          var randomSkillIndex:int = notification.getBody() as Number;
                                       }
                                       else if(!FightingLogicFactor.isPlayBack)
                                       {
                                          randomSkillIndex = FightingAI.selectSkillAI(elfOfPlayer,elfOfComputer);
                                       }
                                       else
                                       {
                                          randomSkillIndex = FightingConfig.selfOrder.selectSkill;
                                       }
                                       LogUtil("自动技能索引" + randomSkillIndex);
                                       selectSkillHanler(randomSkillIndex);
                                    }
                                 }
                                 else
                                 {
                                    if(isFighting == false)
                                    {
                                       return;
                                    }
                                    if(FightingLogicFactor.isRounding == false)
                                    {
                                       return;
                                    }
                                    if(CampOfPlayerMedia.isAllElfDie || CampOfComputerMedia.isAllElfDie)
                                    {
                                       return;
                                    }
                                    LogUtil("结束回合");
                                    FightingLogicFactor.isFightingOfFirst = false;
                                    CalculatorFactor.calculatorElf(elfOfPlayer);
                                    CalculatorFactor.calculatorElf(elfOfComputer);
                                    if(FightingConfig.cannotGoAwayRount > 0)
                                    {
                                       FightingConfig.cannotGoAwayRount = FightingConfig.cannotGoAwayRount - 1;
                                       fighting.canNotGoOutRoundText();
                                    }
                                    elfOfPlayer.lastHurtOfSpecial = 0;
                                    elfOfPlayer.lastHurtOfPhysics = 0;
                                    elfOfComputer.lastHurtOfSpecial = 0;
                                    elfOfComputer.lastHurtOfPhysics = 0;
                                    if(continueSkillHandler(elfOfPlayer.currentSkill,elfOfPlayer))
                                    {
                                       elfOfPlayer.currentSkill = null;
                                    }
                                    if(continueSkillHandler(elfOfComputer.currentSkill,elfOfComputer))
                                    {
                                       elfOfComputer.currentSkill = null;
                                    }
                                    StatusFactor.statusHandlerAfterRound(fighting.campOfPlayer,fighting.campComputer);
                                    StatusFactor.statusHandlerAfterRound(fighting.campComputer,fighting.campOfPlayer);
                                    clearPro(elfOfPlayer);
                                    clearPro(elfOfComputer);
                                    PropFactor.carryReplyHpPropHandler(elfOfPlayer,elfOfComputer);
                                    PropFactor.carryReplyHpPropHandler(elfOfComputer,elfOfPlayer);
                                    sendNotification("update_status_show",0,elfOfPlayer.camp);
                                    sendNotification("update_status_show",0,elfOfComputer.camp);
                                    FightingLogicFactor.isRounding = false;
                                 }
                              }
                              else
                              {
                                 FightingLogicFactor.calculatorAttack();
                              }
                           }
                           else
                           {
                              FightingLogicFactor.attackHandler(notification,elfOfPlayer,elfOfComputer,fighting.campOfPlayer,fighting.campComputer);
                           }
                        }
                        else
                        {
                           goOutNum = 0;
                        }
                     }
                     else
                     {
                        if(notification.getType() == "camp_of_player")
                        {
                           elfOfPlayer = notification.getBody() as ElfVO;
                        }
                        if(notification.getType() == "camp_of_computer")
                        {
                           elfOfComputer = notification.getBody() as ElfVO;
                           sendNotification("update_skill_btns",currentCampOfPlayerSkill);
                        }
                     }
                  }
                  else if(LoadPageCmd.lastPage is ElfSeriesUI || LoadPageCmd.lastPage is PVPBgUI || LoadPageCmd.lastPage is MiningFrameUI)
                  {
                     if(timer == null)
                     {
                        if(LoadPageCmd.lastPage is ElfSeriesUI || LoadPageCmd.lastPage is MiningFrameUI)
                        {
                           countdownTime = 300;
                        }
                        else
                        {
                           countdownTime = 10;
                        }
                        timer = new Timer(1000);
                        timer.addEventListener("timer",timerHanler);
                        timer.start();
                        fighting.showCountdown();
                        fighting.timeTF.text = TimeUtil.convertStringToDate(countdownTime).substr(3);
                     }
                  }
                  else if(fighting.autoFBtn.parent == null && !(LoadPageCmd.lastPage is PVPBgUI) && !(LoadPageCmd.lastPage is KingKwanUI) && !(LoadPageCmd.lastPage is StartChatUI))
                  {
                     fighting.addChild(fighting.autoFBtn);
                  }
               }
               else if(elfOfPlayer != null && isFighting)
               {
                  fighting.addChild(fighting.btnBars);
               }
            }
            else
            {
               fighting.btnBars.removeFromParent();
               if(fighting.autoFBtn.parent)
               {
                  fighting.autoFBtn.removeFromParent();
               }
            }
         }
         else
         {
            isFighting = true;
            currentCampOfPlayerSkill = notification.getBody() as Vector.<SkillVO>;
            isHasRestrain = false;
            if(currentCampOfPlayerSkill != null)
            {
               var i:int = 0;
               while(i < currentCampOfPlayerSkill.length)
               {
                  currentCampOfPlayerSkill[i].isRestrain = false;
                  currentCampOfPlayerSkill[i].isNoEffect = false;
                  currentCampOfPlayerSkill[i].isNoSuggest = false;
                  currentCampOfPlayerSkill[i].isNoGoodEffect = false;
                  if(elfOfPlayer != null)
                  {
                     if(elfOfPlayer.skillBeforeStrone != null && elfOfPlayer.skillBeforeStrone == currentCampOfPlayerSkill[i])
                     {
                        currentCampOfPlayerSkill[i].isNoSuggest = true;
                     }
                     if(elfOfComputer.status.indexOf(currentCampOfPlayerSkill[i].status[0]) != -1 && currentCampOfPlayerSkill[i].power == 0 && currentCampOfPlayerSkill[i].skillAffectTarget == 1)
                     {
                        currentCampOfPlayerSkill[i].isNoSuggest = true;
                     }
                  }
                  if(currentCampOfPlayerSkill[i].name == "电磁波" && elfOfComputer.nature.indexOf("地上") != -1)
                  {
                     currentCampOfPlayerSkill[i].isNoEffect = true;
                  }
                  else if(!(currentCampOfPlayerSkill[i].skillAffectTarget == 0 || currentCampOfPlayerSkill[i].sort == "变化"))
                  {
                     var natureAdd:Number = CalculatorFactor.calculatorNatureAdd(currentCampOfPlayerSkill[i],elfOfComputer);
                     LogUtil("技能" + currentCampOfPlayerSkill[i].name + "与对方的属性加成:" + natureAdd);
                     if(natureAdd >= 2 && currentCampOfPlayerSkill[i].currentPP > 0)
                     {
                        currentCampOfPlayerSkill[i].isRestrain = true;
                        isHasRestrain = true;
                     }
                     if(natureAdd < 1 && natureAdd > 0)
                     {
                        currentCampOfPlayerSkill[i].isNoGoodEffect = true;
                     }
                     if(natureAdd == 0)
                     {
                        currentCampOfPlayerSkill[i].isNoEffect = true;
                     }
                     if(currentCampOfPlayerSkill[i].name == "食梦" && elfOfComputer.status.indexOf(6) == -1)
                     {
                        currentCampOfPlayerSkill[i].isRestrain = false;
                     }
                  }
                  i = i + 1;
               }
            }
            fighting.upDateSkillBtn(currentCampOfPlayerSkill);
         }
      }
      
      private function clearPro(param1:ElfVO) : void
      {
         if(param1.status.indexOf(26) != -1)
         {
            param1.status.splice(param1.status.indexOf(26),1);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_skill_btns","bomb_dialogue","change_environment","update_status_show","remove_dialogue","update_fighting_ele","init_fighting_value","show_prop_info","open_skill_select","load_fighting_page","attack_handler","good_Effect_Show","receive_skill_index",ConfigConst.CLOSE_BACKPACK,"next_dialogue","continue_beattacked","elf_of_play_come","pvp_timer_start","end_round","auto_select_skill","no_fighting_continue","start_round","pvp_timer_stop",ConfigConst.UPDATA_SKILL_PP_SHOW];
      }
      
      private function initElfFightValue(param1:ElfVO) : void
      {
         param1.ablilityAddLv = [0,0,0,0,0,1,0];
      }
      
      private function continueSkillHandler(param1:SkillVO, param2:ElfVO) : Boolean
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         if(param1 != null && (param1.name == "花之舞" || param1.name == "横冲直撞" || param1.name == "龙鳞之怒" || param1.name == "滚动" || param1.id == 301 || param1.id == 253))
         {
            _loc3_ = Math.round(Math.random() * 1 + 2);
            if(param1.name == "滚动" || param1.id == 301)
            {
               _loc3_ = 5;
            }
            if(param1.id == 253)
            {
               _loc3_ = 3;
            }
            if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
            {
               if(param2.camp == "camp_of_player")
               {
                  _loc3_ = FightingConfig.selfOrder.attackRoundNum;
               }
               else
               {
                  _loc3_ = FightingConfig.otherOrder.attackRoundNum;
               }
            }
            if(!FightingLogicFactor.isPlayBack)
            {
               if(param2.camp == "camp_of_player")
               {
                  FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].attackRoundNum = _loc3_;
               }
               else
               {
                  FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].attackRoundNum = _loc3_;
               }
            }
            LogUtil(_loc3_ + "连续技能" + param1.continueSkillCount + "技能名称" + param1.name);
            if(param1.continueSkillCount < _loc3_)
            {
               §§dup(param1).continueSkillCount++;
            }
            if(param1.continueSkillCount >= _loc3_)
            {
               if(param1.id != 205 && param1.id != 301 && param1.id != 253)
               {
                  if(param2.camp == "camp_of_player")
                  {
                     _loc4_ = elfOfComputer;
                  }
                  else
                  {
                     _loc4_ = elfOfPlayer;
                  }
                  if(!PropFactor.carryClearPropHandler(param2,"混乱",_loc4_))
                  {
                     if(param2.status.indexOf(7) == -1)
                     {
                        param2.status.push(7);
                     }
                     Dialogue.collectDialogue(param2.nickName + "混乱了");
                  }
               }
               if(param1.id == 253)
               {
                  FightingLogicFactor.isNoisy = 0;
               }
               param1.continueSkillCount = 0;
               return true;
            }
         }
         return false;
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(fighting.btnBars.parent)
         {
            fighting.btnBars.removeFromParent(true);
         }
         if(fighting.handFBtn.parent)
         {
            fighting.handFBtn.removeFromParent(true);
         }
         if(fighting.speedBtnSpr != null)
         {
            if(fighting.speedBtnSpr.parent)
            {
               fighting.speedBtnSpr.removeFromParent(true);
            }
         }
         endCountTime();
         fighting.bg.texture.dispose();
         facade.removeMediator("FightingMedia");
         UI.dispose();
         viewComponent = null;
         isFighting = false;
         FightingLogicFactor.isPVP = false;
         FightingLogicFactor.isPlayBack = false;
         FightingConfig.cannotGoAwayRount = "0";
         FightingLogicFactor.isFightingOfFirst = false;
         FightingLogicFactor.isNoisy = 0;
      }
   }
}
