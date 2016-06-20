package com.mvc.views.mediator.mainCity.backPack
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.backPack.PlayElfUI;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.views.uis.mainCity.backPack.PlayElfUnitUI;
   import feathers.controls.Alert;
   import starling.events.Event;
   import com.mvc.views.mediator.fighting.CampOfPlayerMedia;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.WinTweens;
   import com.mvc.views.mediator.fighting.FightingMedia;
   import com.mvc.views.mediator.fighting.FightingAI;
   import com.mvc.views.mediator.fighting.CampOfComputerMedia;
   import lzm.starling.swf.display.SwfSprite;
   import org.puremvc.as3.interfaces.INotification;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.views.uis.mainCity.myElf.CarryThingUI;
   import com.mvc.views.uis.mainCity.myElf.HagberryUI;
   import com.common.util.dialogue.Dialogue;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import starling.core.Starling;
   import extend.SoundEvent;
   import com.common.util.ShowElfAbility;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.uis.mainCity.backPack.NewSkillAlert;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.events.EventCenter;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.loading.PVPLoading;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import com.mvc.views.uis.mainCity.hunting.HuntingUI;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import starling.display.DisplayObject;
   
   public class PlayElfMedia extends Mediator
   {
      
      public static const NAME:String = "PlayElfMedia";
      
      public static var isChangeElf:Boolean;
       
      public var playElf:PlayElfUI;
      
      public var playElfVO:ElfVO;
      
      private var currentProp:PropVO;
      
      private var selectSkillVo:SkillVO;
      
      private var elfUnit:PlayElfUnitUI;
      
      private var playElfSure:Alert;
      
      public function PlayElfMedia(param1:Object = null)
      {
         super("PlayElfMedia",param1);
         playElf = param1 as PlayElfUI;
         playElf.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = 0;
         var _loc4_:* = param1.target;
         if(playElf.btn_close === _loc4_)
         {
            if(CampOfPlayerMedia.isRelay)
            {
               Tips.show("主人请选择一个交接的精灵！");
               return;
            }
            if(currentProp == null)
            {
               _loc2_ = 0;
               while(_loc2_ < PlayerVO.bagElfVec.length)
               {
                  if(PlayerVO.bagElfVec[_loc2_] != null && PlayerVO.bagElfVec[_loc2_].isPlay)
                  {
                     _loc3_ = PlayerVO.bagElfVec[_loc2_];
                     break;
                  }
                  _loc2_++;
               }
               if(playElfVO == null && _loc3_ != null && _loc3_.currentHp == 0)
               {
                  Tips.show("必须选择一个精灵出战!");
                  return;
               }
               if(playElfVO != null && playElfVO.currentHp == 0)
               {
                  Tips.show("必须选择一个精灵出战!");
                  return;
               }
            }
            closeWin();
         }
      }
      
      public function closeWin() : void
      {
         playElf.spr_elf.removeChildren(0,-1,true);
         var _loc1_:Game = Config.starling.root as Game;
         if(_loc1_.getChildIndex(_loc1_.page) == _loc1_.numChildren - 2)
         {
            WinTweens.closeWin(playElf.mySpr,remove);
         }
         else
         {
            remove();
         }
      }
      
      public function addElf() : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc1_:* = null;
         playElf.spr_elf.removeChildren(0,-1,true);
         var _loc5_:Vector.<ElfVO> = PlayerVO.bagElfVec;
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            if(_loc3_ % 3 == 0 && _loc3_ != 0)
            {
               _loc4_ = _loc4_ + 1;
            }
            if(_loc5_[_loc3_] != null)
            {
               _loc2_ = new PlayElfUnitUI();
               _loc2_.propVo = currentProp;
               _loc2_.myElfVo = _loc5_[_loc3_];
               _loc2_.x = _loc3_ % 3 * 250;
               _loc2_.y = 160 * _loc4_;
               playElf.spr_elf.addChild(_loc2_);
               if(FightingMedia.isFighting && _loc5_[_loc3_].currentHp > 0)
               {
                  if(FightingAI.isRestrain(_loc5_[_loc3_],CampOfComputerMedia._currentCamp.myVO))
                  {
                     LogUtil(_loc5_[_loc3_].nickName,"===克制对方精灵=======");
                     playElf.addRestrain(_loc2_,"mc_arrow");
                  }
                  else if(FightingAI.isRestrain(CampOfComputerMedia._currentCamp.myVO,_loc5_[_loc3_]))
                  {
                     LogUtil(_loc5_[_loc3_].nickName,"===被对方精灵克制=======");
                     playElf.addRestrain(_loc2_,"mc_arrowDown");
                  }
               }
            }
            else
            {
               _loc1_ = playElf.getNull();
               _loc1_.x = _loc3_ % 3 * 250;
               _loc1_.y = 160 * _loc4_;
               playElf.spr_elf.addChild(_loc1_);
            }
            _loc3_++;
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc8_:* = 0;
         var _loc3_:* = null;
         var _loc6_:* = 0;
         var _loc4_:* = false;
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         var _loc9_:* = param1.getName();
         if("SEND_ELFSELECT_ELF" !== _loc9_)
         {
            if("SEND_SELECT_ELF" !== _loc9_)
            {
               if("SEND_USE_PROP" !== _loc9_)
               {
                  if("next_dialogue" !== _loc9_)
                  {
                     if("skill_pp_up" !== _loc9_)
                     {
                        if("learn_new_skill_request" !== _loc9_)
                        {
                           if("carry_prop_success" !== _loc9_)
                           {
                              if("use_prop_success" !== _loc9_)
                              {
                                 if("SET_CURRENTPROP_NULL" !== _loc9_)
                                 {
                                    if("learn_skill_complete_by_prop" !== _loc9_)
                                    {
                                       if("auto_select_elf" === _loc9_)
                                       {
                                          _loc7_ = 0;
                                          while(_loc7_ < PlayerVO.bagElfVec.length)
                                          {
                                             if(PlayerVO.bagElfVec[_loc7_] != null && PlayerVO.bagElfVec[_loc7_].currentHp > 0 && !PlayerVO.bagElfVec[_loc7_].isPlay)
                                             {
                                                playElfVO = PlayerVO.bagElfVec[_loc7_];
                                                if(playElfSure != null && playElfSure.parent)
                                                {
                                                   playElfSure.removeFromParent(true);
                                                }
                                                remove3();
                                                return;
                                             }
                                             _loc7_++;
                                          }
                                          playElf.spr_elf.removeChildren(0,-1,true);
                                          remove();
                                          sendNotification("auto_select_skill");
                                       }
                                    }
                                    else
                                    {
                                       learnSkill();
                                    }
                                 }
                                 else
                                 {
                                    currentProp = null;
                                 }
                              }
                              else
                              {
                                 if(currentProp.type == 2 || currentProp.type == 17)
                                 {
                                    clearStatus();
                                 }
                                 else if(currentProp.type == 3 || currentProp.type == 16)
                                 {
                                    reply();
                                 }
                                 else if(currentProp.type == 6)
                                 {
                                    if(playElfVO.currentSkillVec.length >= 4)
                                    {
                                       Starling.juggler.delayCall(learnSkill,Config.dialogueDelay);
                                       _loc4_ = true;
                                    }
                                    else
                                    {
                                       learnSkill();
                                       _loc4_ = false;
                                    }
                                 }
                                 else if(currentProp.type == 7)
                                 {
                                    addAblity();
                                 }
                                 _loc5_ = GetPropFactor.getPropIndex(currentProp);
                                 GetPropFactor.addOrLessProp(currentProp,false);
                                 sendNotification("SHOW_BACKPACK");
                                 if(!GetPropFactor.getPropIndex(currentProp))
                                 {
                                    _loc5_ = _loc5_ > 0?_loc5_ - 1:0.0;
                                 }
                                 sendNotification("UPDATA_USE_PROP",_loc5_);
                                 if(!_loc4_)
                                 {
                                    currentProp = null;
                                 }
                              }
                           }
                           else
                           {
                              _loc6_ = GetPropFactor.getPropIndex(currentProp);
                              GetPropFactor.addOrLessProp(currentProp,false);
                              if(currentProp.type == 1 || currentProp.type == 23)
                              {
                                 playElfVO.carryProp = currentProp;
                                 CarryThingUI.getInstance().removeFromParent();
                              }
                              else if(currentProp.type == 16 || currentProp.type == 17)
                              {
                                 playElfVO.hagberryProp = currentProp;
                                 HagberryUI.getInstance().removeFromParent();
                              }
                              Dialogue.updateDialogue(playElfVO.nickName + "携带了" + currentProp.name,true,"prop_be_used");
                              sendNotification("SHOW_BACKPACK");
                              sendNotification("update_pvp_prop");
                              if(!GetPropFactor.getPropIndex(currentProp))
                              {
                                 _loc6_ = _loc6_ > 0?_loc6_ - 1:0.0;
                              }
                              CalculatorFactor.calculatorElf(playElfVO);
                              sendNotification("UPDATA_USE_PROP",_loc6_);
                              sendNotification("UPDATE_MYELF");
                              currentProp = null;
                           }
                        }
                        else
                        {
                           (facade.retrieveProxy("BackPackPro") as BackPackPro).write3013(playElfVO.id,currentProp.skillId,param1.getBody(),currentProp,1,learnSkillComplete);
                        }
                     }
                     else
                     {
                        if(currentProp == null)
                        {
                           return;
                        }
                        selectSkillVo = param1.getBody() as SkillVO;
                        if(currentProp.type == 3 || currentProp.type == 16)
                        {
                           addPPHandler(selectSkillVo);
                        }
                     }
                  }
                  else if(param1.getBody() == "prop_be_used" || param1.getBody() == "prop_no_effect")
                  {
                     if(playElf.parent == null)
                     {
                        return;
                     }
                     playElf.spr_elf.removeChildren(0,-1,true);
                     _loc3_ = Config.starling.root as Game;
                     if(_loc3_.getChildIndex(_loc3_.page) == _loc3_.numChildren - 2)
                     {
                        WinTweens.closeWin(playElf.mySpr,remove2);
                     }
                     else
                     {
                        remove2();
                     }
                  }
               }
               else
               {
                  currentProp = param1.getBody() as PropVO;
                  playElf.myPropVo = currentProp;
                  LogUtil("currentProp.isUsed=" + currentProp.isUsed);
                  if(param1.getType())
                  {
                     popup();
                  }
               }
            }
            else
            {
               elfUnit = param1.getBody() as PlayElfUnitUI;
               LogUtil("32131351==" + currentProp);
               if(currentProp)
               {
                  if(elfUnit.myElfVO.lv >= 100 && currentProp.id == 20)
                  {
                     Tips.show("【" + elfUnit.myElfVO.name + "】已达到最高级别！");
                     return;
                  }
               }
               if(currentProp == null)
               {
                  if(elfUnit.myElfVO.isPlay)
                  {
                     Tips.show("该精灵已经出战");
                     return;
                  }
                  if(elfUnit.myElfVO.currentHp == 0)
                  {
                     Tips.show("该精灵濒死,不能出战");
                     return;
                  }
                  playElfVO = elfUnit.myElfVO;
                  _loc2_ = "你确定要让【" + playElfVO.nickName + "】出战么吗？";
                  _loc8_ = 32;
                  if(_loc2_.length > 15)
                  {
                     _loc8_ = 28 - (_loc2_.length - 15);
                  }
                  playElfSure = Alert.show("<font size=\'" + _loc8_ + "\'>" + _loc2_ + "</font>","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  playElfSure.addEventListener("close",playElfSureHandler);
               }
               else
               {
                  playElfVO = elfUnit.myElfVO;
                  popup();
               }
            }
         }
         else
         {
            playElfVO = param1.getBody() as ElfVO;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_SELECT_ELF","SEND_USE_PROP","carry_prop_success","auto_select_elf","next_dialogue","skill_pp_up","use_prop_success","learn_new_skill_request","SEND_ELFSELECT_ELF","SET_CURRENTPROP_NULL","learn_skill_complete_by_prop"];
      }
      
      private function learnSkillComplete() : void
      {
         learnSkill();
      }
      
      private function addAblity() : void
      {
         var _loc1_:* = null;
         LogUtil("currentProp.elfNature =",currentProp.elfNature);
         LogUtil("嗑药前努力值=",playElfVO.effAry);
         if(currentProp.elfNature == "血量")
         {
            if(playElfVO.effAry[0] < 100)
            {
               var _loc2_:* = 0;
               var _loc3_:* = playElfVO.effAry[_loc2_] + currentProp.effectValue;
               playElfVO.effAry[_loc2_] = _loc3_;
               Dialogue.updateDialogue(playElfVO.nickName + "血量提升了",true,"prop_be_used");
            }
         }
         else if(currentProp.elfNature == "攻击")
         {
            _loc3_ = 1;
            _loc2_ = playElfVO.effAry[_loc3_] + currentProp.effectValue;
            playElfVO.effAry[_loc3_] = _loc2_;
            Dialogue.updateDialogue(playElfVO.nickName + "攻击提升了",true,"prop_be_used");
         }
         else if(currentProp.elfNature == "防守")
         {
            _loc2_ = 2;
            _loc3_ = playElfVO.effAry[_loc2_] + currentProp.effectValue;
            playElfVO.effAry[_loc2_] = _loc3_;
            Dialogue.updateDialogue(playElfVO.nickName + "防守提升了",true,"prop_be_used");
         }
         else if(currentProp.elfNature == "速度")
         {
            _loc3_ = 5;
            _loc2_ = playElfVO.effAry[_loc3_] + currentProp.effectValue;
            playElfVO.effAry[_loc3_] = _loc2_;
            Dialogue.updateDialogue(playElfVO.nickName + "速度提升了",true,"prop_be_used");
         }
         else if(currentProp.elfNature == "特攻|特防")
         {
            _loc2_ = 3;
            _loc3_ = playElfVO.effAry[_loc2_] + currentProp.effectValue;
            playElfVO.effAry[_loc2_] = _loc3_;
            _loc3_ = 4;
            _loc2_ = playElfVO.effAry[_loc3_] + currentProp.effectValue;
            playElfVO.effAry[_loc3_] = _loc2_;
            Dialogue.updateDialogue(playElfVO.nickName + "特攻特防提升了",true,"prop_be_used");
         }
         else if(currentProp.elfNature == "等级")
         {
            playElfVO.lv = playElfVO.lv + currentProp.effectValue;
            if(elfUnit)
            {
               elfUnit.elfLv.text = playElfVO.lv;
            }
            _loc1_ = CalculatorFactor.checkIsCanLearnNewSkill(playElfVO);
            playElfVO.currentExp = CalculatorFactor.calculatorLvNeedExp(playElfVO,playElfVO.lv);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
            Dialogue.updateDialogue(playElfVO.nickName + "等级上升了" + currentProp.effectValue + "级",true,"prop_be_used");
            ShowElfAbility.getInstance().show(playElfVO,currentProp.effectValue);
            if(_loc1_)
            {
               CalculatorFactor.learnNewSkillHandler(playElfVO,_loc1_);
            }
         }
         ifMax();
         CalculatorFactor.calculatorElf(playElfVO);
      }
      
      private function learnSkill() : void
      {
         var newSkill:SkillVO = GetElfFactor.getSkillById(currentProp.skillId);
         if(playElfVO.currentSkillVec.length >= 4)
         {
            playElfVO.currentSkillVec[NewSkillAlert.getInstance().index] = null;
            playElfVO.currentSkillVec[NewSkillAlert.getInstance().index] = newSkill;
            currentProp = null;
         }
         else
         {
            playElfVO.currentSkillVec.push(newSkill);
         }
         if(FightingMedia.isFighting && Config.isOpenFightingAni)
         {
            FightingConfig.skillMusicAssets.push(newSkill.soundName);
            var addSkillComplete:Function = function():void
            {
               EventCenter.removeEventListener("load_swf_asset_complete",addSkillComplete);
               Dialogue.updateDialogue(playElfVO.name + "学会了" + newSkill.name,true,"prop_be_used");
               SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
            };
            EventCenter.addEventListener("load_swf_asset_complete",addSkillComplete);
            LoadSwfAssetsManager.getInstance().addSkillAssets(["skill" + newSkill.id],true);
         }
         else
         {
            Dialogue.updateDialogue(playElfVO.name + "学会了" + newSkill.name,true,"prop_be_used");
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
         }
      }
      
      private function reply() : void
      {
         var _loc1_:int = playElfVO.currentHp;
         if(elfUnit != null)
         {
            elfUnit.getLastScale();
         }
         if(currentProp.replyType == "hp")
         {
            playElfVO.currentHp = playElfVO.currentHp + currentProp.effectValue;
         }
         else if(currentProp.replyType == "life")
         {
            if(playElfVO.currentHp <= 0)
            {
               playElfVO.status = [];
            }
            playElfVO.currentHp = playElfVO.currentHp + Math.round(playElfVO.totalHp * currentProp.effectValue);
         }
         else
         {
            replyPP();
            return;
         }
         if(playElfVO.currentHp > playElfVO.totalHp)
         {
            playElfVO.currentHp = playElfVO.totalHp;
         }
         if(elfUnit != null)
         {
            elfUnit.showHp();
         }
         LogUtil("血量回复=========",playElfVO.currentHp,_loc1_);
         Dialogue.updateDialogue(playElfVO.nickName + "血量回复" + (playElfVO.currentHp - _loc1_) + "点",true,"prop_be_used");
      }
      
      private function replyPP() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         var _loc3_:* = 0;
         if(currentProp.actRole == "单个")
         {
            _loc1_ = selectSkillVo.currentPP;
            _loc2_ = selectSkillVo.currentPP + currentProp.effectValue;
            if(_loc2_ > selectSkillVo.totalPP)
            {
               _loc2_ = selectSkillVo.totalPP;
            }
            selectSkillVo.currentPP = _loc2_;
            Dialogue.updateDialogue("技能" + selectSkillVo.name + "\n恢复了" + (selectSkillVo.currentPP - _loc1_) + "点",true,"prop_be_used");
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < playElfVO.currentSkillVec.length)
            {
               _loc2_ = playElfVO.currentSkillVec[_loc3_].currentPP + currentProp.effectValue;
               if(_loc2_ > playElfVO.currentSkillVec[_loc3_].totalPP)
               {
                  _loc2_ = playElfVO.currentSkillVec[_loc3_].totalPP;
               }
               playElfVO.currentSkillVec[_loc3_].currentPP = _loc2_;
               _loc3_++;
            }
            Dialogue.updateDialogue(playElfVO.nickName + currentProp.describe,true,"prop_be_used");
         }
      }
      
      private function clearStatus() : void
      {
         if(currentProp.relieveState == "中毒")
         {
            if(playElfVO.status.indexOf(4) != -1)
            {
               playElfVO.status.splice(playElfVO.status.indexOf(4),1);
               Dialogue.updateDialogue(playElfVO.nickName + "从中毒状态中恢复了",true,"prop_be_used");
            }
            if(playElfVO.status.indexOf(5) != -1)
            {
               playElfVO.status.splice(playElfVO.status.indexOf(5),1);
               Dialogue.updateDialogue(playElfVO.nickName + "从猛毒状态中恢复了",true,"prop_be_used");
            }
         }
         else if(currentProp.relieveState == "灼伤")
         {
            playElfVO.status.splice(playElfVO.status.indexOf(1),1);
            Dialogue.updateDialogue(playElfVO.nickName + "从灼伤状态中恢复了",true,"prop_be_used");
         }
         else if(currentProp.relieveState == "冰冻")
         {
            playElfVO.status.splice(playElfVO.status.indexOf(2),1);
            Dialogue.updateDialogue(playElfVO.nickName + "从冰冻状态中恢复了",true,"prop_be_used");
         }
         else if(currentProp.relieveState == "睡眠")
         {
            playElfVO.status.splice(playElfVO.status.indexOf(6),1);
            Dialogue.updateDialogue(playElfVO.nickName + "从睡眠状态中恢复了",true,"prop_be_used");
         }
         else if(currentProp.relieveState == "麻痹")
         {
            if(playElfVO.status.indexOf(3) != -1)
            {
               playElfVO.status.splice(playElfVO.status.indexOf(3),1);
               Dialogue.updateDialogue(playElfVO.nickName + "从麻痹状态中恢复了",true,"prop_be_used");
            }
         }
         else if(currentProp.relieveState == "混乱")
         {
            playElfVO.status.splice(playElfVO.status.indexOf(7),1);
            Dialogue.updateDialogue(playElfVO.nickName + "从混乱状态中恢复了",true,"prop_be_used");
         }
         else
         {
            playElfVO.status = [];
            Dialogue.updateDialogue(playElfVO.nickName + "全部恢复",true,"prop_be_used");
         }
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","blood");
         sendNotification("update_status_show",0,"camp_of_player");
      }
      
      private function addPPHandler(param1:SkillVO) : void
      {
         if(param1.currentPP == param1.totalPP)
         {
            Dialogue.updateDialogue("没有任何效果",true,"prop_be_used");
            return;
         }
         (facade.retrieveProxy("BackPackPro") as BackPackPro).write3005(currentProp.id,playElfVO.id,param1.id);
      }
      
      private function popup() : void
      {
         var _loc1_:* = null;
         var _loc5_:* = 0;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc6_:* = 0;
         var _loc3_:* = null;
         if(playElfVO.currentHp <= 0)
         {
            if(!(currentProp.id == 14 || currentProp.id == 15))
            {
               if((Starling.current.root as Game).page.name != "PVPBgMediator")
               {
                  if(currentProp.isUsed)
                  {
                     Tips.show("【" + playElfVO.nickName + "】处于濒死状态，不能使用【" + currentProp.name + "】");
                  }
                  else
                  {
                     Tips.show("【" + playElfVO.nickName + "】处于濒死状态，不能携带【" + currentProp.name + "】");
                  }
                  return;
               }
            }
         }
         if(currentProp.isUsed)
         {
            _loc1_ = "你确定要让【" + playElfVO.nickName + "】使用【" + currentProp.name + "】吗？";
            _loc5_ = 32;
            if(_loc1_.length > 15)
            {
               _loc5_ = 28 - (_loc1_.length - 15);
            }
            _loc7_ = Alert.show("<font size=\'" + _loc5_ + "\'>" + _loc1_ + "</font>","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc7_.addEventListener("close",PropSureHandler);
         }
         else
         {
            if(playElfVO.carryProp)
            {
               if(currentProp.id == playElfVO.carryProp.id)
               {
                  Tips.show(playElfVO.nickName + "已经携带" + currentProp.name);
                  return;
               }
            }
            if(playElfVO.hagberryProp)
            {
               if(currentProp.id == playElfVO.hagberryProp.id)
               {
                  Tips.show(playElfVO.nickName + "已经携带" + currentProp.name);
                  return;
               }
            }
            if(currentProp.type == 16 || currentProp.type == 17)
            {
               _loc1_ = "你确定要让【" + playElfVO.nickName + "】携带【" + currentProp.name + "】吗？";
               _loc5_ = 32;
               if(_loc1_.length > 15)
               {
                  _loc5_ = 28 - (_loc1_.length - 15);
               }
               _loc8_ = Alert.show("<font size=\'" + _loc5_ + "\'>" + _loc1_ + "</font>","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc8_.addEventListener("close",PropSureHandler);
            }
            else if(!playElfVO.carryProp)
            {
               _loc1_ = "你确定要让【" + playElfVO.nickName + "】携带【" + currentProp.name + "】吗？";
               _loc5_ = 32;
               if(_loc1_.length > 15)
               {
                  _loc5_ = 28 - (_loc1_.length - 15);
               }
               _loc4_ = Alert.show("<font size=\'" + _loc5_ + "\'>" + _loc1_ + "</font>\n<font size=\'18\' color=\'#1c6b04\'>(携带之后不能主动卸下，只能替换，被替换的道具也会消失哦)</font>","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc4_.addEventListener("close",PropSureHandler);
            }
            else
            {
               _loc1_ = "你确定使用【" + currentProp.name + "】替换【" + playElfVO.carryProp.name + "】吗？";
               _loc5_ = 32;
               if(_loc1_.length > 15)
               {
                  _loc5_ = 28 - (_loc1_.length - 15);
               }
               _loc2_ = "(替换后【" + playElfVO.carryProp.name + "】将会被替换消失掉哦！)";
               _loc6_ = 32;
               if(_loc2_.length > 15)
               {
                  _loc6_ = 28 - (_loc1_.length - 15);
               }
               _loc3_ = Alert.show("<font size=\'" + _loc5_ + "\'>" + _loc1_ + "</font>\n<font size=\'" + _loc6_ + "\' color=\'#1c6b04\'>" + _loc2_ + "</font>","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc3_.addEventListener("close",PropSureHandler);
            }
         }
      }
      
      private function playElfSureHandler(param1:Event, param2:Object) : void
      {
         if(PVPLoading.isPvpLoading)
         {
            return;
         }
         if(param2.label == "确定")
         {
            surePlayElf();
         }
         else
         {
            playElfVO = null;
         }
      }
      
      private function surePlayElf() : void
      {
         var _loc2_:* = 0;
         if(!FightingMedia.isFighting)
         {
            playElfVO = null;
            return;
         }
         if(FightingLogicFactor.isPVP)
         {
            sendNotification("pvp_timer_stop");
         }
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_] != null && PlayerVO.bagElfVec[_loc2_].isPlay)
            {
               FightingLogicFactor.replyChange(PlayerVO.bagElfVec[_loc2_]);
            }
            _loc2_++;
         }
         playElf.spr_elf.removeChildren(0,-1,true);
         var _loc1_:Game = Config.starling.root as Game;
         if(_loc1_.getChildIndex(_loc1_.page) == _loc1_.numChildren - 2)
         {
            WinTweens.closeWin(playElf.mySpr,remove3);
         }
         else
         {
            remove3();
         }
      }
      
      private function PropSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            LogUtil("status=" + playElfVO.status);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","useProp");
            PropFactor.propEffectHandler(currentProp,playElfVO);
         }
      }
      
      public function ifMax() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < playElfVO.effAry.length)
         {
            if(playElfVO.effAry[_loc1_] > 255)
            {
               playElfVO.effAry[_loc1_] = 255;
            }
            _loc1_++;
         }
      }
      
      private function remove() : void
      {
         playElf.setPostion();
         playElf.removeFromParent();
         currentProp = null;
         sendNotification("switch_win",null);
         sendNotification("reply_count_time");
         playElfVO = null;
         if(LoadPageCmd.lastPage is CityMapUI || LoadPageCmd.lastPage is HuntingUI)
         {
            BeginnerGuide.playCatchGuideOrChangeElf();
         }
      }
      
      private function remove2() : void
      {
         sendNotification("switch_win",null);
         currentProp = null;
         playElf.setPostion();
         playElf.removeFromParent();
         if(playElfVO != null && !FightingMedia.isFighting)
         {
         }
         playElfVO = null;
      }
      
      private function remove3() : void
      {
         isChangeElf = true;
         sendNotification("switch_win",null);
         playElf.removeFromParent();
         if(FightingMedia.isFighting == true)
         {
            sendNotification("update_fighting_ele",playElfVO,"camp_of_player");
         }
         playElfVO = null;
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("PlayElfMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
