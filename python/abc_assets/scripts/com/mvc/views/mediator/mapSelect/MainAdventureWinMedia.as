package com.mvc.views.mediator.mapSelect
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mapSelect.MainAdventureWinUI;
   import feathers.controls.List;
   import com.mvc.models.vos.mapSelect.MainMapVO;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   import com.common.themes.Tips;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.Sprite;
   import starling.display.Image;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.massage.ane.UmengExtension;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI;
   import com.common.util.DisposeDisplay;
   import com.mvc.views.uis.mapSelect.NodeChildUnitUI;
   import feathers.data.ListCollection;
   import com.common.util.IsAllElfDie;
   import com.mvc.models.vos.fighting.FightingConfig;
   import feathers.controls.Alert;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.common.util.dialogue.NPCDialogue;
   import com.common.events.EventCenter;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.common.util.xmlVOHandler.GetElfQuality;
   
   public class MainAdventureWinMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MainMapWinMedia";
      
      public static var index:int = 0;
       
      public var win:MainAdventureWinUI;
      
      private var advanceList:List;
      
      private var mapInfoVec:Vector.<MainMapVO>;
      
      private var computerElfVO:ElfVO;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var raidsNum:int;
      
      private var isUseDia:Boolean;
      
      private var isAllPass:Boolean;
      
      private var newNodDecId:int;
      
      private var reVipArr:Array;
      
      private var reCountArr:Array;
      
      public function MainAdventureWinMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         reVipArr = [[0],[1,2,3,4],[5,6,7,8,9,10],[11,12,13,14,15]];
         reCountArr = [1,2,3,4];
         super("MainMapWinMedia",param1);
         win = param1 as MainAdventureWinUI;
         advanceList = win.advanceList;
         win.addEventListener("triggered",clickHandler);
         win.normalModeBtn.addEventListener("triggered",normalModel);
         win.hardModeBtn.addEventListener("triggered",hardModel);
      }
      
      private function hardModel() : void
      {
         if(!isAllPass)
         {
            return Tips.show("还有普通关卡没有通关哦");
         }
         win.switchMode(true);
         sendNotification("update_main_map_list",GetMapFactor.hardMapVec);
         sendNotification("UPDATE_MAPINFO",GetMapFactor.hardMapVec);
         (facade.retrieveProxy("MapPro") as MapPro).write1701(GetMapFactor.hardMapVec[0]);
      }
      
      private function normalModel() : void
      {
         win.switchMode(false);
         sendNotification("update_main_map_list",GetMapFactor.normalMapVec);
         sendNotification("UPDATE_MAPINFO",GetMapFactor.normalMapVec);
         (facade.retrieveProxy("MapPro") as MapPro).write1701(GetMapFactor.normalMapVec[0]);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(win.closeBtn !== _loc2_)
         {
            if(win.raidsBtn !== _loc2_)
            {
               if(win.raidsAddBtn !== _loc2_)
               {
                  if(win.btn_adventure === _loc2_)
                  {
                     if(win._mainMapVo.isHard && PlayerVO.lv < 9)
                     {
                        return Tips.show("玩家等级达到9级后开启精英模式");
                     }
                     BeginnerGuide.playBeginnerGuide();
                     advanceHandler(mapInfoVec.indexOf(win._mainMapVo));
                  }
               }
               else
               {
                  if(PlayerVO.lv < 10)
                  {
                     return Tips.show("玩家等级达到10级开启扫荡");
                  }
                  if(mapInfoVec[index].isHard)
                  {
                     if(mapInfoVec[index].lessTime == 0)
                     {
                        return Tips.show("挑战次数不足，无法扫荡");
                     }
                     radisHandler(mapInfoVec[index].lessTime);
                  }
                  else
                  {
                     radisHandler(10);
                  }
               }
            }
            else
            {
               if(PlayerVO.lv < 10)
               {
                  return Tips.show("玩家等级达到10级开启扫荡");
               }
               if(mapInfoVec[index].isHard)
               {
                  if(mapInfoVec[index].lessTime == 0)
                  {
                     return Tips.show("挑战次数不足，无法扫荡");
                  }
               }
               radisHandler(1);
            }
         }
         else
         {
            advanceList.removeFromParent();
            WinTweens.closeWin(win.mySpr,removeSelf);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc3_:* = 0;
         var _loc10_:* = param1.getName();
         if("update_main_map_list" !== _loc10_)
         {
            if("adventure_result" !== _loc10_)
            {
               if("main_map_info" !== _loc10_)
               {
                  if("update_raids_num" !== _loc10_)
                  {
                     if("next_dialogue" !== _loc10_)
                     {
                        if("RESTART_UPDATE" === _loc10_)
                        {
                           if(mapInfoVec[index].maxTime > 0)
                           {
                              §§dup(mapInfoVec[index]).reStartTime--;
                              mapInfoVec[index].lessTime = mapInfoVec[index].maxTime;
                              upDateListShow(mapInfoVec);
                           }
                        }
                     }
                     else if("share_exp" == param1.getBody())
                     {
                     }
                  }
                  else
                  {
                     if(mapInfoVec[index].maxTime > 0)
                     {
                        mapInfoVec[index].lessTime = mapInfoVec[index].lessTime - raidsNum;
                     }
                     if(PlayerVO.raidsProp && PlayerVO.raidsProp.count >= raidsNum)
                     {
                        GetPropFactor.addOrLessProp(PlayerVO.raidsProp,false,raidsNum);
                        upDateListShow(mapInfoVec);
                        if(win.advanceList.dataProvider)
                        {
                           win.advanceList.scrollToDisplayIndex(index);
                        }
                        win.lessRaidsNumTF.text = PlayerVO.raidsProp.count;
                     }
                     else
                     {
                        upDateListShow(mapInfoVec);
                        win.advanceList.scrollToDisplayIndex(index);
                     }
                     if(isUseDia)
                     {
                        isUseDia = false;
                        sendNotification("update_play_diamond_info",PlayerVO.diamond - 1 * raidsNum);
                        UmengExtension.getInstance().UMAnalysic("buy|148|" + raidsNum + "|" + raidsNum);
                     }
                  }
               }
               else
               {
                  _loc2_ = param1.getBody()._plan;
                  newNodDecId = _loc2_;
                  if(param1.getBody().challenge)
                  {
                     _loc5_ = param1.getBody().challenge;
                  }
                  LogUtil("开启的冒险节点" + _loc2_,mapInfoVec[0].isHard);
                  _loc6_ = param1.getBody()._starInfoMap;
                  _loc7_ = 0;
                  while(_loc7_ < mapInfoVec.length)
                  {
                     mapInfoVec[_loc7_].curOpenId = _loc2_;
                     if(_loc5_)
                     {
                        _loc3_ = 0;
                        while(_loc3_ < _loc5_.length)
                        {
                           if(mapInfoVec[_loc7_].id == _loc5_[_loc3_].rcdId)
                           {
                              mapInfoVec[_loc7_].lessTime = _loc5_[_loc3_].times;
                              mapInfoVec[_loc7_].reStartTime = _loc5_[_loc3_].resetTimes;
                              break;
                           }
                           _loc3_++;
                        }
                     }
                     _loc10_ = 0;
                     var _loc9_:* = _loc6_;
                     for(var _loc8_ in _loc6_)
                     {
                        if(mapInfoVec[_loc7_].id == _loc8_)
                        {
                           if(_loc6_[_loc8_].hStar)
                           {
                              mapInfoVec[_loc7_].hardStars = _loc6_[_loc8_].hStar;
                              if(mapInfoVec[_loc7_].isHard)
                              {
                                 if(mapInfoVec[_loc7_].hardStars > 0)
                                 {
                                    mapInfoVec[_loc7_].isPass = true;
                                 }
                              }
                           }
                           if(_loc6_[_loc8_].nStar)
                           {
                              mapInfoVec[_loc7_].normalStars = _loc6_[_loc8_].nStar;
                              if(!mapInfoVec[_loc7_].isHard)
                              {
                                 if(mapInfoVec[_loc7_].normalStars > 0)
                                 {
                                    mapInfoVec[_loc7_].isPass = true;
                                 }
                                 if(mapInfoVec[_loc7_].id == _loc2_ && mapInfoVec[mapInfoVec.length - 1].id != _loc2_)
                                 {
                                    index = _loc7_;
                                    if(_loc7_ + 1 < mapInfoVec.length)
                                    {
                                       index = _loc7_ + 1;
                                    }
                                    LogUtil("index====",index);
                                 }
                              }
                           }
                        }
                     }
                     _loc7_++;
                  }
                  upDateListShow(mapInfoVec);
               }
            }
            else
            {
               if(win.advanceList == null)
               {
                  return;
               }
               if(win.advanceList.dataProvider == null)
               {
                  return;
               }
               if(mapInfoVec != null && mapInfoVec[index])
               {
                  if(param1.getType() == "adventure_pass")
                  {
                     mapInfoVec[index].isPass = true;
                     if((win.advanceList.dataProvider.data[index].icon as Sprite).numChildren == 1)
                     {
                        _loc4_ = win.swf.createImage("img_pass");
                        (win.advanceList.dataProvider.data[index].icon as Sprite).addChild(_loc4_);
                        win.advanceList.dataProvider.updateItemAt(index);
                     }
                  }
                  if(param1.getType() == "catch_elf_success")
                  {
                     mapInfoVec[index].isPass = true;
                  }
               }
            }
         }
         else
         {
            if(advanceList.parent == null)
            {
               win.mySpr.addChild(advanceList);
            }
            mapInfoVec = null;
            mapInfoVec = param1.getBody() as Vector.<MainMapVO>;
            if(mapInfoVec != null)
            {
               win.setMapInfo(mapInfoVec);
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_main_map_list","adventure_result","RESTART_UPDATE","main_map_info","update_raids_num","next_dialogue"];
      }
      
      private function removeSelf() : void
      {
         LogUtil("=移除自身=");
         sendNotification("switch_win",null);
         win.removeFromParent();
         if(MyElfMedia.isJumpPage || EvoStoneGuideUI.parentPage == "MyElfMedia")
         {
            sendNotification("switch_win",null,"LOAD_ELF_WIN");
         }
         if(EvoStoneGuideUI.parentPage == "BackPackMedia")
         {
            sendNotification("switch_win",null,"LOAD_BACKPACK_WIN");
         }
      }
      
      private function upDateListShow(param1:Vector.<MainMapVO>) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc2_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         isAllPass = true;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc3_ = new NodeChildUnitUI();
            _loc3_.name = "node" + _loc5_;
            _loc3_.myLevelVo = param1[_loc5_];
            if(!param1[_loc5_].isPass)
            {
               isAllPass = false;
            }
            _loc2_.push({
               "icon":_loc3_,
               "label":""
            });
            displayVec.push(_loc3_);
            _loc5_++;
         }
         win.advanceList.dataProvider = null;
         var _loc4_:ListCollection = new ListCollection(_loc2_);
         win.advanceList.dataProvider = _loc4_;
         win.advanceList.addEventListener("change",list_changeHandler);
         win.advanceList.dataViewPort.addEventListener("CREAT_LIST_COMPLETE",creatListComplete);
         if(EvoStoneGuideUI.isEvoStoneGuide)
         {
            LogUtil("扣扣是否进出需要技能开启的节点");
            EvoStoneGuideUI.isEvoStoneGuide = false;
            if(win.advanceList.dataProvider)
            {
               win.advanceList.scrollToDisplayIndex(EvoStoneGuideUI.nodeRcdIndex);
               win.advanceList.selectedIndex = EvoStoneGuideUI.nodeRcdIndex;
            }
         }
         else
         {
            LogUtil("返回上一个节点========",index);
            win.advanceList.scrollToDisplayIndex(index);
            win.advanceList.selectedIndex = index;
         }
      }
      
      private function creatListComplete() : void
      {
         win.advanceList.dataViewPort.removeEventListener("CREAT_LIST_COMPLETE",creatListComplete);
         BeginnerGuide.playBeginnerGuide();
      }
      
      private function list_changeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex < 0)
         {
            return;
         }
         index = _loc2_.selectedIndex;
         LogUtil("选中某个节点==========",index);
         win.levelVo = mapInfoVec[index];
      }
      
      private function radisHandler(param1:int) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(IsAllElfDie.isAllElfDie())
         {
            return;
         }
         raidsNum = param1;
         if(mapInfoVec[index].type != 1 && mapInfoVec[index].type != 3)
         {
            Tips.show("这里已经没有什么好扫荡的了");
            return;
         }
         if(mapInfoVec[index].maxTime > 0 && mapInfoVec[index].lessTime == 0)
         {
            reStarTime(index);
            return;
         }
         FightingConfig.raidsNum = raidsNum;
         FightingConfig.selectMap = mapInfoVec[index];
         if(PlayerVO.actionForce >= mapInfoVec[index].needPower * raidsNum)
         {
            if(PlayerVO.raidsProp && PlayerVO.raidsProp.count >= raidsNum)
            {
               (facade.retrieveProxy("MapPro") as MapPro).write1704(mapInfoVec[index],raidsNum,false);
            }
            else
            {
               _loc2_ = Alert.show("扫荡券不足,是否花费" + raidsNum + "个钻石扫荡？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc2_.addEventListener("close",useDRadisHander);
            }
         }
         else
         {
            _loc3_ = Alert.show("亲，体力不足哦，是否购买？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc3_.addEventListener("close",buyPowerAlertHander);
         }
      }
      
      private function reStarTime(param1:int) : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc3_:int = mapInfoVec[param1].reStartTime;
         LogUtil("mapInfoVec[index].reStartTime===",_loc3_);
         _loc4_ = 0;
         while(_loc4_ < reVipArr.length)
         {
            if(reVipArr[_loc4_].indexOf(PlayerVO.vipRank) == -1)
            {
               _loc4_++;
               continue;
            }
            break;
         }
         if(_loc3_ == 0)
         {
            if(PlayerVO.vipRank < 11)
            {
               _loc2_ = Alert.show("您今天的重置次数已用完，升级到【VIP" + reVipArr[_loc4_ + 1][0] + "】可以获得更多重置次数，是否充值？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc2_.addEventListener("close",buyReTimeAlertHander);
            }
            Tips.show("您今天的重置次数已使用完，请明天再来吧！");
            return;
         }
         var _loc5_:Alert = Alert.show("亲，挑战次数用完了哦，是否消耗" + (reCountArr[_loc4_] - _loc3_ + 1) * 30 + "钻石重置？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
         _loc5_.addEventListener("close",buyTimeAlertHander);
      }
      
      private function buyPowerAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            sendNotification("switch_win",null,"load_power_panel");
         }
      }
      
      private function buyTimeAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (facade.retrieveProxy("MapPro") as MapPro).write1707(mapInfoVec[index].id);
         }
      }
      
      private function buyReTimeAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            sendNotification("switch_win",null,"load_diamond_panel");
         }
      }
      
      private function useDRadisHander(param1:Event, param2:Object) : void
      {
         var _loc3_:* = null;
         if(param2.label == "确定")
         {
            if(PlayerVO.diamond >= 1 * raidsNum)
            {
               (facade.retrieveProxy("MapPro") as MapPro).write1704(mapInfoVec[index],raidsNum,true);
               isUseDia = true;
            }
            else
            {
               _loc3_ = Alert.show("亲，钻石不足哦，是否购买？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc3_.addEventListener("close",buyDiamondAlertHander);
            }
         }
      }
      
      private function buyDiamondAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            sendNotification("switch_win",null,"load_diamond_panel");
         }
      }
      
      private function advanceHandler(param1:int) : void
      {
         index = param1;
         if(index == -1)
         {
            return;
         }
         if(IsAllElfDie.isAllElfDie())
         {
            return;
         }
         if(index > 0 && !mapInfoVec[index - 1].isPass && !mapInfoVec[index].isHard)
         {
            Tips.show("您还没到这里呢");
            return;
         }
         if(mapInfoVec[index].isHard && mapInfoVec[index].lessTime == 0)
         {
            reStarTime(index);
            return;
         }
         if(PlayerVO.actionForce < mapInfoVec[index].needPower)
         {
            var buyPowerAlert:Alert = Alert.show("亲，体力不足哦，是否购买？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            buyPowerAlert.addEventListener("close",buyPowerAlertHander);
            return;
         }
         if(mapInfoVec[index].type == 5)
         {
            FightingConfig.selectMap = mapInfoVec[index];
            FightingConfig.isWin = true;
            var callBack:Function = function():void
            {
               (facade.retrieveProxy("MapPro") as MapPro).write1702(mapInfoVec[index]);
            }(facade.retrieveProxy("MapPro") as MapPro).write1708(FightingConfig.selectMap,callBack);
            return;
         }
         campOfComputerHandler(index);
         setFightingConfig();
         CityMapMeida.recordExtenAdvance = null;
         win.removeFromParent();
         advanceList.removeFromParent();
         sendNotification("load_fighting_page");
      }
      
      private function setFightingConfig() : void
      {
         FightingConfig.computerElfVO = null;
         FightingConfig.computerElfVO = computerElfVO;
         FightingConfig.selectMap = null;
         FightingConfig.selectMap = mapInfoVec[index];
         FightingConfig.sceneName = mapInfoVec[index].sceneName;
      }
      
      private function campOfComputerHandler(param1:int) : void
      {
         if(mapInfoVec[param1].type == 1)
         {
            computerElfVO = normalNPC();
         }
         else if(mapInfoVec[param1].type == 2 || mapInfoVec[param1].type == 4)
         {
            computerElfVO = normalOutSideElf();
         }
         else if(mapInfoVec[param1].type == 3)
         {
            computerElfVO = specialNPC();
         }
         if(NPCVO.isSpecial && !mapInfoVec[param1].isPass)
         {
            NPCDialogue.playDialogue(NPCVO.dialougBeforeFighting,NPCVO.name,NPCVO.imageName);
            NPCVO.dialougBeforeFighting = [];
            EventCenter.addEventListener("npc_dialogue_end",loadFightUI);
         }
         else
         {
            loadFightUI();
         }
      }
      
      private function loadFightUI() : void
      {
         LogUtil("loadFightUI: " + mapInfoVec,index);
         if(EventCenter.hasEvent("npc_dialogue_end"))
         {
            EventCenter.removeEventListener("npc_dialogue_end",loadFightUI);
         }
         setFightingConfig();
         CityMapMeida.recordExtenAdvance = null;
         win.removeFromParent();
         advanceList.removeFromParent();
         GetElfFactor.getBeforeFightElf();
         var callBack:Function = function():void
         {
            if(FightingConfig.selectMap.isHard)
            {
               FightingConfig.fightingAI = 1;
            }
            else
            {
               FightingConfig.fightingAI = 0;
            }
            sendNotification("switch_page","load_fighting_page");
         };
         (facade.retrieveProxy("MapPro") as MapPro).write1708(FightingConfig.selectMap,callBack);
      }
      
      private function specialNPC() : ElfVO
      {
         var _loc2_:* = null;
         var _loc6_:* = null;
         var _loc3_:* = 0;
         var _loc7_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc1_:* = null;
         LogUtil("特殊NPC对方索引位置==============",index);
         NPCVO.bagElfVec = Vector.<ElfVO>([]);
         _loc4_ = 0;
         while(_loc4_ < mapInfoVec[index].pokeList.length)
         {
            _loc2_ = mapInfoVec[index].pokeList[_loc4_].split(",");
            _loc6_ = _loc2_[0];
            _loc3_ = _loc2_[1];
            if(_loc6_ == "-1")
            {
               _loc5_ = GetElfFactor.getElfVO(NPCVO.elfOfXiaoMao);
               if(_loc3_ >= _loc5_.evoLv && _loc5_.evoLv != -1 && _loc5_.evolveId != "0")
               {
                  NPCVO.elfOfXiaoMao = _loc5_.evolveId;
                  _loc1_ = GetElfFactor.getElfVO(NPCVO.elfOfXiaoMao);
                  if(_loc3_ >= _loc1_.evoLv && _loc5_.evoLv != -1 && _loc1_.evolveId != "0")
                  {
                     NPCVO.elfOfXiaoMao = _loc1_.evolveId;
                  }
               }
               _loc6_ = NPCVO.elfOfXiaoMao;
            }
            LogUtil(_loc6_ + "=小茂精灵id");
            _loc7_ = GetElfFactor.getElfVO(_loc6_);
            _loc7_.lv = _loc3_;
            _loc7_.camp = "camp_of_computer";
            CalculatorFactor.calculatorElf(_loc7_);
            NPCVO.bagElfVec.push(_loc7_);
            selectCurrentSkillVec(_loc7_,true);
            _loc4_++;
         }
         NPCVO.name = mapInfoVec[index].npcName;
         NPCVO.imageName = mapInfoVec[index].picName;
         NPCVO.isSpecial = true;
         if(!mapInfoVec[index].isPass)
         {
            NPCVO.dialougBeforeFighting = mapInfoVec[index].sayBefore.split("|||");
            if(mapInfoVec[index].sayAfter != "")
            {
               NPCVO.dialougAfterFighting = mapInfoVec[index].sayAfter.split("|||");
            }
         }
         else
         {
            NPCVO.dialougBeforeFighting = [];
            NPCVO.dialougAfterFighting = [];
         }
         return NPCVO.bagElfVec[0];
      }
      
      private function normalOutSideElf() : ElfVO
      {
         var _loc1_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = 0;
         var _loc5_:* = null;
         var _loc4_:int = Math.random() * mapInfoVec[index].pokeList.length;
         _loc1_ = mapInfoVec[index].pokeList[_loc4_].split(",");
         _loc3_ = _loc1_[0];
         _loc2_ = _loc1_[1];
         _loc5_ = GetElfFactor.getElfVO(_loc3_);
         _loc5_.lv = _loc2_;
         CalculatorFactor.calculatorElf(_loc5_);
         selectCurrentSkillVec(_loc5_);
         NPCVO.name = null;
         NPCVO.bagElfVec = Vector.<ElfVO>([]);
         NPCVO.isSpecial = false;
         return _loc5_;
      }
      
      private function normalNPC() : ElfVO
      {
         var _loc1_:* = null;
         var _loc4_:* = null;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc5_:* = null;
         LogUtil("一般精灵训练师对方索引位置==============",index);
         NPCVO.bagElfVec = Vector.<ElfVO>([]);
         _loc3_ = 0;
         while(_loc3_ < mapInfoVec[index].pokeList.length)
         {
            _loc1_ = mapInfoVec[index].pokeList[_loc3_].split(",");
            _loc4_ = _loc1_[0];
            _loc2_ = _loc1_[1];
            _loc5_ = GetElfFactor.getElfVO(_loc4_);
            _loc5_.lv = _loc2_;
            _loc5_.camp = "camp_of_computer";
            CalculatorFactor.calculatorElf(_loc5_);
            NPCVO.bagElfVec.push(_loc5_);
            selectCurrentSkillVec(_loc5_);
            _loc3_++;
         }
         NPCVO.name = mapInfoVec[index].npcName;
         NPCVO.imageName = mapInfoVec[index].picName;
         NPCVO.isSpecial = false;
         return NPCVO.bagElfVec[0];
      }
      
      private function selectCurrentSkillVec(param1:ElfVO, param2:Boolean = false) : void
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
         LogUtil("关卡模式=============",mapInfoVec[0].isHard,param1.starts);
         GetElfQuality.alterElfProperty(param1,mapInfoVec[0].isHard);
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("MainMapWinMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         mapInfoVec = null;
      }
   }
}
