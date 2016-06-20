package com.mvc.views.mediator.mapSelect
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import com.mvc.models.vos.mapSelect.MainMapVO;
   import com.mvc.models.vos.mapSelect.ExtenMapVO;
   import com.mvc.models.vos.mapSelect.MapVO;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.mapSelect.ShowSkillNeedWinUI;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.common.util.IsAllElfDie;
   import com.mvc.views.uis.mainCity.playerInfo.ShowBadgeMc;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.dialogue.NPCDialogue;
   import com.common.events.EventCenter;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.themes.Tips;
   import starling.core.Starling;
   import com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.uis.mapSelect.RewardUI;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.mvc.views.uis.mainCity.playerInfo.PlayerUpdateUI;
   import com.common.util.Finger;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.massage.ane.UmengExtension;
   import starling.display.DisplayObject;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.mediator.fighting.AniFactor;
   
   public class CityMapMeida extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MapMeida";
      
      public static var recordMainAdvance:String;
      
      public static var recordExtenAdvance:String;
      
      public static var isHard:Boolean;
      
      public static var playDia:Boolean;
       
      private var mapSelect:CityMapUI;
      
      private var mapInfoVec:Vector.<MainMapVO>;
      
      private var extenMapVO:ExtenMapVO;
      
      private var isUpdateMap:Boolean;
      
      private var recordOpenPage:String;
      
      private var recordOpenNodeId:String;
      
      private var recordNeedSkill:int;
      
      private var recordNeedLv:int;
      
      private var currentCity:MapVO;
      
      public function CityMapMeida(param1:Object = null)
      {
         super("MapMeida",param1);
         mapSelect = param1 as CityMapUI;
         mapSelect.addEventListener("triggered",clickHandler);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         notification = param1;
         var _loc4_:* = notification.getName();
         if("update_city_map_show" !== _loc4_)
         {
            if("PLAY_NPC_DIALOGUE_AF_F" !== _loc4_)
            {
               if("open_main_advance_list" !== _loc4_)
               {
                  if("update_city_point_open" !== _loc4_)
                  {
                     if("tell_new_point_open" !== _loc4_)
                     {
                        if("return_is_open_point" !== _loc4_)
                        {
                           if("open_main_advance_list_by_evoStone" !== _loc4_)
                           {
                              if("UPDATE_MAPINFO" !== _loc4_)
                              {
                                 if("SHOW_CHESTS" !== _loc4_)
                                 {
                                    if("UPDATE_CHESTS" === _loc4_)
                                    {
                                       var index:int = notification.getBody() as int;
                                       RewardUI.getInstance().getReward[index - 1] = 2;
                                       RewardUI.getInstance().setShow();
                                    }
                                 }
                                 else
                                 {
                                    LogUtil("展示宝箱==================");
                                    RewardUI.getInstance().getReward = notification.getBody().boxStatus;
                                    RewardUI.getInstance().currentStar = notification.getBody().star;
                                    RewardUI.getInstance().setShow();
                                    if(RewardUI.getInstance().isGetReward)
                                    {
                                       playAni();
                                    }
                                    else
                                    {
                                       closeAni();
                                    }
                                 }
                              }
                              else
                              {
                                 mapInfoVec = notification.getBody() as Vector.<MainMapVO>;
                                 isHard = mapInfoVec[0].isHard;
                                 LogUtil("点击更新了模式—————————————————————————————————————————",isHard);
                              }
                           }
                           else
                           {
                              isHard = notification.getBody() as Boolean;
                              LogUtil("跳转更新了模式—————————————————————————————————————————",isHard);
                              openMainAdvanceWin("main" + EvoStoneGuideUI.nodeID,true,notification.getBody() as Boolean,isHard);
                           }
                        }
                        else if(!notification.getBody()._isOpen)
                        {
                           if(recordNeedSkill != 0)
                           {
                              var showSkillNeedWin:ShowSkillNeedWinUI = new ShowSkillNeedWinUI();
                              showSkillNeedWin.showMessage(recordNeedSkill);
                              recordNeedSkill = 0;
                           }
                           LogUtil("+++++++========================",recordNeedLv);
                           if(recordNeedLv != 0)
                           {
                              Tips.show("玩家等级达到" + recordNeedLv + "级开启");
                              Starling.current.juggler.delayCall(function():void
                              {
                                 Tips.show("偷偷地告诉你，每日任务提供大量经验哦！");
                              },0.8);
                              recordNeedLv = 0;
                           }
                           recordExtenAdvance = null;
                           recordMainAdvance = null;
                           if(EvoStoneGuideUI.isEvoStoneGuide)
                           {
                              EvoStoneGuideUI.isEvoStoneGuide = false;
                           }
                        }
                        else
                        {
                           LogUtil("检测通过");
                           recordNeedLv = 0;
                           recordNeedSkill = 0;
                           isUpdateMap = true;
                           if(recordOpenPage == "load_exten_map_win")
                           {
                              EventCenter.addEventListener("WIN_PLAY_COMPLETE",updateExInfo);
                           }
                           else
                           {
                              EventCenter.addEventListener("WIN_PLAY_COMPLETE",updateMainAdInfo);
                              recordMainAdvance = recordOpenNodeId;
                           }
                           sendNotification("switch_win",mapSelect,recordOpenPage);
                           var xml:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_needSkillTips");
                           _loc4_ = 0;
                           var _loc3_:* = xml.sta_needSkillTips;
                           for each(x in xml.sta_needSkillTips)
                           {
                              if(recordNeedSkill == x.@id)
                              {
                                 Tips.show("使用了技能" + x.@name + x.@prompt2);
                                 break;
                              }
                           }
                        }
                     }
                     else
                     {
                        openNewHandler();
                     }
                  }
                  else
                  {
                     LogUtil("更新城市节点开启情况",JSON.stringify(FightingConfig.openPoint));
                     mapSelect.cleanMark();
                     mapSelect.setFrameOpen();
                  }
               }
               else
               {
                  LogUtil("打开主线冒险列表");
                  openNewHandler();
                  if(recordMainAdvance == null)
                  {
                     return;
                  }
                  openMainAdvanceWin(recordMainAdvance,isUpdateMap);
               }
            }
            else
            {
               LogUtil("发生了什么事");
               NPCDialogue.playDialogue(NPCVO.dialougAfterFighting,NPCVO.name,NPCVO.imageName);
               NPCVO.isSpecial = false;
               NPCVO.name = null;
               NPCVO.bagElfVec = Vector.<ElfVO>([]);
               NPCVO.dialougAfterFighting = [];
               EventCenter.addEventListener("npc_dialogue_end",afterNpcDialogue);
            }
         }
         else
         {
            LogUtil("更新城市地图的显示");
            currentCity = notification.getBody() as MapVO;
            mapSelect.updateShow(currentCity);
            BeginnerGuide.playBeginnerGuide();
            if(NPCVO.isSpecial && !IsAllElfDie.isAllElfDie() && NPCVO.dialougAfterFighting.length > 0 && playDia)
            {
               playDia = false;
               LogUtil("为什么？" + NPCVO.dialougAfterFighting.length);
               if(ShowBadgeMc.badgeFlag)
               {
                  ShowBadgeMc.getInstance().loadMC();
               }
               else
               {
                  sendNotification("PLAY_NPC_DIALOGUE_AF_F");
               }
            }
            else
            {
               showUpLvHandler();
               NPCVO.name = null;
               NPCVO.bagElfVec = Vector.<ElfVO>([]);
               NPCVO.dialougAfterFighting = [];
            }
         }
      }
      
      private function playAni() : void
      {
         LogUtil("播放打开宝箱按钮动画==================");
         mapSelect.addChild(mapSelect.promptImg);
      }
      
      private function closeAni() : void
      {
         mapSelect.promptImg.removeFromParent();
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_city_map_show","PLAY_NPC_DIALOGUE_AF_F","tell_new_point_open","open_main_advance_list","update_city_point_open","return_is_open_point","open_main_advance_list_by_evoStone","UPDATE_MAPINFO","SHOW_CHESTS","UPDATE_CHESTS"];
      }
      
      private function openNewHandler() : void
      {
         var _loc1_:* = null;
         if(FightingConfig.isHasNewPoint)
         {
            FightingConfig.isHasNewPoint = false;
            Tips.show("有新的地点可以冒险咯");
         }
         if(FightingConfig.isHasNewCity)
         {
            FightingConfig.isHasNewCity = false;
            _loc1_ = Alert.show("开启了新的城市啦,是否前往?","",new ListCollection([{"label":"我要过去"},{"label":"留在这里"}]));
            _loc1_.addEventListener("close",gotoNewCityHandler);
         }
      }
      
      private function gotoNewCityHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "我要过去")
         {
            MainAdventureWinMedia.index = 0;
            WorldMapMedia.mapVO = GetMapFactor.getMapVoById(FightingConfig.openCity);
            (facade.retrieveProxy("MapPro") as MapPro).write1703(WorldMapMedia.mapVO);
            Config.cityScene = WorldMapMedia.mapVO.bgImg;
         }
         else
         {
            BeginnerGuide.playBeginnerGuide();
         }
      }
      
      private function showUpLvHandler() : void
      {
         LogUtil("显示玩家提升等级处理");
         if(FightingConfig.isLvUp)
         {
            isUpdateMap = true;
            PlayerUpdateUI.getInstance().show();
         }
         else
         {
            openNewHandler();
            LogUtil("recordMainAdvance===",recordMainAdvance);
            if(recordMainAdvance != null)
            {
               openMainAdvanceWin(recordMainAdvance,true);
            }
            NPCDialogue.playDialogue(FightingConfig.getArr,"您",null);
         }
      }
      
      private function afterNpcDialogue() : void
      {
         LogUtil("npc对话完毕后");
         EventCenter.removeEventListener("npc_dialogue_end",afterNpcDialogue);
         showUpLvHandler();
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         if(param1.target == mapSelect.closeBtn)
         {
            if(EvoStoneGuideUI.isEvoStoneGuide)
            {
               EvoStoneGuideUI.isEvoStoneGuide = false;
            }
            LogUtil("手指指向动画");
            if(Finger.getInstance().parent)
            {
               LogUtil("手指指向动画");
               Finger.getInstance().removeFromParent();
            }
            if(MyElfMedia.isJumpPage || EvoStoneGuideUI.parentPage == "MyElfMedia")
            {
               sendNotification("switch_win",null,"LOAD_ELF_WIN");
               return;
            }
            if(EvoStoneGuideUI.parentPage == "BackPackMedia")
            {
               sendNotification("switch_win",null,"LOAD_BACKPACK_WIN");
               return;
            }
            recordMainAdvance = null;
            recordExtenAdvance = null;
            LogUtil("ceshi=====",currentCity.id);
            if(currentCity.id > 15)
            {
               sendNotification("switch_page","LOAD_WORLD_MAPTWO_PAGE");
            }
            else
            {
               sendNotification("switch_page","load_world_map_page");
            }
         }
         else if(param1.target == mapSelect.bombBtn)
         {
            RewardUI.getInstance().bomb(currentCity);
            mapSelect.bombBtn.removeFromParent();
            mapSelect.promptImg.removeFromParent();
            RewardUI.getInstance().addEventListener("close_alert",addBombBtn);
            UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|关卡星数奖励");
         }
         else
         {
            _loc2_ = (param1.target as DisplayObject).name;
            if(_loc2_.indexOf("main") != -1)
            {
               _loc4_ = _loc2_.substr(4);
               if(GetMapFactor.getPointArr().indexOf(_loc4_) == -1)
               {
                  Tips.show("亲，你还没到这里哦");
                  return;
               }
               LogUtil("点击打开");
               openMainAdvanceWin(_loc2_);
            }
            if(_loc2_.indexOf("exten") != -1)
            {
               _loc3_ = _loc2_.substr(5);
               if(GetMapFactor.getPointArr().indexOf(_loc3_) == -1)
               {
                  Tips.show("亲，你还没到这里哦");
                  return;
               }
               openExtenWin(_loc2_);
            }
         }
      }
      
      private function addBombBtn() : void
      {
         RewardUI.getInstance().removeEventListener("close_alert",addBombBtn);
         mapSelect.addChild(mapSelect.bombBtn);
         if(RewardUI.getInstance().isGetReward)
         {
            LogUtil("=====添加弹出按钮======");
            playAni();
         }
         else
         {
            closeAni();
         }
      }
      
      private function openExtenWin(param1:String, param2:Boolean = false) : void
      {
         LogUtil(param1 + " openExtenWin");
         if(param2 || recordExtenAdvance != param1)
         {
            recordExtenAdvance = param1;
            extenMapVO = null;
            extenMapVO = GetMapFactor.getExtenMapVoByID(param1.substr(5));
            if(extenMapVO.needSkillId != 0)
            {
               recordNeedSkill = extenMapVO.needSkillId;
               recordOpenPage = "load_exten_map_win";
               (facade.retrieveProxy("MapPro") as MapPro).write1706(extenMapVO);
               recordExtenAdvance = null;
               return;
            }
            if(extenMapVO.needBadge > 0 && PlayerVO.badgeNum < extenMapVO.needBadge)
            {
               Alert.show("需要拥有" + mapInfoVec[0].needBadge + "个徽章才能通过\n<font size=\'22\' color=\'#1c6b04\'>(通过击败各个城市的道馆领主可以获取徽章)</font>","",new ListCollection([{"label":"我知道啦"}]));
               recordExtenAdvance = null;
               return;
            }
            isUpdateMap = true;
            EventCenter.addEventListener("WIN_PLAY_COMPLETE",updateExInfo);
            sendNotification("switch_win",mapSelect,"load_exten_map_win");
         }
         else
         {
            isUpdateMap = false;
            EventCenter.addEventListener("WIN_PLAY_COMPLETE",updateExInfo);
            sendNotification("switch_win",mapSelect,"load_exten_map_win");
         }
      }
      
      private function updateExInfo() : void
      {
         var _loc1_:* = null;
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",updateExInfo);
         sendNotification("update_exten_map_list",{
            "extenMapInfo":extenMapVO,
            "isUpdateMap":isUpdateMap
         });
         if(PlayerVO.cpSpace + PlayerVO.pokeSpace - PlayerVO.comElfVec.length - GetElfFactor.bagElfNum() < 1)
         {
            _loc1_ = Alert.show("亲，精灵存放空间不足哦，先去回家整理下再冒险吧。","",new ListCollection([{"label":"我知道啦"}]));
         }
      }
      
      private function openMainAdvanceWin(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         LogUtil(param2,param1," ======openMainAdvanceWin==========",recordMainAdvance);
         if(param2 && recordMainAdvance != param1 && !param4)
         {
            LogUtil(" 地点不相同需要更新模式————————————————————",isHard);
            isHard = false;
         }
         if(param2 || recordMainAdvance != param1)
         {
            if(recordMainAdvance != param1)
            {
               MainAdventureWinMedia.index = 0;
            }
            if(recordMainAdvance == param1 && param2)
            {
               LogUtil(" 地点相同需要更新==",isHard);
               var param3:Boolean = isHard;
            }
            recordMainAdvance = param1;
            mapInfoVec = null;
            mapInfoVec = GetMapFactor.getMainMapVoByID(param1.substr(4),param3);
            if(mapInfoVec[0].needSkillId != 0)
            {
               recordNeedSkill = mapInfoVec[0].needSkillId;
               recordOpenPage = "load_main_map_win";
               (facade.retrieveProxy("MapPro") as MapPro).write1706(mapInfoVec[0]);
               recordOpenNodeId = param1;
               recordExtenAdvance = null;
               recordMainAdvance = null;
               return;
            }
            if(mapInfoVec[0].needOpenLv != 0)
            {
               LogUtil("需要等级开启======================",mapInfoVec[0].needOpenLv);
               recordNeedLv = mapInfoVec[0].needOpenLv;
               recordOpenPage = "load_main_map_win";
               recordOpenNodeId = param1;
               (facade.retrieveProxy("MapPro") as MapPro).write1706(mapInfoVec[0]);
               recordExtenAdvance = null;
               recordMainAdvance = null;
               return;
            }
            if(mapInfoVec[0].needBadge > 0 && PlayerVO.badgeNum < mapInfoVec[0].needBadge)
            {
               Alert.show("需要拥有" + mapInfoVec[0].needBadge + "个徽章才能通过\n<font size=\'22\' color=\'#1c6b04\'>(通过击败各个城市的道馆领主可以获取徽章)</font>","",new ListCollection([{"label":"我知道啦"}]));
               recordMainAdvance = null;
               return;
            }
            isUpdateMap = true;
            EventCenter.addEventListener("WIN_PLAY_COMPLETE",updateMainAdInfo);
            sendNotification("switch_win",mapSelect,"load_main_map_win");
         }
         else
         {
            isUpdateMap = false;
            EventCenter.addEventListener("WIN_PLAY_COMPLETE",updateMainAdInfo);
            sendNotification("switch_win",mapSelect,"load_main_map_win");
         }
      }
      
      private function updateMainAdInfo() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",updateMainAdInfo);
         LogUtil("更新主要冒险列表——————————",mapInfoVec[0].isHard);
         sendNotification("update_main_map_list",mapInfoVec);
         if(isUpdateMap)
         {
            (facade.retrieveProxy("MapPro") as MapPro).write1701(mapInfoVec[0]);
            isUpdateMap = false;
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         mapSelect.cleanMark();
         AniFactor.ifOpen = false;
         facade.removeMediator("MapMeida");
         if(mapSelect.bg)
         {
            mapSelect.bg.texture.dispose();
         }
         UI.dispose();
         RewardUI.getInstance().dispose();
         viewComponent = null;
         mapInfoVec = null;
      }
   }
}
