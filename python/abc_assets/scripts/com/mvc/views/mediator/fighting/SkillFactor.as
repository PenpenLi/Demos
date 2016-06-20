package com.mvc.views.mediator.fighting
{
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.util.HttpClient;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.mediator.mainCity.backPack.PropFactor;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.GameFacade;
   import com.mvc.views.uis.fighting.CampBaseUI;
   import com.common.util.dialogue.Dialogue;
   import com.mvc.models.vos.fighting.FightingConfig;
   import starling.core.Starling;
   import lzm.starling.swf.Swf;
   import starling.animation.Tween;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.fighting.NPCVO;
   import extend.SoundEvent;
   import com.common.events.EventCenter;
   import lzm.starling.swf.display.SwfMovieClip;
   import com.mvc.views.uis.fighting.CampOfPlayerUI;
   import com.mvc.views.uis.fighting.CampOfComputerUI;
   
   public class SkillFactor
   {
       
      public function SkillFactor()
      {
         super();
      }
      
      public static function readySkill(param1:ElfVO, param2:int, param3:ElfVO) : SkillVO
      {
         var _loc5_:* = null;
         LogUtil(param1.currentSkillVec.length + "技能长度啊大哥" + param2);
         if(param1.currentSkillVec.length <= param2)
         {
            HttpClient.send(Game.upLoadUrl,{
               "custom":Game.system,
               "message":"找不到进呢过:" + param2 + ":技能长度:" + param1.currentSkillVec.length,
               "token":Game.token,
               "userId":PlayerVO.userId,
               "swfVersion":Pocketmon.swfVersion,
               "description":Pocketmon._description
            },null,null,"post");
         }
         var _loc4_:SkillVO = param1.currentSkillVec[param2];
         if(!param1.isStoreGas && _loc4_.continueSkillCount == 0 && !param1.isCannotActStatus && !param1.isReleaseAnger && param1.status.indexOf(17) == -1)
         {
            _loc4_.currentPP = _loc4_.currentPP - 1;
         }
         param1.currentSkill = _loc4_;
         PropFactor.carryReplyPPropHandler(param1,param3);
         if(param1.status.indexOf(29) != -1 && param1.currentSkill.name != "连切")
         {
            param1.status.splice(param1.status.indexOf(29),1);
            _loc5_ = GetElfFactor.getSkillById(210);
            if(param1.skillOfLast != null)
            {
               param1.skillOfLast.power = _loc5_.power;
            }
            _loc5_ = null;
            GameFacade.getInstance().sendNotification("update_status_show",0,param1.camp);
         }
         if(param1.skillOfLast != null)
         {
            if(param1.skillOfLast.name == "守住" || param1.skillOfLast.name == "忍耐" || param1.skillOfLast.name == "先决")
            {
               if(param1.currentSkill.name != "守住" && param1.currentSkill.name != "忍耐" && param1.currentSkill.name != "先决")
               {
                  param1.skillOfLast.successRate = 100;
               }
               else
               {
                  param1.currentSkill.successRate = param1.skillOfLast.successRate;
               }
            }
         }
         return _loc4_;
      }
      
      public static function startSkill(param1:CampBaseUI, param2:CampBaseUI) : void
      {
         var _loc3_:ElfVO = param1.myVO;
         LogUtil("使用的技能" + _loc3_.name);
         if(storeGasHandler(param1))
         {
            return;
         }
         FeatureFactor.pressureHandler(param2.myVO,_loc3_);
         if(isMull(param1))
         {
            return;
         }
         if(_loc3_.skillBeforeStrone == _loc3_.currentSkill)
         {
            GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "陷入石化状态!\n技能使用失败",_loc3_.camp);
            return;
         }
         _loc3_.skillFinalUseId = _loc3_.currentSkill.id;
         _loc3_.skillOfLast = _loc3_.currentSkill;
         if(_loc3_.skillOfFirstSelect == null)
         {
            _loc3_.skillOfFirstSelect = _loc3_.currentSkill;
         }
         if(isCopy(param1,param2))
         {
            return;
         }
         if(_loc3_.currentSkill.id == 252)
         {
            fakeHandler(param1,param2);
            return;
         }
         if(_loc3_.currentSkill.name != "学舌术" && _loc3_.currentSkill.name != "挥指功" && _loc3_.currentSkill.name != "梦话")
         {
            if(_loc3_.currentSkill.id == 253)
            {
               FightingLogicFactor.isNoisy = 1;
               if(param2.myVO.status.indexOf(6) != -1)
               {
                  param2.myVO.status.splice(param2.myVO.status.indexOf(6),1);
                  Dialogue.collectDialogue(param2.myVO.nickName + "被吵醒");
               }
               if(_loc3_.status.indexOf(6) != -1)
               {
                  _loc3_.status.splice(_loc3_.status.indexOf(6),1);
                  Dialogue.collectDialogue(_loc3_.nickName + "被吵醒");
               }
            }
            SkillFactor.skillBeUsed(_loc3_.currentSkill,param1,param2);
         }
         if(isLearn(param1,param2))
         {
            return;
         }
         if(isLead(param1,param2))
         {
            return;
         }
         if(isTalkSleep(param1,param2))
         {
            return;
         }
      }
      
      private static function fakeHandler(param1:CampBaseUI, param2:CampBaseUI) : void
      {
         var _loc4_:ElfVO = param1.myVO;
         if(_loc4_.currentSkill.id == 252 && FightingLogicFactor.isFightingOfFirst)
         {
            if(_loc4_.camp == "camp_of_player")
            {
               if(FightingLogicFactor.isFirstOfOurs)
               {
                  param2.myVO.status.push(9);
                  SkillFactor.skillBeUsed(_loc4_.currentSkill,param1,param2);
                  return;
               }
            }
            else if(!FightingLogicFactor.isFirstOfOurs)
            {
               param2.myVO.status.push(9);
               SkillFactor.skillBeUsed(_loc4_.currentSkill,param1,param2);
               return;
            }
         }
         var _loc3_:String = _loc4_.nickName + "使用假动作被识破";
         GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_,param1.myVO.camp);
      }
      
      private static function isTalkSleep(param1:CampBaseUI, param2:CampBaseUI) : Boolean
      {
         targetCamp = param1;
         otherCamp = param2;
         var targetElf:ElfVO = targetCamp.myVO;
         if(targetElf.currentSkill.name == "梦话")
         {
            var callback:Function = function():void
            {
               targetElf.currentSkill = talkingSleep(targetElf);
               if(targetElf.currentSkill.name == "睡觉")
               {
                  GameFacade.getInstance().sendNotification("tell_after_self_act",targetElf.nickName + "梦话选择了睡觉\n使用失败",targetCamp.myVO.camp);
                  return;
               }
               if(targetElf.currentSkill.id == 91 || targetElf.currentSkill.id == 19 || targetElf.currentSkill.id == 13 || targetElf.currentSkill.id == 143 || targetElf.currentSkill.id == 76 || targetElf.currentSkill.id == 130 || targetElf.currentSkill.id == 117 || targetElf.currentSkill.id == 119 || targetElf.currentSkill.id == 118 || targetElf.currentSkill.id == 253 || targetElf.currentSkill.id == 264 || targetElf.currentSkill.id == 291)
               {
                  GameFacade.getInstance().sendNotification("tell_after_self_act",targetElf.nickName + "梦话不能发动" + targetElf.currentSkill.name + "\n使用失败",targetCamp.myVO.camp);
                  return;
               }
               Dialogue.collectDialogue(targetElf.nickName + "在说梦话");
               Dialogue.playCollectDialogue(function():void
               {
                  SkillFactor.skillBeUsed(targetElf.currentSkill,targetCamp,otherCamp);
               });
            };
            playSkillEffect(targetElf.currentSkill,targetCamp,false,callback);
            return true;
         }
         return false;
      }
      
      private static function isLead(param1:CampBaseUI, param2:CampBaseUI) : Boolean
      {
         targetCamp = param1;
         otherCamp = param2;
         var targetElf:ElfVO = targetCamp.myVO;
         if(targetElf.currentSkill.name == "挥指功")
         {
            var callBack:Function = function():void
            {
               targetElf.currentSkill = leadSkillHandler(targetElf);
               var skillId:int = targetElf.currentSkill.id;
               if(FightingConfig.skillAssetsOfUse.indexOf("skill" + skillId) == -1 && Config.isOpenFightingAni)
               {
                  if(FightingConfig.skillAssetsOfDisposeAtOnce.indexOf("skill" + skillId) == -1)
                  {
                     FightingConfig.skillAssetsOfDisposeAtOnce.push("skill" + skillId);
                  }
               }
               Dialogue.collectDialogue(targetElf.nickName + "使用了\n挥指功");
               Dialogue.playCollectDialogue(function():void
               {
                  SkillFactor.skillBeUsed(targetElf.currentSkill,targetCamp,otherCamp);
               });
            };
            playSkillEffect(targetElf.currentSkill,targetCamp,false,callBack);
            return true;
         }
         return false;
      }
      
      private static function isLearn(param1:CampBaseUI, param2:CampBaseUI) : Boolean
      {
         targetCamp = param1;
         otherCamp = param2;
         var targetElf:ElfVO = targetCamp.myVO;
         if(targetElf.currentSkill.name == "学舌术")
         {
            if(otherCamp.myVO.skillFinalUseId == 0)
            {
               GameFacade.getInstance().sendNotification("tell_after_self_act",targetElf.nickName + "使用学舌术失败",targetCamp.myVO.camp);
               return true;
            }
            targetElf.currentSkill = GetElfFactor.getSkillById(otherCamp.myVO.skillFinalUseId);
            if(targetElf.currentSkill.id == 118 || targetElf.currentSkill.id == 119 || targetElf.currentSkill.id == 165 || targetElf.currentSkill.id == 102 || targetElf.currentSkill.id == 68 || targetElf.currentSkill.id == 144 || targetElf.currentSkill.id == 214 || targetElf.currentSkill.id == 243 || targetElf.currentSkill.id == 244 || targetElf.currentSkill.id == 117 || targetElf.currentSkill.id == 255 || targetElf.currentSkill.id == 353 || targetElf.currentSkill.id == 264)
            {
               var str:String = targetElf.nickName + "使用了学舌术\n但学习不了对方的" + targetElf.currentSkill.name;
               GameFacade.getInstance().sendNotification("tell_after_self_act",str,targetCamp.myVO.camp);
               targetElf.currentSkill = null;
            }
            else
            {
               Dialogue.collectDialogue(targetElf.nickName + "使用了\n学舌术");
               Dialogue.playCollectDialogue(function():void
               {
                  SkillFactor.skillBeUsed(targetElf.currentSkill,targetCamp,otherCamp);
               });
            }
            return true;
         }
         return false;
      }
      
      private static function isCopy(param1:CampBaseUI, param2:CampBaseUI) : Boolean
      {
         targetCamp = param1;
         otherCamp = param2;
         var targetElf:ElfVO = targetCamp.myVO;
         if(targetElf.currentSkill.name == "模仿")
         {
            var otherSkill:SkillVO = otherCamp.myVO.skillOfLast;
            LogUtil(otherSkill + "另外一方最后的技能");
            if(otherSkill == null || otherSkill.name == "模仿" || otherSkill.name == "指挥官" || otherSkill.name == "挣扎")
            {
               GameFacade.getInstance().sendNotification("tell_after_self_act",targetElf.nickName + "模仿失败",targetElf.camp);
               return true;
            }
            var i:int = 0;
            while(i < targetElf.currentSkillVec.length)
            {
               if(targetElf.currentSkillVec[i].name == otherSkill.name)
               {
                  GameFacade.getInstance().sendNotification("tell_after_self_act",targetElf.nickName + "模仿失败",targetElf.camp);
                  return true;
               }
               i = i + 1;
            }
            playSkillEffect(targetElf.currentSkill,targetCamp,false,function():void
            {
               copyHandler(targetElf,otherSkill);
            });
            return true;
         }
         return false;
      }
      
      private static function isMull(param1:CampBaseUI) : Boolean
      {
         var _loc2_:ElfVO = param1.myVO;
         if(_loc2_.status.indexOf(7) != -1)
         {
            if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
            {
               if(_loc2_.camp == "camp_of_player")
               {
                  if(FightingConfig.selfOrder.isMull == 1)
                  {
                     mullHandler(param1);
                     return true;
                  }
               }
               else
               {
                  if(FightingConfig.otherOrder == null)
                  {
                     return true;
                  }
                  if(FightingConfig.otherOrder.hasOwnProperty("isMull") && FightingConfig.otherOrder.isMull == 1)
                  {
                     mullHandler(param1);
                     return true;
                  }
               }
            }
            else if(Math.random() * 2 > 1)
            {
               mullHandler(param1);
               return true;
            }
         }
         return false;
      }
      
      private static function talkingSleep(param1:ElfVO) : SkillVO
      {
         var _loc3_:* = 0;
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               _loc3_ = FightingConfig.selfOrder.talkSleepUseIndex;
            }
            else
            {
               _loc3_ = FightingConfig.otherOrder.talkSleepUseIndex;
            }
         }
         else
         {
            _loc3_ = Math.random() * param1.currentSkillVec.length;
            while(_loc3_ == param1.currentSkillVec.indexOf(param1.currentSkill))
            {
               _loc3_ = Math.random() * param1.currentSkillVec.length;
            }
         }
         var _loc2_:SkillVO = param1.currentSkillVec[_loc3_];
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].talkSleepUseIndex = _loc3_;
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].talkSleepUseIndex = _loc3_;
            }
         }
         return _loc2_;
      }
      
      private static function isChangeEnvironment(param1:String, param2:CampBaseUI) : void
      {
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < SkillMcSort.colorChange.length)
         {
            if(param1 == SkillMcSort.colorChange[_loc3_][0])
            {
               GameFacade.getInstance().sendNotification("change_environment",{
                  "color":SkillMcSort.colorChange[_loc3_][1],
                  "alpha":SkillMcSort.colorChange[_loc3_][2],
                  "time":SkillMcSort.colorChange[_loc3_][3]
               });
               break;
            }
            _loc3_++;
         }
         _loc5_ = 0;
         while(_loc5_ < SkillMcSort.shareScreen1.length)
         {
            if(param1 == SkillMcSort.shareScreen1[_loc5_][0])
            {
               AniFactor.shareScreen1(SkillMcSort.shareScreen1[_loc5_][1]);
               isBeAttacking(param1,param2);
               return;
            }
            _loc5_++;
         }
         _loc4_ = 0;
         while(_loc4_ < SkillMcSort.shareScreen2.length)
         {
            if(param1 == SkillMcSort.shareScreen2[_loc4_][0])
            {
               AniFactor.shareScreen2(SkillMcSort.shareScreen2[_loc4_][1]);
               isBeAttacking(param1,param2);
               return;
            }
            _loc4_++;
         }
         isBeAttacking(param1,param2);
      }
      
      private static function isBeAttacking(param1:String, param2:CampBaseUI) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < SkillMcSort.beAttacking1.length)
         {
            if(param1 == SkillMcSort.beAttacking1[_loc3_][0])
            {
               AniFactor.beAttacking1(param2.elf,SkillMcSort.beAttacking1[_loc3_][1],SkillMcSort.beAttacking1[_loc3_][2]);
               return;
            }
            _loc3_++;
         }
         _loc4_ = 0;
         while(_loc4_ < SkillMcSort.beAttacking2.length)
         {
            if(param1 == SkillMcSort.beAttacking2[_loc4_][0])
            {
               AniFactor.beAttacking2(param2.elf,SkillMcSort.beAttacking2[_loc4_][1],SkillMcSort.beAttacking2[_loc4_][2],SkillMcSort.beAttacking2[_loc4_][3]);
               return;
            }
            _loc4_++;
         }
         _loc5_ = 0;
         while(_loc5_ < SkillMcSort.beAttacking3.length)
         {
            if(param1 == SkillMcSort.beAttacking3[_loc5_])
            {
               AniFactor.beAttacking3(param2.elf,2);
               return;
            }
            _loc5_++;
         }
         _loc6_ = 0;
         while(_loc6_ < SkillMcSort.beAttacking4.length)
         {
            if(param1 == SkillMcSort.beAttacking4[_loc6_])
            {
               AniFactor.beAttacking4(param2.elf,4);
               return;
            }
            _loc6_++;
         }
      }
      
      private static function endFightingSkill(param1:CampBaseUI, param2:CampBaseUI) : void
      {
         targetCamp = param1;
         skillCamp = param2;
         var callBack:Function = function():void
         {
            Dialogue.updateDialogue(targetCamp.myVO.nickName + "使用了" + targetCamp.myVO.currentSkill.name);
            Starling.juggler.delayCall(function():void
            {
               FightingConfig.isWin = false;
               FightingConfig.isGoOut = true;
               Dialogue.updateDialogue("战斗结束",true,"END_FIGHTING");
            },1);
         };
         playSkillEffect(targetCamp.myVO.currentSkill,skillCamp,false,callBack);
      }
      
      public static function storeGasHandler(param1:CampBaseUI) : Boolean
      {
         targetCamp = param1;
         var targetElf:ElfVO = targetCamp.myVO;
         if(targetElf.isStoreGas)
         {
            if(targetElf.camp == "camp_of_computer")
            {
               var otherCamp:String = "camp_of_player";
            }
            else
            {
               otherCamp = "camp_of_computer";
            }
            if(StatusFactor.statusHandlerBeforeSkillStart(targetCamp,otherCamp) == true)
            {
               return true;
            }
            targetElf.isStoreGas = false;
            Dialogue.updateDialogue(targetElf.nickName + "蓄气攻击");
            var index:int = targetCamp.myVO.status.indexOf(19);
            if(index != -1)
            {
               targetCamp.myVO.status.splice(index,1);
               Starling.juggler.delayCall(function():void
               {
                  targetCamp.elf.visible = true;
               },1);
            }
            index = targetCamp.myVO.status.indexOf(43);
            if(index != -1)
            {
               targetCamp.myVO.status.splice(index,1);
               Starling.juggler.delayCall(function():void
               {
                  targetCamp.elf.visible = true;
               },1);
            }
            index = targetCamp.myVO.status.indexOf(20);
            if(index != -1)
            {
               var swf:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("skill91");
               startSkillMc(swf,"mc_91_3",targetCamp,"skill91");
               targetCamp.myVO.status.splice(index,1);
               targetCamp.elf.visible = true;
               var _y:int = targetCamp.elf.y;
               var t:Tween = new Tween(targetCamp.elf,0.3,"easeOut");
               Starling.juggler.add(t);
               t.animate("y",_y,_y + 100);
               t.onComplete = function():void
               {
                  if(targetCamp.shadow != null)
                  {
                     targetCamp.shadow.visible = true;
                  }
               };
            }
            GameFacade.getInstance().sendNotification("attack_handler",0,targetElf.camp);
            GameFacade.getInstance().sendNotification("update_status_show",0,targetElf.camp);
            return true;
         }
         return false;
      }
      
      private static function copyHandler(param1:ElfVO, param2:SkillVO) : void
      {
         var _loc4_:int = param1.currentSkillVec.indexOf(param1.currentSkill);
         param1.copykillIndex = _loc4_;
         param1.recordSkBeforeCopy = param1.currentSkill;
         param1.currentSkillVec[_loc4_] = GetElfFactor.getSkillById(param2.id);
         param1.currentSkillVec[_loc4_].totalPP = 5;
         param1.currentSkillVec[_loc4_].currentPP = "5";
         if(param1.camp == "camp_of_player")
         {
            GameFacade.getInstance().sendNotification("update_skill_btns",param1.currentSkillVec);
         }
         var _loc3_:String = param1.name + "使用了模仿\n" + param1.name + "模仿了技能" + param1.currentSkillVec[_loc4_].name;
         GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_,param1.camp);
      }
      
      private static function mullHandler(param1:CampBaseUI) : void
      {
         var _loc2_:int = CalculatorFactor.mullHurtCalculator(param1.myVO);
         param1.myVO.currentSkill.continueSkillCount = 0;
         param1.myVO.currentSkill = null;
         Dialogue.collectDialogue(param1.myVO.nickName + "因为混乱,攻击了自己\n损失" + _loc2_ + "点HP");
         playStatusEffect(7,param1);
         playOtherEffect("mc_mull",param1);
         GameFacade.getInstance().sendNotification("hp_change",_loc2_,param1.myVO.camp);
         GameFacade.getInstance().sendNotification("tell_after_self_act","",param1.myVO.camp);
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param1.myVO.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isMull = 1;
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isMull = 1;
            }
         }
      }
      
      private static function leadSkillHandler(param1:ElfVO) : SkillVO
      {
         var _loc7_:* = null;
         var _loc5_:* = 0;
         var _loc3_:* = false;
         var _loc6_:* = 0;
         var _loc2_:int = Math.round(Math.random() * 164 + 1);
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               _loc2_ = FightingConfig.selfOrder.leadSkillId;
            }
            else
            {
               _loc2_ = FightingConfig.otherOrder.leadSkillId;
            }
         }
         else
         {
            _loc7_ = [];
            _loc5_ = 0;
            while(_loc5_ < param1.currentSkillVec.length)
            {
               _loc7_.push(param1.currentSkillVec[_loc5_].id);
               _loc5_++;
            }
            _loc7_.push(119,165,102,68,182,194,197,203,214,243);
            while(!_loc3_)
            {
               _loc2_ = Math.round(Math.random() * 164 + 1);
               _loc3_ = true;
               _loc6_ = 0;
               while(_loc6_ < _loc7_.length)
               {
                  if(_loc7_[_loc6_] == _loc2_)
                  {
                     _loc3_ = false;
                     break;
                  }
                  _loc6_++;
               }
            }
         }
         var _loc4_:SkillVO = GetElfFactor.getSkillById(_loc2_);
         LogUtil("指挥功学习的技能" + _loc4_.name);
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].leadSkillId = _loc2_;
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].leadSkillId = _loc2_;
            }
         }
         return _loc4_;
      }
      
      private static function isSwallowSkill(param1:SkillVO, param2:ElfVO) : Boolean
      {
         var _loc3_:* = 0;
         if(param1.id == 256)
         {
            if(param2.storeNum == "0")
            {
               Dialogue.collectDialogue(param2.nickName + "没有储存能量\n吞下失败");
            }
            else
            {
               _loc3_ = param2.totalHp * 0.25 * Math.pow(2,param2.storeNum - 1);
               Dialogue.collectDialogue(param2.nickName + "\n恢复了HP");
               GameFacade.getInstance().sendNotification("hp_change",-_loc3_,param2.camp);
               param2.ablilityAddLv[1] = 0;
               param2.ablilityAddLv[3] = 0;
               param2.storeNum = "0";
            }
            return true;
         }
         return false;
      }
      
      private static function isStoreSkill(param1:SkillVO, param2:ElfVO) : Boolean
      {
         if(param1.id == 254)
         {
            LogUtil(param2 + "精灵为空吗");
            if(param2.storeNum < 3)
            {
               param2.storeNum = param2.storeNum + 1;
               var _loc3_:* = 1;
               var _loc4_:* = param2.ablilityAddLv[_loc3_] + 1;
               param2.ablilityAddLv[_loc3_] = _loc4_;
               _loc4_ = 3;
               _loc3_ = param2.ablilityAddLv[_loc4_] + 1;
               param2.ablilityAddLv[_loc4_] = _loc3_;
               Dialogue.collectDialogue(param2.nickName + "提升了防御和特防");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "最多只能储存三次力量");
            }
            return true;
         }
         return false;
      }
      
      public static function skillBeUsed(param1:SkillVO, param2:CampBaseUI, param3:CampBaseUI) : void
      {
         targetSkill = param1;
         targetCamp = param2;
         otherCamp = param3;
         if(FightingMedia.isFighting == false)
         {
            return;
         }
         var targetElf:ElfVO = targetCamp.myVO;
         if(targetElf.currentSkill.name == "旋风" || targetElf.currentSkill.name == "吼叫")
         {
            if(otherCamp == null)
            {
               return;
            }
            if(targetElf.camp == "camp_of_player")
            {
               if(NPCVO.name == null)
               {
                  if(otherCamp.myVO.status.indexOf(19) != -1 || otherCamp.myVO.status.indexOf(20) != -1 || otherCamp.myVO.status.indexOf(36) != -1)
                  {
                     GameFacade.getInstance().sendNotification("tell_after_self_act",targetCamp.myVO.nickName + "发动" + targetElf.currentSkill.name + "失败",targetCamp.myVO.camp);
                     return;
                  }
                  if(targetElf.currentSkill.name == "吼叫")
                  {
                     firstSkillPlay(targetElf.currentSkill,targetCamp,function():void
                     {
                        endFightingSkill(targetCamp,otherCamp);
                     });
                  }
                  else
                  {
                     playSkillEffect(targetElf.currentSkill,otherCamp,false,function():void
                     {
                        endFightingSkill(targetCamp,otherCamp);
                     });
                  }
                  return;
               }
               if(CampOfComputerMedia.lessElfNum == 1 || otherCamp.myVO.status.indexOf(19) != -1 || otherCamp.myVO.status.indexOf(20) != -1 || otherCamp.myVO.status.indexOf(36) != -1)
               {
                  GameFacade.getInstance().sendNotification("tell_after_self_act",targetCamp.myVO.nickName + "发动" + targetElf.currentSkill.name + "失败",targetCamp.myVO.camp);
                  return;
               }
               var callBack:Function = function():void
               {
                  Dialogue.collectDialogue(targetCamp.myVO.nickName + "发动" + targetElf.currentSkill.name);
                  Dialogue.playCollectDialogue(function():void
                  {
                     GameFacade.getInstance().sendNotification("change_elf",0,"camp_of_computer");
                  });
               };
               if(targetElf.currentSkill.name == "吼叫")
               {
                  firstSkillPlay(targetElf.currentSkill,targetCamp,callBack);
               }
               else
               {
                  playSkillEffect(targetElf.currentSkill,otherCamp,false,callBack);
               }
            }
            else
            {
               LogUtil("背包剩余精灵个数" + GetElfFactor.bagElfNum(true));
               if(GetElfFactor.bagElfNum(true) == 1 || otherCamp.myVO.status.indexOf(19) != -1 || otherCamp.myVO.status.indexOf(20) != -1 || otherCamp.myVO.status.indexOf(36) != -1)
               {
                  GameFacade.getInstance().sendNotification("tell_after_self_act",targetCamp.myVO.nickName + "发动" + targetElf.currentSkill.name + "失败",targetCamp.myVO.camp);
                  return;
               }
               callBack = function():void
               {
                  Dialogue.collectDialogue(targetCamp.myVO.nickName + "发动" + targetElf.currentSkill.name);
                  Dialogue.playCollectDialogue(function():void
                  {
                     GameFacade.getInstance().sendNotification("change_elf",0,"camp_of_player");
                  });
               };
               if(targetElf.currentSkill.name == "吼叫")
               {
                  firstSkillPlay(targetElf.currentSkill,targetCamp,callBack);
               }
               else
               {
                  playSkillEffect(targetElf.currentSkill,otherCamp,false,callBack);
               }
            }
            return;
         }
         if(targetElf.currentSkill.name == "瞬间移动")
         {
            if(NPCVO.name == null && targetElf.status.indexOf(8) == -1 && targetElf.status.indexOf(36) == -1)
            {
               callBack = function():void
               {
                  var _loc1_:Tween = new Tween(targetCamp.elf,0.1,"easeIn");
                  Starling.juggler.add(_loc1_);
                  _loc1_.animate("scaleX",0);
                  _loc1_.delay = 0.5;
                  endFightingSkill(targetCamp,targetCamp);
               };
               playSkillEffect(targetElf.currentSkill,targetCamp,false,callBack);
               return;
            }
            GameFacade.getInstance().sendNotification("tell_after_self_act",targetCamp.myVO.nickName + "发动瞬间移动失败",targetCamp.myVO.camp);
            return;
         }
         if(targetElf.currentSkill.name == "满地星")
         {
            if(otherCamp == null)
            {
               return;
            }
            callBack = function():void
            {
               otherCamp.landStar = otherCamp.landStar + 1 > 3?3:otherCamp.landStar + 1;
               GameFacade.getInstance().sendNotification("tell_after_self_act",targetCamp.myVO.nickName + "铺下满地星",targetCamp.myVO.camp);
            };
            playSkillEffect(targetElf.currentSkill,otherCamp,false,callBack);
            return;
         }
         if(targetSkill.name == "变身")
         {
            targetCamp.elf.dispatchEventWith("end_attack_ani");
            return;
         }
         var skillDialogue:String = targetCamp.myVO.nickName + "使用\n" + targetSkill.name;
         if(targetSkill.name == "聚宝功")
         {
            var moneyNum:int = targetCamp.myVO.lv * 1;
            FightingConfig.moneyFromFighting = FightingConfig.moneyFromFighting + moneyNum;
            skillDialogue = §§dup().skillDialogue + (",投掷出" + moneyNum + "金币");
         }
         Dialogue.updateDialogue(skillDialogue);
         if(targetSkill.skillAffectTarget == 1)
         {
            if(targetSkill.isStoreGas == 1)
            {
               callBack = function():void
               {
                  targetCamp.myVO.isStoreGas = true;
                  AniFactor.useSkillForSelfAni(targetCamp.elf);
                  if(targetSkill.status[0] == 19 || targetSkill.id == 340)
                  {
                     targetCamp.myVO.status.push(19);
                     targetCamp.elf.visible = false;
                  }
                  if(targetSkill.status[0] == 43)
                  {
                     targetCamp.myVO.status.push(43);
                     targetCamp.elf.visible = false;
                  }
                  if(targetSkill.status[0] == 20)
                  {
                     targetCamp.myVO.status.push(20);
                     if(targetCamp.shadow != null)
                     {
                        targetCamp.shadow.visible = false;
                     }
                     var t2:Tween = new Tween(targetCamp.elf,0.5,"easeOut");
                     Starling.juggler.add(t2);
                     t2.animate("y",targetCamp.elf.y + 100);
                     t2.animate("alpha",0);
                     t2.onComplete = function():void
                     {
                        targetCamp.elf.y = targetCamp.elf.y + 100;
                        targetCamp.elf.alpha = 1;
                        targetCamp.elf.visible = false;
                     };
                  }
               };
               playSkillEffect(targetSkill,targetCamp,true,callBack);
            }
            else
            {
               firstSkillPlay(targetSkill,targetCamp,function():void
               {
                  AniFactor.useSkillForOtherAni(targetCamp.elf,targetCamp.moveRange);
               });
            }
         }
         else
         {
            callBack = function():void
            {
               if(Config.isOpenFightingAni)
               {
                  SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","skillM" + targetSkill.soundName);
               }
               skillForSelf(targetSkill,targetCamp.myVO);
               if(targetSkill.name == "缩小")
               {
                  AniFactor.scaleMinAni(targetCamp.elf);
               }
               else if(targetSkill.name != "替身")
               {
                  AniFactor.useSkillForSelfAni(targetCamp.elf);
               }
               if(targetSkill.name == "自我暗示")
               {
                  if(otherCamp == null)
                  {
                     return;
                  }
                  targetCamp.myVO.ablilityAddLv = otherCamp.myVO.ablilityAddLv;
               }
               if(targetSkill.name == "黑雾")
               {
                  Dialogue.collectDialogue(targetCamp.myVO.nickName + "释放黑雾");
                  GameFacade.getInstance().sendNotification("init_fighting_value");
                  return;
               }
            };
            playSkillEffect(targetSkill,targetCamp,false,callBack);
         }
      }
      
      private static function skillForSelf(param1:SkillVO, param2:ElfVO) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(isStoreSkill(param1,param2))
         {
            return;
         }
         if(isSwallowSkill(param1,param2))
         {
            return;
         }
         if(isBlight(param1,param2))
         {
            StatusFactor.getStatus(param2,param1,param2);
            return;
         }
         isClearStatus(param1,param2);
         if(isChangeAblilityLvs(param1,param2))
         {
            return;
         }
         if(param1.effectForSelf[0] != 0)
         {
            skillEffectForSelf(param1,param2);
         }
         if(param1.name == "守住" || param1.name == "忍耐" || param1.name == "先决")
         {
            _loc5_ = Math.random() * 100;
            if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
            {
               if(param2.camp == "camp_of_player")
               {
                  _loc5_ = FightingConfig.selfOrder.hitRandomNum[0];
               }
               else
               {
                  LogUtil(JSON.stringify(FightingConfig.otherOrder) + "对方");
                  _loc5_ = FightingConfig.otherOrder.hitRandomNum[0];
               }
            }
            if(!FightingLogicFactor.isPlayBack)
            {
               if(param2.camp == "camp_of_player")
               {
                  FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].hitRandomNum.push(_loc5_);
               }
               else
               {
                  FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].hitRandomNum.push(_loc5_);
               }
            }
            LogUtil("概率" + _loc5_ + ":成功率:" + param1.successRate);
            if(_loc5_ > param1.successRate)
            {
               param1.successRate = 100;
               Dialogue.collectDialogue(param2.nickName + "发动技能失败");
               return;
            }
            param1.successRate = param1.successRate / 2;
         }
         if(param1.name == "睡觉")
         {
            _loc3_ = param2.status.indexOf(1);
            if(_loc3_ != -1)
            {
               param2.status.splice(_loc3_,1);
            }
            _loc3_ = param2.status.indexOf(2);
            if(_loc3_ != -1)
            {
               param2.status.splice(_loc3_,1);
            }
            _loc3_ = param2.status.indexOf(3);
            if(_loc3_ != -1)
            {
               param2.status.splice(_loc3_,1);
            }
            _loc3_ = param2.status.indexOf(4);
            if(_loc3_ != -1)
            {
               param2.status.splice(_loc3_,1);
            }
            _loc3_ = param2.status.indexOf(5);
            if(_loc3_ != -1)
            {
               param2.status.splice(_loc3_,1);
            }
            _loc4_ = param2.totalHp;
            GameFacade.getInstance().sendNotification("hp_change",-_loc4_,param2.camp);
         }
         if(param1.name == "变性")
         {
            param2.nature = [param1.property];
         }
         if(param1.name == "替身")
         {
            if(param2.status.indexOf(13) != -1)
            {
               GameFacade.getInstance().sendNotification("tell_after_self_act",param2.name + "已经是替身状态",param2.camp);
               return;
            }
            if(param2.currentHp <= param2.totalHp / 4)
            {
               GameFacade.getInstance().sendNotification("tell_after_self_act",param2.name + "没有足够HP发动替身",param2.camp);
               return;
            }
            avatarsHandler(param2);
         }
         StatusFactor.getStatus(param2,param1,param2);
      }
      
      private static function isBlight(param1:SkillVO, param2:ElfVO) : Boolean
      {
         var _loc3_:* = null;
         if(param1.id == 353 && param2.status.indexOf(42) == -1)
         {
            if(param2.camp == "camp_of_player")
            {
               _loc3_ = CampOfComputerMedia._currentCamp.myVO;
            }
            else
            {
               _loc3_ = CampOfPlayerMedia._currentCamp.myVO;
            }
            param2.blightHurt = CalculatorFactor.hurtCalculator(param2,_loc3_,param1);
            trace("破灭愿望伤害" + param2.blightHurt);
            return true;
         }
         if(param1.id == 353)
         {
            return true;
         }
         return false;
      }
      
      private static function isChangeAblilityLvs(param1:SkillVO, param2:ElfVO) : Boolean
      {
         if(param1.id == 322)
         {
            if(param2.ablilityAddLv[1] < 6)
            {
               var _loc3_:* = 1;
               var _loc4_:* = param2.ablilityAddLv[_loc3_] + 1;
               param2.ablilityAddLv[_loc3_] = _loc4_;
               Dialogue.collectDialogue(param2.nickName + "\n防御力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n防御力升满了");
            }
            if(param2.ablilityAddLv[3] < 6)
            {
               _loc4_ = 3;
               _loc3_ = param2.ablilityAddLv[_loc4_] + 1;
               param2.ablilityAddLv[_loc4_] = _loc3_;
               Dialogue.collectDialogue(param2.nickName + "\n特殊防御力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n特殊防御力升满了");
            }
            return true;
         }
         if(param1.id == 339)
         {
            if(param2.ablilityAddLv[1] < 6)
            {
               _loc3_ = 1;
               _loc4_ = param2.ablilityAddLv[_loc3_] + 1;
               param2.ablilityAddLv[_loc3_] = _loc4_;
               Dialogue.collectDialogue(param2.nickName + "\n防御力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n防御力升满了");
            }
            if(param2.ablilityAddLv[0] < 6)
            {
               _loc4_ = 0;
               _loc3_ = param2.ablilityAddLv[_loc4_] + 1;
               param2.ablilityAddLv[_loc4_] = _loc3_;
               Dialogue.collectDialogue(param2.nickName + "\n攻击力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n攻击力升满了");
            }
            return true;
         }
         if(param1.id == 349)
         {
            if(param2.ablilityAddLv[0] < 6)
            {
               _loc3_ = 0;
               _loc4_ = param2.ablilityAddLv[_loc3_] + 1;
               param2.ablilityAddLv[_loc3_] = _loc4_;
               Dialogue.collectDialogue(param2.nickName + "\n攻击力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n攻击力升满了");
            }
            if(param2.ablilityAddLv[4] < 6)
            {
               _loc4_ = 4;
               _loc3_ = param2.ablilityAddLv[_loc4_] + 1;
               param2.ablilityAddLv[_loc4_] = _loc3_;
               Dialogue.collectDialogue(param2.nickName + "\n速度提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n速度升满了");
            }
            return true;
         }
         if(param1.id == 347)
         {
            if(param2.ablilityAddLv[2] < 6)
            {
               _loc3_ = 2;
               _loc4_ = param2.ablilityAddLv[_loc3_] + 1;
               param2.ablilityAddLv[_loc3_] = _loc4_;
               Dialogue.collectDialogue(param2.nickName + "\n特殊攻击力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n特殊攻击力升满了");
            }
            if(param2.ablilityAddLv[3] < 6)
            {
               _loc4_ = 3;
               _loc3_ = param2.ablilityAddLv[_loc4_] + 1;
               param2.ablilityAddLv[_loc4_] = _loc3_;
               Dialogue.collectDialogue(param2.nickName + "\n特殊防御力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n特殊防御力升满了");
            }
            return true;
         }
         return false;
      }
      
      private static function isClearStatus(param1:SkillVO, param2:ElfVO) : void
      {
         var _loc3_:* = 0;
         var _loc6_:* = undefined;
         var _loc5_:* = 0;
         var _loc7_:* = null;
         var _loc4_:* = 0;
         if(param1.id == 287)
         {
            if(param2.status.indexOf(1) != -1)
            {
               _loc3_ = param2.status.indexOf(1);
               param2.status.splice(_loc3_,1);
            }
            if(param2.status.indexOf(3) != -1)
            {
               _loc3_ = param2.status.indexOf(3);
               param2.status.splice(_loc3_,1);
            }
            if(param2.status.indexOf(4) != -1)
            {
               _loc3_ = param2.status.indexOf(4);
               param2.status.splice(_loc3_,1);
            }
            Dialogue.collectDialogue(param2.nickName + "休整了自身");
         }
         LogUtil("使用芳香治疗" + param1.id);
         if(param1.id == 312)
         {
            if(param2.camp == "camp_of_player")
            {
               _loc6_ = PlayerVO.bagElfVec;
            }
            else if(NPCVO.name != null)
            {
               _loc6_ = NPCVO.bagElfVec;
            }
            else
            {
               _loc6_ = new Vector.<ElfVO>([]);
               _loc6_.push(CampOfComputerMedia._currentCamp.myVO);
            }
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               if(_loc6_[_loc5_] != null)
               {
                  _loc7_ = _loc6_[_loc5_];
                  _loc4_ = 0;
                  while(_loc4_ < StatusFactor.specialStatus.length)
                  {
                     if(_loc7_.status.indexOf(StatusFactor.specialStatus[_loc4_]) != -1)
                     {
                        _loc7_.status.splice(_loc7_.status.indexOf(StatusFactor.specialStatus[_loc4_]),1);
                     }
                     _loc4_++;
                  }
               }
               _loc5_++;
            }
            _loc6_ = Vector.<ElfVO>([]);
            Dialogue.collectDialogue(param2.nickName + "放出沁人心脾的香气\n消除全队的异常状态。");
         }
      }
      
      private static function avatarsHandler(param1:ElfVO) : void
      {
         param1.hpBeforeAvatars = param1.currentHp - param1.totalHp / 4;
         LogUtil("记录替身前血量" + param1.hpBeforeAvatars);
         param1.currentHp = param1.totalHp / 4;
         var _loc2_:int = param1.status.indexOf(8);
         if(_loc2_ != -1)
         {
            param1.status.splice(_loc2_,1);
         }
         param1.status.push(13);
         Starling.juggler.delayCall(showAvatars,Config.dialogueDelay / 2,param1);
      }
      
      private static function showAvatars(param1:ElfVO) : void
      {
         GameFacade.getInstance().sendNotification("start_avatars",0,param1.camp);
      }
      
      private static function skillEffectForSelf(param1:SkillVO, param2:ElfVO) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(param1.id == 339)
         {
            CalculatorFactor.calculatorElf(param2);
            return;
         }
         if(param1.id == 349)
         {
            CalculatorFactor.calculatorElf(param2);
            return;
         }
         if(param1.id == 347)
         {
            CalculatorFactor.calculatorElf(param2);
            return;
         }
         if(param1.effectForSelf[0] == 1)
         {
            if(param1.name == "肚子大鼓")
            {
               _loc3_ = param2.totalHp / 2;
               if(_loc3_ >= param2.currentHp)
               {
                  Dialogue.collectDialogue(param2.nickName + "HP不足\n技能发动失败");
                  return;
               }
               GameFacade.getInstance().sendNotification("hp_change",_loc3_,param2.camp);
            }
            if(param2.ablilityAddLv[0] < 6)
            {
               var _loc5_:* = 0;
               var _loc6_:* = param2.ablilityAddLv[_loc5_] + param1.effectForSelf[1];
               param2.ablilityAddLv[_loc5_] = _loc6_;
               Dialogue.collectDialogue(param2.nickName + "\n攻击力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n攻击力加满了");
            }
            if(param1.name == "生长")
            {
               if(param2.ablilityAddLv[2] < 6)
               {
                  _loc6_ = 2;
                  _loc5_ = param2.ablilityAddLv[_loc6_] + param1.effectForSelf[1];
                  param2.ablilityAddLv[_loc6_] = _loc5_;
                  Dialogue.collectDialogue(param2.nickName + "\n攻击力提升,特殊攻击力提升了");
               }
               else
               {
                  Dialogue.collectDialogue(param2.nickName + "\n特殊攻击力加满了");
               }
            }
         }
         else if(param1.effectForSelf[0] == 2)
         {
            if(param2.ablilityAddLv[2] < 6)
            {
               _loc5_ = 2;
               _loc6_ = param2.ablilityAddLv[_loc5_] + param1.effectForSelf[1];
               param2.ablilityAddLv[_loc5_] = _loc6_;
               Dialogue.collectDialogue(param2.nickName + "\n特殊攻击力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n特殊攻击力加满了");
            }
         }
         else if(param1.effectForSelf[0] == 3)
         {
            if(param2.ablilityAddLv[4] < 6)
            {
               _loc6_ = 4;
               _loc5_ = param2.ablilityAddLv[_loc6_] + param1.effectForSelf[1];
               param2.ablilityAddLv[_loc6_] = _loc5_;
               Dialogue.collectDialogue(param2.nickName + "\n速度提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n速度加满了");
            }
         }
         else if(param1.effectForSelf[0] == 4)
         {
            if(param2.status.indexOf(27) != -1)
            {
               Dialogue.collectDialogue(param2.nickName + "被看破");
               return;
            }
            if(param2.ablilityAddLv[6] < 6)
            {
               _loc5_ = 6;
               _loc6_ = param2.ablilityAddLv[_loc5_] + param1.effectForSelf[1];
               param2.ablilityAddLv[_loc5_] = _loc6_;
               Dialogue.collectDialogue(param2.nickName + "\n回避提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n回避加满了");
            }
         }
         else if(param1.effectForSelf[0] == 5)
         {
            if(param1.name == "防卫卷")
            {
               param2.hasUseDefense = true;
            }
            if(param2.ablilityAddLv[1] < 6)
            {
               _loc6_ = 1;
               _loc5_ = param2.ablilityAddLv[_loc6_] + param1.effectForSelf[1];
               param2.ablilityAddLv[_loc6_] = _loc5_;
               Dialogue.collectDialogue(param2.nickName + "\n防御力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n防御力加满了");
            }
         }
         else if(param1.effectForSelf[0] == 6)
         {
            if(param2.ablilityAddLv[3] < 6)
            {
               _loc5_ = 3;
               _loc6_ = param2.ablilityAddLv[_loc5_] + param1.effectForSelf[1];
               param2.ablilityAddLv[_loc5_] = _loc6_;
               Dialogue.collectDialogue(param2.nickName + "\n特殊防御力提升了");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "\n特殊防御力加满了");
            }
         }
         else if(param1.effectForSelf[0] == 7)
         {
            _loc4_ = param2.totalHp * param1.effectForSelf[1];
            Dialogue.collectDialogue(param2.nickName + "\n恢复了HP");
            GameFacade.getInstance().sendNotification("hp_change",-_loc4_,param2.camp);
         }
         CalculatorFactor.calculatorElf(param2);
      }
      
      private static function firstSkillPlay(param1:SkillVO, param2:CampBaseUI, param3:Function) : void
      {
         targetSkill = param1;
         targetCamp = param2;
         callback = param3;
         if(!Config.isOpenFightingAni)
         {
            if(callback)
            {
               callback();
            }
            return;
         }
         var i:int = 0;
         while(i < SkillMcSort.both.length)
         {
            if(SkillMcSort.both[i] == targetSkill.name)
            {
               var skillName:String = "skill" + targetSkill.id;
               var loadSwfComplete:Function = function():void
               {
                  if(EventCenter.hasEvent("load_swf_asset_complete"))
                  {
                     EventCenter.removeEventListener("load_swf_asset_complete",loadSwfComplete);
                  }
                  if(LoadSwfAssetsManager.getInstance().assets.swfNames.indexOf(skillName) == -1)
                  {
                     return;
                  }
                  LogUtil("播放技能开始");
                  var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf(skillName);
                  var _loc2_:SwfMovieClip = startSkillMc(_loc1_,"mc_" + targetSkill.id + "_self",targetCamp,skillName);
                  return;
                  §§push(callback());
               };
               if(FightingConfig.skillAssetsOfUse.indexOf(skillName) == -1)
               {
                  FightingConfig.skillAssetsOfUse.push(skillName);
                  EventCenter.addEventListener("load_swf_asset_complete",loadSwfComplete);
                  LoadSwfAssetsManager.getInstance().addSkillAssets([skillName],true);
               }
               else
               {
                  loadSwfComplete();
               }
               return;
            }
            i = i + 1;
         }
         return;
         §§push(callback());
      }
      
      public static function playSkillEffect(param1:SkillVO, param2:CampBaseUI, param3:Boolean, param4:Function) : void
      {
         skill = param1;
         targetCamp = param2;
         isStoreGasFirst = param3;
         callBack = param4;
         if(!Config.isOpenFightingAni)
         {
            if(callBack)
            {
               callBack();
            }
            return;
         }
         LogUtil("技能名称:" + skill.name);
         var skillName:String = "skill" + skill.id;
         var loadSwfComplete:Function = function():void
         {
            if(EventCenter.hasEvent("load_swf_asset_complete"))
            {
               EventCenter.removeEventListener("load_swf_asset_complete",loadSwfComplete);
            }
            if(callBack)
            {
               callBack();
            }
            isChangeEnvironment(skill.name,targetCamp);
            if(LoadSwfAssetsManager.getInstance().assets.swfNames.indexOf(skillName) == -1)
            {
               return;
            }
            var _loc3_:String = "mc_" + skill.id;
            if(isStoreGasFirst)
            {
               _loc3_ = _loc3_ + "_1";
            }
            else if(skill.isStoreGas)
            {
               _loc3_ = _loc3_ + "_2";
               if(skill.status[0] == 19)
               {
                  FightingConfig.isShareScreen = true;
               }
            }
            var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf(skillName);
            LogUtil("技能名称" + _loc3_ + "有没有" + _loc1_.hasMovieClip(_loc3_));
            if(!_loc1_.hasMovieClip(_loc3_))
            {
               return;
            }
            var _loc2_:SwfMovieClip = startSkillMc(_loc1_,_loc3_,targetCamp,skillName);
            specialShowHandler(_loc2_,skill,targetCamp);
            _loc1_ = null;
            if(skill.id == 56)
            {
               playOtherEffect("mc_56",targetCamp);
            }
         };
         if(FightingConfig.skillAssetsOfUse.indexOf(skillName) == -1)
         {
            FightingConfig.skillAssetsOfUse.push(skillName);
            EventCenter.addEventListener("load_swf_asset_complete",loadSwfComplete);
            LoadSwfAssetsManager.getInstance().addSkillAssets([skillName],true);
         }
         else
         {
            loadSwfComplete();
         }
      }
      
      public static function disposeSomeSkillAssets(param1:String) : void
      {
         LogUtil(FightingConfig.skillAssetsOfDisposeAtOnce + "存在么" + FightingConfig.skillAssetsOfDisposeAtOnce.indexOf(param1));
         if(FightingConfig.skillAssetsOfDisposeAtOnce.indexOf(param1) != -1)
         {
            LoadSwfAssetsManager.getInstance().removeAsset([param1]);
            FightingConfig.skillAssetsOfDisposeAtOnce.splice(FightingConfig.skillAssetsOfDisposeAtOnce.indexOf(param1),1);
            FightingConfig.skillAssetsOfUse.splice(FightingConfig.skillAssetsOfUse.indexOf(param1),1);
            LogUtil("立刻销毁的技能资源" + FightingConfig.skillAssetsOfDisposeAtOnce);
         }
      }
      
      private static function startSkillMc(param1:Swf, param2:String, param3:CampBaseUI, param4:String) : SwfMovieClip
      {
         swf = param1;
         skillMc = param2;
         targetCamp = param3;
         skillName = param4;
         if(!Config.isOpenFightingAni)
         {
            return null;
         }
         LogUtil(swf + "mc名字" + skillMc);
         if(swf == null)
         {
            return null;
         }
         var mc:SwfMovieClip = swf.createMovieClip(skillMc);
         targetCamp.addChild(mc);
         mc.gotoAndPlay(0);
         mc.x = targetCamp.elf.x;
         mc.y = targetCamp.elf.y - (targetCamp.elf.height >> 1);
         mc.completeFunction = function():void
         {
            var _loc1_:* = false;
            var _loc2_:* = 0;
            mc.removeFromParent(true);
            if(FightingConfig.isShareScreen)
            {
               FightingConfig.isShareScreen = false;
               AniFactor.beAttacking2(targetCamp.elf,1);
               AniFactor.shareScreen1(2);
            }
            var _loc3_:String = StatusFactor.statusInfo[targetCamp.myVO.status[targetCamp.myVO.status.length - 1] - 1];
            if(Dialogue.collectDialogueVec.indexOf(targetCamp.myVO.nickName + "\n进入" + _loc3_ + "状态") != -1)
            {
               playStatusEffect(targetCamp.myVO.status[targetCamp.myVO.status.length - 1],targetCamp);
            }
            if(FightingLogicFactor.attackNum == 0 && !targetCamp.myVO.isStoreGas)
            {
               _loc1_ = true;
               _loc2_ = 0;
               while(_loc2_ < SkillMcSort.continueAttackSkill.length)
               {
                  if(skillName == SkillMcSort.continueAttackSkill[_loc2_])
                  {
                     _loc1_ = false;
                     break;
                  }
                  _loc2_++;
               }
               if(_loc1_)
               {
                  disposeSomeSkillAssets(skillName);
               }
            }
         };
         return mc;
      }
      
      public static function playStatusEffect(param1:int, param2:CampBaseUI) : void
      {
         if(!Config.isOpenFightingAni)
         {
            return;
         }
         LogUtil("状态id:" + param1);
         var _loc3_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("status");
         var _loc5_:String = "mc_status0" + param1;
         LogUtil("技能名称" + _loc5_ + "有没有" + _loc3_.hasMovieClip(_loc5_));
         if(!_loc3_.hasMovieClip(_loc5_))
         {
            return;
         }
         var _loc4_:SwfMovieClip = startStatusMc(_loc3_,_loc5_,param2);
         if(param1 == 100 && param2 is CampOfPlayerUI)
         {
            var _loc6_:* = -1;
            _loc4_.scaleY = _loc6_;
            _loc4_.scaleX = _loc6_;
         }
         _loc3_ = null;
         if(param1 == 7)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","mull");
         }
      }
      
      public static function playOtherEffect(param1:String, param2:CampBaseUI) : void
      {
         LogUtil("播放其他动画" + param1);
         if(!Config.isOpenFightingAni)
         {
            return;
         }
         var _loc3_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("status");
         var _loc4_:SwfMovieClip = startStatusMc(_loc3_,param1,param2);
         _loc3_ = null;
      }
      
      private static function startStatusMc(param1:Swf, param2:String, param3:CampBaseUI) : SwfMovieClip
      {
         swf = param1;
         mcName = param2;
         targetCamp = param3;
         if(!Config.isOpenFightingAni)
         {
            return null;
         }
         var mc:SwfMovieClip = swf.createMovieClip(mcName);
         targetCamp.addChild(mc);
         mc.gotoAndPlay(0);
         mc.x = targetCamp.elf.x;
         mc.y = targetCamp.elf.y - (targetCamp.elf.height >> 1);
         mc.completeFunction = function():void
         {
            mc.removeFromParent(true);
         };
         return mc;
      }
      
      private static function specialShowHandler(param1:SwfMovieClip, param2:SkillVO, param3:CampBaseUI) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         if(!Config.isOpenFightingAni)
         {
            return;
         }
         if(param2.name == "旋风" && param3 is CampOfPlayerUI)
         {
            var _loc6_:* = -1;
            param1.scaleY = _loc6_;
            param1.scaleX = _loc6_;
            return;
         }
         if(param2.name == "旋风" && param3 is CampOfComputerUI && NPCVO.name == null)
         {
            _loc4_ = new Tween(param3.elf,0.5,"easeInBack");
            Starling.juggler.add(_loc4_);
            _loc4_.animate("x",param3.elf.x + 300);
            _loc4_.animate("y",param3.elf.y - 300);
            _loc4_.delay = 0.7;
            return;
         }
         if(param3 is CampOfPlayerUI)
         {
            _loc5_ = 0;
            while(_loc5_ < SkillMcSort.needScaleSkillArr.length)
            {
               if(SkillMcSort.needScaleSkillArr[_loc5_] == param2.name)
               {
                  _loc6_ = -1;
                  param1.scaleY = _loc6_;
                  param1.scaleX = _loc6_;
                  break;
               }
               _loc5_++;
            }
         }
         if(param2.name == "梦话" && param3 is CampOfComputerUI)
         {
            _loc6_ = -1;
            param1.scaleY = _loc6_;
            param1.scaleX = _loc6_;
         }
         if(param2.id == 336 && param3 is CampOfComputerUI)
         {
            _loc6_ = -1;
            param1.scaleY = _loc6_;
            param1.scaleX = _loc6_;
         }
         return;
         §§push(LogUtil("扭转"));
      }
   }
}
